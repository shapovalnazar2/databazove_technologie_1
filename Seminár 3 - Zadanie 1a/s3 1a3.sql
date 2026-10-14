CREATE OR REPLACE VIEW analyst_orders AS
SELECT
    order_id,
    customer_id,
    product_id,
    sales,
    quantity,
    discount
FROM orders;

SELECT profit FROM orders;