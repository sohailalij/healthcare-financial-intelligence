-- Conflict of Interest Risk Scoring
-- Uses: CTE + custom weighted risk score formula

WITH physician_profile AS (
    SELECT
        Covered_Recipient_NPI,
        Specialty,
        Recipient_State,
        ROUND(SUM(Payment_Amount), 2)        AS total_received,
        COUNT(DISTINCT Payer_Name)            AS num_distinct_payers,
        COUNT(*)                              AS num_transactions,
        ROUND(AVG(Payment_Amount), 2)         AS avg_payment,
        MAX(Payment_Amount)                   AS largest_single_payment,
        SUM(CASE WHEN Physician_Ownership_Indicator = 'Yes'
            THEN 1 ELSE 0 END)               AS ownership_flag_count
    FROM vw_general_payments_clean
    WHERE Covered_Recipient_NPI != 'HOSPITAL_NO_NPI'
    GROUP BY Covered_Recipient_NPI
),
risk_scored AS (
    SELECT *,
        ROUND(
            (total_received / 1000.0) * 0.5 +
            (num_distinct_payers * 10.0) * 0.3 +
            (ownership_flag_count * 50.0) * 0.2
        , 2) AS conflict_risk_score
    FROM physician_profile
)
SELECT *
FROM risk_scored
ORDER BY conflict_risk_score DESC
LIMIT 10;