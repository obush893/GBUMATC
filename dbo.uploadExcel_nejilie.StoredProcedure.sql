/****** Object:  StoredProcedure [dbo].[uploadExcel_nejilie]    Script Date: 08/05/2016 08:55:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[uploadExcel_nejilie] 
 @fname varchar(255) ,
 @filter varchar(8000)=null,
 @regions varchar(8000)=null
as
 begin
 
 set @filter =ISNULL(@filter,'')
 
 
/*


exec GBUMATC.dbo.[uploadExcel_nejilie] 'E:\DataBase\TBO_files\24.11.2015_9-36-09_nejele.xlsx', ' and [rayon] in( ''Крюково'',''Матушкино'',''Савелки'',''Силино'',''Старое Крюково'')', 'Крюково,Матушкино,Савелки,Силино,Старое Крюково'

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
 from(  SELECT t.* from (select ID, [Округ]  as okrug, 
       [Район]   as rayon, 
       [УНОМ МКД] as unom_mkd,
       [Адрес МКД]   as adres_mkd,	
        [Наименование арендатора]  as ima_arendatora, 
       --cast ([ИНН арендатора] as char) as   inn_arendatora, 
        inn inn_arendatora,
       [Арендуемая площадь, м2 (для отдельных видов деятельности)] as arenduemaya_ploshad, 
       [Численность (для отдельных видов деятельности)] as chislennost, 
      [Вид деятельности] as vid_deyatelnosti, 
       [Образование ТБО по договору, тонн в год] as obrazovanie_TBO, 
       [Образование КГМ по договору, тонн в год]  as obrazovanie_kgm, 
       [ID Дворовой территории] as id_dvor_territorii,
       [Наименование дворовой территории] as ima_dvor_territorii,
       [ID места сбора ТБО] as id_mesta_sbora_tbo,
       [Адрес места сбора ТБО]   as adres_mesta_sbora_tbo, 
       [ID места сбора КГМ]  as id_mesta_sbora_kgm, 
        [Адрес места сбора КГМ] as adres_mesta_sbora_kgm, 
        [Мусоровывозящая компания] as musorovivodashaya_kompaniya, 
        [№ Договора] as nomer_dogovora,
        [Дата заключения договора] as data_zaklucheniya_dogovora,
        [Срок действия договора] as srok_deystviya_dogovora,
        [Дата/время принятия информации] as data_vrema_prinatiya_informatsii
        
          FROM OPENROWSET(''MSDASQL'',''DRIVER=Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb);
                  UID=admin;UserCommitSync=Yes;Threads=3;SafeTransactions=0;ReadOnly=1;PageTimeout=5;MaxScanRows=8;MaxBufferSize=2048;
                  FIL=excel 12.0;DriverId=1046;DefaultDir=c:\;DBQ='+@fname+''', ''SELECT * FROM [Заполняем нежилье$]'')
              where [Округ] is not null    
            ) t ' ,
        @sql2=case when (select count(1) from #region)>5 then '
         inner join #region r on r.strval=t.rayon ' else  ' where 1=1 '+ @filter end+') t
        
 /*left join (select id_ploshadki , max(rayon) rayon  from dbo.tbo_obekti_sbora_otkhodov t '+
 case when (select count(1) from #region)>5 then '
         inner join #region r on r.strval=t.rayon ' else  ' where 1=1 '+ @filter end+ '
         group by id_ploshadki ) as oso on t.id_mesta_sbora_tbo= oso.id_ploshadki and t.rayon  = oso.rayon 
*/
LEFT JOIN [tbo_koef] k on k.naimenovanie = t.vid_deyatelnosti 
where (/*oso.id_ploshadki is null
      or t.id_mesta_sbora_tbo is null
      or */k.naimenovanie is null 
      or ltrim(isnull(cast(okrug as varchar(4000)),''-'')) =''-''
      or ltrim(isnull(cast(t.rayon as varchar(4000)),''-''))=''-'' 
      or ltrim(isnull(cast(vid_deyatelnosti as varchar(4000)),''-''))=''-'' 
      or ISNUMERIC(IsNull(chislennost,0))<>1
      or ISNUMERIC(IsNull(arenduemaya_ploshad,0))<>1
      --or ISNUMERIC(IsNull(id_mesta_sbora_tbo,0))<>1
      
      
)  ';


