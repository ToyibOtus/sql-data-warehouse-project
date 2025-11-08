/*
=============================================================================
 Cumulative Analysis
=============================================================================
Script Purpose:
	This script reveals how the business progresses over time through
	key business metrics such as running totals & moving averages.
=============================================================================
*/
-- Year-Over-Year Analysis (Running Totals & Moving Averages)?
SELECT
	yearly_orders,
	SUM(total_orders) OVER(ORDER BY yearly_orders) running_total_orders,
	SUM(total_quantity) OVER(ORDER BY yearly_orders) running_total_quantity,
	SUM(total_sales) OVER(ORDER BY yearly_orders) running_total_sales,
	AVG(avg_selling_price) OVER(ORDER BY yearly_orders) moving_avg_price,
	AVG(avg_product_cost) OVER(ORDER BY yearly_orders) moving_avg_product_cost,
	SUM(estimated_total_profit) OVER(ORDER BY yearly_orders) running_total_estimated_profit
FROM
(
	SELECT
		YEAR(order_date) yearly_orders,
		COUNT(DISTINCT order_number) total_orders,
		SUM(quantity) total_quantity,
		SUM(sales_amount) total_sales,
		AVG(price) avg_selling_price,
		AVG(p.product_cost) avg_product_cost,
		SUM(s.price - p.product_cost) estimated_total_profit
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_products p
	ON s.product_key = p.product_key
	WHERE order_date IS NOT NULL
	GROUP BY YEAR(order_date)
)SUB;

-- Month-Over-Month Analysis (Running Totals & Moving Averages)
SELECT
	order_date_month,
	SUM(total_orders) OVER(PARTITION BY YEAR(order_date_month) ORDER BY order_date_month) running_total_orders,
	SUM(total_quantity) OVER(PARTITION BY YEAR(order_date_month) ORDER BY order_date_month) running_total_quantity,
	SUM(total_sales) OVER(PARTITION BY YEAR(order_date_month) ORDER BY order_date_month) running_total_sales,
	AVG(avg_selling_price) OVER(PARTITION BY YEAR(order_date_month) ORDER BY order_date_month) moving_avg_price,
	AVG(avg_product_cost) OVER(PARTITION BY YEAR(order_date_month) ORDER BY order_date_month) moving_avg_product_cost,
	SUM(estimated_total_profit) OVER(PARTITION BY YEAR(order_date_month) ORDER BY order_date_month) running_total_estimated_profit
FROM
(
	SELECT
		DATETRUNC(month, order_date) order_date_month,
		COUNT(DISTINCT order_number) total_orders,
		SUM(quantity) total_quantity,
		SUM(sales_amount) total_sales,
		AVG(price) avg_selling_price,
		AVG(p.product_cost) avg_product_cost,
		SUM(s.price - p.product_cost) estimated_total_profit
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_products p
	ON s.product_key = p.product_key
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(month, order_date)
)SUB;
