/*
==========================================================================================
Part-to-Whole-Analysis
==========================================================================================
Script Purpose:	
	This script finds the percentage distribution of total sales across important
	dimensions such as country, product line, and monthly orders.
==========================================================================================
*/
-- What is the percentage distribution of sales across countries?
SELECT
	country,
	sales_by_country,
	SUM(sales_by_country) OVER() total_sales,
	FORMAT(CAST(sales_by_country AS FLOAT)/SUM(sales_by_country) OVER(), 'P') percent_sales_dist
FROM
(
	SELECT
		c.country,
		SUM(s.sales_amount) sales_by_country
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_customers c
	ON s.customer_key = c.customer_key
	GROUP BY c.country
)SUB
ORDER BY sales_by_country DESC;

-- Are sales evenly distributed across product line?
SELECT
	product_line,
	sales_by_product_line,
	SUM(sales_by_product_line) OVER() total_sales,
	FORMAT(CAST(sales_by_product_line AS FLOAT)/SUM(sales_by_product_line) OVER(), 'P') percent_sales_dist
FROM
(
	SELECT
		p.product_line,
		SUM(s.sales_amount) sales_by_product_line
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_products p
	ON s.product_key = p.product_key
	GROUP BY p.product_line
)SUB
ORDER BY sales_by_product_line DESC;

-- Is there a pattern in the percentage distribution across the months of every year? 
SELECT
	order_date_month,
	sales_by_month,
	SUM(sales_by_month) OVER(PARTITION BY YEAR(order_date_month)) sales_by_year,
	FORMAT(CAST(sales_by_month AS FLOAT)/SUM(sales_by_month) OVER(PARTITION BY YEAR(order_date_month)), 'P') percent_sales_dist
FROM
(
	SELECT
		DATETRUNC(month,order_date) order_date_month,
		SUM(sales_amount) sales_by_month
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(month,order_date)
)SUB
ORDER BY YEAR(order_date_month), sales_by_month DESC;
