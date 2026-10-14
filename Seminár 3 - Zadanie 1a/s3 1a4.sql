CREATE INDEX idx_orders_customer_id
ON orders (customer_id);

SELECT *
FROM orders
WHERE customer_id = 'C001';

EXPLAIN ANALYZE
SELECT *
FROM orders
WHERE customer_id = 'C001';