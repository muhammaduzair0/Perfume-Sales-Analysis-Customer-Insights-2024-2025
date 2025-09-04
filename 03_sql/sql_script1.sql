-- What is our total revenue and order count?
SELECT
	CAST(SUM(p.price * o.quantity) AS UNSIGNED) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders
    
FROM orders o
JOIN products p ON o.product_id = p.product_id
WHERE o.returned = 'N';
    
