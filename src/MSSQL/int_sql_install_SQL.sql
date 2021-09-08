USE master;
-- Create Project's Environment
GO
EXEC [SSISDB].[catalog].[create_environment] @environment_name=N'Project2', @environment_description=N'Set up variables for Project2 jobs.', @folder_name=N'Project2';
GO
-- Change var_email to your email
DECLARE @var_email sql_variant = N'paq9695@gmail.com'
EXEC [SSISDB].[catalog].[create_environment_variable] @variable_name=N'ErrorEmail', @sensitive=False,
@description=N'Email address for receiving error alert', @environment_name=N'Project2', @folder_name=N'Project2', @value=@var_email, @data_type=N'String';
GO
-- Change var_path to your project path
DECLARE @var_path sql_variant = N'E:\Project2-Topic4\group_4-fa-project1'
EXEC [SSISDB].[catalog].[create_environment_variable] @variable_name=N'ProjectPath', @sensitive=False,
@description=N'Path to Project folder', @environment_name=N'Project2', @folder_name=N'Project2', @value=@var_path, @data_type=N'String';
GO
-- Change var_snowflake_dsn_name to your Snowflake DSN Name
DECLARE @var_snowflake_dsn_name sql_variant = N'Snowflake'
EXEC [SSISDB].[catalog].[create_environment_variable] @variable_name=N'SnowflakeDSNName', @sensitive=False,
@description=N'Snowflake DSN Name', @environment_name=N'Project2', @folder_name=N'Project2', @value=@var_snowflake_dsn_name, @data_type=N'String'
GO
-- Change var_snowflake_account to your Snowflake account
DECLARE @var_snowflake_account sql_variant = N'fk36375.ap-southeast-1'
EXEC [SSISDB].[catalog].[create_environment_variable] @variable_name=N'SnowflakeAccount', @sensitive=False,
@description=N'Snowflake Account', @environment_name=N'Project2', @folder_name=N'Project2', @value=@var_snowflake_account, @data_type=N'String'
GO
-- Change var_snowflake_password to your Snowflake password
DECLARE @var_snowflake_password sql_variant = N'Ab@019283'
EXEC [SSISDB].[catalog].[create_environment_variable] @variable_name=N'SnowflakePassword', @sensitive=False,
@description=N'Snowflake Password', @environment_name=N'Project2', @folder_name=N'Project2', @value=@var_snowflake_password, @data_type=N'String'
GO
-- Change var_snowflake_user to your Snowflake user
DECLARE @var_snowflake_user sql_variant = N'quanpa'
EXEC [SSISDB].[catalog].[create_environment_variable] @variable_name=N'SnowflakeUser', @sensitive=False,
@description=N'Snowflake User', @environment_name=N'Project2', @folder_name=N'Project2', @value=@var_snowflake_user, @data_type=N'String'
GO
-- Change var_servername to your SQL Server Name
DECLARE @var_servername sql_variant = @@servername
EXEC [SSISDB].[catalog].[create_environment_variable] @variable_name=N'Servername', @sensitive=False,
@description=N'SQL Servername', @environment_name=N'Project2', @folder_name=N'Project2', @value=@var_servername, @data_type=N'String'
GO

Declare @reference_id bigint
EXEC [SSISDB].[catalog].[create_environment_reference] @environment_name=N'Project2', @reference_id=@reference_id OUTPUT, @project_name=N'Project2', @folder_name=N'Project2', @reference_type=R
Select @reference_id

GO
EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'ErrorEmail', @object_name=N'Project2', @folder_name=N'Project2', @project_name=N'Project2', @value_type=R, @parameter_value=N'ErrorEmail'
GO
EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'ProjectPath', @object_name=N'Project2', @folder_name=N'Project2', @project_name=N'Project2', @value_type=R, @parameter_value=N'ProjectPath'
GO
EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'SnowflakeDSNName', @object_name=N'Project2', @folder_name=N'Project2', @project_name=N'Project2', @value_type=R, @parameter_value=N'SnowflakeDSNName'
GO
EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'SnowflakeAccount', @object_name=N'Project2', @folder_name=N'Project2', @project_name=N'Project2', @value_type=R, @parameter_value=N'SnowflakeAccount'
GO
EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'SnowflakePassword', @object_name=N'Project2', @folder_name=N'Project2', @project_name=N'Project2', @value_type=R, @parameter_value=N'SnowflakePassword'
GO
EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'SnowflakeUser', @object_name=N'Project2', @folder_name=N'Project2', @project_name=N'Project2', @value_type=R, @parameter_value=N'SnowflakeUser'
GO
EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'ServerName', @object_name=N'Project2', @folder_name=N'Project2', @project_name=N'Project2', @value_type=R, @parameter_value=N'Servername'
GO

