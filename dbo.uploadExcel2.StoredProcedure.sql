/****** Object:  StoredProcedure [dbo].[uploadExcel2]    Script Date: 08/05/2016 08:55:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[uploadExcel2] 
 @fname varchar(255) ,
 @filter varchar(8000)=null
as
 begin
 
 set @filter =ISNULL(@filter,'')
/*
GBUMATC; exec [uploadExcel] 'E:\DataBase\TBO_files\13.10.2015_12-34-20.xlsx', ' where ( [rayon] = ''Бибирево'' or [rayon] = ''Бутырский'')'


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

CREATE TABLE #t(
  id int,
	[okrug] [nvarchar](255),
	[rayon] [nvarchar](255),
	[unom_mkd]  [nvarchar](255),
	[adres_mkd] [nvarchar](255),
	[ima_upravl_kompanii] [nvarchar](255),
	[uchasnik_eksperementa] [nvarchar](255),
	[chislenost_nasiliniya] [nvarchar](255),
	[metod_sbora] [nvarchar](255),
	[id_dvor_territorii] [nvarchar](255),
	[ima_dvor_territorii] [nvarchar](255),
	[id_mesta_sbora_tbo] [nvarchar](255),
	[adres_mesta_sbora_tbo] [nvarchar](255),
	[id_mesta_sbora_kgm] [nvarchar](255),
	[adres_mesta_sbora_kgm] [nvarchar](255)
	)


 insert into #t (id,okrug, rayon, unom_mkd, adres_mkd, ima_upravl_kompanii, 
uchasnik_eksperementa, chislenost_nasiliniya, 
metod_sbora, id_dvor_territorii, ima_dvor_territorii, id_mesta_sbora_tbo, 
adres_mesta_sbora_tbo, id_mesta_sbora_kgm, adres_mesta_sbora_kgm)

exec ('declare @d datetime;set @d=GETDATE(); 
select * from(  SELECT ID, [Округ] as okrug, [Район] as rayon, [УНОМ МКД] as unom_mkd, [Адрес МКД] as adres_mkd,	
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
        FIL=excel 12.0;DriverId=1046;DefaultDir=c:\;DBQ='+@fname+''', ''SELECT * FROM [Все адреса$]''
))t
where ( ltrim(isnull(cast(okrug as varchar(4000)),''-'')) =''-''
      or ltrim(isnull(cast(rayon as varchar(4000)),''-''))=''-''
      or ltrim(isnull(cast(adres_mkd as varchar(4000)),''-''))=''-''
     -- or ltrim(isnull(cast(ima_upravl_kompanii as varchar(4000)),''-''))=''-'' 
      or ltrim(isnull(cast(uchasnik_eksperementa as varchar(4000)),''-''))=''-'' 
     -- or ltrim(isnull(cast(metod_sbora as varchar(4000)),''-''))=''-'' 
     -- or ltrim(isnull(cast(adres_mesta_sbora_tbo as varchar(4000)),''-''))=''-'' 
     -- or ltrim(isnull(cast(adres_mesta_sbora_kgm as varchar(4000)),''-''))=''-''
      --or ltrim(isnull(cast(unom_mkd as varchar(4000)),''-''))=''-'' 
      or ltrim(isnull(cast(chislenost_nasiliniya as varchar(4000)),''-''))=''-'' 
      or ltrim(isnull(cast(id_mesta_sbora_tbo as varchar(4000)),''-''))=''-'' 
      --or ISNUMERIC(unom_mkd)<> 1
      or ISNUMERIC(chislenost_nasiliniya)<> 1
      or ISNUMERIC(id_mesta_sbora_tbo)<> 1
      or uchasnik_eksperementa not in (''да'',''нет'')

) ' + @filter)



set @rowcnt =@@ROWCOUNT 
if @rowcnt >0  
  --select  'error!!!' as err, *
 -- from #t
  
--else 
 begin
  select  'error!!!' as err, *,
      case when isnull(okrug ,'-') ='-'  or ltrim(okrug)='' then 'Округ пусто; <br>' else '' end +
      case when isnull(rayon,'-')='-'    or ltrim(rayon)='' then 'Район пусто; <br>' else '' end +
      case when isnull(adres_mkd ,'-')='-'        or ltrim(adres_mkd)=''  then 'Адрес МКД  пусто; <br>' else '' end +
      --case when isnull(ima_upravl_kompanii ,'-')='-'   or ltrim(ima_upravl_kompanii)='' then 'Имя управляющей компании  пусто; <br>' else '' end +
      case when isnull(uchasnik_eksperementa,'-')='-' or ltrim(uchasnik_eksperementa)='' then 'Участник эксперемента пусто; <br>' else '' end +
      --case when isnull(metod_sbora,'-')='-' or ltrim(metod_sbora)=''  then 'Метод сбора тбо пусто; <br>' else '' end +
      --case when isnull(adres_mesta_sbora_tbo,'-')='-' or ltrim(adres_mesta_sbora_tbo)=''  then 'Адрес места сбора ТБО пусто; <br>' else '' end +
      --case when isnull(adres_mesta_sbora_kgm,'-')='-' or ltrim(adres_mesta_sbora_kgm)=''  then 'Адрес места сбора КГМ пусто; <br>' else '' end +
      --case when isnull(unom_mkd,'-')='-' or ltrim(unom_mkd)=''  then 'УНОМ МКД пусто; <br>' else '' end +
      case when isnull(chislenost_nasiliniya,'-')='-' or ltrim(chislenost_nasiliniya)=''  then 'Численность начеления пусто; <br>' else '' end +
      case when isnull(id_mesta_sbora_tbo,'-')='-' or ltrim(id_mesta_sbora_tbo)=''  then 'ID места сбора ТБО пусто; <br>' else '' end +
      --case when unom_mkd is null or isnumeric(unom_mkd )<> 1  then 'УНОМ МКД  не является числом; <br>' else '' end +
      case when chislenost_nasiliniya is null or isnumeric(chislenost_nasiliniya)<> 1 then 'Численность населения не является числом; <br>' else '' end +
      case when uchasnik_eksperementa not in ('да', 'нет') then 'В поле участник эксперемента допускается написание только: да или нет; <br>' else '' end +
      case when id_mesta_sbora_tbo is null or isnumeric(id_mesta_sbora_tbo)<> 1 then 'ID место сбора ТБО не является числом; <br>' else '' end  as err_text
      
        --- это я добавил 
  from #t
  end
--else 
 begin  
  
 --  select  top 0 'No error!!!' as err, 0 as cntErrors
   
--   Раскоментируй, после того как наиграешься с этой процедурой!!!
exec ('declare @d datetime;set @d=GETDATE(); 
insert into dbo.tbo_vse_adresa(okrug, rayon, unom_mkd, adres_mkd, ima_upravl_kompanii, uchasnik_eksperementa, chislenost_nasiliniya, metod_sbora, id_dvor_territorii, ima_dvor_territorii, id_mesta_sbora_tbo, adres_mesta_sbora_tbo, id_mesta_sbora_kgm, adres_mesta_sbora_kgm, del,    dataZagruzki,      dataUdaleniya, fname)
--SELECT                         okrug, rayon, unom_mkd, adres_mkd, ima_upravl_kompanii, uchasnik_eksperementa, chislenost_nasiliniya, metod_sbora, cast(id_dvor_territorii as int), ima_dvor_territorii, cast(id_mesta_sbora_tbo as int), adres_mesta_sbora_tbo, cast(id_mesta_sbora_kgm as int), adres_mesta_sbora_kgm,   0, @d dataZagruzki, null dataUdaleniya, '''+@fname+''' fname FROM OPENROWSET(''MSDASQL'',''DRIVER=Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb);UID=admin;UserCommitSync=Yes;Threads=3;SafeTransactions=0;ReadOnly=1;PageTimeout=5;MaxScanRows=8;MaxBufferSize=2048;FIL=excel 12.0;DriverId=1046;DefaultDir=c:\;DBQ='+@fname+''', ''SELECT * FROM [Все адреса$]''
select okrug, rayon, unom_mkd, adres_mkd, ima_upravl_kompanii, uchasnik_eksperementa, chislenost_nasiliniya, metod_sbora, id_dvor_territorii, ima_dvor_territorii, id_mesta_sbora_tbo, adres_mesta_sbora_tbo, id_mesta_sbora_kgm, adres_mesta_sbora_kgm, del,    dataZagruzki,      dataUdaleniya, fname
 from( SELECT ID,  [Округ] as okrug, 
        [Район] as rayon,
        [УНОМ МКД] as unom_mkd, [Адрес МКД] as adres_mkd,	
         [Наименование управляющей компании] as ima_upravl_kompanii, 
         [Участник эксперимента] as uchasnik_eksperementa, 
         [Чиленность населения в МКД, жителей] as chislenost_nasiliniya, 
         [Метод сбора отходов] as metod_sbora, 
         [ID Дворовой территории] as id_dvor_territorii, 
         [Наименование дворовой территории] as ima_dvor_territorii, 
         [ID места сбора ТБО] as id_mesta_sbora_tbo, 
         [Адрес места сбора ТБО] as adres_mesta_sbora_tbo, 
         [ID места сбора КГМ] as id_mesta_sbora_kgm, 
         [Адрес места сбора КГМ] as adres_mesta_sbora_kgm,  
         0 del, @d dataZagruzki, null dataUdaleniya, '''+@fname+''' fname FROM OPENROWSET(''MSDASQL'',''DRIVER=Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb);UID=admin;UserCommitSync=Yes;Threads=3;SafeTransactions=0;ReadOnly=1;PageTimeout=5;MaxScanRows=8;MaxBufferSize=2048;FIL=excel 12.0;DriverId=1046;DefaultDir=c:\;DBQ='+@fname+''', ''SELECT * FROM [Все адреса$]''

)) t 
where ID not in(select id from #t) 
' + @filter + ' ;  select @@ROWCOUNT as cnt_inserted')
 end;
 
-- потому что тут используется другой тип данных отличный от строки. В данном случае целочисленное значение!!


 
/*

 exec [uploadExcel] 'E:\DataBase\TBO_files\15.10.2015_14-17-35_naselenie.xlsx', ''


я файлы старые удалил


*/

end
GO
