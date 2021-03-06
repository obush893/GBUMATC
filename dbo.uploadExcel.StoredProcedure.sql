/****** Object:  StoredProcedure [dbo].[uploadExcel]    Script Date: 08/05/2016 08:55:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uploadExcel] 
 @fname varchar(255) ,
 @filter varchar(8000)=null,
 @regions varchar(8000)=null
as
 begin
 
 set @filter =ISNULL(@filter,'')
 
 
/*

exec GBUMATC.dbo.[uploadExcel] 'E:\DataBase\TBO_files\09.12.2015_19-35-05_naselenie.xlsx', ' and [rayon] in( ''Крюково'',''Матушкино'',''Савелки'',''Силино'',''Старое Крюково'')', 'Крюково,Матушкино,Савелки,Силино,Старое Крюково'


Самысл в следующем:
1. Ты диалоговым окном предлагаешь пользователю загрузить файл в базу. Пользователь указывает файл
2. Копируешь этот файл на дисковую шару ms sql server
3. устанавливаешь необходимый фильтр, что нужно забрать из файла: фильтр формируешь в строковой переменной как в sql запросах where a=b...
4. запускаешь процедуру закачки данных в ms sql server
4.1 проверяешь сколько записей ошибок вернул скрипт:
4.1.1 Если записей нет, данные загружены (при их наличии)
4.1.2. если записи есть то это их нужно сохранить в файл и вернуть пользователю
5. наслаждаешься загрузкой данных... попивая (beer)

*/

set nocount on


-- вытаскиваем ошибки по всему файлу!!! не учитывая пользовательские фильтры
declare @rowcnt int
set @regions=ISNULL(@regions,'')


select StrVal, min(iiid ) iiid into #region  from  dbo.[ConvertStringDelimsToTable](@regions,',')
group by StrVal

CREATE TABLE #t(
 id int,
 id_ploshadki int
 
	)

--Загружай данные. Потом удалишь эти данные и загрузишь нормальные!!!
declare @sql varchar(8000),@sql2 varchar(8000)
select @sql ='declare @d datetime;set @d=GETDATE(); 
insert into #t ( id,id_ploshadki)
 select t.id, /*oso.id_ploshadki */ 1 as  id_ploshadki
 from(select t.* from( SELECT ID, [Округ] as okrug, [Район] as rayon, [УНОМ МКД] as unom_mkd, [Адрес МКД] as adres_mkd,	
       [Наименование управляющей компании] as ima_upravl_kompanii, [Участник эксперимента] as uchasnik_eksperementa, 
       [Чиленность населения в МКД, жителей] as chislenost_nasiliniya, 
       [Метод сбора отходов] as metod_sbora, 
       [ID Дворовой территории] as id_dvor_territorii, 
       [Наименование дворовой территории] as ima_dvor_territorii, 
       [ID места сбора ТБО]as id_mesta_sbora_tbo, 
       [Адрес места сбора ТБО] as adres_mesta_sbora_tbo, 
       [ID места сбора КГМ] as id_mesta_sbora_kgm,
       [Адрес места сбора КГМ] as adres_mesta_sbora_kgm 
      FROM OPENROWSET(''MSDASQL'',''DRIVER=Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb);
              UID=admin;UserCommitSync=Yes;Threads=3;SafeTransactions=0;ReadOnly=1;PageTimeout=5;MaxScanRows=8;MaxBufferSize=2048;
              FIL=excel 12.0;DriverId=1046;DefaultDir=c:\;DBQ='+@fname+''', ''SELECT * FROM [Все адреса$]'')
          where [Округ] is not null    
        ) t  ' ,
        @sql2=case when (select count(1) from #region)>5
             then '  inner join #region r on r.strval=t.rayon ' 
            else  ' where 1=1 '+ @filter end+
     ') t
        
/* left join (select id_ploshadki , max(rayon) rayon from dbo.tbo_obekti_sbora_otkhodov t '+
 case when (select count(1) from #region)>5 then '
         inner join #region r on r.strval=t.rayon ' 
          else  ' where 1=1 '+ @filter end+ ' group by  id_ploshadki ) as oso on t.id_mesta_sbora_tbo= oso.id_ploshadki and t.rayon  = oso.rayon 
*/where
      /*oso.id_ploshadki is null
      or t.id_mesta_sbora_tbo is null
      or */ ltrim(isnull(cast(okrug as varchar(4000)),''-'')) =''-''
      or ltrim(isnull(cast(rayon as varchar(4000)),''-''))=''-''
      or ltrim(isnull(cast(uchasnik_eksperementa as varchar(4000)),''-''))=''-'' 
      or ltrim(isnull(cast(chislenost_nasiliniya as varchar(4000)),''-''))=''-'' 
      or ISNUMERIC(chislenost_nasiliniya)<> 1
      or uchasnik_eksperementa not in (''Да'',''Нет'')

 ';

-- sp_updatestats
-- 1 проверка. Набирает временную таблицу с ошибками!!!

exec(@sql+ @sql2);
--  print(@sql); print(@sql2); return
 
 
 --это к другой таблице
set @rowcnt =@@ROWCOUNT 

create  table #tt(cnt int)

select @sql ='declare @d datetime;set @d=GETDATE(); 

insert into dbo.tbo_vse_adresa(okrug, rayon, unom_mkd, adres_mkd, ima_upravl_kompanii, 
uchasnik_eksperementa, chislenost_nasiliniya, metod_sbora, 
id_dvor_territorii, ima_dvor_territorii, id_mesta_sbora_tbo, adres_mesta_sbora_tbo, 
id_mesta_sbora_kgm, adres_mesta_sbora_kgm, del,    dataZagruzki,      
dataUdaleniya, fname)

select okrug, rayon, unom_mkd, adres_mkd, ima_upravl_kompanii, 
uchasnik_eksperementa, chislenost_nasiliniya, metod_sbora, 
id_dvor_territorii, ima_dvor_territorii, id_mesta_sbora_tbo, adres_mesta_sbora_tbo, 
id_mesta_sbora_kgm, adres_mesta_sbora_kgm, del,    dataZagruzki,      
dataUdaleniya, fname
 
from(  SELECT  ID, [Округ] as okrug, [Район] as rayon, [УНОМ МКД] as unom_mkd, [Адрес МКД] as adres_mkd,	
       [Наименование управляющей компании] as ima_upravl_kompanii, [Участник эксперимента] as uchasnik_eksperementa, 
       [Чиленность населения в МКД, жителей] as chislenost_nasiliniya, 
       [Метод сбора отходов] as metod_sbora, 
       [ID Дворовой территории] as id_dvor_territorii, 
       [Наименование дворовой территории] as ima_dvor_territorii, 
       [ID места сбора ТБО]as id_mesta_sbora_tbo, 
       [Адрес места сбора ТБО] as adres_mesta_sbora_tbo, 
       [ID места сбора КГМ] as id_mesta_sbora_kgm,
       [Адрес места сбора КГМ] as adres_mesta_sbora_kgm,
       
        0 del, @d dataZagruzki, null dataUdaleniya, '''+@fname+''' fname 
        FROM OPENROWSET(''MSDASQL'',''DRIVER=Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb);UID=admin;UserCommitSync=Yes;Threads=3;SafeTransactions=0;ReadOnly=1;PageTimeout=5;MaxScanRows=8;MaxBufferSize=2048;FIL=excel 12.0;DriverId=1046;DefaultDir=c:\;DBQ='+@fname+''',
        ''SELECT * FROM [Все адреса$]''

)) t 

