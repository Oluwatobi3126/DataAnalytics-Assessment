-- Categorize customers by their average number of transactions per month

WITH 
-- Step 1: Calculate transactions per customer per month
monthly_transactions AS (
    SELECT 
        s.owner_id,
        EXTRACT(YEAR FROM s.created_on) AS year,
        EXTRACT(MONTH FROM s.created_on) AS month,
        COUNT(*) AS transaction_count
    FROM 
        savings_savingsaccount s
    GROUP BY 
        s.owner_id, 
        EXTRACT(YEAR FROM s.created_on), 
        EXTRACT(MONTH FROM s.created_on)
),

-- Step 2: Calculate average monthly transactions per customer
avg_transactions AS (
    SELECT 
        owner_id,
        AVG(transaction_count) AS avg_transactions_per_month
    FROM 
        monthly_transactions
    GROUP BY 
        owner_id
),

-- Step 3: Categorize customers based on average transaction frequency
categorized_customers AS (
    SELECT 
        CASE 
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month >= 3 AND avg_transactions_per_month < 10 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        owner_id,
        avg_transactions_per_month
    FROM 
        avg_transactions
)

-- Step 4: Aggregate results by transaction frequency category
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM 
    categorized_customers
GROUP BY 
    frequency_category
ORDER BY 
    CASE 
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        WHEN frequency_category = 'Low Frequency' THEN 3
    END;
