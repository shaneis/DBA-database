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
-- Create date: 20/05/2013 
-- Description:	Returns a list of objects which contains the  
--				given pattern and their definition 
-- 
-- Log History:	18/08/2013 - RAG - Included functionality to look for the pattern in job steps 
--				19/08/2013 - RAG - Changed Global temp table for a local temp table to avoid concurrency problems 
--				28/11/2013 - RAG - Included database name for job steps instead of SQL Agent 
--				30/05/2014 - RAG - Included GO at the end of any SQL module  
--				04/12/2014 - RAG - Included search into sysarticles if exists 
--				25/04/2016 - SZO - Included ability to specify database to search 
--				31/10/2016 - SZO - Included ability to check definition of check constraints 
--				01/11/2016 - SZO - Included ability to check definition of default constraints 
--				16/11/2016 - SZO - Changes script to group check and default constraints together 
--				30/09/2018 - RAG - Added specific query for foreign keys that will desplay 
--										the referenced column and referential actions
-- ============================================= 
DECLARE @pattern		SYSNAME = NULL, 
		@databaseName	SYSNAME = NULL 
	
SET NOCOUNT ON 

CREATE TABLE #result( 
	databaseName		SYSNAME 
	, objectName		SYSNAME 
	, objectTypeDesc	SYSNAME 
	, objectDefinition	NVARCHAR(MAX) 
) 

DECLARE @databases TABLE ( 
	ID		INT IDENTITY 
	,dbname SYSNAME) 

-- Local variables  
DECLARE @sql				NVARCHAR(MAX) 
		, @dbname			SYSNAME 
		, @countDB			INT = 1 
		, @numDB			INT 
		, @countResults		INT = 1 
		, @numResults		INT 

-- All online databases 
INSERT INTO @databases  
	SELECT TOP 100 PERCENT name  
		FROM sys.databases  
		WHERE [name] NOT IN ('model', 'tempdb')  
			AND state = 0  
			AND [name] = ISNULL(@databaseName, [name])  
		ORDER BY name ASC 

SET @numDB = @@ROWCOUNT 

