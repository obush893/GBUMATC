/****** Object:  StoredProcedure [dbo].[p_getdetailed_zapolnaem_nejelyo]    Script Date: 08/05/2016 08:55:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[p_getdetailed_zapolnaem_nejelyo]
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
 
 
declare @s varchar(255)='1-й Нагатинский проезд, д.11. корп.1'
exec  dbo.p_getdetailed_vse_adresa @s,'','all'
exec  dbo.p_getdetailed_otdelnie @s,'','all'
exec   dbo.p_getdetailed_zapolnaem_nejelyo @s,'','all'
exec  dbo.p_getdetailed_summary @s,'','all'
 
 
 
*/

declare @Text1 varchar(8000)

select @addr = ISNULL(ltrim(rtrim(@addr)),''),
       @id =  ISNULL(ltrim(rtrim(@id)),'') 
    ,@okrug=','+ISNULL(ltrim(rtrim(@okrug)),'')+','



 

select  adres_mesta_sbora_tbo [Адрес места сбора ТБО],
 ima_arendatora [Имя арендатора],
-- chislennost [Численность населения],
--t2.id_mesta_sbora_tbo [ID места сбора ТБО],
-- id_dvor_territorii [ID дворовой территории],
 
 --arenduemaya_ploshad [Арендуемая площадь],
 
 t2.p3 [Объем отходов, м3/сутки]
 From (select d1.id_mesta_sbora_tbo, id_dvor_territorii,d1.adres_mesta_sbora_tbo ,
              ima_arendatora,
              CAST(SUM(cast(case when d2.ktype='Площадь' then d2.kub_metrov * d1.arenduemaya_ploshad /365
                            else d2.kub_metrov * d1.chislennost /365 end as float)) as decimal(10,5)) p3,
        --      sum(chislennost) chislennost,
              sum(arenduemaya_ploshad) arenduemaya_ploshad
       from dbo.tbo_zapolnaem_nejelyo d1
       join  dbo.[tbo_koef]  d2 on d2.naimenovanie = d1.vid_deyatelnosti
       where d1.del=0 
        and (@okrug like '%all%' or @okrug like '%,'+d1.okrug+',%')
      and  (@id='' or exists( select * from  dbo.fn_find_addr2(@id) a where a.addr1=d1.adres_mesta_sbora_tbo )    or  d1.id_mesta_sbora_tbo=@id) 
      and  (@addr='' or exists( select * from  dbo.fn_find_id2(@addr) i where i.id_ploshadki=d1.id_mesta_sbora_tbo) or d1.adres_mesta_sbora_tbo=@addr )
    
       group by  d1.id_mesta_sbora_tbo,id_dvor_territorii, ima_arendatora,adres_mesta_sbora_tbo
      ) t2

        
order by adres_mesta_sbora_tbo
GO
