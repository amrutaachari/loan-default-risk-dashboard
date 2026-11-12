CREATE DATABASE loan_db;
USE loan_db;

-- 1. Overall default rate
SELECT COUNT(*) AS total_loans,
       SUM(loan_status) AS defaults,
       ROUND(100.0 * SUM(loan_status) / COUNT(*), 2) AS default_rate_pct
FROM loans;

-- 2. Default rate by loan grade
SELECT loan_grade,
       COUNT(*) AS loans,
       ROUND(100.0 * AVG(loan_status), 2) AS default_rate_pct
FROM loans
GROUP BY loan_grade
ORDER BY loan_grade;

-- 3. Default rate and average loan amount by purpose
SELECT loan_intent,
       COUNT(*) AS loans,
       ROUND(AVG(loan_amnt), 0) AS avg_loan_amount,
       ROUND(100.0 * AVG(loan_status), 2) AS default_rate_pct
FROM loans
GROUP BY loan_intent
ORDER BY default_rate_pct DESC;

-- 4. Default rate by income band
SELECT CASE
         WHEN person_income < 30000 THEN '1. Under 30k'
         WHEN person_income < 60000 THEN '2. 30k to 60k'
         WHEN person_income < 100000 THEN '3. 60k to 100k'
         ELSE '4. Above 100k'
       END AS income_band,
       COUNT(*) AS loans,
       ROUND(100.0 * AVG(loan_status), 2) AS default_rate_pct
FROM loans
GROUP BY income_band
ORDER BY income_band;

-- 5. Previous default on file
SELECT cb_person_default_on_file AS previous_default,
       COUNT(*) AS loans,
       ROUND(100.0 * AVG(loan_status), 2) AS default_rate_pct
FROM loans
GROUP BY cb_person_default_on_file;

-- 6. High-risk segment: loan is 30% or more of income
SELECT person_home_ownership,
       COUNT(*) AS loans,
       ROUND(100.0 * AVG(loan_status), 2) AS default_rate_pct
FROM loans
WHERE loan_percent_income >= 0.3
GROUP BY person_home_ownership
HAVING COUNT(*) > 50
ORDER BY default_rate_pct DESC;

-- 7. Grades riskier than the overall average
SELECT loan_grade,
       ROUND(100.0 * AVG(loan_status), 2) AS default_rate_pct
FROM loans
GROUP BY loan_grade
HAVING AVG(loan_status) > (SELECT AVG(loan_status) FROM loans)
ORDER BY default_rate_pct DESC;


