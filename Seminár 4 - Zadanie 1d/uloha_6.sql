
WITH customer_orders AS (
    SELECT
        c.customer_id,
        c.customer_name,
        o.order_date,
        MAX(o.order_date) OVER (
            PARTITION BY c.customer_id
        ) AS last_order_date,
        MAX(o.order_date) OVER () AS latest_order_date
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
),
inactive_customers AS (
    SELECT DISTINCT
        customer_id,
        customer_name,
        last_order_date
    FROM customer_orders
    WHERE last_order_date < latest_order_date - INTERVAL '90 days'
)
SELECT
    customer_id,
    customer_name,
    last_order_date
FROM inactive_customers
ORDER BY last_order_date ASC;



WITH customer_activity AS (
    SELECT
        c.customer_name,
        MAX(o.order_date) AS last_order_date,
        (SELECT MAX(order_date) FROM orders) AS latest_order_date
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE c.customer_name = 'Customer_14'
    GROUP BY c.customer_name
)
SELECT
    customer_name,
    last_order_date,
    latest_order_date,
    last_order_date >= latest_order_date - INTERVAL '90 days'
        AS active_in_last_90_days
FROM customer_activity;
