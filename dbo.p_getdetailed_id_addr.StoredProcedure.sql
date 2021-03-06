/****** Object:  StoredProcedure [dbo].[p_getdetailed_id_addr]    Script Date: 08/05/2016 08:55:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[p_getdetailed_id_addr]
@addr nvarchar(255),
@id varchar(255)=null
,@okrug varchar(255)=null
as 


/*
[p_getdetailed_zapolnaem_nejelyo] null, null
[p_getdetailed_zapolnaem_nejelyo4] '','1987960', 'all'
[p_getdetailed_zapolnaem_nejelyo4] 'Зеленоград г. к.1431','', 'all'
 chislenost_nasiliniya
 ima_dvor_territorii
  это для таблицы мкд
  
 
 давай по очереди. а то я немного запутался.
1 таблица: 
"адреса МКД", 4 столбцов: дома, население, объем отходов эксперем-ент, объем отходов не эксперемент. дома и население берем из таблицы, 
а объем расходов расчитываем вот по этому куску: CAST( SUM(p1)*1.45/365 as decimal(10,2))[Эксперимент, м3/сутки] 
, CAST( SUM(p2)*1.45/365 as decimal(10,2)) [Не эксперимент, м3/сутки],
 
 
declare @s varchar(255)='Шубинский пер, дом № 7'
exec  dbo.p_getdetailed_vse_adresa @s,'','all'
exec  dbo.p_getdetailed_otdelnie @s,'','all'
exec   dbo.p_getdetailed_zapolnaem_nejelyo @s,'','all'
exec  dbo.p_getdetailed_summary @s,'','all'
 
 select * from  dbo.fn_find_id2(@s)
 
 
*/

declare @Text1 varchar(8000)

select @addr = ISNULL(ltrim(rtrim(@addr)),''),
       @id =  ISNULL(ltrim(rtrim(@id)),'') 
    ,@okrug=','+ISNULL(ltrim(rtrim(@okrug)),'')+','


select distinct id_ploshadki [ID площадки], addr1 [Адрес] from (
 
 select * from  dbo.fn_find_addr2(@id) 
 union all
 select * from  dbo.fn_find_id2(@addr) 
  
 ) t
GO
