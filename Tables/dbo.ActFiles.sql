﻿SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ActFiles] AS FILETABLE
WITH (
  FILETABLE_COLLATE_FILENAME = Cyrillic_General_CI_AS,
  FILETABLE_PRIMARY_KEY_CONSTRAINT_NAME = [PK__ActFiles__5A5B77D5FAE1F3D0],
  FILETABLE_STREAMID_UNIQUE_CONSTRAINT_NAME = [UQ__ActFiles__9DD95BAF21F8316D],
  FILETABLE_FULLPATH_UNIQUE_CONSTRAINT_NAME = [UQ__ActFiles__A236CBB3DB7A3C34]
)
GO

GRANT
  ALTER,
  DELETE,
  INSERT,
  SELECT,
  UPDATE,
  VIEW CHANGE TRACKING,
  VIEW DEFINITION
ON [dbo].[ActFiles] TO [NT AUTHORITY\СЕТЬ]
GO