/****** Object:  StoredProcedure [dbo].[uploadExcel_otdelnie]    Script Date: 08/05/2016 08:55:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uploadExcel_otdelnie] 
 @fname varchar(255) ,
 @filter varchar(8000)=null,
 @regions varchar(8000)=null
as
 begin
 
 set @filter =ISNULL(@filter,'')
 
 
/*Ok???
сейчас проверю, но последнюю проверку по ID нужно пока отключить

exec GBUMATC.dbo.[uploadExcel_otdelnie] 'E:\DataBase\TBO_files\25.11.2015_16-28-55_otdelnie.xlsx', ' and [rayon] in( ''Крюково'',''Матушкино'',''Савелки'',''Силино'',''Старое Крюково'')', 'Крюково,Матушкино,Савелки,Силино,Старое Крюково'


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
select t.ID, /*oso.id_ploshadki */ 1 as  id_ploshadki
  from (select t.* from(SELECT ID, [Округ]  as okrug, 
                 [Район]   as rayon, 
                ltrim(rtrim(str( [УНОМ здания],255 ))) as unom,
                 [Адрес здания]   as adres,	
                 [Наименование арендатора]  as ima_arendatora, 
                 cast (inn as varchar) as inn ,
                 [Арендуемая площадь, м2 (для отдельных видов деятельности)] as arenduemaya_ploshad, 
                 [Численность (для отдельных видов деятельности)] as chislinnost, 
                [Вид деятельности] as vid_deyatelnosti, 
                 [Объем по договору, тонн в год] as obem_po_dogovoru, 
                 [ID места сбора отходов]  as id_mesta_sbora_otkhodov, 
                 [Адрес места сбора отходов] as adres_mesta_sbora_otkhodov,
                 [Мусоровывозящая компания] as musorovivodashaya_kompaniya,
                 [№ Договора] as nomer_dogovora,
                 [Дата заключения договора]   as data_zaklucheniya_dogovora, 
                 [Срок действия договора]  as srok_deystviya_dogovora
        
          FROM OPENROWSET(''MSDASQL'',''DRIVER=Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb);
                  UID=admin;UserCommitSync=Yes;Threads=3;SafeTransactions=0;ReadOnly=1;PageTimeout=5;MaxScanRows=8;MaxBufferSize=2048;
                  FIL=excel 12.0;DriverId=1046;DefaultDir=c:\;DBQ='+@fname+''', ''SELECT * FROM [Заполняем ОСЗ$]'')
              where [Округ] is not null    
            ) t ' ,
        @sql2=case when (select count(1) from #region)>5 then '
         inner join #region r on r.strval=t.rayon ' else  ' where 1=1 '+ @filter end+') t
        
/* left join (select id_ploshadki , max(rayon) rayon from dbo.tbo_obekti_sbora_otkhodov t '+
            case when (select count(1) from #region)>5 then '  inner join #region r on r.strval=t.rayon '
      else  ' where 1=1 '+ @filter end+ ' group by id_ploshadki) as oso on t.id_mesta_sbora_otkhodov= oso.id_ploshadki and t.rayon  = oso.rayon 
*/  
LEFT JOIN [tbo_koef] k on k.naimenovanie = t.vid_deyatelnosti 

where (/*oso.id_ploshadki is null
      or */ k.naimenovanie is null 
      --or t.id_mesta_sbora_otkhodov is null
      or ltrim(isnull(cast(okrug as varchar(4000)),''-'')) =''-''
      or ltrim(isnull(cast(t.rayon as varchar(4000)),''-''))=''-'' 
      or ltrim(isnull(cast(vid_deyatelnosti as varchar(4000)),''-''))=''-'' 
      or ISNUMERIC(IsNull(chislinnost,0))<>1
      or ISNUMERIC(IsNull(arenduemaya_ploshad,0))<>1
      
      
) ';
/*  and adres=''МКАД, 78 км, 14, корп. 1''
*/
-- 1 проверка. Набирает временную таблицу с ошибками!!!

 exec(@sql+@sql2);
 
 
 /*select * from #t
 return */
 --print(@sql);print(@sql2);return
 
 --это к другой таблице
set @rowcnt =@@ROWCOUNT 

create  table #tt(cnt int)

select @sql ='declare @d datetime;set @d=GETDATE(); 

insert into dbo.tbo_otdelnie(okrug, rayon, unom, adres, ima_arendatora, inn, arenduemaya_ploshad, chislinnost, 
vid_deyatelnosti, obem_po_dogovoru, id_mesta_sbora_otkhodov, adres_mesta_sbora_otkhodov, musorovivodashaya_kompaniya, 
nomer_dogovora, data_zaklucheniya_dogovora, srok_deystviya_dogovora, del, dataZagruzki, dataUdaleniya, fname)

select rtrim(ltrim(okrug)), rtrim(ltrim(t.rayon)), unom, rtrim(ltrim(adres)), rtrim(ltrim(ima_arendatora)), 
rtrim(ltrim(inn)), arenduemaya_ploshad, chislinnost,
 rtrim(ltrim(vid_deyatelnosti)), obem_po_dogovoru, id_mesta_sbora_otkhodov, 
 rtrim(ltrim(adres_mesta_sbora_otkhodov)), rtrim(ltrim(musorovivodashaya_kompaniya)),
  rtrim(ltrim(nomer_dogovora)), data_zaklucheniya_dogovora,srok_deystviya_dogovora, del, dataZagruzki, dataUdaleniya, fname
from(  SELECT  ID, [Округ]  as okrug, 
       [Район]   as rayon, 
       [УНОМ здания] as unom,
       [Адрес здания]   as adres,	
        [Наименование арендатора]  as ima_arendatora, 
         cast (inn as varchar) as inn,
       [Арендуемая площадь, м2 (для отдельных видов деятельности)] as arenduemaya_ploshad, 
       [Численность (для отдельных видов деятельности)] as chislinnost, 
      [Вид деятельности] as vid_deyatelnosti, 
       [Объем по договору, тонн в год] as obem_po_dogovoru, 
       [ID места сбора отходов]  as id_mesta_sbora_otkhodov, 
       [Адрес места сбора отходов] as adres_mesta_sbora_otkhodov,
       [Мусоровывозящая компания] as musorovivodashaya_kompaniya,
       [№ Договора] as nomer_dogovora,
       [Дата заключения договора]   as data_zaklucheniya_dogovora, 
       [Срок действия договора]  as srok_deystviya_dogovora,
        
        0 del, @d dataZagruzki, null dataUdaleniya, '''+@fname+''' fname 
        FROM OPENROWSET(''MSDASQL'',''DRIVER=Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb);UID=admin;UserCommitSync=Yes;Threads=3;SafeTransactions=0;ReadOnly=1;PageTimeout=5;MaxScanRows=8;MaxBufferSize=2048;FIL=excel 12.0;DriverId=1046;DefaultDir=c:\;DBQ='+@fname+''',
        ''SELECT * FROM [Заполняем ОСЗ$]''

)) t 

