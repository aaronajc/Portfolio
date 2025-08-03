/***************************************************************
**************************sys Variables**************************
***************************************************************/
DECLARE @ErrorTableName NVARCHAR(250)
DECLARE @ErrorTableCreate NVARCHAR(250)
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @ErrorTable NVARCHAR(500)
DECLARE @STMT NVARCHAR(2000)
/***************************************************************
**************************Variables**************************
***************************************************************/
DECLARE @TransactionName NVARCHAR(50)
/***************************************************************
*********************Assign sys Variables*************************
***************************************************************/
SELECT @ParmDefinition = N'@TransactionName NVARCHAR(50)'
SELECT @ErrorTableName = N'#ErrorTable'
SELECT @ErrorTableCreate = CASE 
													WHEN @ErrorTableName LIKE N'#%' THEN N'IF OBJECT_ID(''tempdb..'+@ErrorTableName+''') IS NOT NULL DROP TABLE ' +@ErrorTableName +';
													
													CREATE TABLE '+@ErrorTableName    
												ELSE NULL 
												END 
SELECT @ErrorTable = @ErrorTableCreate +
											'	(
													[HostName] NVARCHAR(128)
													, [UserName] NVARCHAR(128)
													, [TransactionName] NVARCHAR(50)
													, [ErrorLine] INT 
													, [ErrorNumber] INT
													, [ErrorSeverity] INT
													, [ErrorState] INT 
													, [ErrorMessage] NVARCHAR(2000)
												)
												'

SELECT @STMT = ISNULL(@ErrorTable,N'') 
							+ N'INSERT INTO '+@ErrorTableName+N'
										(
											 [HostName] 
											, [UserName] 
											, [TransactionName] 
											, [ErrorLine]  
											, [ErrorNumber] 
											, [ErrorSeverity] 
											, [ErrorState]  
											, [ErrorMessage] 
										)
									VALUES 
										(
											 Host_Name()
											, User_Name ()
											, @TransactionName
											, Error_Line()
											, Error_Number()
											, Error_Severity() 
											, Error_State()
											, Error_Message()
										)

									SELECT 
										 [HostName] 
										, [UserName] 
										, [TransactionName] 
										, [ErrorLine]  
										, [ErrorNumber] 
										, [ErrorSeverity] 
										, [ErrorState]  
										, [ErrorMessage] 
									FROM 
										'+@ErrorTableName


PRINT @STMT
/***************************************************************
*********************Assign Variables*****************************
***************************************************************/
SELECT 
	@TransactionName = N'TransactionTest'
/***************************************************************
*********************BEGIN TRANSACTION**********************
***************************************************************/
BEGIN TRY 
BEGIN TRANSACTION @TransactionName

SELECT 1/0

COMMIT TRANSACTION @TransactionName
END TRY 
BEGIN CATCH 

	EXEC sp_executesql
				@STMT
				, @ParmDefinition
				, @TransactionName  = @TransactionName 

ROLLBACK TRANSACTION @TransactionName
END CATCH 
