CREATE INDEX idx_orders_region_category
ON orders (customer_id, order_date);

SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.profit
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.region = 'West'
  AND o.order_date >= '2024-01-01'
ORDER BY o.order_date;