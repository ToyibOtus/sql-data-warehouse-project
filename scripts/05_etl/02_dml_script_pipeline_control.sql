/*
======================================================================================================
DML Script: Populate Pipeline Control Table
======================================================================================================
Script Purpose:
    Populates the 'etl.pipeline_control' table with metadata for all ETL procedures 
    across the Bronze and Silver layers, defining their execution order within the master pipeline.

    Run this script after creating 'etl.pipeline_control' to seed it with ETL metadata.
======================================================================================================
*/
INSERT INTO etl.pipeline_control
VALUES
('bronze', 'bronze.load_crm_cust_info', 1),
('bronze', 'bronze.load_crm_prd_info', 2),
('bronze', 'bronze.load_crm_sales_details', 3),
('bronze', 'bronze.load_erp_cust_az12', 4),
('bronze', 'bronze.load_erp_loc_a101', 5),
('bronze', 'bronze.load_erp_px_cat_g1v2', 6),
('silver', 'silver.load_crm_cust_info', 7),
('silver', 'silver.load_crm_prd_info', 8),
('silver', 'silver.load_crm_sales_details', 9),
('silver', 'silver.load_erp_cust_az12', 10),
('silver', 'silver.load_erp_loc_a101', 11),
('silver', 'silver.load_erp_px_cat_g1v2', 12);
