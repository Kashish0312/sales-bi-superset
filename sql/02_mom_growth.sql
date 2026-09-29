WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date)::date AS month,
        SUM(sales) AS monthly_revenue
    FROM sales_orders
    GROUP BY DATE_TRUNC('month', order_date)
),
revenue_with_previous_month AS (
    SELECT
        month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (
            ORDER BY month
        ) AS previous_month_revenue
    FROM monthly_sales
)
SELECT
    month,
    ROUND(monthly_revenue::numeric, 2) AS monthly_revenue,
    ROUND(previous_month_revenue::numeric, 2) AS previous_month_revenue,
    ROUND(
        (
            ((monthly_revenue - previous_month_revenue) / NULLIF(previous_month_revenue, 0)) * 100
        )::numeric,
        2
    ) AS mom_growth_percent
FROM revenue_with_previous_month
ORDER BY month;
