/*
================================================================================================
DDL Script: Create an ETL Pipeline Control Table
================================================================================================
Script Purpose: 
	This script creates the control table 'etl.pipeline_control'. It stores and manages the
	sequence of stored procedures in the 'etl.run_master_pipeline'.

	Run this script to redefine the structure of your etl master log table.
================================================================================================
*/
IF OBJECT_ID('etl.pipeline_control', 'U') IS NOT NULL
DROP TABLE etl.pipeline_control;
GO

CREATE TABLE etl.pipeline_control
(
	pipeline_name NVARCHAR(50) NOT NULL,
	proc_name NVARCHAR(50) NOT NULL,
	execution_order INT NOT NULL
);
GO
