/*
======================================================================================================================
Stored Procedure: Full ETL Run (Source -> Bronze -> Silver)
======================================================================================================================
Script Purpose:
	This script performs a full etl run, extracting, transforming, and loading the bronze and silver layers
	where necessary. Additionally, it loads high-level execution details into the log table'audit.etl_master_log', 
	ensuring adequate monitoring, and traceability on a high-level.

Parameter: None

Usage:
	EXEC etl.run_master_pipeline

Note:
	After executing this stored procedure, run the following scripts:
	'SELECT * FROM audit.etl_log' to access the etl log table.
	'SELECT * FROM audit.etl_master_log' to access the etl master table.

	These tables are very vital for easy monitoring of the etl process, and thus enabling easier
	traceability, and debugging.
======================================================================================================================
*/
CREATE OR ALTER PROCEDURE etl.run_master_pipeline AS
BEGIN
	BEGIN TRY
		-- Declare variables
		DECLARE 
		@run_id UNIQUEIDENTIFIER = NEWID(),
		@start_time DATETIME,
		@end_time DATETIME,
		@tables_expected INT,
		@tables_loaded INT;
		
		-- Map values to variables
		SELECT @tables_expected = COUNT(*) FROM etl.pipeline_control;

		PRINT '==================================================================================';
		PRINT 'ETL Master Pipeline Started';
		PRINT 'Run ID: ' + CAST(@run_id AS NVARCHAR(50));
		SET @start_time = GETDATE();
		PRINT 'Start Time: ' + CAST(@start_time AS NVARCHAR(50));
		PRINT '==================================================================================';

		PRINT '----------------------------------------------------------------------------------';
		PRINT '>> Loading Bronze Layer';
		PRINT '----------------------------------------------------------------------------------';

		PRINT '>> Loading bronze.crm_cust_info';
		EXEC bronze.load_crm_cust_info @run_id;
		PRINT '>> Loading Completed Successfully';

		PRINT '>> Loading bronze.crm_prd_info';
		EXEC bronze.load_crm_prd_info @run_id;
		PRINT '>> Loading Completed Successfully';

		PRINT '>> Loading bronze.crm_sales_details';
		EXEC bronze.load_crm_sales_details @run_id;
		PRINT '>> Loading Completed Successfully';

		PRINT '>> Loading bronze.erp_cust_az12';
		EXEC bronze.load_erp_cust_az12 @run_id;
		PRINT '>> Loading Completed Successfully';

		PRINT '>> Loading bronze.erp_loc_a101';
		EXEC bronze.load_erp_loc_a101 @run_id;
		PRINT '>> Loading Completed Successfully';

		PRINT '>> Loading bronze.erp_px_cat_g1v2';
		EXEC bronze.load_erp_px_cat_g1v2 @run_id;
		PRINT '>> Loading Completed Successfully';

		PRINT '----------------------------------------------------------------------------------';
		PRINT '>> Loading Silver Layer';
		PRINT '----------------------------------------------------------------------------------';

		PRINT '>> Loading silver.crm_cust_info';
		EXEC silver.load_crm_cust_info @run_id;
		PRINT '>> Loading Completed Successfully';

		PRINT '>> Loading silver.crm_prd_info';
		EXEC silver.load_crm_prd_info @run_id;
		PRINT '>> Loading Completed Successfully';

		PRINT '>> Loading silver.crm_sales_details';
		EXEC silver.load_crm_sales_details @run_id;
		PRINT '>> Loading Completed Successfully';

		PRINT '>> Loading silver.erp_cust_az12';
		EXEC silver.load_erp_cust_az12 @run_id;
		PRINT '>> Loading Completed Successfully';

		PRINT '>> Loading silver.erp_loc_a101';
		EXEC silver.load_erp_loc_a101 @run_id;
		PRINT '>> Loading Completed Successfully';

		PRINT '>> Loading silver.erp_px_cat_g1v2';
		EXEC silver.load_erp_px_cat_g1v2 @run_id;
		PRINT '>> Loading Completed Successfully';

		PRINT '==================================================================================';
		PRINT 'ETL Master Pipeline Completed Successfully';
		SET @end_time = GETDATE();
		PRINT 'End Time: ' +  CAST(@end_time AS NVARCHAR(50));
		PRINT 'total_Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR(50)) + ' seconds';
		PRINT '==================================================================================';

		-- Map values to variables
		SELECT @tables_loaded = COUNT(*) FROM audit.etl_log WHERE run_id = @run_id;

		-- Log success
		INSERT INTO audit.etl_master_log
		(
			run_id,
			pipeline_name,
			load_status,
			start_time,
			end_time,
			total_load_duration_seconds,
			tables_expected,
			tables_loaded
		)
		VALUES
		(
			@run_id,
			'run_master_pipeline',
			'Success',
			@start_time,
			@end_time,
			DATEDIFF(second, @start_time, @end_time),
			@tables_expected,
			@tables_loaded
		)
	END TRY

	BEGIN CATCH
		SET @end_time = GETDATE()

		PRINT '==================================================================================';
		PRINT 'ETL Master Pipeline Failed';
		PRINT 'Error Procedure: ' + ERROR_PROCEDURE();
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(50));
		PRINT 'Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR(50));
		PRINT '==================================================================================';

		-- Log any failure with error details
		INSERT INTO audit.etl_master_log
		(
			run_id,
			pipeline_name,
			load_status,
			start_time,
			end_time,
			total_load_duration_seconds,
			error_number,
			error_message,
			error_line
		)
		VALUES
		(
			@run_id,
			'run_master_pipeline',
			'Failure',
			@start_time,
			@end_time,
			DATEDIFF(second, @start_time, @end_time),
			ERROR_NUMBER(),
			ERROR_MESSAGE(),
			ERROR_LINE()
		)
	END CATCH
END;
GO
