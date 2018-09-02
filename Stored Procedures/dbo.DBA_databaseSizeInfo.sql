SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--=============================================
-- Copyright (C) 2018 Raul Gonzalez, @SQLDoubleG
-- All rights reserved.
--   
-- You may alter this code for your own *non-commercial* purposes. You may
-- republish altered code as long as you give due credit.
--   
-- THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
-- ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
-- TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
-- PARTICULAR PURPOSE.
--
-- =============================================
-- Author:		Raul Gonzalez
-- Create date: 18/10/2013
-- Description:	Returns database files size (ROWS, LOG, FILESTREAM and FULLTEXT)
--				for a given database or all if not specified
--
-- Parameters:
--				@dbname
--
-- Log History:	2014-01-31 RAG - Changed the totals recodset to use PIVOT and display one row per database
--				2014-10-17 RAG - Added functionality to display info for FILESTREAM and FULLTEXT
--				2018-03-26 RAG - Added system databases
-- =============================================
CREATE PROCEDURE [dbo].[DBA_databaseSizeInfo]
	@dbname				SYSNAME = NULL
	, @includeTotals	BIT = 1
AS
BEGIN

	SET NOCOUNT ON

	DECLARE @dbs TABLE (
		ID			INT IDENTITY(1,1)
		, dbname	SYSNAME)

	DECLARE @dbfiles TABLE (
		[db_name]		SYSNAME
		, [file_id]		INT
		, type_desc		SYSNAME
		, name			SYSNAME
		, physical_name NVARCHAR(260)
		, file_group	SYSNAME
		, sizeMB		DECIMAL(10,2)
	)

	DECLARE @db				SYSNAME = NULL
			, @countDBs		INT = 1
			, @numDBs		INT
			, @sqlstring	NVARCHAR(2000)

	INSERT INTO @dbs (dbname)
		SELECT name 
			FROM sys.databases 
			WHERE state = 0 
				AND name LIKE ISNULL(@dbname, name)
			ORDER BY name

	SET @numDBs = @@ROWCOUNT
 
	-- Unfortunately sys.master_files returns size 0 for filestream containes, hence the loop.
	WHILE @countDBs <= @numDBs BEGIN

		SET @db			= ( SELECT dbname FROM @dbs WHERE ID = @countDBs )
		SET @sqlstring	= N'
		
		USE ' + QUOTENAME(@db) + N'
		
		SELECT DB_NAME(), file_id, df.type_desc, df.name, physical_name, ISNULL(fg.name, ''Not Applicable''), (size*8.)/1024. 
			FROM sys.database_files AS df
				LEFT JOIN sys.filegroups AS fg
					ON fg.data_space_id = df.data_space_id
		'
	
		INSERT INTO @dbfiles ([db_name], [file_id], type_desc, name, physical_name, file_group, sizeMB)
			EXEC sp_executesql @sqlstring

		SET @countDBs = @countDBs + 1
	END

	SELECT [db_name]
			, [file_id]	
			, type_desc
			, name
			, physical_name
			, file_group
			, SUM(sizeMB) AS SizeMB
		FROM @dbfiles 
		GROUP BY [db_name], [file_id], type_desc, name, physical_name, file_group
		ORDER BY [db_name] ASC
				, type_desc DESC

	IF @includeTotals = 1 BEGIN

		SELECT [db_name] 
				, [ROWS] AS DataSizeMB
				, [LOG] AS LogSizeMB
				, ISNULL([FILESTREAM], 0) AS FilestreamSizeMB
				, ISNULL([FULLTEXT], 0) AS FulltextSizeMB
				, [ROWS] + [LOG] + ISNULL([FILESTREAM], 0) + ISNULL([FULLTEXT], 0) AS TotalSizeMB
			FROM ( 
				SELECT [db_name], type_desc, sizeMB
					FROM @dbfiles 
			) AS t
			PIVOT(
				SUM(sizeMB)
				FOR type_desc IN ([ROWS],[LOG],[FILESTREAM],[FULLTEXT])
			) AS p
	END
END

GO
