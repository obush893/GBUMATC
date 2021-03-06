/****** Object:  StoredProcedure [dbo].[p_getdetailed_summary4]    Script Date: 08/05/2016 08:55:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[p_getdetailed_summary4]
@addr nvarchar(255),
@id varchar(255)=null
,@okrug varchar(255)= null

as 
set nocount on

/*
p_getdetailed_summary null, null
p_getdetailed_summary4 '','1987960','all'
[p_getdetailed_summary4] 'Зеленоград г. к.1431',''

select * from  dbo.fn_find_addr2('1987960')
 
*/
select @addr = ISNULL(ltrim(rtrim(@addr)),''),
       @id =  ISNULL(ltrim(rtrim(@id)),'') 
      ,@okrug=','+ISNULL(ltrim(rtrim(@okrug)),'')+','




 select --adres_mesta_sbora_tbo [Адрес места сбора ТБО],
 CAST(SUM(IsNull(p1,0))*1.45/365 as decimal(10,5))[Эксперимент, м3/сутки],
 CAST(SUM(IsNull(p2,0))*1.45/365 as decimal(10,5)) [Не эксперимент, м3/сутки],
 CAST(SUM(IsNull(p3,0)) as decimal(10,5)) [Арендаторы в МКД, м3/сутки],
 CAST(SUM(IsNull(p4,0)) as decimal(10,5)) [Отдельно стоящие здания, куб.м. в сутки],
 CAST(SUM(IsNull(p1,0))*1.45/365+ SUM(IsNull(p2,0))*1.45/365+SUM(IsNull(p3,0)) as decimal(10,5))[ОБЩИЙ объем отходов, куб.м. в сутки]
 from(
     select id_mesta_sbora_tbo ,adres_mesta_sbora_tbo,
       case when uchasnik_eksperementa like 'да'   then chislenost_nasiliniya else cast(0 as float) end p1,
       case when uchasnik_eksperementa like 'нет'  then chislenost_nasiliniya else cast(0 as float)  end p2,
       cast(0 as float) p3,
     cast(0 as float) p4
     From dbo.tbo_vse_adresa va
     where del=0
     and (@okrug like '%all%' or @okrug like '%,'+va.okrug+',%')
     and  (@id='' or exists( select * from  dbo.fn_find_addr2(@id) a where a.addr1=va.adres_mesta_sbora_tbo )  or va.adres_mesta_sbora_tbo=@addr  ) 
     and  (@addr='' or exists( select * from  dbo.fn_find_id2(@addr) i where i.id_ploshadki=va.id_mesta_sbora_tbo) or  va.id_mesta_sbora_tbo=@id )
     
    Union All
      select   d1.id_mesta_sbora_tbo, d1.adres_mesta_sbora_tbo,
      0 p1,
     0 p2,
       cast(case when d2.ktype='Площадь'  then d2.kub_metrov * d1.arenduemaya_ploshad /365
            else d2.kub_metrov * d1.chislennost /365 end as float) p3
    ,0 p4
     from dbo.tbo_zapolnaem_nejelyo d1 
    join  dbo.[tbo_koef]  d2 on d2.naimenovanie = d1.vid_deyatelnosti
    where d1.del=0
      and (@okrug like '%all%' or @okrug like '%,'+d1.okrug+',%')
      and  (@id='' or exists( select * from  dbo.fn_find_addr2(@id) a where a.addr1=d1.adres_mesta_sbora_tbo )  or d1.adres_mesta_sbora_tbo=@addr  ) 
      and  (@addr='' or exists( select * from  dbo.fn_find_id2(@addr) i where i.id_ploshadki=d1.id_mesta_sbora_tbo) or  d1.id_mesta_sbora_tbo=@id )
    
   
    Union All
     select  d3.id_mesta_sbora_otkhodov, d3.adres_mesta_sbora_otkhodov,
        0 p1,
        0 p2,
        0 p3,
       cast(case when d2.ktype='Площадь'  then d2.kub_metrov * d3.arenduemaya_ploshad /365
            else cast(d2.kub_metrov as float) * d3.chislinnost /365 end as float) p4
    from dbo.tbo_otdelnie d3
     join  dbo.[tbo_koef]  d2 on d2.naimenovanie = d3.vid_deyatelnosti
    where d3.del=0
       and (@okrug like '%all%' or @okrug like '%,'+d3.okrug+',%')
      and  (@id='' or exists( select * from  dbo.fn_find_addr2(@id) a where a.addr1=d3.adres_mesta_sbora_otkhodov )  or d3.adres_mesta_sbora_otkhodov=@addr  ) 
      and  (@addr='' or exists( select * from  dbo.fn_find_id2(@addr) i where i.id_ploshadki=d3.id_mesta_sbora_otkhodov) or  d3.id_mesta_sbora_otkhodov=@id )
     

 ) t
    -- group by adres_mesta_sbora_tbo
GO
