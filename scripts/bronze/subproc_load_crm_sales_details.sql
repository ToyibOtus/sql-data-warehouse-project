/*
================================================================================================================
Stored Procedure: Load bronze.crm_sales_details (Source -> Bronze)
================================================================================================================
Script Purpose:	
	This scripts performs the following operations:
	1. Truncates table 'bronze.crm_sales_details'.
	2. Uses the bulk insert command to load data from the source system into the bronze table.
	3. Records important ETL execution details into the log table 'audit.etl_log'.

Parameters:
	@run_id UNIQUEIDENTIFIER
	This procedure requires you input the value 'NEWID()' into the parameter if it is being run manually, 
	and it doesn't return any values.

Usage:
	EXEC bronze.load_crm_sales_details @run_id = NEWID();

Notes:
    It is recommended to execute the master procedure 'etl.run_master_pipeline' instead of individual
    sub-procedures for the following reasons:
        * It executes the entire ETL process in the correct sequence.
        * It assigns the same @run_id across all sub-procedures for unified tracking.
        * It provides centralized logging and easier monitoring.
================================================================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_crm_sales_details @run_id UNIQUEIDENTIFIER AS
BEGIN
	DECLARE 
	@process_name NVARCHAR(50),
	@start_time DATETIME,
	@end_time DATETIME,
	@rows_loaded INT,
	@source_file NVARCHAR(50),
	@file_path NVARCHAR(250);

	-- ------------------------------------------------------------------
	-- Checking For Error
	-- ------------------------------------------------------------------
	BEGIN TRY
		SET @process_name = 'Load bronze.crm_sales_details';
		SET @start_time = GETDATE();

		-- Truncate Table 'bronze.crm_sales_details'
		TRUNCATE TABLE bronze.crm_sales_details;

		-- Bulk Insert Table 'bronze.crm_sales_details'
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\PC\Documents\SQL_DataWareHouseProject\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		SET @source_file = 'crm_sales_details';
		SET @file_path = 'C:\Users\PC\Documents\SQL_DataWareHouseProject\sql-data-warehouse-project\datasets\source_crm\sales_details.csv';
		SELECT @rows_loaded = COUNT(*) FROM bronze.crm_sales_details;

		-- Insert Into ETL Log Table 'audit.etl_log'
		INSERT INTO audit.etl_log 
		(
		run_id, 
		process_name, 
		load_status, 
		start_time, 
		end_time, 
		load_duration_seconds,
		rows_loaded,
		source_file,
		file_path
		)
		VALUES
		(
		@run_id,
		@process_name,
		'Success',
		@start_time,
		@end_time,
		DATEDIFF(second, @start_time, @end_time),
		@rows_loaded,
		@source_file,
		@file_path
		);
	END TRY
	-- ------------------------------------------------------------------
	-- Error Handling
	-- ------------------------------------------------------------------
	BEGIN CATCH
	-- Insert the following when an error occurs
		INSERT INTO audit.etl_log
		(
		run_id,
		process_name,
		load_status,
		start_time,
		end_time,
		load_duration_seconds,
		source_file,
		file_path,
		error_number,
		error_message,
		error_line,
		error_severity,
		error_state,
		error_procedure
		)
		VALUES
		(
		@run_id,
		@process_name,
		'Failure',
		@start_time,
		@end_time,
		DATEDIFF(second, @start_time, @end_time),
		@source_file,
		@file_path,
		ERROR_NUMBER(),
		ERROR_MESSAGE(),
		ERROR_LINE(),
		ERROR_SEVERITY(),
		ERROR_STATE(),
		ERROR_PROCEDURE()
		);
	END CATCH
END;
GO
