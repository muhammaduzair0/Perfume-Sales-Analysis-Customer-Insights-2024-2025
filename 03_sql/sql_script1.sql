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

