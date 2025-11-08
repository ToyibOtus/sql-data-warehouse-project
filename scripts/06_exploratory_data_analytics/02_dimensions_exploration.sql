/*
====================================================================
Explore Dimension in each table
====================================================================
Script Purpose:
	This script explores all unique dimensions in both tables, 
	'gold.dim_customers', and 'gold.dim_products'.
====================================================================
*/
-- Explore table customers
SELECT DISTINCT country FROM gold.dim_customers;
SELECT DISTINCT gender FROM gold.dim_customers;
SELECT DISTINCT marital_status FROM gold.dim_customers;

-- Explore table products
SELECT DISTINCT category, subcategory, product_name FROM gold.dim_products;
SELECT DISTINCT product_line, category, subcategory FROM gold.dim_products;