', @sql2=
 case when (select count(1) from #region)>5 then '
         inner join #region r on r.strval=t.rayon 
         where okrug is not null and ID not in(select id from #t) '
     else ' where okrug is not null and ID not in(select id from #t) '+ @filter  end+ 
  + ' 
 ;  insert into #tt(cnt) select @@ROWCOUNT as cnt_inserted' ;
exec(@sql+@sql2)



if @rowcnt >0    -- есть ошибки
 begin 
   -- 1.1 проверка. Ошибки есть!!! Теперь выводятся все ошибки!!! А не первая попавшаяся!!!

  select @sql=' select 
(select top 1 cnt from #tt ) as cnt_inserted,    
  ''error!!!'' as err, *
  ,
   --case when id_ploshadki is null  then ''ID место сбора ТБО не из адресного перечьня АСУ ОДС;<br>'' else '''' end +
     case when isnull(ltrim(rtrim(okrug)),''-'') =''-'' or ltrim(okrug)='''' then ''Округ пусто; <br>'' else '''' end +
     case when isnull(ltrim(rtrim(rayon)),''-'')=''-'' or ltrim(rayon)='''' then ''Район пусто; <br>'' else '''' end +
     case when isnull(ltrim(rtrim(uchasnik_eksperementa)),''-'') in(''-'', '''') then ''Участник эксперемента пусто; <br>'' else '''' end +
     case when isnull(ltrim(rtrim(str(chislenost_nasiliniya,25))),''-'')=''-'' or ltrim(chislenost_nasiliniya)=''''  then ''Численность начеления пусто; <br>'' else '''' end +
     case when chislenost_nasiliniya is null or isnumeric(chislenost_nasiliniya)<> 1 then ''Численность населения не является числом; <br>'' else '''' end +
     case when uchasnik_eksperementa not in (''Да'', ''Нет'') then ''В поле участник эксперемента допускается написание только: Да или Нет; <br>'' else '''' end +
         '''' as err_text
        
  from(
  select t.*
 from( select t.*, oso.id_ploshadki from (SELECT  ID, [Округ] as okrug, [Район] as rayon, [УНОМ МКД] as unom_mkd, [Адрес МКД] as adres_mkd,	
       [Наименование управляющей компании] as ima_upravl_kompanii, [Участник эксперимента] as uchasnik_eksperementa, 
       [Чиленность населения в МКД, жителей] as chislenost_nasiliniya, 
       [Метод сбора отходов] as metod_sbora, 
       [ID Дворовой территории] as id_dvor_territorii, 
       [Наименование дворовой территории] as ima_dvor_territorii, 
       [ID места сбора ТБО]as id_mesta_sbora_tbo, 
       [Адрес места сбора ТБО] as adres_mesta_sbora_tbo, 
       [ID места сбора КГМ] as id_mesta_sbora_kgm,
       [Адрес места сбора КГМ] as adres_mesta_sbora_kgm 
        
        FROM OPENROWSET(''MSDASQL'',''DRIVER=Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb);
                  UID=admin;UserCommitSync=Yes;Threads=3;SafeTransactions=0;ReadOnly=1;PageTimeout=5;MaxScanRows=8;MaxBufferSize=2048;FIL=excel 12.0;DriverId=1046;DefaultDir=c:\;DBQ='+@fname+''',
        ''SELECT * FROM [Все адреса$]'')
              where [Округ] is not null ) t
       inner join #t as oso on oso.id = t.id
            ' ,
            
           @sql2= case when (select count(1) from #region)>5 then '
         inner join #region r on r.strval=t.rayon ' else  ' where 1=1 '+ @filter  end+' ) t

)t
  ';
  
  exec(@sql+ @sql2);
--print(@sql);print(@sql2)

  
  end
 else 
  begin
  select top 1 cnt cnt_inserted from #tt

end

end
GO
