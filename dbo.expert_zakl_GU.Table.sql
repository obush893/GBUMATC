/****** Object:  Table [dbo].[expert_zakl_GU]    Script Date: 08/05/2016 08:55:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[expert_zakl_GU](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_GU] [int] NOT NULL,
	[id_expert_zakl] [int] NOT NULL,
	[vneseno] [timestamp] NOT NULL,
	[vneseno_IP] [varchar](50) NOT NULL CONSTRAINT [DF_ekspert_zakl_GU_vneseno_IP]  DEFAULT (CONVERT([char](15),connectionproperty('client_net_address'),(0))),
	[vneseno_Host_name] [nvarchar](50) NOT NULL CONSTRAINT [DF_ekspert_zakl_GU_vneseno_Host_name]  DEFAULT (host_name()),
	[vneseno_user] [nvarchar](50) NOT NULL CONSTRAINT [DF_ekspert_zakl_GU_vneseno_user]  DEFAULT (suser_sname()),
 CONSTRAINT [PK_expert_zakl_GU] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [1] ON [dbo].[expert_zakl_GU] 
(
	[id] ASC,
	[id_GU] ASC,
	[id_expert_zakl] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [unik] ON [dbo].[expert_zakl_GU] 
(
	[id_GU] ASC,
	[id_expert_zakl] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[expert_zakl_GU]  WITH CHECK ADD  CONSTRAINT [FK_expert_zakl_GU_expert_zakl] FOREIGN KEY([id_expert_zakl])
REFERENCES [dbo].[expert_zakl] ([id])
GO
ALTER TABLE [dbo].[expert_zakl_GU] CHECK CONSTRAINT [FK_expert_zakl_GU_expert_zakl]
GO
ALTER TABLE [dbo].[expert_zakl_GU]  WITH CHECK ADD  CONSTRAINT [FK_expert_zakl_GU_gu] FOREIGN KEY([id_GU])
REFERENCES [dbo].[gu] ([kod])
GO
ALTER TABLE [dbo].[expert_zakl_GU] CHECK CONSTRAINT [FK_expert_zakl_GU_gu]
GO
