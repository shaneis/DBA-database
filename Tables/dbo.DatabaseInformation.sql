CREATE TABLE [dbo].[DatabaseInformation]
(
[ID] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[server_name] [sys].[sysname] NOT NULL,
[name] [sys].[sysname] NOT NULL,
[database_id] [int] NULL,
[source_database_id] [int] NULL,
[source_database_name] [sys].[sysname] NULL,
[owner_sid] [varbinary] (85) NULL,
[owner_name] [sys].[sysname] NULL,
[create_date] [datetime] NULL,
[compatibility_level] [tinyint] NULL,
[collation_name] [sys].[sysname] NULL,
[user_access] [tinyint] NULL,
[user_access_desc] [nvarchar] (60) COLLATE Latin1_General_CI_AS NULL,
[is_read_only] [bit] NULL,
[is_auto_close_on] [bit] NULL,
[is_auto_shrink_on] [bit] NULL,
[state] [tinyint] NULL,
[state_desc] [nvarchar] (60) COLLATE Latin1_General_CI_AS NULL,
[is_in_standby] [bit] NULL,
[is_cleanly_shutdown] [bit] NULL,
[is_supplemental_logging_enabled] [bit] NULL,
[snapshot_isolation_state] [tinyint] NULL,
[snapshot_isolation_state_desc] [nvarchar] (60) COLLATE Latin1_General_CI_AS NULL,
[is_read_committed_snapshot_on] [bit] NULL,
[recovery_model] [tinyint] NULL,
[recovery_model_desc] [nvarchar] (60) COLLATE Latin1_General_CI_AS NULL,
[page_verify_option] [tinyint] NULL,
[page_verify_option_desc] [nvarchar] (60) COLLATE Latin1_General_CI_AS NULL,
[is_auto_create_stats_on] [bit] NULL,
[is_auto_update_stats_on] [bit] NULL,
[is_auto_update_stats_async_on] [bit] NULL,
[is_ansi_null_default_on] [bit] NULL,
[is_ansi_nulls_on] [bit] NULL,
[is_ansi_padding_on] [bit] NULL,
[is_ansi_warnings_on] [bit] NULL,
[is_arithabort_on] [bit] NULL,
[is_concat_null_yields_null_on] [bit] NULL,
[is_numeric_roundabort_on] [bit] NULL,
[is_quoted_identifier_on] [bit] NULL,
[is_recursive_triggers_on] [bit] NULL,
[is_cursor_close_on_commit_on] [bit] NULL,
[is_local_cursor_default] [bit] NULL,
[is_fulltext_enabled] [bit] NULL,
[is_trustworthy_on] [bit] NULL,
[is_db_chaining_on] [bit] NULL,
[is_parameterization_forced] [bit] NULL,
[is_master_key_encrypted_by_server] [bit] NULL,
[is_published] [bit] NULL,
[is_subscribed] [bit] NULL,
[is_merge_published] [bit] NULL,
[is_distributor] [bit] NULL,
[is_sync_with_backup] [bit] NULL,
[service_broker_guid] [uniqueidentifier] NULL,
[is_broker_enabled] [bit] NULL,
[log_reuse_wait] [tinyint] NULL,
[log_reuse_wait_desc] [nvarchar] (60) COLLATE Latin1_General_CI_AS NULL,
[is_date_correlation_on] [bit] NULL,
[is_cdc_enabled] [bit] NULL,
[is_encrypted] [bit] NULL,
[is_honor_broker_priority_on] [bit] NULL,
[replica_id] [uniqueidentifier] NULL,
[group_database_id] [uniqueidentifier] NULL,
[default_language_lcid] [smallint] NULL,
[default_language_name] [nvarchar] (128) COLLATE Latin1_General_CI_AS NULL,
[default_fulltext_language_lcid] [int] NULL,
[default_fulltext_language_name] [nvarchar] (128) COLLATE Latin1_General_CI_AS NULL,
[is_nested_triggers_on] [bit] NULL,
[is_transform_noise_words_on] [bit] NULL,
[two_digit_year_cutoff] [smallint] NULL,
[containment] [tinyint] NULL,
[containment_desc] [nvarchar] (60) COLLATE Latin1_General_CI_AS NULL,
[target_recovery_time_in_seconds] [int] NULL,
[is_memory_optimized_elevate_to_snapshot_on] [bit] NULL,
[is_auto_create_stats_incremental_on] [bit] NULL,
[is_query_store_on] [bit] NULL,
[resource_pool_id] [int] NULL,
[delayed_durability] [int] NULL,
[delayed_durability_desc] [nvarchar] (60) COLLATE Latin1_General_CI_AS NULL,
[PrimaryFilePath] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Size_MB] [decimal] (10, 2) NULL,
[SpaceAvailable_MB] [decimal] (10, 2) NULL,
[DataSpace_MB] [decimal] (10, 2) NULL,
[IndexSpace_MB] [decimal] (10, 2) NULL,
[LogSpace_MB] [decimal] (10, 2) NULL,
[LastBackupDate] [datetime] NULL,
[LastLogBackupDate] [datetime] NULL,
[LastDifferentialDatabaseBackupDate] [datetime] NULL,
[LastFileFilegroupBackupDate] [datetime] NULL,
[LastDifferentialFileBackupDate] [datetime] NULL,
[LastPartialBackupDate] [datetime] NULL,
[LastDifferentialPartialBackupDate] [datetime] NULL,
[LastSuccessfulCheckDB] [datetime] NULL,
[VersionSpecificFeatures] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Num_VLF] [int] NULL,
[DataPurityFlag] [tinyint] NULL,
[BackupSchedule] [char] (7) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_DatabaseInformation_BackupSchedule] DEFAULT ('DDDDDDD'),
[BackupRootPath] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[BackupNFiles] [tinyint] NULL CONSTRAINT [DF_DatabaseInformation_new_BackupNFiles] DEFAULT ((1)),
[BackupBatchNo] [tinyint] NULL,
[KeepNBackups] [tinyint] NULL CONSTRAINT [DF_DatabaseInformation_new_KeepNBackups] DEFAULT ((10)),
[IndexMaintenanceSchedule] [char] (7) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_IndexMaintenanceSchedule] DEFAULT ('------R'),
[DBCCSchedule] [char] (7) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_DBCCSchedule] DEFAULT ('------F'),
[StatisticsMaintenanceSchedule] [char] (7) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_UpdateStatsSchedule] DEFAULT ('------F'),
[DataCollectionTime] [datetime] NULL,
[is_federation_member] [bit] NULL,
[is_remote_data_archive_enabled] [bit] NULL,
[is_mixed_page_allocation_on] [bit] NULL,
[is_temporal_retention_enabled] [bit] NULL,
[is_temporal_history_retention_enabled] [bit] NULL,
[RowCheckSum] AS (checksum([server_name],[name],[database_id],[source_database_id],[source_database_name],[owner_sid],[owner_name],[create_date],[compatibility_level],[collation_name],[user_access],[user_access_desc],[is_read_only],[is_auto_close_on],[is_auto_shrink_on],[state],[state_desc],[is_in_standby],[is_cleanly_shutdown],[is_supplemental_logging_enabled],[snapshot_isolation_state],[snapshot_isolation_state_desc],[is_read_committed_snapshot_on],[recovery_model],[recovery_model_desc],[page_verify_option],[page_verify_option_desc],[is_auto_create_stats_on],[is_auto_update_stats_on],[is_auto_update_stats_async_on],[is_ansi_null_default_on],[is_ansi_nulls_on],[is_ansi_padding_on],[is_ansi_warnings_on],[is_arithabort_on],[is_concat_null_yields_null_on],[is_numeric_roundabort_on],[is_quoted_identifier_on],[is_recursive_triggers_on],[is_cursor_close_on_commit_on],[is_local_cursor_default],[is_fulltext_enabled],[is_trustworthy_on],[is_db_chaining_on],[is_parameterization_forced],[is_master_key_encrypted_by_server],[is_published],[is_subscribed],[is_merge_published],[is_distributor],[is_sync_with_backup],[service_broker_guid],[is_broker_enabled],[is_date_correlation_on],[is_cdc_enabled],[is_encrypted],[is_honor_broker_priority_on],[replica_id],[group_database_id],[default_language_lcid],[default_language_name],[default_fulltext_language_lcid],[default_fulltext_language_name],[is_nested_triggers_on],[is_transform_noise_words_on],[two_digit_year_cutoff],[containment],[containment_desc],[target_recovery_time_in_seconds],[is_memory_optimized_elevate_to_snapshot_on],[is_auto_create_stats_incremental_on],[is_query_store_on],[resource_pool_id],[delayed_durability],[delayed_durability_desc],[PrimaryFilePath],[VersionSpecificFeatures],[BackupSchedule],[BackupRootPath],[BackupNFiles],[BackupBatchNo],[KeepNBackups],[IndexMaintenanceSchedule],[DBCCSchedule],[StatisticsMaintenanceSchedule],[is_federation_member],[is_remote_data_archive_enabled],[is_mixed_page_allocation_on],[is_temporal_retention_enabled],[is_temporal_history_retention_enabled]))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DatabaseInformation] ADD CONSTRAINT [PK_DatabaseInformation] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UIX_DatabaseInformation_server_name_name] ON [dbo].[DatabaseInformation] ([server_name], [name]) ON [PRIMARY]
GO