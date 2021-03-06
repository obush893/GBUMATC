/****** Object:  StoredProcedure [dbo].[tbo_asp_search2]    Script Date: 08/05/2016 08:55:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[tbo_asp_search2]
@addr nvarchar(255),
@id varchar(255)=null

as
set nocount on

-- exec tbo_asp_search @addr='зеленогра',@ID='708904'


-- exec tbo_asp_search @addr='Зеленоград',@ID=null


select @addr = ISNULL(ltrim(rtrim(@addr)),''),
       @id =  ISNULL(ltrim(rtrim(@id)),'') 


select @addr = case when @addr ='' then '' else '%'+@addr +'%' end 
      


select adres,
 

case when max(isnull(id_mesta_sbora_otkhodov,'')) = min(isnull(id_mesta_sbora_otkhodov,'')) then  max(isnull(id_mesta_sbora_otkhodov,''))
    	    else  min(isnull(id_mesta_sbora_otkhodov,'')) + ' '+  max(isnull(id_mesta_sbora_otkhodov,''))
	    end id_mesta_sbora_otkhodov,
	    
	    case when max(isnull(adres_mesta_sbora_otkhodov,''))=min(isnull(adres_mesta_sbora_otkhodov,'')) then max(isnull(adres_mesta_sbora_otkhodov,''))
	    else min(isnull(adres_mesta_sbora_otkhodov,''))+' '+ max(isnull(adres_mesta_sbora_otkhodov,''))
	    end adres_mesta_sbora_otkhodov
	    
from  tbo_otdelnie
where (@addr ='' or adres_mesta_sbora_otkhodov like @addr or adres like @addr)
and (@id='' or id_mesta_sbora_otkhodov=@id) and del=0
group by adres
GO
