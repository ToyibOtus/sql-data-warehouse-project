/*
================================================================================================
DDL Script: Creates an ETL Log Table
================================================================================================
Script Purpose: 
	This script firstly checks the existence of the schema 'audit'. If it doesn't exist,
	it is created, otherwise no execution is carried out. Secondly, it checks the existence
	of the table 'audit.etl_log'. If it exists, it is dropped, otherwise no execution is
	carried out. Lastly, the script creates the log table 'audit.etl_log'.

	Run this script to redefine the structure of your etl log table.
================================================================================================
*/

IF NOT EXISTS(SELECT 1 FROM sys.schemas WHERE name = 'audit')
BEGIN
	EXEC('CREATE SCHEMA audit')
END;

IF OBJECT_ID('audit.etl_log', 'U') IS NOT NULL
DROP TABLE audit.etl_log;
GO

CREATE TABLE audit.etl_log
(
	log_id INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	run_id UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	process_name NVARCHAR(50) NOT NULL,
	load_status NVARCHAR(50) NOT NULL,
	start_time DATETIME NOT NULL,
	end_time DATETIME NOT NULL,
	load_duration_seconds INT NOT NULL,
	rows_loaded INT,
	source_file NVARCHAR(50) NOT NULL,
	file_path NVARCHAR(250),
	error_number INT,
	error_message NVARCHAR(MAX),
	error_line INT,
	error_severity INT,
	error_state INT,
	error_procedure NVARCHAR(50)
);
