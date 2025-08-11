DROP TABLE IF EXISTS [StagingFitBit].[UnformattedData]
GO
CREATE TABLE [StagingFitBit].[UnformattedData]
	(
		[RowID] UNIQUEIDENTIFIER NOT NULL CONSTRAINT ETLUnformattedDataRowID DEFAULT NEWSEQUENTIALID() 
		, [DateLoaded] DATETIME NOT NULL CONSTRAINT ETLUnformattedDataLoadDate DEFAULT GETDATE()
		, [Source0] NVARCHAR(255) NULL 
		, [RowData] NVARCHAR(4000) NULL 
		, [RowHash] AS HASHBYTES('SHA2_512',[RowData])
		, [RowType] NVARCHAR(2)

	)


GO 