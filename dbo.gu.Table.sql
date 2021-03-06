/****** Object:  Table [dbo].[gu]    Script Date: 08/05/2016 08:55:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gu](
	[kod] [int] IDENTITY(1,1) NOT NULL,
	[project] [nvarchar](max) NULL,
	[num] [nchar](10) NULL,
	[data_montaja] [date] NULL,
	[status] [nvarchar](max) NULL,
	[fio] [nvarchar](max) NULL,
	[fio_doljnost] [nvarchar](max) NULL,
	[data_v_proverku] [date] NULL,
	[data_osmotra] [date] NULL,
	[fact_ustanovki] [nvarchar](max) NULL,
	[unikalniy] [nvarchar](max) NULL,
	[tipgu] [nvarchar](50) NULL,
	[okrug] [nvarchar](max) NULL,
	[ulitsa] [nvarchar](max) NULL,
	[nazvanie_ulitsi] [nvarchar](max) NULL,
	[dom_korp_str] [nvarchar](max) NULL,
	[odnostoronie_dvijenie] [nchar](10) NULL,
	[izmerennaya_shirina_trotuara] [nvarchar](max) NULL,
	[otsenochaya_shirina_trotuara] [nvarchar](max) NULL,
	[rastoyanie_ot_opori] [nvarchar](max) NULL,
	[tip_poverchnosti] [nvarchar](max) NULL,
	[prokhodimost] [nvarchar](max) NULL,
	[rekonstruktsiya] [nvarchar](max) NULL,
	[prosmatrivaemost] [nvarchar](max) NULL,
	[sostoyaniegu] [nvarchar](max) NULL,
	[orientatsiyagu] [nvarchar](max) NULL,
	[sootv_tech_pasport] [nvarchar](max) NULL,
	[rastoyanie_do_mesta_ust_po_pasportu] [nvarchar](max) NULL,
	[po_prosmatrivaemosti] [nvarchar](max) NULL,
	[po_shirine_trotuara_v_meste_ustanovki] [nvarchar](max) NULL,
	[po_otsutstviyu_navisaniya_nad_proezzhej_chastyu] [nvarchar](max) NULL,
	[po_raspolozheniyu_otnositelno_zelenykh_nasazhdenij] [nvarchar](max) NULL,
	[po_rasstoyaniyu_ot_vkhoda_v_transportnye_uzly_i_doma] [nvarchar](max) NULL,
	[po_rasstoyaniyu_do_kraya_velosipednoj_dorozhki] [nvarchar](max) NULL,
	[po_soderzhaniyu] [nvarchar](max) NULL,
	[po_kolichestvu_i_pravilnomu_raspolozheniyu] [nvarchar](max) NULL,
	[kolichestvo_informatsionnykh_polej] [nchar](10) NULL,
	[nalichie_modulya_s_kartoj_mestnosti] [nvarchar](max) NULL,
	[oformlenie_osnovaniya] [nvarchar](max) NULL,
	[territoriya] [nvarchar](max) NULL,
	[razmer_betonnogo_bloka_dlina] [nvarchar](max) NULL,
	[razmer_betonnogo_bloka_shirina] [nvarchar](max) NULL,
	[ploschad_vosstanovitelnykh_rabot_posle_zaglubleniya] [nvarchar](max) NULL,
	[vyvoz_tekhniki_inventarya_oborudovaniya] [nvarchar](max) NULL,
	[inye_narusheniya_trebovanij_tekhnicheskikh_pravil_k_gorodskim_uk] [nvarchar](max) NULL,
	[zaklyuchenie] [nvarchar](max) NULL,
	[tip_narusheniya_vneshnego_vida_i_tekhnicheskogo_sostoyaniya] [nvarchar](max) NULL,
	[data_otpravki_inforiatsii_ispolnitelyu] [date] NULL,
	[egko_x] [nvarchar](max) NULL,
	[egko_y] [nvarchar](max) NULL,
	[adres_v_moskve] [nchar](10) NULL,
	[naimenovaniya_i_narpavleniya_ukazannye_na_inf_polyakh_verny] [nvarchar](max) NULL,
	[otmetka_o_zanesenii_v_asu_inventarnyj_nomer] [nvarchar](max) NULL,
	[data_zaneseniya_informatsii_v_asu] [date] NULL,
	[sotrudnik_zanesshij_dannye_v_asu] [nvarchar](max) NULL,
	[data_ustanovki_po_grafiku] [date] NULL,
	[god_realizatsii] [int] NULL,
	[etap_rabot] [nvarchar](max) NULL,
	[proekt] [nvarchar](max) NULL,
	[data_montaja_plan] [date] NULL,
	[data_postupleniya_informatsiya_v_otdel_monitoringa] [date] NULL,
	[ploschad_betonnogo_bloka_kvm] [nvarchar](max) NULL,
	[dolzhnost_sotrudnika_obsledovavshego_gu] [nvarchar](max) NULL,
	[dolzhnost_sotrudnika_zanesshego_nformatsiyu_v_asu] [nvarchar](max) NULL,
	[prim] [nvarchar](max) NULL,
	[akt_v_arkhive] [nchar](10) NULL,
	[inf_pole_blok_1_storona_a] [nvarchar](max) NULL,
	[inf_pole_blok_1_storona_b] [nvarchar](max) NULL,
	[inf_pole_blok_2_storona_a] [nvarchar](max) NULL,
	[inf_pole_blok_2_storona_b] [nvarchar](max) NULL,
	[inf_pole_blok_3_storona_a] [nvarchar](max) NULL,
	[inf_pole_blok_3_storona_b] [nvarchar](max) NULL,
	[inf_pole_blok_4_storona_a] [nvarchar](max) NULL,
	[inf_pole_blok_4_storona_b] [nvarchar](max) NULL,
	[foto_storona_a] [nvarchar](max) NULL,
	[foto_storona_b] [nvarchar](max) NULL,
	[foto_text_1] [nvarchar](max) NULL,
	[foto_text_2] [nvarchar](max) NULL,
	[foto_text_3] [nvarchar](max) NULL,
	[foto_text_4] [nvarchar](max) NULL,
	[geogr_koordinati] [nvarchar](max) NULL,
	[koordinati_leg] [nvarchar](max) NULL,
	[zamechaniya_key] [int] NULL,
	[v_plane_v_rabote] [int] NULL,
	[vse_ok_key] [int] NULL,
	[v_plane_key] [int] NULL,
	[ustraneno_key] [int] NULL,
	[akt_v_ogs_key] [int] NULL,
	[prinato_key] [int] NULL,
	[zam1_key] [int] NULL,
	[zam2_key] [int] NULL,
	[zam3_key] [int] NULL,
	[zam4_key] [int] NULL,
	[data_prinatiya] [date] NULL,
	[obkhodchik_timer] [nvarchar](max) NULL,
	[zam1_text] [nvarchar](max) NULL,
	[zam2_text] [nvarchar](max) NULL,
	[zam3_text] [nvarchar](max) NULL,
	[zam4_text] [nvarchar](max) NULL,
	[zam1_foto] [nvarchar](max) NULL,
	[zam2_foto] [nvarchar](max) NULL,
	[zam3_foto] [nvarchar](max) NULL,
	[zam4_foto] [nvarchar](max) NULL,
	[memo] [nvarchar](max) NULL,
	[isklucheno_key] [int] NULL,
	[isklucheno_date] [date] NULL,
	[isklucheno_memo] [nvarchar](max) NULL,
	[isklucheno_pic] [nvarchar](max) NULL,
	[qr] [nvarchar](max) NULL,
 CONSTRAINT [PK_gu] PRIMARY KEY CLUSTERED 
(
	[kod] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'для qr кода' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'gu', @level2type=N'COLUMN',@level2name=N'qr'
GO
