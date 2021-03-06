/****** Object:  StoredProcedure [dbo].[otchet_full]    Script Date: 08/05/2016 08:55:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[otchet_full]
AS
IF OBJECT_ID('tbotest', 'U') IS NOT NULL
  DROP TABLE tbotest; 
IF OBJECT_ID('kgmtest', 'U') IS NOT NULL
  DROP TABLE kgmtest; 
IF OBJECT_ID('kgmtbo', 'U') IS NOT NULL
  DROP TABLE kgmtbo;
IF OBJECT_ID('osztest', 'U') IS NOT NULL
  DROP TABLE osztest;
IF OBJECT_ID('arendtest', 'U') IS NOT NULL
  DROP TABLE arendtest;
IF OBJECT_ID('arendosz', 'U') IS NOT NULL
  DROP TABLE arendosz;
IF OBJECT_ID('mfull', 'U') IS NOT NULL
  DROP TABLE mfull;
SELECT okrug,rayon,adres_mesta_sbora_tbo AS adres,SUM(chislenost_nasiliniya*1.45/365) tbo INTO tbotest FROM dbo.tbo_vse_adresa WHERE del=0 GROUP BY okrug,rayon,adres_mesta_sbora_tbo;
SELECT okrug,rayon,adres_mesta_sbora_kgm AS adres,SUM(chislenost_nasiliniya*0.46/365) kgm INTO kgmtest FROM dbo.tbo_vse_adresa WHERE del=0 GROUP BY okrug,rayon,adres_mesta_sbora_kgm;
select  okrug,rayon,adres_mesta_sbora_otkhodov AS adres,
              CAST(SUM(cast(case when d2.ktype='Площадь' and del=0 then d2.kub_metrov * d3.arenduemaya_ploshad /365
                                 else d2.kub_metrov * d3.chislinnost /365 end as float)) as decimal(10,5))  osz INTO osztest
        from dbo.tbo_otdelnie d3
        join  dbo.[tbo_koef]  d2 on d2.naimenovanie = d3.vid_deyatelnosti
  WHERE del=0
GROUP BY okrug,rayon,adres_mesta_sbora_otkhodov;

SELECT okrug,rayon,d1.adres_mesta_sbora_tbo as adres,
              CAST(SUM(cast(case when d2.ktype='Площадь' then d2.kub_metrov * d1.arenduemaya_ploshad /365
                            else d2.kub_metrov * d1.chislennost /365 end as float)) as decimal(10,5)) arend INTO arendtest
       from dbo.tbo_zapolnaem_nejelyo d1
       join  dbo.[tbo_koef]  d2 on d2.naimenovanie = d1.vid_deyatelnosti
       where d1.del=0 
       group by okrug,rayon,adres_mesta_sbora_tbo;


SELECT DISTINCT * INTO kgmtbo FROM (
SELECT tbotest.okrug,tbotest.rayon,tbotest.adres,tbo,kgm FROM tbotest LEFT JOIN kgmtest on tbotest.adres=kgmtest.adres
UNION
SELECT tbotest.okrug,tbotest.rayon,tbotest.adres,tbo,kgm FROM tbotest RIGHT  JOIN kgmtest on tbotest.adres=kgmtest.adres) t ;
SELECT DISTINCT * INTO arendosz FROM (
SELECT osztest.okrug,osztest.rayon,osztest.adres,osz,arend FROM osztest LEFT JOIN arendtest on osztest.adres=arendtest.adres
UNION
SELECT osztest.okrug,osztest.rayon,osztest.adres,osz,arend FROM osztest RIGHT  JOIN arendtest on osztest.adres=arendtest.adres) t ;
SELECT DISTINCT * INTO mfull FROM (
SELECT kgmtbo.okrug, kgmtbo.rayon, kgmtbo.adres,tbo,kgm,osz,arend FROM  kgmtbo LEFT JOIN arendosz on  kgmtbo.adres=arendosz.adres
UNION
SELECT kgmtbo.okrug, kgmtbo.rayon, kgmtbo.adres,tbo,kgm,osz,arend FROM  kgmtbo RIGHT  JOIN arendosz on  kgmtbo.adres=arendosz.adres) t ;
IF OBJECT_ID('tbotest', 'U') IS NOT NULL
  DROP TABLE tbotest; 
IF OBJECT_ID('kgmtest', 'U') IS NOT NULL
  DROP TABLE kgmtest; 
IF OBJECT_ID('kgmtbo', 'U') IS NOT NULL
  DROP TABLE kgmtbo;
IF OBJECT_ID('osztest', 'U') IS NOT NULL
  DROP TABLE osztest;
IF OBJECT_ID('arendtest', 'U') IS NOT NULL
  DROP TABLE arendtest;
IF OBJECT_ID('arendosz', 'U') IS NOT NULL
  DROP TABLE arendosz;
GO
