/****** Object:  StoredProcedure [dbo].[tmp_test000_clear_and_insert]    Script Date: 08/05/2016 08:55:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [dbo].[tmp_test000_clear_and_insert]
@fname varchar(255),
@d datetime
as
set nocount on
-- Очищаем мусор из таблицы загрузки данных из XML
 delete t
  FROM [tmp_test000] t
  where (ltrim(isnull(f10 ,''))='' and ltrim(isnull(f11 ,''))='' and ltrim(isnull(f12 ,''))=''
  or f10 ='10'and f11='11' and f12='12' 
  ) and fname = @fname

/*
declare @d datetime
set @d = GETDATE()
*/


if(exists(select top 1  kod from dbo.tbo_sbor_otkhodov where xml_name = @fname))
 begin
  select 'Ошибка: данные уже загружались' as t
  return ;
 end
 
 

insert into tbo_sbor_otkhodov ( okrug,  rayon, id_dvor, ima_dvor_territorii, id_ploshadki, adres_ploshadki, koordinati_shirina, koordinati_dolgota, rastoyanie_ot_ploshadki_do_mesta_pogruzki, mesto_pogruzki_shirota, mesto_pogruzki_dolgota, tip_ploshadki, id_kont_obekta, vid_otkhodov, kolvo_konteynerov, obem_konteynerov, #dogovora, obrazovatel, transaportirovshik, predmet_dogovora, istochnik_abnansirovaniya, nachalo_deystviya_dogovora, okonchanie_deystviya_dogovora, naimenovanie_grafika, nachalo_deystviya_grafika, okonchaniya_deystviya_grafika, vrema_vivoza_s, vrema_vivoza_po, tip_grafika, detalizatsiya_po_mesatsam, detalizatsiya_po_nedelam, detalizatsiya_po_dnam, naimenovanie_marshruta
  , id_ploshadki2, date1,  id_tmp_test000, xml_name, del_ , iskl)
  select  c0,     f2,      f3,f4,f5,f6,f7,f8,f9,f10,f11,f12,f13,f14,f15,f16,f17,f18,f19,f20,f21,f22,f23,f24,f25,f26,f27,f28,f29,f30,f31,f32,f33
  , cast(f5 as int), @d ,  ID,fname,0,0
  FROM [tmp_test000] t where f5<>'ID площадки' and  fname = @fname
  
  select 'Данные загружены: '+ LTRIM(STR(@@ROWCOUNT))+'шт.' as t
GO
