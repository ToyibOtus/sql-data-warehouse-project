/*
================================================================================================================
Stored Procedure: Load bronze.erp_cust_az12 (Source -> Bronze)
================================================================================================================
Script Purpose:	
	This scripts performs the following operations:
	1. Truncates table 'bronze.erp_cust_az12'.
	2. Uses the bulk insert command to load data from the source system into the bronze table.
	3. Records important ETL execution details into the log table 'audit.etl_log'.

	Additionally, it also loads vital execution details into the etl log table 'audit.etl_log', ensuring
	easy monitoring, traceability, and debugging.

Parameters:
	@run_id UNIQUEIDENTIFIER

Usage:
	EXEC bronze.load_erp_cust_az12 @run_id = NEWID();

Notes:
    It is recommended to execute the master procedure 'etl.run_master_pipeline' instead of individual
    sub-procedures for the following reasons:
        * It executes the entire ETL process in the correct sequence.
        * It assigns the same @run_id across all sub-procedures for unified tracking.
        * It provides centralized logging and easier monitoring.
================================================================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_erp_cust_az12 @run_id UNIQUEIDENTIFIER AS
BEGIN
	-- Declare variables
	DECLARE 
	@process_name NVARCHAR(50),
	@start_time DATETIME,
	@end_time DATETIME,
	@rows_loaded INT,
	@source_file NVARCHAR(50),
	@file_path NVARCHAR(250);

	BEGIN TRY
		-- Map values to variables
		SET @process_name = 'Load bronze.erp_cust_az12';
		SET @start_time = GETDATE();

		-- Clear target table before load
		TRUNCATE TABLE bronze.erp_cust_az12;

		-- Load Data
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\PC\Documents\SQL_DataWareHouseProject\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		-- Map values to variables
		SET @end_time = GETDATE();
		SET @source_file = 'erp_cust_az12';
		SET @file_path = 'C:\Users\PC\Documents\SQL_DataWareHouseProject\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv';
		SELECT @rows_loaded = COUNT(*) FROM bronze.erp_cust_az12;

		-- Log success
		INSERT INTO audit.etl_log 
		(
			run_id, 
			layer,
			load_type,
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
			'bronze',
			'Full',
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
	
	BEGIN CATCH
	-- Log any failure with error details
		INSERT INTO audit.etl_log
		(
			run_id,
			layer,
			load_type,
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
			'bronze',
			'Full',
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
