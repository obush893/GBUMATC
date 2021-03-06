/****** Object:  StoredProcedure [dbo].[norm_table_Addr]    Script Date: 08/05/2016 08:55:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[norm_table_Addr]
as
set nocount on

update v set adres_mesta_sbora_tbo_norm= 'зеленоград к.'+ adres_mesta_sbora_tbo  
from [tbo_vse_adresa]  v
where adres_mesta_sbora_tbo_norm is null
and okrug = 'зелао' 
and  adres_mesta_sbora_tbo not like '%[йцукенгшщзфывапролджячсмитьбю]%'

update v set adres_mesta_sbora_tbo_norm= 'зеленоград к.'+ adres_mesta_sbora_tbo  
from [tbo_vse_adresa]  v
where adres_mesta_sbora_tbo_norm is null
and okrug = 'зелао' and  adres_mesta_sbora_tbo  like '[0123456789]%'




update tbo_otdelnie set adres_mesta_sbora_otkhodov= LTRIM(rtrim(replace(adres_mesta_sbora_otkhodov, char(160), char(32)))) from tbo_otdelnie 
where adres_mesta_sbora_otkhodov is not null and adres_mesta_sbora_otkhodov<> LTRIM(rtrim(replace(adres_mesta_sbora_otkhodov, char(160), char(32))))



update dbo.tbo_obekti_sbora_otkhodov set  adres_ploshadki    =  LTRIM(rtrim(replace(adres_ploshadki, char(160), char(32))))
where adres_ploshadki <> LTRIM(rtrim(replace(adres_ploshadki, char(160), char(32))))
    
    
    

update dbo.tbo_vse_adresa set  adres_mesta_sbora_tbo    =  LTRIM(rtrim(replace(adres_mesta_sbora_tbo, char(160), char(32))))
where adres_mesta_sbora_tbo <> LTRIM(rtrim(replace(adres_mesta_sbora_tbo, char(160), char(32))))
    
   

update dbo.tbo_zapolnaem_nejelyo set  adres_mesta_sbora_tbo    =  LTRIM(rtrim(replace(adres_mesta_sbora_tbo, char(160), char(32))))
where adres_mesta_sbora_tbo <> LTRIM(rtrim(replace(adres_mesta_sbora_tbo, char(160), char(32))))
GO
