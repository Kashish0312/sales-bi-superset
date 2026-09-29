WITH product_sales AS (
    SELECT
        category,
        sub_category,
        SUM(sales) AS total_revenue
    FROM sales_orders
    GROUP BY category, sub_category
),
ranked_products AS (
    SELECT
        category,
        sub_category,
        total_revenue,
        RANK() OVER (
            PARTITION BY category ORDER BY total_revenue DESC
        ) AS revenue_rank
    FROM product_sales
)
SELECT
    category,
    sub_category,
    ROUND(total_revenue::numeric, 2) AS total_revenue,
    revenue_rank
FROM ranked_products
WHERE revenue_rank <= 5
ORDER BY category, revenue_rank, total_revenue DESC;
