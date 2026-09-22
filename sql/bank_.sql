-- 1) Row count
		SELECT COUNT(*) AS total_rows 
		FROM bank;


-- 2) NULL check across all columns
		SELECT
		  SUM(CustomerId IS NULL) AS null_id,
		  SUM(Geography IS NULL)  AS null_geo,
		  SUM(Age IS NULL)        AS null_age,
		  SUM(Balance IS NULL)    AS null_balance,
		  SUM(Exited IS NULL)     AS null_exited
		FROM bank;


-- 3) Duplicate CustomerId detection
		SELECT CustomerId, COUNT(*) AS count_
		FROM bank
		GROUP BY CustomerId
		HAVING COUNT(*) > 1;


-- 4) How many total customers and churned customers are in the dataset?
		SELECT 
			COUNT(*) AS total_customers,
			SUM(Exited) AS churned_customers,
			CONCAT(ROUND(SUM(Exited) * 100.0 / COUNT(*), 2),"%") AS churn_rate_percentage
		FROM bank;


-- 5) Show all customers from Germany who have churned, ordered by highest balance.
		SELECT CustomerId, Surname, Age, Balance, EstimatedSalary
		FROM bank
		WHERE Geography = 'Germany' AND Exited = 1
		ORDER BY Balance DESC;


-- 6) What is the churn rate by geography?
		SELECT Geography, COUNT(*) AS total_customers, SUM(Exited) AS churned, CONCAT(ROUND(SUM(Exited) * 100.0 / COUNT(*), 2),"%") AS churn_rate
		FROM bank
		GROUP BY Geography
		ORDER BY churn_rate DESC;


-- 7) Which geographies have more than 100 churned customers?
		SELECT Geography, SUM(Exited) AS churned_customers
		FROM bank
		GROUP BY Geography
		HAVING SUM(Exited) > 100
		ORDER BY churned_customers DESC;


-- 8) How can we segment customers by age group and see churn?
		SELECT 
			CASE 
				WHEN Age < 30 THEN 'Young (Under 30)'
				WHEN Age BETWEEN 30 AND 45 THEN 'Middle Age (30-45)'
				WHEN Age BETWEEN 46 AND 60 THEN 'Senior (46-60)'
				ELSE 'Elderly (60+)'
			END AS age_group,
			COUNT(*) AS total_customers, SUM(Exited) AS churned, CONCAT(ROUND(SUM(Exited) * 100.0 / COUNT(*), 2),"%") AS churn_rate
		FROM bank
		GROUP BY age_group
		ORDER BY churn_rate DESC;


-- 9) Segment customers by balance category.
		SELECT
			CASE
				WHEN Balance = 0 THEN 'Zero Balance'
				WHEN Balance < 50000 THEN 'Low Balance (<50K)'
				WHEN Balance BETWEEN 50000 AND 100000 THEN 'Medium Balance (50K-100K)'
				WHEN Balance BETWEEN 100001 AND 150000 THEN 'High Balance (100K-150K)'
				ELSE 'Premium Balance (150K+)'
			END AS balance_segment,
			COUNT(*) AS customer_count, CONCAT(ROUND(AVG(Exited) * 100, 2), '%') AS churn_rate
		FROM bank
		GROUP BY balance_segment
		ORDER BY AVG(Exited) DESC
		LIMIT 0, 1000;


-- 10) Create a summary table and join it with main data.
	-- First create a summary view.
		CREATE VIEW geography_summary AS
		SELECT Geography, COUNT(*) AS total_customers, AVG(CreditScore) AS avg_credit_score, AVG(Balance) AS avg_balance
		FROM bank
		GROUP BY Geography;

	-- Now joining with main data.
		SELECT c.CustomerId, c.Surname, c.Geography, c.Balance, g.avg_balance AS geo_avg_balance, CASE 
																										WHEN c.Balance > g.avg_balance THEN 'Above Average'
																										ELSE 'Below Average'
																								   END AS balance_comparison
		FROM bank AS c
		JOIN geography_summary g ON c.Geography = g.Geography
		LIMIT 20;


-- 11) Find customers with same surname (potential duplicates) [Self Join].
		SELECT a.CustomerId AS customer_1, a.Surname, b.CustomerId AS customer_2, a.Geography, b.Geography AS customer_2_geo
		FROM bank AS a
		JOIN bank AS b ON a.Surname = b.Surname AND a.CustomerId < b.CustomerId
		LIMIT 20;


-- 12) Find customers whose balance is above their country's average (by using Subquery).
		SELECT CustomerId, Surname, Geography, Balance
		FROM bank
		WHERE Balance > (
							SELECT AVG(Balance) 
							FROM bank
							WHERE Geography = 'France'
		)
		AND Geography = 'France'
		LIMIT 10;


