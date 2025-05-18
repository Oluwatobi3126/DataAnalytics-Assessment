-- Identify accounts (both Savings and Investment) with no transactions in the last 365 days

-- Step 1: Get the last transaction date for each Savings or Investment plan
WITH last_txn AS (

    -- Subquery for Savings accounts
    SELECT
        plan_id,
        owner_id,
        'Savings' AS type,  -- Label the account type
        MAX(DATE(transaction_date)) AS last_transaction_date  -- Most recent confirmed transaction date
    FROM
        savings_savingsaccount
    WHERE
        confirmed_amount > 0  -- Only consider transactions with confirmed amounts
        AND transaction_date IS NOT NULL
    GROUP BY
        id, owner_id

    UNION ALL

    -- Subquery for Investment or Regular Savings plans
    SELECT
        id AS plan_id,
        owner_id,
        'Investment' AS type,  -- Label the account type
        MAX(DATE(created_on)) AS last_transaction_date  -- Use the plan's creation date as proxy for last activity
    FROM
        plans_plan
    WHERE
        (is_a_fund = TRUE OR is_regular_savings = TRUE)  -- Consider only investment-type plans
        AND created_on IS NOT NULL
    GROUP BY
        id, owner_id
)

-- Step 2: Filter accounts that have been inactive for more than 365 days
SELECT
    plan_id,
    owner_id,
    type,  -- 'Savings' or 'Investment'
    last_transaction_date,
    DATEDIFF(CURRENT_DATE, last_transaction_date) AS inactivity_days  -- Days since last transaction
FROM
    last_txn
WHERE
    DATEDIFF(CURRENT_DATE, last_transaction_date) > 365  -- Inactive for over a year
ORDER BY
    inactivity_days DESC;  -- Show longest inactive accounts first
