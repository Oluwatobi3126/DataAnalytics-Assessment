# DataAnalytics-Assessment

This repository contains SQL solutions for a data analyst proficiency assessment. The goal of this project is to demonstrate the ability to write clear, efficient, and accurate SQL queries to solve real-world business problems across multiple tables.

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


---


## Assessment Overview

The dataset consists of the following tables:

The assessment tests SQL proficiency in solving real-world business queries using multiple tables:
- `users_customuser`
- `savings_savingsaccount`
- `plans_plan`
- `withdrawals_withdrawal`– Records of withdrawal transactions (not used in this assessment).

Each SQL file solves a distinct business problem using data from the provided tables.

---

##  Questions & Approaches

### **Assessment_Q1.sql**  
**Task**: Find customers with at least one funded savings plan and one funded investment plan. Sort them by total deposits.

**Approach**:
- Filter savings inflows from `savings_savingsaccount`.
- Count how many savings and investment plans each customer has from `plans_plan`.
- Aggregate total deposits and format output by user.
- Only include customers with at least one of each plan type.

---

### **Assessment_Q2.sql**  
**Task**: Categorize customers based on average number of transactions per month into:
- High Frequency (≥10/month)
- Medium Frequency (3–9/month)
- Low Frequency (≤2/month)

**Approach**:
- Extract monthly transaction counts from savings data.
- Compute the average monthly transactions per customer.
- Categorize customers based on this average and count how many fall into each group.

---

###  **Assessment_Q3.sql**  
**Task**: Identify all savings and investment accounts with no inflow in the last 365 days.

**Approach**:
- Get the most recent `transaction_date` for savings and `created_on` for investment plans.
- Use `DATEDIFF()` to calculate inactivity in days.
- Filter for accounts where the last inflow was over a year ago.

---

### **Assessment_Q4.sql**  
**Task**: Estimate Customer Lifetime Value (CLV) based on account tenure and transaction volume.

**CLV Formula**:
\[
\text{CLV} = \left(\frac{\text{total transactions}}{\text{tenure in months}} \right) \times 12 \times \text{avg profit per transaction}
\]
Assumed average profit per transaction = **0.1%**

**Approach**:
- Calculate tenure in months using `PERIOD_DIFF()` between current date and `date_joined`.
- Count confirmed transactions and convert `confirmed_amount` from kobo to naira.
- Apply the CLV formula and rank customers by value.

---

## Technologies Used

- SQL (MySQL syntax)
- Date formatting and aggregation functions
- Common Table Expressions (CTEs)

---

## Challenges Encountered

- Ensuring compatibility between PostgreSQL and MySQL syntax (e.g., handling `::date`, `DATE_TRUNC`, `AGE()`).
- Convert all amounts from kobo to naira to ensure accurate output.
- Managing NULL or missing values for edge cases in joins and calculations.

---

##  How to Run

1. Use a MySQL-compatible environment (MySQL Workbench).
2. Run each SQL file independently depending on the question of interest.
3. Ensure all four datasets (`users_customuser`, `savings_savingsaccount`, `plans_plan`, `withdrawals_withdrawal`) are available in your schema.

---

## Author

This assessment was completed by **Oluwatobi Ijete** as part of a technical evaluation for a data analyst role.
