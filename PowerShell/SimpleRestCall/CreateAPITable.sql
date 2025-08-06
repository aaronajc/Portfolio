DROP TABLE IF EXISTS [StagingAPI].[ExchangeRates]
GO 

CREATE TABLE [StagingAPI].[ExchangeRates]
	(
		RowID UNIQUEIDENTIFIER NOT NULL CONSTRAINT ETLRowID DEFAULT NEWSEQUENTIALID() 
		, DateLoaded DATETIME NOT NULL CONSTRAINT ETLLoadDate DEFAULT GETDATE()
		, Source0 NVARCHAR(255) NULL 
		, Result Nvarchar(50)
		, Provider0 Nvarchar(250)
		, documentation Nvarchar(250)
		, TermsOfUse	Nvarchar(250) 
		, TimeLastUpdateUTC	DATETIME 
		, TimeNextUpdateUTC	DATETIME 
		, CurrencyBaseCode Nvarchar(10)
		, CurrencyCodeName Nvarchar(10)
		, CurrencyCodeValue Decimal(13,7)
	)