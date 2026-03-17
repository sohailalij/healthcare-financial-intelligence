-- Monthly Payment Trends with Running Total
-- Uses: CTE + SUM() OVER() running window function

WITH monthly AS (
    SELECT
        Payment_Month,
        Payment_Year,
        ROUND(SUM(Payment_Amount), 2)   AS monthly_total,
        COUNT(*)                         AS num_transactions
    FROM vw_general_payments_clean
    GROUP BY Payment_Year, Payment_Month
)
SELECT
    Payment_Year || '-' || Payment_Month        AS year_month,
    monthly_total,
    num_transactions,
    ROUND(SUM(monthly_total) OVER (
        ORDER BY Payment_Year, Payment_Month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2)                                        AS running_total_usd
FROM monthly
ORDER BY Payment_Year, Payment_Month;