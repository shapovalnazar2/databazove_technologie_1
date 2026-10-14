WITH RECURSIVE monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', sale_date)::date AS month,
        SUM(total_amount) AS revenue
    FROM flourmills_sales
    GROUP BY DATE_TRUNC('month', sale_date)
),
ordered_months AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY month) AS rn,
        month,
        revenue
    FROM monthly_revenue
),
cumulative_target AS (
    SELECT
        rn,
        month,
        revenue,
        revenue AS cumulative_revenue
    FROM ordered_months
    WHERE rn = 1

    UNION ALL

    SELECT
        o.rn,
        o.month,
        o.revenue,
        c.cumulative_revenue + o.revenue
    FROM cumulative_target c
    JOIN ordered_months o
        ON o.rn = c.rn + 1
    WHERE c.cumulative_revenue < 500000000
)
SELECT *
FROM cumulative_target
ORDER BY rn;