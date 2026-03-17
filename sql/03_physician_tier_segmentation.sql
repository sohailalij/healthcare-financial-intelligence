-- Physician Payment Tier Segmentation
-- Uses: CTE + NTILE(4) window function

WITH physician_totals AS (
    SELECT
        Covered_Recipient_NPI,
        Specialty,
        Recipient_State,
        ROUND(SUM(Payment_Amount), 2)   AS total_received,
        COUNT(DISTINCT Payer_Name)       AS num_payers
    FROM vw_general_payments_clean
    WHERE Covered_Recipient_NPI != 'HOSPITAL_NO_NPI'
    GROUP BY Covered_Recipient_NPI
),
tiered AS (
    SELECT *,
        NTILE(4) OVER (ORDER BY total_received DESC) AS payment_tier
    FROM physician_totals
)
SELECT
    payment_tier,
    CASE payment_tier
        WHEN 1 THEN 'Tier 1 — Top 25% (Highest Risk)'
        WHEN 2 THEN 'Tier 2 — Upper Middle'
        WHEN 3 THEN 'Tier 3 — Lower Middle'
        WHEN 4 THEN 'Tier 4 — Bottom 25% (Lowest Risk)'
    END                                 AS tier_label,
    COUNT(*)                            AS num_physicians,
    ROUND(MIN(total_received), 2)       AS min_payment,
    ROUND(MAX(total_received), 2)       AS max_payment,
    ROUND(AVG(total_received), 2)       AS avg_payment,
    ROUND(SUM(total_received), 2)       AS total_payment
FROM tiered
GROUP BY payment_tier
ORDER BY payment_tier;