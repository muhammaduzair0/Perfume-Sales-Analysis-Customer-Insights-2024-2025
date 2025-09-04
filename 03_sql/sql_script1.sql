-- What is our total revenue and order count?
SELECT
	CAST(SUM(p.price * o.quantity) AS UNSIGNED) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders
    
FROM orders o
JOIN products p ON o.product_id = p.product_id
WHERE o.returned = 'N';
    
-- What is our AOV?
SELECT
	CAST(SUM(p.price * o.quantity) / COUNT(DISTINCT o.order_id) AS UNSIGNED) AS average_order_value
    FROM orders o
    JOIN products p ON o.product_id = p.product_id
    WHERE o.returned = 'N';
    
-- What is the monthly sales trend?
SELECT
	DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
    SUM(p.price * o.quantity) AS monthly_revenue
    FROM orders o
    JOIN products p ON o.product_id = p.product_id
    WHERE o.returned = 'N'
    GROUP BY order_month
    ORDER BY order_month;
    
-- Which cities generate the most revenue?
SELECT
	o.city,
    SUM(p.price * o.quantity) AS city_revenue
    FROM orders o
    JOIN products p ON o.product_id = p.product_id
    WHERE o.returned = 'N'
    GROUP BY o.city
    ORDER BY city_revenue DESC
    LIMIT 5;
    
-- What are our best-selling perfumes?
SELECT
	p.perfume_name,
    SUM(p.price * o.quantity) AS product_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
WHERE o.returned = "N"
GROUP BY p.perfume_name
ORDER BY product_revenue DESC
LIMIT 10;

-- How effective are our sales channels?
SELECT
	o.channel,
    SUM(p.price * o.quantity) AS channel_revenue,
    COUNT(DISTINCT o.order_id) AS number_of_orders
FROM orders o 
JOIN products p ON o.product_id = p.product_id
WHERE o.returned = "N"
GROUP BY o.channel
ORDER BY channel_revenue DESC;

-- What percentage of customers are repeat buyers?
WITH CustomerOrderCounts AS (
	SELECT 
		customer_id,
		COUNT(DISTINCT order_id) AS order_count
    FROM orders
    WHERE returned = 'N'
    GROUP BY customer_id
)
SELECT
	CASE
		WHEN order_count > 1 THEN 'Repeat Customer'
        ELSE 'New Customer'
	END AS customer_type,
    COUNT(customer_id) AS number_of_customers
FROM CustomerOrderCounts
GROUP BY customer_type;

-- What is the overall product return rate?
SELECT
	SUM(CASE WHEN returned = 'Y' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS return_rate_percent
FROM orders;

-- This shows cumulative growth over time.
WITH MonthlyRevenue AS (
	SELECT
		DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
        SUM(p.price * o.quantity) AS monthly_revenue
	FROM orders o
    JOIN products p ON o.product_id = p.product_id
    WHERE o.returned = 'N'
    GROUP BY order_month
)
SELECT
	order_month,
    monthly_revenue,
    SUM(monthly_revenue) OVER (ORDER BY order_month) AS running_total_revenue 
FROM MonthlyRevenue;

-- This helps identify the top performer in each category (Men, Women, etc.).
WITH ProductRevenue AS (
	SELECT
		p.category,
        p.perfume_name,
        SUM(p.price * o.quantity) AS total_revenue
	FROM orders o
	JOIN products p ON o.product_id = p.product_id
	WHERE o.returned = "N"
	GROUP BY p.category, p.perfume_name
)
SELECT
	category,
    perfume_name,
    total_revenue,
    RANK() OVER (PARTITION BY category ORDER BY total_revenue DESC) AS  rank_in_category
    FROM ProductRevenue;