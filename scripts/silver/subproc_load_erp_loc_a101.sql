/*
==================================================================================================================
Stored Procedure: Load silver.load_erp_loc_a101 (Bronze -> Silver)
==================================================================================================================
Script Purpose:
	This script loads silver.load_erp_loc_a101 from the source table bronze.erp_loc_a101.
	It performs appropriate data transformations, such as data cleansing, data enrinchment, data standardization
	and normalization on the bronze table before loading the silver, ensuring adequate data quality.
	Additionally, it also loads vital execution details into the etl log table 'audit.etl_log', ensuring
	easy monitoring, traceability, and debugging.

Parameter:
	@run_id UNIQUEIDENTIFIER

Usage:
	EXEC silver.load_erp_loc_a101 @run_id = NEWID();

Note:
	It is recommended to execute the master procedure 'etl.run_master_pipeline' instead of individual
    sub-procedures for the following reasons:
        * It executes the entire ETL process in the correct sequence.
        * It assigns the same @run_id across all sub-procedures for unified tracking.
        * It provides centralized logging and easier monitoring.
==================================================================================================================
*/
CREATE OR ALTER PROCEDURE silver.load_erp_loc_a101 @run_id UNIQUEIDENTIFIER AS
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
		SET @process_name = 'Load silver.erp_loc_a101';
		SET @start_time = GETDATE();

		-- Clear target table before load
		TRUNCATE TABLE silver.erp_loc_a101;

		-- Load and transform data
		INSERT INTO silver.erp_loc_a101 (cid, cntry)
		SELECT
			REPLACE(TRIM(cid), '-', '') cid,
			CASE
				WHEN TRIM(cntry) IN ('USA', 'US') THEN 'United States'
				WHEN TRIM(cntry) = 'DE' THEN 'Germany'
				WHEN TRIM(cntry) IS NULL OR TRIM(cntry) = '' THEN 'N/A'
				ELSE TRIM(cntry)
			END cntry
		FROM bronze.erp_loc_a101;

		-- Map values to variables
		SET @end_time = GETDATE();
		SET @source_table = 'bronze.erp_loc_a101';
		SET @target_table = 'silver.erp_loc_a101';
		SELECT @rows_source = COUNT(*) FROM bronze.erp_loc_a101;
		SELECT @rows_loaded = COUNT(*) FROM silver.erp_loc_a101;

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
