﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [dbo].[rz_vostanovl_fasad]
WITH   VIEW_METADATA
AS
SELECT        kod, status, text, [key], pic, zam, memo, foto, podtverjd_memo, podtverjd_foto, podtverjd_status
FROM            dbo.reestr_zamechaniya
WHERE        (zam_type = 'vostanovl_fasad')

GO