-- Top 10 Medical Specialties by Payment Volume
-- Uses: CTE + RANK() window function

WITH specialty_totals AS (
    SELECT
        Specialty,
        COUNT(*)                                    AS total_transactions,
        ROUND(SUM(Payment_Amount), 2)               AS total_paid_usd,
        ROUND(AVG(Payment_Amount), 2)               AS avg_payment_usd,
        COUNT(DISTINCT Covered_Recipient_NPI)       AS unique_physicians
    FROM vw_general_payments_clean
    WHERE Specialty != 'Not Specified'
    GROUP BY Specialty
),
ranked AS (
    SELECT *,
        RANK() OVER (ORDER BY total_paid_usd DESC) AS payment_rank
    FROM specialty_totals
)
SELECT payment_rank, Specialty, unique_physicians,
       total_transactions, total_paid_usd, avg_payment_usd
FROM ranked
WHERE payment_rank <= 10
ORDER BY payment_rank;