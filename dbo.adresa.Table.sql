/****** Object:  Table [dbo].[adresa]    Script Date: 08/05/2016 08:55:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[adresa](
	[#] [float] NULL,
	[okrug] [nvarchar](255) NULL,
	[ulitsa] [nvarchar](255) NULL,
	[nazvanie_ulitsi] [nvarchar](255) NULL,
	[polniy_adres] [nvarchar](255) NULL,
	[dom] [nvarchar](255) NULL,
	[korpus] [nvarchar](255) NULL,
	[stroenie] [nvarchar](255) NULL,
	[ulitsa_only] [nvarchar](255) NULL,
	[type_full] [nvarchar](255) NULL,
	[ulitsa_num] [nvarchar](255) NULL,
	[propis] [nvarchar](255) NULL,
	[ulitsa_sokr] [nvarchar](255) NULL,
	[kod_adresa] [nvarchar](255) NULL,
	[bti_for_find] [nvarchar](255) NULL
) ON [PRIMARY]
GO
