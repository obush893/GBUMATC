/****** Object:  Table [dbo].[expert_zakl]    Script Date: 08/05/2016 08:55:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[expert_zakl](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[number] [nvarchar](50) NOT NULL,
	[data_zakl] [date] NOT NULL CONSTRAINT [DF_ekspert_zakl_data_zakl]  DEFAULT (getdate()),
	[picture] [varbinary](max) NULL,
	[vneseno] [timestamp] NOT NULL,
	[vneseno_IP] [varchar](50) NOT NULL CONSTRAINT [DF_ekspert_zakl_vneseno_IP]  DEFAULT (CONVERT([char](15),connectionproperty('client_net_address'),(0))),
	[vneseno_Host_name] [nvarchar](50) NOT NULL CONSTRAINT [DF_ekspert_zakl_vneseno_Host_name]  DEFAULT (host_name()),
	[vneseno_user] [nvarchar](50) NOT NULL CONSTRAINT [DF_ekspert_zakl_vneseno_user]  DEFAULT (suser_sname()),
 CONSTRAINT [PK_ekspert_zakl] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [1] ON [dbo].[expert_zakl] 
(
	[id] ASC,
	[number] ASC,
	[data_zakl] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [unik] ON [dbo].[expert_zakl] 
(
	[number] ASC,
	[data_zakl] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[expert_zakl]  WITH NOCHECK ADD  CONSTRAINT [CK_ekspert_zakl_data_zakl] CHECK  (([DATA_ZAKL]<getdate()))
GO
ALTER TABLE [dbo].[expert_zakl] CHECK CONSTRAINT [CK_ekspert_zakl_data_zakl]
GO
