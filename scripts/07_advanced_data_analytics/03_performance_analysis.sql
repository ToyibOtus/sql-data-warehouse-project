/*
==============================================================================================
Performance Analysis
==============================================================================================
Script Purpose:
	This script checks the performance of each product line by comparing its yearly sales
	with its average and previous yearly sales. Additionally, It also checks the over all 
	performance and growth of the business, by measuring how much it progresses relative
	to its previous year.
==============================================================================================
*/
-- What is the yearly performance of each product line based on its average yearly sales? 
SELECT
	yearly_orders,
	product_line,
	current_sales_year,
	avg_sales_year,
	diff_avg,
	percent_dev_avg,
	CASE
		WHEN diff_avg > 0 THEN 'Above Average'
		WHEN diff_avg < 0 THEN 'Below Average'
		ELSE 'Equal to Average'
	END current_sales_status
FROM
(
	SELECT
		yearly_orders,
		product_line,
		current_sales_year,
		avg_sales_year,
		current_sales_year - avg_sales_year diff_avg,
		FORMAT(CAST((current_sales_year - avg_sales_year) AS FLOAT)/avg_sales_year, 'P') percent_dev_avg
	FROM
	(
		SELECT
			YEAR(s.order_date) yearly_orders,
			p.product_line,
			SUM(s.sales_amount) current_sales_year,
			AVG(SUM(s.sales_amount)) OVER(PARTITION BY p.product_line) avg_sales_year
			FROM gold.fact_sales s
		LEFT JOIN gold.dim_products p
		ON s.product_key = p.product_key
		WHERE order_date IS NOT NULL AND order_date NOT BETWEEN '2010-01-01' AND '2010-12-31'
		GROUP BY YEAR(s.order_date), p.product_line
	)SUB1
)SUB2
ORDER BY product_line, yearly_orders;

-- What is the yearly performance of each product line based on its previous yearly sales? 
SELECT
	yearly_orders,
	product_line,
	current_sales_year,
	previous_sales_year,
	diff_psy,
	percent_dev_psy,
	CASE
		WHEN diff_psy > 0 THEN 'Above Previous Year Sales'
		WHEN diff_psy < 0 THEN 'Below Previous Year Sales'
		ELSE 'No Change'
	END current_sales_status
FROM
(
	SELECT
		yearly_orders,
		product_line,
		current_sales_year,
		previous_sales_year,
		current_sales_year - previous_sales_year diff_psy,
		FORMAT(CAST((current_sales_year - previous_sales_year) AS FLOAT)/previous_sales_year, 'P') percent_dev_psy
	FROM
	(
		SELECT
			YEAR(s.order_date) yearly_orders,
			p.product_line,
			SUM(s.sales_amount) current_sales_year,
			LAG(SUM(s.sales_amount)) OVER(PARTITION BY p.product_line ORDER BY YEAR(s.order_date)) previous_sales_year
		FROM gold.fact_sales s
		LEFT JOIN gold.dim_products p
		ON s.product_key = p.product_key
		WHERE order_date IS NOT NULL AND order_date NOT BETWEEN '2010-01-01' AND '2010-12-31'
		GROUP BY YEAR(s.order_date), p.product_line
	)SUB1
)SUB2
ORDER BY product_line, yearly_orders;

-- What is the yearly progressive growth of the business realative to its previous year?
SELECT
	yearly_orders,
	running_total_sales,
	LAG(running_total_sales) OVER(ORDER BY yearly_orders) previous_sales,
	running_total_sales - LAG(running_total_sales) OVER(ORDER BY yearly_orders) sales_diff,
	FORMAT(CAST((running_total_sales - LAG(running_total_sales) OVER(ORDER BY yearly_orders)) AS FLOAT)/
	LAG(running_total_sales) OVER(ORDER BY yearly_orders), 'P') percent_sales_diff
FROM
(
	SELECT
		yearly_orders,
		total_sales,
		SUM(total_sales) OVER(ORDER BY yearly_orders) running_total_sales
	FROM
	(
		SELECT
			YEAR(order_date) yearly_orders,
			SUM(sales_amount) total_sales
		FROM gold.fact_sales 
		WHERE order_date IS NOT NULL AND order_date NOT BETWEEN '2010-01-01' AND '2010-12-31'
		GROUP BY YEAR(order_date)
	)SUB1
)SUB2
