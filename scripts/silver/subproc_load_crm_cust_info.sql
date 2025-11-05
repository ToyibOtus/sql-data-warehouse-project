/*
==================================================================================================================
Stored Procedure: Load silver.load_crm_cust_info (Bronze -> Silver)
==================================================================================================================
Script Purpose:
	This script loads silver.load_crm_cust_info from the source table bronze.crm_cust_info.
	It performs appropriate data transformations, such as data cleansing, data enrinchment, data standardization
	and normalization on the bronze table before loading the silver, ensuring adequate data quality.
	Additionally, it also loads vital execution details into the etl log table 'audit.etl_log', ensuring
	easy monitoring, traceability, and debugging.

Parameter:
	@run_id UNIQUEIDENTIFIER

Usage:
	EXEC silver.load_crm_cust_info @run_id = NEWID();

Note:
	It is recommended to execute the master procedure 'etl.run_master_pipeline' instead of individual
    sub-procedures for the following reasons:
        * It executes the entire ETL process in the correct sequence.
        * It assigns the same @run_id across all sub-procedures for unified tracking.
        * It provides centralized logging and easier monitoring.
==================================================================================================================
*/
CREATE OR ALTER PROCEDURE silver.load_crm_cust_info @run_id UNIQUEIDENTIFIER AS
BEGIN
	-- Declare variables
	DECLARE
	@process_name NVARCHAR(50),
	@start_time DATETIME,
	@end_time DATETIME,
	@rows_source INT,
	@rows_loaded INT,
	@source_table NVARCHAR(50),
	@target_table NVARCHAR(50);

	BEGIN TRY
		-- Map values to variables
		SET @process_name = 'Load silver.crm_cust_info';
		SET @start_time = GETDATE();

		-- Clear target table before load
		TRUNCATE TABLE silver.crm_cust_info;

		-- Load and transform data
		INSERT INTO silver.crm_cust_info
		(
			cst_id,
			cst_key,
			cst_first_name,
			cst_last_name,
			cst_marital_status,
			cst_gndr,
			cst_create_date
		)
		SELECT
			cst_id,
			cst_key,
			TRIM(cst_first_name) AS cst_first_name,
			TRIM(cst_last_name) AS cst_last_name,
			CASE TRIM(cst_marital_status)
				WHEN 'M' THEN 'Married'
				WHEN 'S' THEN 'Single'
				ELSE 'N/A'
			END AS cst_marital_status,
			CASE TRIM(cst_gndr)
				WHEN 'F' THEN 'Female'
				WHEN 'M' THEN 'Male'
				ELSE 'N/A'
			END AS cst_gndr,
			cst_create_date
		FROM
		(
		SELECT
			cst_id,
			cst_key,
			cst_first_name,
			cst_last_name,
			cst_marital_status,
			cst_gndr,
			cst_create_date,
			ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) flag_last
		FROM bronze.crm_cust_info
		WHERE cst_id IS NOT NULL
		)SUB
		WHERE flag_last = 1; 

		-- Map values to variables
		SET @end_time = GETDATE();
		SET @source_table = 'bronze.crm_cust_info';
		SET @target_table = 'silver.crm_cust_info';
		SELECT @rows_source = COUNT(*) FROM bronze.crm_cust_info;
		SELECT @rows_loaded = COUNT(*) FROM silver.crm_cust_info;

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
			rows_source,
			rows_loaded,
			source_table,
			target_table
		)
		VALUES
		(
			@run_id,
			'silver',
			'Full',
			@process_name,
			'Success',
			@start_time,
			@end_time,
			DATEDIFF(second, @start_time, @end_time),
			@rows_source,
			@rows_loaded,
			@source_table,
			@target_table
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
			source_table,
			target_table,
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
			'silver',
			'Full',
			@process_name,
			'Failure',
			@start_time,
			@end_time,
			DATEDIFF(second, @start_time, @end_time),
			@source_table,
			@target_table,
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
