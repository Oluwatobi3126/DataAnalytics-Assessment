-- Identify accounts (both Savings and Investment) with no transactions in the last 365 days

SELECT
    p.id AS plan_id,  -- Unique identifier of the plan
    p.owner_id,       -- Customer ID who owns the plan
    
    -- Determine the plan type based on flags
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
    END AS type,
    
    -- Most recent transaction date for the plan
    MAX(s.transaction_date) AS last_transaction_date,
    
    -- Calculate number of days since last transaction
    DATEDIFF(CURRENT_DATE, MAX(s.transaction_date)) AS inactivity_days

FROM
    adashi_staging.plans_plan p

-- Join with savings account transactions table, only considering confirmed transactions
LEFT JOIN
    adashi_staging.savings_savingsaccount s
    ON p.id = s.plan_id
    AND s.confirmed_amount > 0

-- Only include savings or investment plans
WHERE
    p.is_regular_savings = 1 
    OR p.is_a_fund = 1

-- Group by plan details to compute aggregates
GROUP BY
    p.id, 
    p.owner_id, 
    p.is_regular_savings, 
    p.is_a_fund

-- Include plans that have a recorded transaction, or where the last transaction was more than a year ago
HAVING
    MAX(s.transaction_date) IS NOT NULL 
    OR MAX(s.transaction_date) <= DATE_SUB(CURRENT_DATE, INTERVAL 365 DAY)

-- Sort results by most inactive first
ORDER BY
    inactivity_days DESC;
