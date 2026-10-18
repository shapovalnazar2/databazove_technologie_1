

SELECT
    stock_code,
    country,
    invoice_date,
    quantity,
    ROUND(
        AVG(quantity) OVER (
            PARTITION BY stock_code, country
            ORDER BY invoice_date
            RANGE BETWEEN INTERVAL '7 days' PRECEDING
                      AND CURRENT ROW
        ),
        2
    ) AS avg_quantity_7_days
FROM retail_sales
WHERE quantity > 1
  AND stock_code = '10002'
  AND country = 'EIRE'
ORDER BY invoice_date
LIMIT 1;
