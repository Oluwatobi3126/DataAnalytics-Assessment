# DataAnalytics-Assessment

This repository contains solutions to a SQL-based Data Analyst Assessment. It demonstrates the use of SQL to solve real-world business problems by querying user accounts, savings and investment data, and customer transaction behavior.

---

## Repository Structure
```
DataAnalytics-Assessment/
│
├── Assessment_Q1.sql
├── Assessment_Q2.sql
├── Assessment_Q3.sql
├── Assessment_Q4.sql
└── README.md
```

Each SQL file addresses a separate question using MySQL-compatible syntax.

---

## Dataset Overview
The SQL queries make use of the following tables:

- `users_customuser`: Contains customer profile and registration information.
- `savings_savingsaccount`: Records of savings transactions (inflows).
- `plans_plan`: Contains metadata about financial plans (savings or investments).
- `withdrawals_withdrawal`: Contains withdrawal transaction records (not used in this assessment).

All monetary values are stored in **kobo** and converted to **naira** where applicable.

---

## Question Summaries and Solutions

### **Assessment_Q1.sql** – High-Value Customers with Multiple Products
**Scenario**: Identify customers who have at least one funded savings plan and one funded investment plan.

**Approach**:
- Use `plans_plan` and `savings_savingsaccount` to aggregate savings and investment plans.
- Join on `plan_id` to match transactions to plans.
- Filter for `is_regular_savings = 1` and `is_a_fund = 1`.
- Aggregate total deposits and count plan types per customer.
- Return users who meet both criteria, sorted by total deposits.

---

### **Assessment_Q2.sql** – Transaction Frequency Analysis
**Scenario**: Categorize customers into frequency tiers based on their average transactions per month.

**Approach**:
- Group transactions by `owner_id` and month.
- Calculate average monthly transaction volume per customer.
- Assign frequency categories:
  - High Frequency: ≥ 10/month
  - Medium Frequency: 3–9/month
  - Low Frequency: < 3/month
- Count number of users per category and average transaction rate.

---

### **Assessment_Q3.sql** – Account Inactivity Alert
**Scenario**: Flag savings or investment accounts with no inflow transactions in the past 365 days.

**Approach**:
- Use `MAX(transaction_date)` to determine the latest activity for each plan.
- Filter for plans where the most recent transaction is older than one year.
- Return `plan_id`, `owner_id`, account `type`, last activity date, and days since.

---

### **Assessment_Q4.sql** – Customer Lifetime Value (CLV)
**Scenario**: Estimate customer value using tenure and transaction data.

**Formula**:
```
CLV = (total_transactions / tenure_months) * 12 * (0.001 * avg_transaction_value)
```

**Approach**:
- Calculate months since `date_joined` for each customer.
- Aggregate confirmed transactions and average transaction value.
- Apply the simplified CLV formula.
- Return ranked results by estimated value.

---

## Tools & Features Used
- MySQL SQL syntax
- CTEs (Common Table Expressions)
- Aggregate functions: `COUNT`, `SUM`, `AVG`, `ROUND`
- Date functions: `DATEDIFF`, `TIMESTAMPDIFF`, `EXTRACT`, `DATE_SUB`
- Conditional logic: `CASE`, `COALESCE`, `NULLIF`

---

## Challenges Faced
- Ensured compatibility with MySQL syntax (avoided PostgreSQL-specific functions).
- Converted monetary amounts from kobo to naira.
- Handled missing or null values with safe defaults (e.g., `COALESCE`, `NULLIF`).
- Carefully joined data to prevent row multiplication.

---

## How to Run
1. Use a MySQL-compatible environment (e.g., MySQL Workbench, db-fiddle).
2. Make sure the schema includes the required tables.
3. Run each query independently in your SQL interface.

---

## Author
This project was completed by **Oluwatobi Ijete** as part of a Data Analyst technical evaluation.