', @sql2=
 case when (select count(1) from #region)>5 then '
         inner join #region r on r.strval=t.rayon 
         where okrug is not null and ID not in(select id from #t) '
     else ' where okrug is not null and ID not in(select id from #t) '+ @filter  end+ 
  + ' 
 ;  insert into #tt(cnt) select @@ROWCOUNT as cnt_inserted' ;

exec (@sql + @sql2)



if @rowcnt >0    -- есть ошибки
 begin 
   -- 1.1 проверка. Ошибки есть!!! Теперь выводятся все ошибки!!! А не первая попавшаяся!!!


 select @sql='declare @d datetime ; set @d= getdate(); select 
(select top 1 cnt from #tt ) as cnt_inserted,    
  ''error!!!'' as err, *,
    case when ktype_name is null  then ''Параметр "Вид деятельности" не из справочника;<br>'' else '''' end +
    case when  id_ploshadki is null  then ''ID площадки не из адресного перечьня АСУ ОДС;<br>'' else '''' end +
      case when isnull(okrug ,''-'') =''-''  or ltrim(okrug)='''' then ''Округ пусто; <br>'' else '''' end +
      case when isnull(t.rayon,''-'')=''-''    or ltrim(t.rayon)='''' then ''Район пусто; <br>'' else '''' end +
      case when isnull(vid_deyatelnosti,''-'')=''-'' or ltrim(vid_deyatelnosti)='''' then ''Вид деятельности пусто; <br>'' else '''' end +
      case when isnumeric(isnull(arenduemaya_ploshad,0))<> 1 then ''Арендуемая площадь не является числом; <br>'' else '''' end +
      case when isnumeric(IsNull(chislinnost,0))<> 1 then ''Численность не является целым числом; <br>'' else '''' end +
--case when id_mesta_sbora_otkhodov is null then '' ID места сбора отходов пусто;<br>'' else  '''' end +
      '''' as err_text
  from(select t.*, oso.id_ploshadki,k.naimenovanie as ktype_name from (SELECT ID, [Округ]  as okrug, 
                 [Район]   as rayon, 
                ltrim(rtrim(str( [УНОМ здания],255 ))) as unom,
                 [Адрес здания]   as adres,	
                 [Наименование арендатора]  as ima_arendatora, 
                 cast (inn as varchar) as inn ,
                 [Арендуемая площадь, м2 (для отдельных видов деятельности)] as arenduemaya_ploshad, 
                 [Численность (для отдельных видов деятельности)] as chislinnost, 
                [Вид деятельности] as vid_deyatelnosti, 
                 [Объем по договору, тонн в год] as obem_po_dogovoru, 
                 [ID места сбора отходов]  as id_mesta_sbora_otkhodov, 
                 [Адрес места сбора отходов] as adres_mesta_sbora_otkhodov,
                 [Мусоровывозящая компания] as musorovivodashaya_kompaniya,
                 [№ Договора] as nomer_dogovora,
                 [Дата заключения договора]   as data_zaklucheniya_dogovora, 
                 [Срок действия договора]  as srok_deystviya_dogovora,
        
        0 del, @d dataZagruzki, null dataUdaleniya, '''+@fname+''' fname 
        FROM OPENROWSET(''MSDASQL'',''DRIVER=Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb);
                  UID=admin;UserCommitSync=Yes;Threads=3;SafeTransactions=0;ReadOnly=1;PageTimeout=5;MaxScanRows=8;MaxBufferSize=2048;FIL=excel 12.0;DriverId=1046;DefaultDir=c:\;DBQ='+@fname+''',
        ''SELECT * FROM [Заполняем ОСЗ$]'')
              where [Округ] is not null 
            ) t inner join #t oso on oso.id=t.id ', @sql2='
          LEFT JOIN [tbo_koef] k on k.naimenovanie = t.vid_deyatelnosti 
)t
  ';
  
 exec(@sql+ @sql2);
--print (@sql) ; print(@sql2);return
  
  end
 else 
  begin
  select top 1 cnt cnt_inserted from #tt

end

end
GO
