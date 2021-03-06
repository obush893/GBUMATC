/****** Object:  StoredProcedure [dbo].[p_getdetailed_zapolnaem_nejelyo_old]    Script Date: 08/05/2016 08:55:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[p_getdetailed_zapolnaem_nejelyo_old]
@addr nvarchar(255),
@id varchar(255)=null
as 


/*
[p_getdetailed_zapolnaem_nejelyo] null, null
[p_getdetailed_zapolnaem_nejelyo] '','1987960'
[p_getdetailed_zapolnaem_nejelyo] 'Зеленоград г. к.1431',''
 chislenost_nasiliniya
 ima_dvor_territorii
  это для таблицы мкд
  
 
 давай по очереди. а то я немного запутался.
1 таблица: 
"адреса МКД", 4 столбцов: дома, население, объем отходов эксперем-ент, объем отходов не эксперемент. дома и население берем из таблицы, 
а объем расходов расчитываем вот по этому куску: CAST( SUM(p1)*1.45/365 as decimal(10,2))[Эксперимент, м3/сутки] 
, CAST( SUM(p2)*1.45/365 as decimal(10,2)) [Не эксперимент, м3/сутки],
 
 
*/

declare @Text1 varchar(8000)

select @addr = ISNULL(ltrim(rtrim(@addr)),''),
       @id =  ISNULL(ltrim(rtrim(@id)),'') 


select   t2.id_mesta_sbora_tbo [ID места сбора ТБО],
 id_dvor_territorii [ID дворовой территории],
 ima_arendatora [Имя арендатора],
 arenduemaya_ploshad [Арендуемая площадь],
 adres.min_adres_ploshadki [Адрес места сбора ТБО],
 t2.p3 [Арендаторы в МКД, м3/сутки]
 From
 (
 select   id_mesta_sbora_tbo,id_dvor_territorii,ima_arendatora,
 CAST(SUM(p3) as decimal(10,2)) p3,
 sum(chislennost) chislennost,
 sum(arenduemaya_ploshad) arenduemaya_ploshad
 
 from(
      select    d1.id_mesta_sbora_tbo, d1.adres_mesta_sbora_tbo,
       cast(case when d2.ktype='Площадь' and del=0 then d2.kub_metrov * d1.arenduemaya_ploshad /365
       else d2.kub_metrov * d1.chislennost /365 end as float) p3,
   
   chislennost,
   id_dvor_territorii,
   ima_arendatora,
   arenduemaya_ploshad
    from dbo.tbo_zapolnaem_nejelyo d1
    join  dbo.[tbo_koef]  d2 on d2.naimenovanie = d1.vid_deyatelnosti
     where d1.del=0
     
) t
    group by   id_mesta_sbora_tbo,id_dvor_territorii, ima_arendatora
) t2
left join (select f.id_ploshadki, min(f.adres_ploshadki) min_adres_ploshadki, max(f.adres_ploshadki)  max_adres_ploshadki,
        count(distinct f.adres_ploshadki) cnt_adres_ploshadki
           from  dbo.tbo_obekti_sbora_otkhodov f
           group by f.id_ploshadki
            )adres
              on  adres.id_ploshadki= t2.id_mesta_sbora_tbo 
              
where       (@id='' or  @id= t2.id_mesta_sbora_tbo) and  (@addr='' or @addr=adres.min_adres_ploshadki      )

              order by  adres.min_adres_ploshadki
GO
