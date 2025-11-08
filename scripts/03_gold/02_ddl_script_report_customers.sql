/*
=================================================================================================================
Customer Report
=================================================================================================================

Purpose:
	This report consolidates key customer metrics and behaviours. 
	It highlights the following:
	
	1. Essential fields such as customer name, country, gender, marital status,birth date, and age
	2. Aggregates of metrics at the customer-level:
		* First Order,
		* Last Order,
		* total Orders,
		* total sales,
		* total quantity of products purchased,
		* total number of products (unique), and
		* lifespan in month.
	3. Segments of customers based on their lifespan and revenue generated (VIP, Regular, and New).
	4. Calculate Valuable KPIS:
		* recency (months since last order),
		* average order value (sale per order), and
		* average monthly value (sale per month).
=================================================================================================================
*/
IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
DROP VIEW gold.report_customers;
GO

CREATE VIEW gold.report_customers AS
WITH base_query AS 
/*-------------------------------------------------------------------------------------------
Base Query: Retrieve only core columns from tables
---------------------------------------------------------------------------------------------*/
(
SELECT
	s.order_number,
	s.product_key,
	s.order_date,
	s.sales_amount,
	s.quantity,
	c.customer_key,
	c.customer_number,
	CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
	c.country,
	c.gender,
	c.marital_status,
	c.birth_date,
	DATEDIFF(year, c.birth_date, GETDATE()) AS age,
	c.create_date
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
WHERE s.order_date IS NOT NULL
)
, customer_aggregation AS
/*-------------------------------------------------------------------------------------------
Customer Aggregation: Summarizes key business metrics at customer-level
---------------------------------------------------------------------------------------------*/
(
SELECT
	customer_key,
	customer_number,
	customer_name,
	country,
	gender,
	marital_status,
	birth_date,
	age,
	MIN(order_date) AS first_order_date,
	MAX(order_date) AS last_order_date,
	DATEDIFF(month, MAX(order_date), GETDATE()) AS recency_month,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan_month,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT product_key) AS total_products,
	SUM(sales_amount) AS total_sales
FROM base_query
GROUP BY
	customer_key,
	customer_number,
	customer_name,
	country,
	gender,
	marital_status,
	birth_date,
	age
)
SELECT
	customer_key,
	customer_number,
	customer_name,
	country,
	gender,
	marital_status,
	birth_date,
	age,
	CASE
		WHEN age < 20 THEN 'Below 20'
		WHEN age BETWEEN 20 AND 29 THEN '20-29'
		WHEN age BETWEEN 30 AND 39 THEN '30-39'
		WHEN age BETWEEN 40 AND 49 THEN '40-49'
		WHEN age BETWEEN 50 AND 59 THEN '50-59'
		ELSE 'Above 59'
	END AS age_group,
	first_order_date,
	last_order_date,
	recency_month,
	CASE
		WHEN lifespan_month >= 12 AND total_sales > 5000 THEN 'VIP'
		WHEN lifespan_month >= 12 AND total_sales <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_status,
	total_orders,
	total_quantity,
	total_products,
	total_sales,
	lifespan_month,
	CASE
		WHEN total_orders = 0 THEN 0
		ELSE total_sales/total_orders
	END AS avg_order_value,
	CASE
		WHEN lifespan_month = 0 THEN total_sales
		ELSE total_sales/lifespan_month
	END AS avg_monthly_spend
FROM customer_aggregation