-- Create Database
IF DB_ID('Project2') IS NOT NULL
DROP DATABASE Project2;
GO
CREATE DATABASE [Project2];
GO
USE [Project2];
GO
CREATE SCHEMA Staging;
GO
CREATE SCHEMA Storing;
GO

-- Create Table
CREATE TABLE [Staging].[Customer](
	[Customer_ID] int PRIMARY KEY,
	[name] [varchar](100) NOT NULL,
	[username] [varchar](50) NOT NULL,
	[sex] [varchar](1) NOT NULL,
	[mail] [varchar](100) NOT NULL,
	[birthdate] Datetime NULL,
	[Location_ID] int NOT NULL,
	[Phone] [varchar](50) NOT NUll,
	[uuid] [uniqueidentifier] DEFAULT newid(),
	[LastEditedBy] [nvarchar](64) NOT NULL,
	[LastEditedWhen] [datetime] NOT NULL,
);

CREATE TABLE [Staging].[Location](
	[Location_ID] Int PRIMARY KEY,
	[Address] [varchar](100) NOT NULL,
	[Lat] float NOT NULL,
	[Long] float NOT NULL,
	[City] [varchar](50) NOT NULL,
	[Country_code] [varchar](2) NOT NULL,
	[Country_name] [varchar](50) NOT NULL,
	[States] [varchar](50) NOT NULL,
	[uuid] [uniqueidentifier] DEFAULT newid(),
	[LastEditedBy] [nvarchar](64) NOT NULL,
	[LastEditedWhen] [datetime] NOT NULL,
);

CREATE TABLE [Staging].[Product](
	[Product_ID] int PRIMARY KEY,
	[Product_Name] [varchar](50) NOT NULL,
	[Product_Category] [varchar](50) NULL,
	[Product_Code] int NOT NULL,
	[Weight] float NOT NULL,
	[uuid] [uniqueidentifier] DEFAULT newid(),
	[LastEditedBy] [nvarchar](64) NOT NULL,
	[LastEditedWhen] [datetime] NOT NULL,
);

CREATE TABLE [Staging].[Export](
	[Order_ID] int PRIMARY KEY,
	[Product_ID] int NOT NULL,
	[Customer_ID] int NOT NULL,
	[Quantity] int NOT NULL,
	[Date_Order] date NOT NULL,
	[Date_Ship] date NOT NULL,
	[Date_due] date NOT NULL,
	[Ship_Distance] float NOT NULL,
	[Ship_Cost] float NOT NULL,
	[uuid] [uniqueidentifier] DEFAULT newid(),
	[LastEditedBy] [nvarchar](64) NOT NULL,
	[LastEditedWhen] [datetime] NOT NULL,
);

CREATE TABLE [Staging].[Warehouse](
	[Warehouse_ID] int PRIMARY KEY,
	[Warehouse_Name] [varchar](100) NOT NULL,
	[Warehouse_cost] float NOT NULL,
	[Location_ID] int NOT NULL,
	[uuid] [uniqueidentifier] DEFAULT newid(),
	[LastEditedBy] [nvarchar](64) NOT NULL,
	[LastEditedWhen] [datetime] NOT NULL,
);

CREATE TABLE [Staging].[Storage](
	[StorageID] [int] PRIMARY KEY,
	[Product_ID] [int] NOT NULL,
	[Warehouse_ID] [int] NOT NULL,
	[Capacity] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[uuid] [uniqueidentifier] DEFAULT newid(),
	[LastEditedBy] [nvarchar](64) NOT NULL,
	[LastEditedWhen] [datetime] NOT NULL
);

