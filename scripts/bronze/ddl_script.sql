/*
=======================================================================================================
DDL Script: Create bronze tables
=======================================================================================================
Script Purpose:
	This script checks the existence of the followning tables:
		* crm_cust_info,
		* crm_prd_info,
		* crm_sales_details
		* erp_cust_az12,
		* erp_loc_a101, and
		* erp_px_cat_g1v2,
	deletes them if they exist, and recreates them.

	Run this script to redefine the structure of your 'bronze' tables
=======================================================================================================
*/
USE Datawarehouse;
GO

-- Drop bronze table 'bronze.crm_cust_info' if it exists
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
DROP TABLE bronze.crm_cust_info;
GO
-- Create bronze table 'bronze.crm_cust_info'
CREATE TABLE bronze.crm_cust_info
(
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_first_name NVARCHAR(50),
	cst_last_name NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE
);

-- Drop bronze table 'bronze.crm_prd_info' if it exists
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
DROP TABLE bronze.crm_prd_info;
GO
-- Create bronze table 'bronze.crm_prd_info'
CREATE TABLE bronze.crm_prd_info
(
	prd_id INT,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE
);

-- Drop bronze table 'bronze.crm_sales_details' if it exists
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
DROP TABLE bronze.crm_sales_details;
GO
-- Create bronze table 'bronze.crm_sales_details'
CREATE TABLE bronze.crm_sales_details
(
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_date INT,
	sls_due_date INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
);

-- Drop bronze table 'bronze.erp_cust_az12' if it exists
IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
DROP TABLE bronze.erp_cust_az12;
GO
-- Create bronze table 'bronze.erp_cust_az12'
CREATE TABLE bronze.erp_cust_az12
(
	cid NVARCHAR(50),
	bdate DATE,
	gen NVARCHAR(50)
);

-- Drop bronze table 'bronze.erp_loc_a101' if it exists
IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
DROP TABLE bronze.erp_loc_a101;
GO
-- Create bronze table 'bronze.erp_loc_a101'
CREATE TABLE bronze.erp_loc_a101
(
	cid NVARCHAR(50),
	cntry NVARCHAR(50)
);

-- Drop bronze table 'bronze.erp_px_cat_g1v2' if it exists
IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
DROP TABLE bronze.erp_px_cat_g1v2;
GO
-- Create bronze table 'bronze.erp_px_cat_g1v2'
CREATE TABLE bronze.erp_px_cat_g1v2
(
	id NVARCHAR(50),
	cat NVARCHAR(50),
	subcat NVARCHAR(50),
	maintenance NVARCHAR(50)
);
