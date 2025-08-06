SELECT 
	[sc].[name] AS [Schema]
	, [tl].[name] AS [TableName]
	, QUOTENAME([sc].[name])+N'.'+QUOTENAME([tl].[name]) AS [FullTableName]
	, N'SELECT TOP 500 * FROM '+QUOTENAME([sc].[name])+N'.'+QUOTENAME([tl].[name]) AS [TableSelect]
	, [pr2].[totRows]
	, [pr2].[totPartitons]
FROM 
	[sys].[schemas] [sc]
INNER JOIN 
	[sys].[tables] [tl]
ON 
	[sc].[schema_id] = [tl].[schema_id]
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