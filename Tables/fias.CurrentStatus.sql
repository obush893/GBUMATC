﻿CREATE TABLE [fias].[CurrentStatus] (
  [CURENTSTID] [int] NOT NULL,
  [NAME] [nvarchar](100) NOT NULL,
  CONSTRAINT [PK_CurrentStatus] PRIMARY KEY CLUSTERED ([CURENTSTID])
)
ON [PRIMARY]
GO