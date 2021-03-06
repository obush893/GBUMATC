/****** Object:  StoredProcedure [dbo].[tbo_asp_search1]    Script Date: 08/05/2016 08:55:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[tbo_asp_search1]
@addr nvarchar(255),
@id varchar(255)=null

as
set nocount on

-- exec tbo_asp_search @addr='зеленогра',@ID='708904'


-- exec tbo_asp_search @addr='Зеленоград',@ID=null


select @addr = ISNULL(ltrim(rtrim(@addr)),''),
       @id =  ISNULL(ltrim(rtrim(@id)),'') 


select @addr = case when @addr ='' then '' else '%'+@addr +'%' end 
      
      
select    
	   adres_mkd,

case when max(isnull(id_mesta_sbora_tbo,'')) = min(isnull(id_mesta_sbora_tbo,'')) then  max(isnull(id_mesta_sbora_tbo,''))
    	    else  min(isnull(id_mesta_sbora_tbo,'')) + ' '+  max(isnull(id_mesta_sbora_tbo,''))
	    end id_mesta_sbora_tbo,
	    
	    case when max(isnull(adres_mesta_sbora_tbo,''))=min(isnull(adres_mesta_sbora_tbo,'')) then max(isnull(adres_mesta_sbora_tbo,''))
	    else min(isnull(adres_mesta_sbora_tbo,''))+' '+ max(isnull(adres_mesta_sbora_tbo,''))
	    end adres_mesta_sbora_tbo,
	    
	     case when min(isnull(id_mesta_sbora_kgm,''))=max(isnull(id_mesta_sbora_kgm,'')) then max(isnull(id_mesta_sbora_kgm,''))
       else min(isnull(id_mesta_sbora_kgm,''))+' '+ max(isnull(id_mesta_sbora_kgm,''))
       end id_mesta_sbora_kgm,
       
      case when min(isnull(adres_mesta_sbora_kgm,''))=max(isnull(adres_mesta_sbora_kgm,'')) then max(isnull(adres_mesta_sbora_kgm,'')) 
      else  min(isnull(adres_mesta_sbora_kgm,''))+' '+max(isnull(adres_mesta_sbora_kgm,''))
      end  adres_mesta_sbora_kgm
      
      
      
	    from tbo_vse_adresa  
	where (@addr ='' or adres_mesta_sbora_tbo like @addr or adres_mesta_sbora_kgm like @addr or  adres_mkd like @addr)  
	and(@id='' or id_mesta_sbora_tbo=@id or id_mesta_sbora_kgm=@id) and del=0
	group by adres_mkd
--	having COUNT(1)>1
GO
