/*
========================================================================
Measures Exploration (Key Business Metrics)
========================================================================
Script Purpose:
	This script reveals vital business metrics. It also consolidates
	these metrics into a single report.
========================================================================
*/
-- What is the total revenue generated?
SELECT SUM(sales_amount) total_sales FROM gold.fact_sales;

-- What is the total quantity of products sold?
SELECT SUM(quantity) total_quantity FROM gold.fact_sales;

-- What is the average selling price?
SELECT AVG(price) avg_selling_price FROM gold.fact_sales;

-- What is the average product cost?
SELECT AVG(product_cost) avg_product_cost FROM gold.dim_products;

-- What is the total number of orders made?
SELECT COUNT (DISTINCT order_number) total_orders FROM gold.fact_sales;

-- What is the total number of customers?
SELECT COUNT(customer_key) total_customers FROM gold.dim_customers;

-- How many of these customers have patronized us?
SELECT COUNT(DISTINCT customer_key) total_customers_ordered FROM gold.fact_sales;

-- What is the total number of products purchased by the organization?
SELECT COUNT(product_key) total_products FROM gold.dim_products;

-- How many of these products have been sold?
SELECT COUNT(DISTINCT product_key) total_products_sold FROM gold.fact_sales;

-- Generate a report showcasing all of these business metrics
SELECT 'Total Sales' measure_name, SUM(sales_amount) measure_value FROM gold.fact_sales
UNION
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION
SELECT 'Avg Selling Price', AVG(price) FROM gold.fact_sales
UNION
SELECT 'Avg Product Cost', AVG(product_cost) FROM gold.dim_products
UNION
SELECT 'Total Nr. Order', COUNT (DISTINCT order_number)FROM gold.fact_sales
UNION
SELECT 'Total Nr. Customers', COUNT(customer_key) FROM gold.dim_customers
UNION
SELECT 'Total Nr. Customers Ordered', COUNT(DISTINCT customer_key) FROM gold.fact_sales
UNION
SELECT 'Total Nr. Products', COUNT(product_key) FROM gold.dim_products
UNION
SELECT 'Total Nr. Products Sold', COUNT(DISTINCT product_key) FROM gold.fact_sales;