-- 13) Find customers who have higher balance than the average of their own country.
		SELECT c1.CustomerId,  c1.Surname, c1.Geography, c1.Balance
		FROM bank AS c1
		WHERE c1.Balance > (
								SELECT AVG(c2.Balance)
								FROM bank AS c2
								WHERE c2.Geography = c1.Geography
		)
		LIMIT 15;


-- 14) Use CTE to calculate churn rate by age group.
		WITH age_churn AS (
							SELECT 
								CASE 
									WHEN Age < 30 THEN 'Young'
									WHEN Age BETWEEN 30 AND 45 THEN 'Middle'
									ELSE 'Senior'
								END AS age_group,
								COUNT(*) AS total, SUM(Exited) AS churned
							FROM bank
							GROUP BY age_group
		)
		SELECT age_group, total, churned, CONCAT(ROUND(churned * 100.0 / total, 2),"%") AS churn_rate
		FROM age_churn
		ORDER BY churn_rate DESC;


-- 15) Compare churn by geography and gender.
		WITH geo_churn AS (
							SELECT Geography, 
								   COUNT(*) AS total,
								   SUM(Exited) AS churned
							FROM bank
							GROUP BY Geography
		),
		gender_churn AS (
							SELECT Gender,
								   COUNT(*) AS total,
								   SUM(Exited) AS churned
							FROM bank
							GROUP BY Gender
		)
		SELECT 'Geography' AS dimension, Geography AS category, CONCAT(ROUND(churned * 100.0 / total, 2),"%") AS churn_rate
		FROM geo_churn
		UNION ALL
		SELECT 'Gender' AS dimension, Gender AS category, CONCAT(ROUND(churned * 100.0 / total, 2),"%") AS churn_rate
		FROM gender_churn
		ORDER BY dimension, churn_rate DESC;


-- 16) Assign unique row numbers to customers by balance.
		SELECT CustomerId, Surname, Balance, ROW_NUMBER() OVER (ORDER BY Balance DESC) AS row_num
		FROM bank
		LIMIT 20;


-- 17) Rank customers by credit score. (by using Rank, Dense rank and Row number)
		SELECT CustomerId, CreditScore, RANK() OVER (ORDER BY CreditScore DESC) AS rank_col,
										DENSE_RANK() OVER (ORDER BY CreditScore DESC) AS dense_rank_col,
										ROW_NUMBER() OVER (ORDER BY CreditScore DESC) AS row_num
		FROM bank
		WHERE CreditScore > 800
		LIMIT 20;


-- 18) Compare customer balance with previous/next customer.
		SELECT CustomerId, Balance, LAG(Balance) OVER (ORDER BY CustomerId) AS previous_balance,
									LEAD(Balance) OVER (ORDER BY CustomerId) AS next_balance,
									Balance - LAG(Balance) OVER (ORDER BY CustomerId) AS balance_diff
		FROM bank
		LIMIT 15;

-- 18) Running total of churned customers by customer ID.
		SELECT CustomerId, Exited, SUM(Exited) OVER (ORDER BY CustomerId) AS running_churn_total
		FROM bank
		LIMIT 30;


-- 19) Moving average of balance (3-customer window).
		SELECT CustomerId, Balance,ROUND(AVG(Balance) OVER (ORDER BY CustomerId ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS moving_avg_3
		FROM bank
		LIMIT 20;


-- 20) Date/time analysis note and a simple derived "cohort" using Tenure.
	-- Cohort-style analysis using Tenure as cohort
		SELECT Tenure AS cohort_years, COUNT(*) AS total_customers, SUM(Exited) AS churned, CONCAT(ROUND(SUM(Exited) * 100.0 / COUNT(*), 2),"%") AS churn_rate
		FROM bank
		GROUP BY Tenure
		ORDER BY Tenure;


-- 21) Retention analysis by tenure.
		SELECT Tenure, COUNT(*) AS total, COUNT(*) - SUM(Exited) AS retained, CONCAT(ROUND((COUNT(*) - SUM(Exited)) * 100.0 / COUNT(*), 2),"%") AS retention_rate
		FROM bank
		GROUP BY Tenure
		ORDER BY Tenure;


-- 22) Top 10 customers by estimated salary who churned.
		SELECT CustomerId, Surname, EstimatedSalary,Geography
		FROM bank
		WHERE Exited = 1
		ORDER BY EstimatedSalary DESC
		LIMIT 10;


-- 23) Top 3 customers by balance in each geography.
		WITH ranked AS (
						SELECT CustomerId, Surname, Geography, Balance, ROW_NUMBER() OVER (PARTITION BY Geography ORDER BY Balance DESC) AS row_no
						FROM bank
		)
		SELECT * FROM ranked WHERE row_no <= 3;


-- 24) Check for duplicate CustomerIds.
		SELECT CustomerId, COUNT(*) AS occurrences
		FROM bank
		GROUP BY CustomerId
		HAVING COUNT(*) > 1;





















































