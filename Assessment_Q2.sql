-- Categorize customers by their average number of transactions per month

-- Step 1: Aggregate the number of transactions per customer per month
WITH monthly_txns AS (
    SELECT
        s.owner_id,  -- Unique identifier of the customer
        DATE_FORMAT(s.transaction_date, '%Y-%m-01') AS txn_month,  -- Normalize to the first day of the transaction month
        COUNT(*) AS txns_per_month  -- Count of transactions in that month
    FROM
        savings_savingsaccount s
    WHERE
        s.confirmed_amount > 0  -- Only include confirmed transactions
        AND s.transaction_date IS NOT NULL  -- Ensure transaction date is present
    GROUP BY
        s.owner_id,
        DATE_FORMAT(s.transaction_date, '%Y-%m-01')
),

-- Step 2: Compute average transactions per month for each customer
avg_txns AS (
    SELECT
        owner_id,  -- Customer ID
        AVG(txns_per_month) AS avg_txns_per_month  -- Average monthly transaction count
    FROM
        monthly_txns
    GROUP BY
        owner_id
),

-- Step 3: Categorize customers based on their average monthly transaction volume
categorized AS (
    SELECT
        CASE
            WHEN avg_txns_per_month >= 10 THEN 'High Frequency'       -- 10 or more transactions/month
            WHEN avg_txns_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'  -- 3 to 9 transactions/month
            ELSE 'Low Frequency'                                      -- Fewer than 3 transactions/month
        END AS frequency_category,
        avg_txns_per_month
    FROM
        avg_txns
)

-- Step 4: Aggregate final counts and averages by frequency category
SELECT
    frequency_category,  -- Category label
    COUNT(*) AS customer_count,  -- Number of customers in the category
    ROUND(AVG(avg_txns_per_month), 1) AS avg_transactions_per_month  -- Average transactions/month in the group
FROM
    categorized
GROUP BY
    frequency_category
ORDER BY
    avg_transactions_per_month DESC;  -- Show most active groups first