-- 1 проверка. Набирает временную таблицу с ошибками!!!

 exec(@sql+ @sql2);
-- print(@sql);print(@sql2); return;
 
 --это к другой таблице
set @rowcnt =@@ROWCOUNT 

create  table #tt(cnt int)

select @sql ='declare @d datetime;set @d=GETDATE(); 

insert into dbo.tbo_zapolnaem_nejelyo(okrug, rayon, unom_mkd, adres_mkd, ima_arendatora, inn_arendatora, arenduemaya_ploshad, 
chislennost, vid_deyatelnosti, obrazovanie_TBO, obrazovanie_kgm, id_dvor_territorii, ima_dvor_territorii, id_mesta_sbora_tbo,
 adres_mesta_sbora_tbo, id_mesta_sbora_kgm, adres_mesta_sbora_kgm, musorovivodashaya_kompaniya, nomer_dogovora, data_zaklucheniya_dogovora,
  srok_deystviya_dogovora, data_vrema_prinatiya_informatsii, del,    dataZagruzki,      dataUdaleniya, fname)
select okrug, rayon, unom_mkd, adres_mkd, ima_arendatora, inn_arendatora, arenduemaya_ploshad, 
chislennost, vid_deyatelnosti, obrazovanie_TBO, obrazovanie_kgm, id_dvor_territorii, ima_dvor_territorii, id_mesta_sbora_tbo,
 adres_mesta_sbora_tbo, id_mesta_sbora_kgm, adres_mesta_sbora_kgm, musorovivodashaya_kompaniya, nomer_dogovora, data_zaklucheniya_dogovora,
  srok_deystviya_dogovora, data_vrema_prinatiya_informatsii, del,    dataZagruzki,      dataUdaleniya, fname 
