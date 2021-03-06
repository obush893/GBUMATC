﻿SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[mainFileContainer] AS FILETABLE
WITH (
  FILETABLE_COLLATE_FILENAME = Cyrillic_General_CI_AS,
  FILETABLE_PRIMARY_KEY_CONSTRAINT_NAME = [PK__DataBase__5A5B77D5E8E812C6],
  FILETABLE_STREAMID_UNIQUE_CONSTRAINT_NAME = [UQ__DataBase__9DD95BAF738DEAF8],
  FILETABLE_FULLPATH_UNIQUE_CONSTRAINT_NAME = [UQ__DataBase__A236CBB3F6605A3A]
)
GO

CREATE INDEX [_dta_index_mainFileContainer_5_558833253__K4_3_8_9_10_11_12_13_14_15_16_17]
  ON [dbo].[mainFileContainer] ([path_locator])
  INCLUDE ([name], [creation_time], [last_write_time], [last_access_time], [is_directory], [is_offline], [is_hidden], [is_readonly], [is_archive], [is_system], [is_temporary])
  ON [PRIMARY]
GO

CREATE INDEX [_dta_index_mainFileContainer_5_558833253__K9_K3]
  ON [dbo].[mainFileContainer] ([last_write_time], [name])
  ON [PRIMARY]
GO

CREATE STATISTICS [_dta_stat_558833253_3_9]
  ON [dbo].[mainFileContainer] ([name], [last_write_time])
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [insertedActulization]
ON [dbo].[mainFileContainer]
AFTER INSERT
AS
INSERT INTO Files_mainContainer(MainC_HID) SELECT path_locator FROM INSERTED
GO

GRANT
  ALTER,
  CONTROL,
  DELETE,
  INSERT,
  REFERENCES,
  SELECT,
  TAKE OWNERSHIP,
  UPDATE,
  VIEW CHANGE TRACKING,
  VIEW DEFINITION
ON [dbo].[mainFileContainer] TO [NT AUTHORITY\IUSR]
GO

GRANT
  ALTER,
  CONTROL,
  DELETE,
  INSERT,
  REFERENCES,
  SELECT,
  TAKE OWNERSHIP,
  UPDATE,
  VIEW CHANGE TRACKING,
  VIEW DEFINITION
ON [dbo].[mainFileContainer] TO [NT AUTHORITY\LOCAL SERVICE]
GO

GRANT
  ALTER,
  CONTROL,
  DELETE,
  INSERT,
  REFERENCES,
  SELECT,
  TAKE OWNERSHIP,
  UPDATE,
  VIEW CHANGE TRACKING,
  VIEW DEFINITION
ON [dbo].[mainFileContainer] TO [NT AUTHORITY\NETWORK SERVICE]
GO

GRANT
  ALTER,
  CONTROL,
  DELETE,
  INSERT,
  REFERENCES,
  SELECT,
  TAKE OWNERSHIP,
  UPDATE,
  VIEW CHANGE TRACKING,
  VIEW DEFINITION
ON [dbo].[mainFileContainer] TO [NT AUTHORITY\СЕТЬ]
GO

GRANT
  ALTER,
  CONTROL,
  DELETE,
  INSERT,
  REFERENCES,
  SELECT,
  TAKE OWNERSHIP,
  UPDATE,
  VIEW CHANGE TRACKING,
  VIEW DEFINITION
ON [dbo].[mainFileContainer] TO [NT AUTHORITY\система]
GO

GRANT
  ALTER,
  CONTROL,
  DELETE,
  INSERT,
  REFERENCES,
  SELECT,
  TAKE OWNERSHIP,
  UPDATE,
  VIEW CHANGE TRACKING,
  VIEW DEFINITION
ON [dbo].[mainFileContainer] TO [NT AUTHORITY\СЛУЖБА]
GO