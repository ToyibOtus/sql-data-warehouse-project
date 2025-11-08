/*
===============================================================================
Change Over Time Analysis (Trend)
===============================================================================
Script Purpose:
	This script reveals how key business metrics such total sales, orders,
	quantity etc. trend over time.
===============================================================================
*/
-- Year-Over-Year Analysis (Are sales increasing by the year?)
SELECT
	YEAR(s.order_date) yearly_orders,
	COUNT(DISTINCT s.order_number) total_orders,
	SUM(s.quantity) total_quantity,
	SUM(s.sales_amount) total_sales,
	AVG(s.price) avg_selling_price,
	AVG(p.product_cost) avg_product_cost,
	SUM(s.price - p.product_cost) estimated_total_profit
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY yearly_orders;

-- Month-Over-Month Analysis (Are sales Increasing by the months)
SELECT
	DATETRUNC(month, s.order_date) order_date_month,
	COUNT(DISTINCT s.order_number) total_orders,
	SUM(s.quantity) total_quantity,
	SUM(s.sales_amount) total_sales,
	AVG(s.price) avg_selling_price,
	AVG(p.product_cost) avg_product_cost,
	SUM(s.price - p.product_cost) estimated_total_profit
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, s.order_date)
ORDER BY order_date_month;
