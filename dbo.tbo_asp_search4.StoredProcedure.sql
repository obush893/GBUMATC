/****** Object:  StoredProcedure [dbo].[tbo_asp_search4]    Script Date: 08/05/2016 08:55:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[tbo_asp_search4]
@addr nvarchar(255)= null,
@id varchar(255)=null
,@dostup varchar(255)=null
,@okrug varchar(255)=null
,@rayon varchar(255)=null


as
set nocount on


exec  norm_table_Addr;

/*
exec tbo_asp_search4 @addr='зеленогра',@ID='', @dostup='all'
exec tbo_asp_search4 @addr='',@ID=''
exec tbo_asp_search4 @addr=null,@ID=null


exec tbo_asp_search4 @addr='Зеле',@ID=null, @dostup='all'
*/

select @addr = ISNULL(ltrim(rtrim(@addr)),''),
       @id =  ISNULL(ltrim(rtrim(@id)),'') 
       ,@dostup=ISNULL(ltrim(rtrim(@dostup)),'')
       ,@okrug=ISNULL(ltrim(rtrim(@okrug)),'')
       ,@rayon=ISNULL(ltrim(rtrim(@rayon)),'')

--print(@okrug)


select @addr = case when @addr ='' then '' else '%'+@addr +'%' end 
      
-- Готовим таблицу доступных округов 
select strval into #okrug from dbo.ConvertStringDelimsToTable(@dostup, ',') 


select distinct id [ID], addr [Адрес]  from (  
select  top 1000 ltrim(rtrim(str(id_mesta_sbora_tbo, 30))) id, adres_mesta_sbora_tbo addr,1 tabl
from tbo_vse_adresa va
left join  #okrug okr on okr.StrVal=va.okrug
where del=0 and (id_mesta_sbora_tbo is not null or adres_mesta_sbora_tbo is not null)
 and (@addr ='' or adres_mesta_sbora_tbo like @addr) 
 and (@id='' or id_mesta_sbora_tbo=@id )
 and (okr.StrVal is not null or exists(select strval from #okrug where StrVal='all'))
and (@okrug='' or va.okrug=@okrug)
and (@rayon='' or va.rayon=@rayon)
union all 
select top 1000 ltrim(rtrim(str(id_mesta_sbora_kgm, 30))), adres_mesta_sbora_kgm,2 tabl
from tbo_vse_adresa va
left join  #okrug okr on okr.StrVal=va.okrug

where del=0 and (id_mesta_sbora_kgm is not null or adres_mesta_sbora_kgm is not null)
 and (@addr ='' or adres_mesta_sbora_kgm like @addr) 
 and (@id='' or id_mesta_sbora_kgm=@id )
  and (okr.StrVal is not null or exists(select strval from #okrug where StrVal='all'))
and (@okrug='' or va.okrug=@okrug)
and (@rayon='' or va.rayon=@rayon)

union all
select  top 1000 ltrim(rtrim(str(id_mesta_sbora_otkhodov, 30))), adres_mesta_sbora_otkhodov ,3 tabl
from  tbo_otdelnie o
left join  #okrug okr on okr.StrVal=o.okrug
where  del=0 and (id_mesta_sbora_otkhodov is not null or adres_mesta_sbora_otkhodov is not null)
 and (@addr ='' or adres_mesta_sbora_otkhodov like @addr) 
 and (@id='' or id_mesta_sbora_otkhodov=@id )
 and (okr.StrVal is not null or exists(select strval from #okrug where StrVal='all'))
 and (@okrug='' or o.okrug=@okrug)
 and (@rayon='' or o.rayon=@rayon)

 union all

select  top 1000
 ltrim(rtrim(str(id_mesta_sbora_tbo , 30))), adres_mesta_sbora_tbo,4 tabl
from tbo_zapolnaem_nejelyo zn
left join  #okrug okr on okr.StrVal=zn.okrug
where  del=0 and (id_mesta_sbora_tbo is not null or adres_mesta_sbora_tbo is not null)
 and (@addr ='' or adres_mesta_sbora_tbo like @addr) 
 and (@id='' or id_mesta_sbora_tbo=@id )
 --and (@okrug='all' or zn.okrug=@okrug)
 and (okr.StrVal is not null or exists(select strval from #okrug where StrVal='all'))
 and (@okrug='' or zn.okrug=@okrug)
 and (@rayon='' or zn.rayon=@rayon)


union all
select  top 1000 id_mesta_sbora_kgm, adres_mesta_sbora_kgm,5 tabl
from tbo_zapolnaem_nejelyo zn
left join  #okrug okr on okr.StrVal=zn.okrug
where  del=0 and (id_mesta_sbora_kgm is not null or adres_mesta_sbora_kgm is not null)
 and (@addr ='' or adres_mesta_sbora_kgm like @addr) 
 and (@id='' or id_mesta_sbora_kgm=@id )
 --and (@okrug='all' or zn.okrug=@okrug)
 and (okr.StrVal is not null or exists(select strval from #okrug where StrVal='all'))
 and (@okrug='' or zn.okrug=@okrug)
 and (@rayon='' or zn.rayon=@rayon)

 
) t
GO
