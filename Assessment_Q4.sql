-- Estimate Customer Lifetime Value (CLV) based on customer tenure and transaction activity

-- Step 1: Aggregate transaction data (count and value) per customer
WITH transactions AS (
    SELECT
        owner_id,
        COUNT(*) AS total_transactions,                        -- Total number of transactions by the customer
        SUM(confirmed_amount) / 100.0 AS total_value           -- Convert from kobo to naira
    FROM
        savings_savingsaccount
    WHERE
        confirmed_amount > 0                                   -- Only count actual confirmed transactions
    GROUP BY
        owner_id
),

-- Step 2: Calculate customer tenure in months since they joined
tenure AS (
    SELECT
        id AS customer_id,
        CONCAT(first_name, ' ', last_name) AS name,            -- Full name of the customer
        PERIOD_DIFF(
            DATE_FORMAT(CURDATE(), '%Y%m'),                    -- Current year-month
            DATE_FORMAT(date_joined, '%Y%m')                   -- Year-month of account creation
        ) AS tenure_months                                     -- Total months since the customer joined
    FROM
        users_customuser
    WHERE
        CONCAT(first_name, ' ', last_name) IS NOT NULL         -- Ensure customer has a name
),

-- Step 3: Calculate CLV using average monthly transactions
clv_calc AS (
    SELECT
        t.customer_id,
        t.name,
        t.tenure_months,
        IFNULL(tx.total_transactions, 0) AS total_transactions,  -- Default to 0 if no transactions
        ROUND(
            (
                IFNULL(tx.total_transactions, 0) / NULLIF(t.tenure_months, 0)  -- Avoid division by zero
            ) * 12 * 0.001,                                      -- Annualized rate * arbitrary multiplier
            2
        ) AS estimated_clv                                       -- Estimated Customer Lifetime Value
    FROM
        tenure t
    LEFT JOIN
        transactions tx ON t.customer_id = tx.owner_id          -- Join tenure with transaction data
)

-- Step 4: Return results sorted by estimated CLV
SELECT
    *
FROM
    clv_calc
ORDER BY
    estimated_clv DESC;                                         -- Highest value customers first
