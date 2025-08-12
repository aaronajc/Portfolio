USE [YourDatabaseNameHere]
GO
IF (NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'StagingAPI')) 
BEGIN
    EXEC ('CREATE SCHEMA [StagingAPI] AUTHORIZATION [dbo]')
END
GO 
DROP TABLE IF EXISTS [StagingAPI].[ExchangeRates]
GO

/****** Object:  Table [StagingAPI].[ExchangeRates]    Script Date: 12/08/2025 14:25:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [StagingAPI].[ExchangeRates](
	[RowID] [uniqueidentifier] NOT NULL CONSTRAINT [ETLRowID]  DEFAULT (newsequentialid()),
	[DateLoaded] [datetime] NOT NULL CONSTRAINT [ETLLoadDate]  DEFAULT (getdate()) ,
	[Source0] [nvarchar](255) NULL,
	[Result] [nvarchar](50) NULL,
	[Provider0] [nvarchar](250) NULL,
	[documentation] [nvarchar](250) NULL,
	[TermsOfUse] [nvarchar](250) NULL,
	[TimeLastUpdateUTC] [datetimeoffset](7) NULL,
	[TimeNextUpdateUTC] [datetimeoffset](7) NULL,
	[CurrencyBaseCode] [nvarchar](10) NULL,
	[CurrencyCodeName] [nvarchar](10) NULL,
	[CurrencyCodeValue] [decimal](13, 7) NULL
) ON [PRIMARY]