CREATE TABLE [Staging].[Supplier](
	[Supplier_ID] [int] PRIMARY KEY,
	[Supplier_Name] [varchar](50) NOT NULL,
	[Location_ID] [int] NOT NULL,
	[uuid] [uniqueidentifier] DEFAULT newid(),
	[LastEditedBy] [nvarchar](64) NOT NULL,
	[LastEditedWhen] [datetime] NOT NULL
);

CREATE TABLE [Staging].[Import](
	[Import_ID] [int] PRIMARY KEY,
	[Product_ID] [int] NOT NULL,
	[Warehouse_ID] [int] NOT NULL,
	[Supplier_ID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[Ship_Distance] [float] NOT NULL,
	[Ship_Cost] [float] NOT NULL,
	[Import_Date] [date] NOT NULL,
	[uuid] [uniqueidentifier] DEFAULT newid(),
	[LastEditedBy] [nvarchar](64) NOT NULL,
	[LastEditedWhen] [datetime] NOT NULL
);

CREATE TABLE [Storing].[Product](
	[Product_ID] [int] IDENTITY(1,1) PRIMARY KEY,
	[Source_Product_ID] [int] NOT NULL,
	[Product_Code] [int] NOT NULL,
	[Product_Name] [varchar](50) NOT NULL,
	[Product_Category] [varchar](50) NULL,
	[Weight] [float] NOT NULL,
	[Current] [bit] NULL,
	[uuid] [uniqueidentifier] DEFAULT newid(),
	[LastEditedBy] [nvarchar](64) NOT NULL,
	[LastEditedWhen] [datetime] NOT NULL
);
CREATE INDEX Product_uuid ON [Storing].[Product]([uuid]);

CREATE TABLE [Storing].[Location](
	[Location_ID] [int] IDENTITY(1,1) PRIMARY KEY,
	[Source_Location_ID] [int] NOT NULL,
	[Address] [varchar](100) NOT NULL,
	[Lat] [float] NOT NULL,
	[Long] [float] NOT NULL,
	[City] [varchar](50) NOT NULL,
	[Country_code] [varchar](2) NOT NULL,
	[Country_name] [varchar](50) NOT NULL,
	[States] [varchar](50) NOT NULL,
	[uuid] [uniqueidentifier] DEFAULT newid(),
	[LastEditedBy] [nvarchar](64) NOT NULL,
	[LastEditedWhen] [datetime] NOT NULL
);
CREATE INDEX Location_uuid ON [Storing].[Location]([uuid]);

CREATE TABLE [Storing].[Customer](
	[Customer_ID] [int] IDENTITY(1,1) PRIMARY KEY,
	[Source_Customer_ID] [int] NOT NULL,
	[name] [varchar](100) NOT NULL,
	[username] [varchar](50) NOT NULL,
	[sex] [varchar](1) NOT NULL,
	[mail] [varchar](100) NOT NULL,
	[birthdate] [date] NULL,
	[Location_ID] [int] NOT NULL,
	[Phone] [varchar](50) NOT NULL,
	[uuid] [uniqueidentifier] DEFAULT newid(),
	[Current] [bit] NULL,
	[LastEditedBy] [nvarchar](64) NOT NULL,
	[LastEditedWhen] [datetime] NOT NULL,
    FOREIGN KEY (Location_ID) REFERENCES [Storing].[Location](Location_ID)
);
CREATE INDEX Customer_uuid ON [Storing].[Customer]([uuid]);

CREATE TABLE [Storing].[Supplier](
	[Supplier_ID] [int] IDENTITY(1,1) PRIMARY KEY,
	[Source_Supplier_ID] [int] NOT NULL,
	[Supplier_Name] [varchar](50) NOT NULL,
	[Location_ID] [int] NOT NULL,
	[uuid] [uniqueidentifier] DEFAULT newid(),
	[LastEditedBy] [nvarchar](64) NOT NULL,
	[LastEditedWhen] [datetime] NOT NULL,
	FOREIGN KEY (Location_ID) REFERENCES [Storing].[Location](Location_ID)
);
CREATE INDEX Supplier_uuid ON [Storing].[Supplier]([uuid]);

CREATE TABLE [Storing].[Warehouse](
	[Warehouse_ID] [int] IDENTITY(1,1) PRIMARY KEY,
	[Source_Warehouse_ID] [int] NOT NULL,
	[Warehouse_Name] [varchar](100) NOT NULL,
	[Warehouse_cost] [float] NOT NULL,
	[Location_ID] [int] NOT NULL,
	[uuid] [uniqueidentifier] DEFAULT newid(),
	[LastEditedBy] [nvarchar](64) NOT NULL,
	[LastEditedWhen] [datetime] NOT NULL,
    FOREIGN KEY (Location_ID) REFERENCES [Storing].[Location](Location_ID)
);
CREATE INDEX Warehouse_uuid ON [Storing].[Warehouse]([uuid]);

CREATE TABLE [Storing].[Storage](
	[StorageID] [int] IDENTITY(1,1) PRIMARY KEY,
	[Source_StorageID] [int] NOT NULL,
	[Product_ID] [int] NOT NULL,
	[Warehouse_ID] [int] NOT NULL,
	[Capacity] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[uuid] [uniqueidentifier] DEFAULT newid(),
	[LastEditedBy] [nvarchar](64) NOT NULL,
	[LastEditedWhen] [datetime] NOT NULL
    FOREIGN KEY ([Product_ID]) REFERENCES [Storing].[Product]([Product_ID]),
    FOREIGN KEY ([Warehouse_ID]) REFERENCES [Storing].[Warehouse]([Warehouse_ID])
);
CREATE INDEX Storage_uuid ON [Storing].[Storage]([uuid]);

CREATE TABLE [Storing].[Export](
	[Order_ID] [int] IDENTITY(1,1) PRIMARY KEY,
	[Source_Order_ID] [int] NOT NULL,
	[Product_ID] [int] NOT NULL,
	[Customer_ID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[Date_Order] [date] NOT NULL,
	[Date_Ship] [date] NOT NULL,
	[Date_due] [date] NOT NULL,
	[Ship_Distance] [float] NOT NULL,
	[Ship_Cost] [float] NOT NULL,
	[uuid] [uniqueidentifier] DEFAULT newid(),
	[LastEditedBy] [nvarchar](64) NOT NULL,
	[LastEditedWhen] [datetime] NOT NULL,
    FOREIGN KEY ([Product_ID]) REFERENCES [Storing].[Product]([Product_ID]),
    FOREIGN KEY ([Customer_ID]) REFERENCES [Storing].[Customer]([Customer_ID]),
);
CREATE INDEX Export_uuid ON [Storing].[Export]([uuid]);

CREATE TABLE [Storing].[Import](
	[ImportID] [int] IDENTITY(1,1) PRIMARY KEY,
	[Source_Import_ID] [int] NOT NULL,
	[Product_ID] [int] NOT NULL,
	[Warehouse_ID] [int] NOT NULL,
	[Supplier_ID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[Ship_Distance] [float] NOT NULL,
	[Ship_Cost] [float] NOT NULL,
	[Import_Date] [date] NOT NULL,
	[uuid] [uniqueidentifier] DEFAULT newid(),
	[LastEditedBy] [nvarchar](64) NOT NULL,
	[LastEditedWhen] [datetime] NOT NULL,
    FOREIGN KEY ([Product_ID]) REFERENCES [Storing].[Product]([Product_ID]),
    FOREIGN KEY ([Supplier_ID]) REFERENCES [Storing].[Supplier]([Supplier_ID]),
    FOREIGN KEY ([Warehouse_ID]) REFERENCES [Storing].[Warehouse]([Warehouse_ID])
);
CREATE INDEX Import_uuid ON [Storing].[Import]([uuid]);

GO
sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'Database Mail XPs', 1;
GO
RECONFIGURE
GO	
-- Create a Database Mail profile
IF 'Notifications' IN (SELECT [name] FROM [msdb].[dbo].[sysmail_profile])
	EXECUTE msdb.dbo.sysmail_delete_profile_sp
    @profile_name = 'Notifications';

EXECUTE msdb.dbo.sysmail_add_profile_sp  
    @profile_name = 'Notifications',  
    @description = 'Profile used for sending error log using Gmail.' ;  
GO
-- Grant access to the profile to the DBMailUsers role  
EXECUTE msdb.dbo.sysmail_add_principalprofile_sp  
    @profile_name = 'Notifications',  
    @principal_name = 'public',  
    @is_default = 1 ;
GO

IF 'Gmail' IN (SELECT [name] FROM [msdb].[dbo].[sysmail_account])
	EXECUTE msdb.dbo.sysmail_delete_account_sp
	@account_name = 'Gmail';

-- Create a Database Mail account  
EXECUTE msdb.dbo.sysmail_add_account_sp  
    @account_name = 'Gmail',  
    @description = 'Mail account for sending error log notifications.',  
    @email_address = 'dummyforssis@gmail.com',  
    @display_name = 'Automated Mailer',  
    @mailserver_name = 'smtp.gmail.com',
	@mailserver_type = 'SMTP',
    @port = 587,
    @enable_ssl = 1,
    @username = 'dummyforssis@gmail.com',
    @password = 'Ab@123456' ;  
GO

-- Add the account to the profile  
EXECUTE msdb.dbo.sysmail_add_profileaccount_sp  
    @profile_name = 'Notifications',  
    @account_name = 'Gmail',  
    @sequence_number = 1;  
GO

-- Create Job Upload
USE [msdb]
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'Upload', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]'
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'Upload', @server_name = @@servername
GO
USE [msdb]
GO
Declare @reference_id nvarchar(max) = (SELECT reference_id
  FROM [SSISDB].[internal].[environment_references]
  WHERE environment_name = 'Project2');
Declare @command nvarchar(max) = '/ISSERVER "\"\SSISDB\Project2\Project2\Upload.dtsx\"" /SERVER "\"'+@@servername+'\"" /ENVREFERENCE ' + @reference_id +' /Par "\"$ServerOption::LOGGING_LEVEL(Int16)\"";1 /Par "\"$ServerOption::SYNCHRONIZED(Boolean)\"";True /CALLERINFO SQLAGENT /REPORTING E'
EXEC msdb.dbo.sp_add_jobstep @job_name=N'Upload', @step_name=N'Upload', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=2, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'SSIS', 
		@command=@command, 
		@database_name=N'master', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Upload', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'', 
		@category_name=N'[Uncategorized (Local)]', 
		@notify_email_operator_name=N'', 
		@notify_page_operator_name=N''
GO
-- Add schedule
EXEC sp_add_schedule @schedule_name = N'Upload', 
		@freq_type = 4, 
		@freq_interval = 1, 
		@active_start_time = 000500;

-- Attach job to schedule
GO
EXEC sp_attach_schedule  
   		@job_name = N'Upload',  
   		@schedule_name = N'Upload';

-- Create Job Unload
USE [msdb]
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'Unload', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]'
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'Unload', @server_name = @@servername
GO
USE [msdb]
GO
Declare @reference_id nvarchar(max) = (SELECT reference_id
  FROM [SSISDB].[internal].[environment_references]
  WHERE environment_name = 'Project2');
Declare @command nvarchar(max) = '/ISSERVER "\"\SSISDB\Project2\Project2\Unload.dtsx\"" /SERVER "\"'+@@servername+'\"" /ENVREFERENCE ' + @reference_id +' /Par "\"$ServerOption::LOGGING_LEVEL(Int16)\"";1 /Par "\"$ServerOption::SYNCHRONIZED(Boolean)\"";True /CALLERINFO SQLAGENT /REPORTING E'
EXEC msdb.dbo.sp_add_jobstep @job_name=N'Unload', @step_name=N'Unload', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=2, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'SSIS', 
		@command=@command,
		@database_name=N'master', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Unload', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'', 
		@category_name=N'[Uncategorized (Local)]', 
		@notify_email_operator_name=N'', 
		@notify_page_operator_name=N''
GO
-- Add schedule
EXEC sp_add_schedule @schedule_name = N'Unload', 
		@freq_type = 4, 
		@freq_interval = 1, 
		@active_start_time = 070500;

-- Attach job to schedule
GO
EXEC sp_attach_schedule  
   		@job_name = N'Unload',  
   		@schedule_name = N'Unload';
