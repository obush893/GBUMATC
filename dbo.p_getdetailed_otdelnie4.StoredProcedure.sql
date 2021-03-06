/****** Object:  StoredProcedure [dbo].[p_getdetailed_otdelnie4]    Script Date: 08/05/2016 08:55:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[p_getdetailed_otdelnie4]
@addr varchar(255),
@id varchar(255)=null
,@okrug varchar(255)= null

as 
set nocount on

/*
[p_getdetailed_otdelnie] null, null
[p_getdetailed_otdelnie] '','1987960'
[p_getdetailed_otdelnie4] ' Белозерская,17г','','all'
[p_getdetailed_otdelnie4] 'ини','','all'

select * from  dbo.fn_find_addr2('')
select ascii(addr1), * from  dbo.fn_find_id2('Белозерская,11')

select top 100 adres_mesta_sbora_otkhodov, LTRIM(rtrim(raplace(adres_mesta_sbora_otkhodov, char(160), char(32))) from tbo_otdelnie where adres_mesta_sbora_otkhodov is not null
 

 chislenost_nasiliniya
 ima_dvor_territorii
  это для таблицы мкд
  
 
 
 
 давай по очереди. а то я немного запутался.
1 таблица: 
"адреса МКД", 4 столбцов: дома, население, объем отходов эксперем-ент, объем отходов не эксперемент. дома и население берем из таблицы, 
а объем расходов расчитываем вот по этому куску: CAST( SUM(p1)*1.45/365 as decimal(10,2))[Эксперимент, м3/сутки] 
, CAST( SUM(p2)*1.45/365 as decimal(10,2)) [Не эксперимент, м3/сутки],
 
 
*/


select @addr = ISNULL(ltrim(rtrim(@addr)),''),
       @id =  ISNULL(ltrim(rtrim(@id)),'')
      ,@okrug= ','+IsNull(ltrim(rtrim(@okrug)), '')+','


  select  t2.adres_mesta_sbora_otkhodov [Адрес места сбора ТБО],   
    ima_arendatora [Имя арендатора],
    t2.[Объем отходов, м3/сутки] 
  From( select id_mesta_sbora_otkhodov ,
                ima_arendatora,
                adres_mesta_sbora_otkhodov,
                CAST(SUM(cast(case when d2.ktype='Площадь' and del=0 then d2.kub_metrov * d3.arenduemaya_ploshad /365
                                   else d2.kub_metrov * d3.chislinnost /365 end as float)) as decimal(10,5)) [Объем отходов, м3/сутки]
          from dbo.tbo_otdelnie d3
          join  dbo.[tbo_koef]  d2 on d2.naimenovanie = d3.vid_deyatelnosti
           where d3.del=0 and (@okrug like '%all%' or @okrug like '%,'+d3.okrug+',%')
            group by   id_mesta_sbora_otkhodov, ima_arendatora,adres_mesta_sbora_otkhodov
        ) t2
        

  where       

  (@addr='' or exists( select * from  dbo.fn_find_addr2(@id) a where a.addr1=t2.adres_mesta_sbora_otkhodov )  or adres_mesta_sbora_otkhodov=@addr  )
  and (@id='' or exists( select * from  dbo.fn_find_id2(@addr) i where i.id_ploshadki=t2.id_mesta_sbora_otkhodov) or  id_mesta_sbora_otkhodov=@id  )
 

  order by t2.adres_mesta_sbora_otkhodov
GO