from(  SELECT  ID,[Округ] as okrug, 
       [Район] as rayon, 
       [УНОМ МКД] as unom_mkd,
       [Адрес МКД] as adres_mkd,	
       [Наименование арендатора] as ima_arendatora, 
       inn as inn_arendatora,
       [Арендуемая площадь, м2 (для отдельных видов деятельности)] as arenduemaya_ploshad, 
       
       [Численность (для отдельных видов деятельности)] as chislennost, 
       [Вид деятельности] as vid_deyatelnosti, 
       [Образование ТБО по договору, тонн в год] as obrazovanie_TBO, 
       [Образование КГМ по договору, тонн в год]  as obrazovanie_kgm, 
       [ID Дворовой территории] as  id_dvor_territorii,
       [Наименование дворовой территории] as ima_dvor_territorii,
       [ID места сбора ТБО] as id_mesta_sbora_tbo,
       
       [Адрес места сбора ТБО] as adres_mesta_sbora_tbo, 
        [ID места сбора КГМ] as id_mesta_sbora_kgm, 
        [Адрес места сбора КГМ] as adres_mesta_sbora_kgm, 
        [Мусоровывозящая компания] as musorovivodashaya_kompaniya, 
        [№ Договора] as nomer_dogovora,
        [Дата заключения договора] as data_zaklucheniya_dogovora,
        
        [Срок действия договора] as srok_deystviya_dogovora,
        [Дата/время принятия информации] as data_vrema_prinatiya_informatsii,
        0 del, @d dataZagruzki, null dataUdaleniya, '''+@fname+''' fname 
        FROM OPENROWSET(''MSDASQL'',''DRIVER=Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb);UID=admin;UserCommitSync=Yes;Threads=3;SafeTransactions=0;ReadOnly=1;PageTimeout=5;MaxScanRows=8;MaxBufferSize=2048;FIL=excel 12.0;DriverId=1046;DefaultDir=c:\;DBQ='+@fname+''',
        ''SELECT * FROM [Заполняем нежилье$]''

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

  select @sql='declare @d datetime ; set @d= getdate(); select 
(select top 1 cnt from #tt ) as cnt_inserted,    
  ''error!!!'' as err, *,
    case when ktype_name is null  then ''Параметр "Вид деятельности" не из справочника;<br>'' else '''' end +
    case when  id_ploshadki is null  then ''ID место сбора ТБО не из адресного перечьня АСУ ОДС;<br>'' else '''' end +
     case when isnull(okrug ,''-'') =''-''  or ltrim(okrug)='''' then ''Округ пусто; <br>'' else '''' end +
      case when isnull(t.rayon,''-'')=''-''    or ltrim(t.rayon)='''' then ''Район пусто; <br>'' else '''' end +
      case when isnull(vid_deyatelnosti,''-'')=''-'' or ltrim(vid_deyatelnosti)='''' then ''Вид деятельности пусто; <br>'' else '''' end +
      case when isnumeric(isnull(arenduemaya_ploshad,0))<> 1 then ''Арендуемая площадь не является числом; <br>'' else '''' end +
      case when isnumeric(IsNull(chislennost,0))<> 1 then ''Численность не является целым числом; <br>'' else '''' end +
      --case when isnumeric(isnull(id_mesta_sbora_tbo,0))<> 1 then ''ID место сбора ТБО не является числом; <br>'' else '''' end +

      '''' as err_text
  from(
  
  select t.*, k.naimenovanie as ktype_name 
 from(select t.*, oso.id_ploshadki from(
  SELECT  ID,[Округ] as okrug, 
       [Район] as rayon, 
       [УНОМ МКД] as unom_mkd,
       [Адрес МКД] as adres_mkd,	
       [Наименование арендатора] as ima_arendatora, 
       inn as inn_arendatora,
       [Арендуемая площадь, м2 (для отдельных видов деятельности)] as arenduemaya_ploshad, 
       [Численность (для отдельных видов деятельности)] as chislennost, 
       [Вид деятельности] as vid_deyatelnosti, 
       [Образование ТБО по договору, тонн в год] as obrazovanie_TBO, 
       [Образование КГМ по договору, тонн в год]  as obrazovanie_kgm, 
       [ID Дворовой территории] as  id_dvor_territorii,
       [Наименование дворовой территории] as ima_dvor_territorii,
       [ID места сбора ТБО] as id_mesta_sbora_tbo,
       [Адрес места сбора ТБО] as adres_mesta_sbora_tbo, 
        [ID места сбора КГМ] as id_mesta_sbora_kgm, 
        [Адрес места сбора КГМ] as adres_mesta_sbora_kgm, 
        [Мусоровывозящая компания] as musorovivodashaya_kompaniya, 
        [№ Договора] as nomer_dogovora,
        [Дата заключения договора] as data_zaklucheniya_dogovora,
        [Срок действия договора] as srok_deystviya_dogovora,
        [Дата/время принятия информации] as data_vrema_prinatiya_informatsii,
        0 del, @d dataZagruzki, null dataUdaleniya, '''+@fname+''' fname 
        FROM OPENROWSET(''MSDASQL'',''DRIVER=Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb);
                  UID=admin;UserCommitSync=Yes;Threads=3;SafeTransactions=0;ReadOnly=1;PageTimeout=5;MaxScanRows=8;MaxBufferSize=2048;FIL=excel 12.0;DriverId=1046;DefaultDir=c:\;DBQ='+@fname+''',
        ''SELECT * FROM [Заполняем нежилье$]'')
              where [Округ] is not null   ) t 
         join #t oso on oso.id= t.id
            ' ,
            
           @sql2= case when (select count(1) from #region)>5 then '
         inner join #region r on r.strval=t.rayon ' else  ' where 1=1 '+ @filter  end+' )t 
 
LEFT JOIN [tbo_koef] k on k.naimenovanie = t.vid_deyatelnosti 
)t
  ';
  
 exec(@sql+ @sql2);
  --print(@sql);print(@sql2); return;

  
  end
 else 
  begin
  select top 1 cnt cnt_inserted from #tt

end

end
GO
