/*
=============================================================================================
Quality Checks
=============================================================================================
Script Purpose:
	This script performs data quality checks on the gold layer.
	It performs the following data quality checks:
	* Checks for uniqueness of surrogate keys in dimension tables
	* Referential integrity between fact and dimension tables
	* Validation of relationships in data model for analytical purposes

Usage Rules:
	* Run these checks after creating the gold layer (views)
	* Investigate and resolve any discrepancies found the checks
=============================================================================================
*/

-- ==========================================================================================
-- Checking 'gold.dim_customers'
-- ==========================================================================================
-- Checking For Uniqueness of 'customer_key' in 'gold.dim_customers'
-- Expectation: No Results
SELECT
	customer_key,
	COUNT(*) duplicate_check
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ==========================================================================================
-- Checking 'gold.dim_products'
-- ==========================================================================================
-- Checking For Uniqueness of 'product_key' in 'gold.dim_products'
-- Expectation: No Results
SELECT
	product_key,
	COUNT(*) duplicate_check
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ==========================================================================================
-- Checking 'gold.fact_sales'
-- ==========================================================================================
-- Checking Connectivity Between Fact Table and Dimension Tables
SELECT 
* 
FROM gold.fact_sales s 
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL;
