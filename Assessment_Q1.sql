-- Customers with at least one funded savings and one funded investment plan

WITH 

-- First CTE: Aggregate funded savings account details per user
savings_accounts AS (
    SELECT 
        p.owner_id,
        COUNT(DISTINCT p.id) AS savings_count,
        COALESCE(SUM(s.confirmed_amount), 0) / 100.0 AS savings_total  -- Convert kobo to currency
    FROM 
        plans_plan p
    JOIN 
        savings_savingsaccount s 
        ON s.plan_id = p.id
    WHERE 
        p.is_regular_savings = 1
        AND s.confirmed_amount > 0
    GROUP BY 
        p.owner_id
),

-- Second CTE: Aggregate funded investment account details per user
investment_accounts AS (
    SELECT 
        p.owner_id,
        COUNT(DISTINCT p.id) AS investment_count,
        COALESCE(SUM(s.confirmed_amount), 0) / 100.0 AS investment_total  -- Convert kobo to currency
    FROM 
        plans_plan p
    JOIN 
        savings_savingsaccount s 
        ON s.plan_id = p.id
    WHERE 
        p.is_a_fund = 1
        AND s.confirmed_amount > 0
    GROUP BY 
        p.owner_id
)

-- Main query: Combine savings and investment info with user details
SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,
    s.savings_count,
    i.investment_count,
    ROUND((s.savings_total + i.investment_total), 2) AS total_deposits
FROM 
    users_customuser u
JOIN 
    savings_accounts s 
    ON u.id = s.owner_id
JOIN 
    investment_accounts i 
    ON u.id = i.owner_id
WHERE 
    s.savings_count >= 1
    AND i.investment_count >= 1
ORDER BY 
    total_deposits DESC;
