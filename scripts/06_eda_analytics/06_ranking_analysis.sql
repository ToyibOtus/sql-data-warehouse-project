/*
=========================================================================================
Ranking Analysis
=========================================================================================
Script Purpose:
	This script reveals our top performing categories, customers and products alike
	based on various metrics such as total sales and orders made.
=========================================================================================
*/
-- Who are our top 5 customers based on total revenue generated?
SELECT
*
FROM
(
SELECT
	c.customer_key,
	c.first_name,
	c.last_name,
	SUM(s.sales_amount) total_sales,
	DENSE_RANK() OVER(ORDER BY SUM(s.sales_amount) DESC) rank_customers
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_customers c
	ON s.customer_key = c.customer_key
GROUP BY 
	c.customer_key,
	c.first_name,
	c.last_name
)SUB
WHERE rank_customers <= 5

-- Who are our top 5 customers based on total number of orders made?
SELECT
*
FROM
(
SELECT
	c.customer_key,
	c.first_name,
	c.last_name,
	COUNT(s.order_number) total_orders,
	DENSE_RANK() OVER(ORDER BY COUNT(s.order_number) DESC) rank_customers
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_customers c
	ON s.customer_key = c.customer_key
GROUP BY 
	c.customer_key,
	c.first_name,
	c.last_name
)SUB
WHERE rank_customers <= 5

-- What are the top 3 countries based on total revenue generated?
SELECT
*
FROM
(
SELECT
	c.country,
	SUM(s.sales_amount) total_quantity,
	DENSE_RANK() OVER(ORDER BY SUM(s.sales_amount) DESC) rank_customers
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_customers c
	ON s.customer_key = c.customer_key
GROUP BY c.country
)SUB
WHERE rank_customers <= 3

-- What are the top 3 countries with the highest amount of orders?
SELECT
*
FROM
(
SELECT
	c.country,
	COUNT(DISTINCT s.order_number) total_orders,
	DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT s.order_number) DESC) rank_customers
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_customers c
	ON s.customer_key = c.customer_key
GROUP BY c.country
)SUB
WHERE rank_customers <= 3

-- What are the top 3 product lines that generate the higest revenues
SELECT
*
FROM
(
SELECT
	p.product_line,
	SUM(s.sales_amount) total_sales,
	DENSE_RANK() OVER(ORDER BY SUM(s.sales_amount)  DESC) rank_customers
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_products p
	ON s.product_key = p.product_key
GROUP BY p.product_line
)SUB
WHERE rank_customers <= 3

-- Within each product line, what is the top category of products that brings the highest revenue?
SELECT
*
FROM
(
SELECT
	p.product_line,
	p.category,
	SUM(s.sales_amount) total_sales,
	DENSE_RANK() OVER(PARTITION BY p.product_line ORDER BY SUM(s.sales_amount)  DESC) rank_customers
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_products p
	ON s.product_key = p.product_key
GROUP BY p.product_line, p.category
)SUB
WHERE rank_customers = 1;

-- What are the top 3 subcategories within each category and product line that bring in the most revenue?
SELECT
*
FROM
(
SELECT
	p.product_line,
	p.category,
	p.subcategory,
	SUM(s.sales_amount) total_sales,
	DENSE_RANK() OVER(PARTITION BY p.product_line, p.category ORDER BY SUM(s.sales_amount)  DESC) rank_customers
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_products p
	ON s.product_key = p.product_key
GROUP BY p.product_line, p.category, p.subcategory
)SUB
WHERE rank_customers <= 3;
