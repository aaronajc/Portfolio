/***********************************************************************
********************Variables********************************************
***********************************************************************/
DECLARE @SchemaName NVARCHAR(250)
DECLARE @TableName NVARCHAR(250)
DECLARE @ColumnName NVARCHAR(250)
/***********************************************************************
**************************Assign Variables********************************
***********************************************************************/
SELECT 
	@SchemaName = N''
	, @TableName = N''
	, @ColumnName = N''




SELECT 
	[sc].[name] AS [Schema]
	, [tl].[name] AS [TableName]
	, QUOTENAME([sc].[name])+N'.'+QUOTENAME([tl].[name]) AS [FullTableName]
	, N'SELECT TOP 500 * FROM '+QUOTENAME([sc].[name])+N'.'+QUOTENAME([tl].[name]) +N' WHERE 0=0 AND '+QUOTENAME([cl].[name])+' LIKE ''%%'' 'AS [TableSelect]
	, [pr2].[totRows]
	, [pr2].[totPartitons]
	, [cl].[name] AS [ColumnName]
	, [tp].[name] AS [DataType] 
	, [cl].[max_length]
	, CASE	
		WHEN [tp].[name] LIKE N'%CHAR%' THEN QUOTENAME([cl].[name]) +' '+[tp].[name]+'('+CAST([cl].[max_length] AS NVARCHAR(8))+')'
		ELSE QUOTENAME([cl].[name]) +' '+[tp].[name]
	 END AS [ColCreate] 
FROM 
	[sys].[schemas] [sc]
INNER JOIN 
	[sys].[tables] [tl]
ON 
	[sc].[schema_id] = [tl].[schema_id]
INNER JOIN 
	[sys].[columns] [cl]
ON 
	[tl].[object_id] = [cl].[object_id]
INNER JOIN 
	[sys].[types] [tp]
ON 
	[cl].[user_type_id] = [tp].[user_type_id]
LEFT JOIN 
	(
		SELECT 
			[pr1].[object_id]
			, COUNT([pr1].[partition_number]) AS [totPartitons]
			, SUM([pr1].[rows]) AS [totRows]
		FROM 
				(
					SELECT 
						[pr].[object_id]
						, [pr].[partition_number]
						, [pr].[rows]
						, ROW_NUMBER() OVER(PARTITION BY [pr].[object_id], [pr].[partition_number] ORDER BY [pr].[object_id] ) RN 
					FROM 
						[sys].[partitions] [pr]
				)[pr1]
		WHERE 
			0=0
			AND [pr1].[RN] = 1 
		GROUP BY 
			[pr1].[object_id]
	)[pr2]
ON 
	[tl].[object_id] = [pr2].[object_id]
WHERE 
	0=0
	AND [sc].[name] LIKE '%'+@SchemaName+'%'
	AND [tl].[name] LIKE '%'+@TableName+'%'
	AND [cl].[name] LIKE '%'+@ColumnName+'%'
ORDER BY 
	[ColumnName]