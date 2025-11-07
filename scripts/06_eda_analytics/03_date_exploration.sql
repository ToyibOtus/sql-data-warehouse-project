/*
==============================================================================
Date Exploration
==============================================================================
Script Purpose:
	This script reveals the scope and timespan of the data present in 
	'gold.fact_sales' and 'gold.dim_products'. Additionally, it reveals
	the age range of our customers.
==============================================================================
*/
-- Identify the timespan in fact table 'sales'
SELECT
MIN(order_date) first_order_date,
MAX(order_date) last_order_date,
DATEDIFF(year, MIN(order_date), MAX(order_date)) date_range_yrs
FROM gold.fact_sales;

-- Identify the timespan in table 'products'
SELECT
MIN(start_date) first_start_date,
MAX(start_date) last_start_date,
DATEDIFF(year, MIN(start_date), MAX(start_date)) date_range_yrs
FROM gold.dim_products;

-- Identify our youngest and oldest customers
SELECT
MAX(birth_date) youngest_bdate,
MIN(birth_date) oldest_bdate,
DATEDIFF(year, MAX(birth_date), GETDATE()) age_youngest,
DATEDIFF(year, MIN(birth_date), GETDATE()) age_oldest
FROM gold.dim_customers;
