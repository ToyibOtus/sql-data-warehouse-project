/*
==================================================================================================================
Stored Procedure: Load silver.load_erp_cust_az12 (Bronze -> Silver)
==================================================================================================================
Script Purpose:
	This script loads silver.load_erp_cust_az12 from the source table bronze.erp_cust_az12.
	It performs appropriate data transformations, such as data cleansing, data enrinchment, data standardization
	and normalization on the bronze table before loading the silver, ensuring adequate data quality.
	Additionally, it also loads vital execution details into the etl log table 'audit.etl_log', ensuring
	easy monitoring, traceability, and debugging.

Parameter:
	@run_id UNIQUEIDENTIFIER

Usage:
	EXEC silver.load_erp_cust_az12 @run_id = NEWID();

Note:
	It is recommended to execute the master procedure 'etl.run_master_pipeline' instead of individual
    sub-procedures for the following reasons:
        * It executes the entire ETL process in the correct sequence.
        * It assigns the same @run_id across all sub-procedures for unified tracking.
        * It provides centralized logging and easier monitoring.
==================================================================================================================
*/
CREATE OR ALTER PROCEDURE silver.load_erp_cust_az12 @run_id UNIQUEIDENTIFIER AS
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
		SET @process_name = 'Load silver.erp_cust_az12';
		SET @start_time = GETDATE();

		-- Clear target table before load
		TRUNCATE TABLE silver.erp_cust_az12;

		-- Load and transform data
		INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)
		SELECT
			CASE 
				WHEN TRIM(cid) LIKE ('N%') THEN SUBSTRING(TRIM(cid), 4, LEN(cid))
				ELSE TRIM(cid)
			END cid,
			CASE
				WHEN bdate > GETDATE() THEN NULL
				ELSE bdate
			END AS bdate,
			CASE
				WHEN TRIM(gen) IN ('M', 'Male') THEN 'Male'
				WHEN TRIM(gen) IN ('F', 'Female') THEN 'Female'
				ELSE 'N/A'
			END AS gen
		FROM bronze.erp_cust_az12;

		-- Map values to variables
		SET @end_time = GETDATE();
		SET @source_table = 'bronze.erp_cust_az12';
		SET @target_table = 'silver.erp_cust_az12';
		SELECT @rows_source = COUNT(*) FROM bronze.erp_cust_az12;
		SELECT @rows_loaded = COUNT(*) FROM silver.erp_cust_az12;

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
