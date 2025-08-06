USE [Your Database Name Here]
GO

/****** Object:  Table [PowerBIT01].[AppsImport]    Script Date: 24/12/2024 19:04:23 ******/
DROP TABLE IF EXISTS  [StagingJson].[JsonImport]
GO
/****** Object:  Table [PowerBIT01].[AppsImport]    Script Date: 24/12/2024 19:04:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [StagingJson].[JsonImport](
	[RowID] [uniqueidentifier] NOT NULL DEFAULT (newsequentialid()) ,
	[DateLoaded] [datetime] NOT NULL   DEFAULT (getdate()) ,
	[Source0] [nvarchar](255) NULL,
	[OdataContext] [nvarchar](255) NULL,
	[ID] [nvarchar](50) NULL,
	[Name0] [nvarchar](250) NULL,
	[Users] [nvarchar](500) NULL,
	[WorkSpaceID] [nvarchar](100) NULL,
	[PublishedBy] [nvarchar](250) NULL,
	[LastUpdate] [datetime] NULL
) ON [PRIMARY]
GO