WHILE @countDB <= @numDB BEGIN 
	SET @dbname = (SELECT dbname FROM @databases WHERE ID = @countDB) 
	
	SET @sql = N' 
		USE ' + QUOTENAME(@dbname) + N' 

		DECLARE @pattern			SYSNAME = ''' + @pattern  + N''' 

		INSERT INTO #result ( databaseName, objectName, objectTypeDesc, objectDefinition) 
			SELECT DB_NAME() 
					, QUOTENAME(OBJECT_SCHEMA_NAME(o.object_id)) + ''.'' + QUOTENAME(o.name) 
					, o.type_desc 
					, ''USE '' + QUOTENAME(DB_NAME()) + CHAR(10) + ''GO'' + CHAR(10) + RTRIM(LTRIM(m.[definition])) + CHAR(10) + ''GO'' 
				FROM sys.objects as o 
					LEFT JOIN sys.sql_modules as m 
						ON m.object_id = o.object_id 
				WHERE ( o.name LIKE ''%'' + @pattern + ''%'' OR m.definition LIKE ''%'' + @pattern + ''%'' ) 
					-- handled in the final union, creates duplicate results. 
					AND o.type_desc NOT IN (''CHECK_CONSTRAINT'', ''DEFAULT_CONSTRAINT'', ''FOREIGN_KEY_CONSTRAINT'') 
					AND o.is_ms_shipped = 0 
			UNION  
			SELECT DB_NAME() 
					, QUOTENAME(OBJECT_SCHEMA_NAME(o.object_id)) + ''.'' + QUOTENAME(o.name) + ''.'' + QUOTENAME(c.name) 
					, o.type_desc + ''_COLUMN'' 
					, t.name + ISNULL((CASE WHEN t.xtype = t.xusertype  
											THEN ''('' + CONVERT( VARCHAR, CONVERT(INT,(c.max_length * 1.) / (t.length / (NULLIF(t.prec, 0) * 1.))) ) + '')'' 
											ELSE '''' 
										END), '''') 
				FROM sys.columns as c 
					INNER JOIN sys.objects AS o 
						ON o.object_id = c.object_id 
					INNER JOIN systypes as t 
						ON t.xusertype = c.user_type_id 
				WHERE c.name LIKE ''%'' + @pattern + ''%'' 
					AND is_ms_shipped = 0 
			UNION 
			SELECT DB_NAME() 
					, QUOTENAME(OBJECT_SCHEMA_NAME(o.[object_id])) + ''.'' + QUOTENAME(o.name) 
					, o.type_desc 
					, RTRIM(LTRIM(ISNULL(dc.[definition], cc.[definition]))) 
				FROM sys.objects AS o 
					LEFT JOIN sys.default_constraints AS dc 
						ON o.[object_id] = dc.[object_id] 
					LEFT JOIN sys.check_constraints AS cc 
						ON o.[object_id] = cc.[object_id] 
				WHERE (dc.[definition] LIKE ''%'' + @pattern + ''%'' OR cc.[definition] LIKE ''%'' + @pattern + ''%'' 
						OR dc.name LIKE ''%'' + @pattern + ''%'' OR cc.name LIKE ''%'' + @pattern + ''%'') 
					AND o.is_ms_shipped = 0 
			UNION 
			SELECT DB_NAME() 
					, QUOTENAME(OBJECT_SCHEMA_NAME(o.[object_id])) + ''.'' + QUOTENAME(o.name) 
					, o.type_desc 
					, ''REFERENCES '' + QUOTENAME(OBJECT_SCHEMA_NAME(fk.referenced_object_id)) + ''.'' 
							+ QUOTENAME(OBJECT_NAME(fk.referenced_object_id)) + ''.''  
							+ QUOTENAME(COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id))
							+ '' ON DELETE '' + fk.delete_referential_action_desc COLLATE DATABASE_DEFAULT
							+ '', ON UPDATE '' + fk.delete_referential_action_desc COLLATE DATABASE_DEFAULT
				FROM sys.objects AS o 
					INNER JOIN sys.foreign_keys AS fk
						ON fk.[object_id] = o.[object_id] 
					LEFT JOIN sys.foreign_key_columns AS fkc
						ON fkc.constraint_object_id = fk.object_id

				WHERE o.name LIKE ''%'' + @pattern + ''%'' 
					AND o.is_ms_shipped = 0 


		IF OBJECT_ID(''sysarticles'') IS NOT NULL BEGIN  
			INSERT INTO #result ( databaseName, objectName, objectTypeDesc, objectDefinition) 
				SELECT DB_NAME() 
						, name 
						, ''REPLICATION ARTICLE'' 
						, '''' 
					FROM dbo.sysarticles AS a							 
					WHERE a.name LIKE ''%'' + @pattern + ''%''  
						OR a.del_cmd LIKE ''%'' + @pattern + ''%''  
						OR a.ins_cmd LIKE ''%'' + @pattern + ''%''  
						OR a.upd_cmd LIKE ''%'' + @pattern + ''%''  
		END  
	' 
	--SELECT @sql
	EXECUTE sp_executesql @sql 

	SET @countDB = @countDB + 1 
END		 

INSERT INTO #result ( databaseName, objectName, objectTypeDesc, objectDefinition) 
SELECT js.database_name 
		, j.name + N'. Step ' + CONVERT(NVARCHAR, js.step_id) + N' (' + js.step_name + N')' + CASE WHEN j.enabled = 0 THEN N' (Disabled)' ELSE N'' END 
		, 'SQL AGENT JOB' 
		, js.command 
	FROM msdb.dbo.sysjobs AS j 
		INNER JOIN msdb.dbo.sysjobsteps AS js 
			ON js.job_id = j.job_id 
	WHERE js.command LIKE '%' + @pattern + '%' 

SELECT databaseName 
		, objectName 
		, objectTypeDesc 
		, objectDefinition 
	FROM #result  
	ORDER BY 1,3,2 

DROP TABLE #result 
GO
