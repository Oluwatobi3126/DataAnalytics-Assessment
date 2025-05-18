-- Customers with at least one funded savings and one funded investment plan

WITH savings_data AS (
    SELECT
        s.owner_id,  -- ID of the user who owns the savings account
        COUNT(DISTINCT s.id) AS savings_count,  -- Total number of funded savings accounts
        SUM(s.confirmed_amount) AS total_deposits  -- Sum of confirmed deposit amounts
    FROM savings_savingsaccount s
    WHERE s.confirmed_amount > 0  -- Only consider accounts with confirmed deposits
    GROUP BY s.owner_id
),

investment_data AS (
    SELECT
        p.owner_id,  -- ID of the user who owns the investment plan
        COUNT(DISTINCT CASE WHEN p.is_a_fund = TRUE THEN p.id END) AS investment_count,  -- Number of investment (fund) plans
        COUNT(DISTINCT CASE WHEN p.is_regular_savings = TRUE THEN p.id END) AS savings_plan_count  -- Number of savings-type plans
    FROM plans_plan p
    GROUP BY p.owner_id
)

SELECT
    u.id AS owner_id,  -- User ID
    CONCAT(u.first_name, ' ', u.last_name) AS name,  -- Full name of the user
    sd.savings_count,  -- Number of funded savings accounts
    idata.investment_count,  -- Number of investment plans
    ROUND(sd.total_deposits / 100.00, 2) AS total_deposits  -- Total confirmed deposits (converted to major currency unit)
FROM users_customuser u
JOIN savings_data sd 
    ON sd.owner_id = u.id  -- Join with savings summary
JOIN investment_data idata 
    ON idata.owner_id = u.id  -- Join with investment summary
WHERE idata.savings_plan_count >= 1  -- Must have at least one savings plan
  AND idata.investment_count >= 1  -- Must have at least one investment plan
ORDER BY total_deposits DESC;  -- Sort by deposit size (descending)
