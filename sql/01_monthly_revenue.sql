WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', order_date)::date AS month,
        SUM(sales) AS monthly_revenue
    FROM sales_orders
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT 
    month,
    monthly_revenue,
    SUM(monthly_revenue) OVER (
        ORDER BY month
    ) AS cumulative_revenue
FROM monthly_sales
ORDER BY month;