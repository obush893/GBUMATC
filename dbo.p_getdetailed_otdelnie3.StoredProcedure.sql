/****** Object:  StoredProcedure [dbo].[p_getdetailed_otdelnie3]    Script Date: 08/05/2016 08:55:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[p_getdetailed_otdelnie3]
@addr nvarchar(255),
@id varchar(255)=null
,@okrug varchar(255)= null

as 
set nocount on

/*
[p_getdetailed_otdelnie] null, null
[p_getdetailed_otdelnie3] '','1987960'
[p_getdetailed_otdelnie3] 'Зеленоград г. к.1431','','all'
[p_getdetailed_otdelnie3] 'Зеленоград г. к.1431','','зао, юзао'
[p_getdetailed_otdelnie3] 'Зеленоград г. к.1431','','зао, сзао'

  
*/
declare @okrug2 varchar(255)

select @addr = ISNULL(ltrim(rtrim(@addr)),''),
       @id =  ISNULL(ltrim(rtrim(@id)),'')
      ,@okrug=''''+replace(replace(replace(@okrug,', ',','),' ,',','),',',''',''')+''''
	  ,@okrug2=','+replace(replace(@okrug,', ',','),' ,',',')+','
 
select  t2.adres_mesta_sbora_otkhodov [Адрес места сбора ТБО],   
ima_arendatora [Имя арендатора],
--chislinnost [Числненность населения],
 t2.[Объем отходов, м3/сутки] 
 From( select id_mesta_sbora_otkhodov ,
              ima_arendatora,
              adres_mesta_sbora_otkhodov,
              CAST(SUM(cast(case when d2.ktype='Площадь' and del=0 then d2.kub_metrov * d3.arenduemaya_ploshad /365
                                 else d2.kub_metrov * d3.chislinnost /365 end as float)) as decimal(10,5)) [Объем отходов, м3/сутки]
 --          , SUM(chislinnost) chislinnost
        from dbo.tbo_otdelnie d3
        join  dbo.[tbo_koef]  d2 on d2.naimenovanie = d3.vid_deyatelnosti
        --left join  dbo.ConvertStringDelimsToTable(@okrug, ',') okr on okr.StrVal=d3.okrug
         where d3.del=0
         and (@id='' or  @id= d3.id_mesta_sbora_otkhodov) and (@addr='' or @addr=adres_mesta_sbora_otkhodov)
         
		 --and (@okrug like '%,all,%' or d3.okrug in(@okrug))
		  and (@okrug2 like '%,all,%' or @okrug2 like '%,'+d3.okrug+',%')
		 
		 
		 --and (okr.StrVal is not null or exists(select strval from dbo.ConvertStringDelimsToTable(@okrug, ',') where StrVal='all'))

          group by   id_mesta_sbora_otkhodov, ima_arendatora,adres_mesta_sbora_otkhodov
      ) t2
      
      
left join dbo.fn_find_addr(@addr,@id)as  i on i.id_ploshadki =CAST( t2.id_mesta_sbora_otkhodov as varchar(8000))
left join dbo.fn_find_id(@addr,@id) as a on a.adres_ploshadki = t2.adres_mesta_sbora_otkhodov
          
      
where
 (@id='' or id_mesta_sbora_otkhodov = @id or  @id=a.id1  or  @id=a.id2 or  @id=a.id3 or  @id=a.id4 or  @id=a.id5 or  @id=a.id6 or  @id=a.id7 or  @id=a.id8  ) and 
 (@addr='' or @addr=t2.adres_mesta_sbora_otkhodov or   @addr =i.addr1  or @addr =i.addr2  or @addr =i.addr3 or @addr =i.addr4 or @addr =i.addr5 or @addr =i.addr6 or @addr =i.addr7 or @addr =i.addr8)
 
order by t2.adres_mesta_sbora_otkhodov
GO
