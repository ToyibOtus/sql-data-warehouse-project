/*
================================================================================================
DDL Script: Creates an ETL Master Log Table
================================================================================================
Script Purpose: 
	This script firstly checks the existence of the table 'audit.etl_log'. If it exists, 
	it is dropped and recreated, otherwise there is no table to be dropped, and the 
	log table 'audit.etl_master_log' is created directly.

	Run this script to redefine the structure of your etl master log table.
================================================================================================
*/

IF OBJECT_ID('audit.etl_master_log', 'U') IS NOT NULL
DROP TABLE audit.etl_master_log;
GO

CREATE TABLE audit.etl_master_log
(
	log_id INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
	run_id UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
	pipeline_name NVARCHAR(50) NOT NULL,
	load_status NVARCHAR(50) NOT NULL,
	start_time DATETIME NOT NULL,
	end_time DATETIME NOT NULL,
	total_load_duration_seconds INT NOT NULL,
	tables_expected INT,
	tables_loaded INT,
	error_number INT,
	error_message INT,
	error_line INT
);
GO 
