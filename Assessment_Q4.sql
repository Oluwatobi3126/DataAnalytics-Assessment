-- Estimate Customer Lifetime Value (CLV) based on tenure and average transaction value
WITH 

-- Calculate tenure in months for each customer
customer_tenure AS (
    SELECT 
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE) AS tenure_months
    FROM 
        users_customuser u
),

-- Calculate total transactions and average transaction value
customer_transactions AS (
    SELECT 
        s.owner_id,
        COUNT(*) AS total_transactions,
        AVG(s.confirmed_amount / 100.0) AS avg_transaction_value  -- Convert kobo to Naira
    FROM 
        savings_savingsaccount s
    WHERE 
        s.confirmed_amount > 0
    GROUP BY 
        s.owner_id
)

-- Final CLV calculation
SELECT 
    ct.customer_id,
    ct.name,
    ct.tenure_months,
    tr.total_transactions,

    -- CLV = (monthly transaction rate) * 12 * (0.1% of average transaction value)
    ROUND(
        (tr.total_transactions / NULLIF(ct.tenure_months, 0)) * 12 * 
        (tr.avg_transaction_value * 0.001),  -- 0.1% assumed profit margin
        2
    ) AS estimated_clv

FROM 
    customer_tenure ct

JOIN 
    customer_transactions tr 
    ON ct.customer_id = tr.owner_id

-- Filter out customers with zero tenure to avoid division errors
WHERE 
    ct.tenure_months > 0

ORDER BY 
    estimated_clv DESC;
