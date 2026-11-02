-- Grain of output: one row per experimental arm.
CREATE OR REPLACE TABLE arm_metrics AS
SELECT
    segment,
    COUNT(*) AS customers,
    SUM(visit) AS visits,
    SUM(conversion) AS conversions,
    SUM(spend) AS total_spend,
    AVG(visit) AS visit_rate,
    AVG(conversion) AS conversion_rate,
    AVG(spend) AS avg_spend_per_customer
FROM customer_experiment
GROUP BY segment;

-- Reconcile aggregate grain to source customer count.
SELECT
    SUM(customers) AS total_customers_across_arms,
    (SELECT COUNT(*) FROM customer_experiment) AS source_customers,
    SUM(customers) = (SELECT COUNT(*) FROM customer_experiment) AS row_count_reconciles
FROM arm_metrics;

SELECT segment, customers, visits, 100*visit_rate AS visit_rate_pct,
       conversions, 100*conversion_rate AS conversion_rate_pct,
       total_spend, avg_spend_per_customer
FROM arm_metrics
ORDER BY CASE segment
  WHEN 'Mens E-Mail' THEN 1
  WHEN 'Womens E-Mail' THEN 2
  WHEN 'No E-Mail' THEN 3
END;
