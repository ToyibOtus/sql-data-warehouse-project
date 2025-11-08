/*
=================================================================================================================
Product Report
=================================================================================================================

Purpose:
	This report consolidates key product metrics and behaviours. 
	It highlights the following:
	
	1. Essential fields such as product name, product line, category, subcategory, and cost.
	2. Aggregates of metrics at the product-level:
		* total Orders,
		* total sales,
		* total quantity of products purchased,
		* total number of customers (unique), and
		* lifespan in month.
	3. Segments of products based on their revenue to identify High-Performers, Mid-Range, and Low-Performers.
	4. Calculate Valuable KPIS:
		* recency (months since last sale),
		* average order revenue (sale per order), and
		* average monthly revenue (sale per month).
=================================================================================================================
*/
IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
DROP VIEW 'gold.report_products';
GO

CREATE VIEW gold.report_products AS
WITH base_query AS
/*-------------------------------------------------------------------------------------------
Base Query: Retrieve core columns from tables
---------------------------------------------------------------------------------------------*/
(
SELECT
	s.order_number,
	s.customer_key,
	s.order_date,
	s.sales_amount,
	s.quantity,
	s.price,
	p.product_key,
	p.product_number,
	p.product_name,
	p.product_line,
	p.category_id,
	p.category,
	p.subcategory,
	p.maintenance,
	p.product_cost
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
WHERE s.order_date IS NOT NULL
)
, product_aggregation AS
/*-------------------------------------------------------------------------------------------
Product Aggregation: Summarizes key business metrics at product-level
---------------------------------------------------------------------------------------------*/
(
SELECT
	product_key,
	product_number,
	product_name,
	product_line,
	category_id,
	category,
	subcategory,
	maintenance,
	product_cost,
	AVG(price) AS avg_selling_price,
	MAX(order_date) AS last_order_date,
	DATEDIFF(month, MAX(order_date), GETDATE()) AS recency_month,
	COUNT(DISTINCT order_number) AS total_orders,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity,
	SUM(sales_amount) AS total_sales,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan_month
FROM base_query
GROUP BY
	product_key,
	product_number,
	product_name,
	product_line,
	category_id,
	category,
	subcategory,
	maintenance,
	product_cost
)
SELECT
	product_key,
	product_number,
	product_name,
	product_line,
	category_id,
	category,
	subcategory,
	maintenance,
	product_cost,
	avg_selling_price,
	last_order_date,
	recency_month,
	total_orders,
	total_customers,
	total_quantity,
	total_sales,
	lifespan_month,
	CASE
		WHEN total_sales > 250000 THEN 'High Performer'
		WHEN total_sales BETWEEN 100000 AND 250000 THEN 'Mid Range'
		ELSE 'Low Performer'
	END AS product_status,
	CASE 
		WHEN total_orders = 0 THEN 0
		ELSE total_sales/total_orders
	END AS avg_order_revenue,
	CASE
		WHEN lifespan_month = 0 THEN total_sales
		ELSE total_sales/lifespan_month
	END AS avg_monthly_revenue
FROM product_aggregation
