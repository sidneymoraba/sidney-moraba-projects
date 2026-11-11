USE coffee_shop;

-- 1. Best-selling products
SELECT p.name, SUM(oi.quantity) AS units_sold, SUM(oi.quantity * oi.unit_price) AS revenue
FROM order_items oi JOIN products p ON p.product_id = oi.product_id
GROUP BY p.product_id, p.name ORDER BY units_sold DESC;

-- 2. Revenue per day
SELECT * FROM v_daily_sales ORDER BY sale_date;

-- 3. Customer spending (top customers first)
SELECT c.full_name, COUNT(DISTINCT t.order_id) AS orders, SUM(t.order_total) AS total_spent
FROM customers c JOIN v_order_totals t ON t.customer_id = c.customer_id
WHERE t.status <> 'cancelled'
GROUP BY c.customer_id, c.full_name ORDER BY total_spent DESC;

-- 4. Orders that are not fully paid
SELECT t.order_id, t.order_total, COALESCE(SUM(pay.amount),0) AS paid,
       t.order_total - COALESCE(SUM(pay.amount),0) AS outstanding
FROM v_order_totals t LEFT JOIN payments pay ON pay.order_id = t.order_id
GROUP BY t.order_id, t.order_total
HAVING outstanding > 0;

-- 5. Products running low on stock
SELECT name, stock_qty FROM products WHERE stock_qty < 35 AND is_active ORDER BY stock_qty;
