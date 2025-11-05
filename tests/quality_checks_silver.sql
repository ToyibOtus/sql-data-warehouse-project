/*
===============================================================================================
Quality Checks
===============================================================================================
Script Purpose:
	This script performs data quality checks across the 'silver' tables.
	It performs the follwing checks:
	* Nulls and duplicate checks.
	* Unwanted spaces in string fields.
	* Data standardization & consistency.
	* Invalid date values, and ranges
	* Data consistency between/among related fields

Usage Notes:
	* Run after loading the silver layer
	* Investigate and resolve any discrepancies during checks
===============================================================================================
*/

-- ===========================================================
-- Checking silver.crm_cust_info
-- ===========================================================

-- Checking For Duplicates and Nulls in Primary Key
-- Expectation: No Results
SELECT
	cst_id,
	COUNT(*) duplicate_check
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Checking For Unwanted Spaces in String Fields
-- Expectation: No Results
SELECT
	cst_key
FROM silver.crm_cust_info
WHERE cst_key <> TRIM(cst_key);

SELECT
	cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname <> TRIM(cst_firstname);

SELECT
	cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname <> TRIM(cst_lastname);

-- Data Standardization and Consistency
-- Expectation: User Friendly Values, and No Nulls
SELECT DISTINCT
	cst_maritalstatus
FROM silver.crm_cust_info;

SELECT DISTINCT
	cst_gndr
FROM silver.crm_cust_info;

-- ===========================================================
-- Checking silver.crm_prd_info
-- ===========================================================

-- Checking For Duplicates and Nulls in Primary Key
-- Expectation: No Results
SELECT
	prd_id,
	COUNT(*) duplicate_check
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Checking For Unwanted Spaces in String Fields
-- Expectation: No Results
SELECT
	prd_nm
FROM silver.crm_prd_info
WHERE prd_nm <> TRIM(prd_nm);

-- Checking For Invalid prd_costs (Nulls and Negatives)
--Expectation: No Results
SELECT
	prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Data Standardization and Consistency
-- Expectation: User Friendly Values, and No Nulls
SELECT DISTINCT
	prd_line
FROM silver.crm_prd_info;

-- Checking For Invalid Dates
-- Expectation: No Results
SELECT
	prd_start_dt,
	prd_end_dt
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- ===========================================================
-- Checking silver.crm_sales_details
-- ===========================================================

-- Checking For Unwanted Spaces in String Fields
-- Expectation: No Results
SELECT
	sls_ord_num
FROM silver.crm_sales_details
WHERE sls_ord_num <> TRIM(sls_ord_num);

SELECT
	sls_prd_key
FROM silver.crm_sales_details
WHERE sls_prd_key <> TRIM(sls_prd_key);

-- --------------------------------------------------------
-- Checking Invalid Dates
-- --------------------------------------------------------

-- Expectation: DATE Data Type
SELECT
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt
FROM silver.crm_sales_details;

-- Expectation: No Result
SELECT
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
OR sls_order_dt > sls_due_dt;

-- Checking For Invalid Values(Negatives, Zeros, or Nulls) In Sales, Quantity, and Price
-- Checking For Consistency Between Sales, Quantity, and Price 
-- Expectation: No Result

SELECT
	sls_sales,
	sls_quantity,
	sls_price
FROM silver.crm_sales_details
WHERE  sls_sales <> sls_quantity * sls_price 
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- ===========================================================
-- Checking silver.erp_cust_az12
-- ===========================================================

-- Checking For Unwanted Spaces in String Fields
-- Expectation: No Results
SELECT
	cid
FROM silver.erp_cust_az12
WHERE cid <> TRIM(cid);

-- Checking For Invalid bdate
-- Expectation: No Results
SELECT
	bdate
FROM silver.erp_cust_az12
WHERE bdate > GETDATE();

-- Data Standardization and Consistency
-- Expectation: User Friendly Values and No Nulls
SELECT DISTINCT
	gen
FROM silver.erp_cust_az12;

-- ===========================================================
-- Checking silver.erp_loc_a101
-- ===========================================================

-- Checking For Duplicates and Nulls
-- Expectation: No Results
SELECT
	cid,
	COUNT(*) duplicate_check
FROM silver.erp_loc_a101
GROUP BY cid
HAVING COUNT(*) > 1 OR cid IS NULL;

-- Checking For Unwanted Spaces in String Fields
-- Expectation: No Results
SELECT
	cid
FROM silver.erp_loc_a101
WHERE cid <> TRIM(cid);

-- Data Standardization and Consistency
-- Expectation: User Friendly Values and No Nulls
SELECT DISTINCT
	cntry
FROM silver.erp_loc_a101;

-- ===========================================================
-- Checking silver.erp_px_cat_g1v2
-- ===========================================================
-- Checking For Duplicates and Nulls in Primary Key
-- Expectation: No Results
SELECT
	id,
	COUNT(*) duplicate_check
FROM silver.erp_px_cat_g1v2
GROUP BY id
HAVING COUNT(*) > 1 OR id IS NULL;

-- Checking For Unwanted Spaces in String Fields
-- Expectation: No Results
SELECT
	cat
FROM silver.erp_px_cat_g1v2
WHERE cat <> TRIM(cat);

SELECT
	subcate
FROM silver.erp_px_cat_g1v2
WHERE subcate <> TRIM(subcate);

SELECT
	maintenance
FROM silver.erp_px_cat_g1v2
WHERE maintenance <> TRIM(maintenance);

-- Data Standardization and Consistency
-- Expectation: User Friendly Values and No Nulls
SELECT DISTINCT
	cat
FROM silver.erp_px_cat_g1v2;

SELECT DISTINCT
	subcate
FROM silver.erp_px_cat_g1v2;

SELECT DISTINCT
	maintenance
FROM silver.erp_px_cat_g1v2;
