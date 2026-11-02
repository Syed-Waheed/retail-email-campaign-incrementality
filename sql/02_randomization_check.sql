-- Arm size reconciliation
SELECT segment, COUNT(*) AS customers
FROM customer_experiment
GROUP BY segment
ORDER BY CASE segment
  WHEN 'Mens E-Mail' THEN 1
  WHEN 'Womens E-Mail' THEN 2
  WHEN 'No E-Mail' THEN 3
END;

-- Pre-treatment categorical distributions
SELECT segment, channel, COUNT(*) AS customers,
       100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY segment) AS pct_within_arm
FROM customer_experiment
GROUP BY segment, channel
ORDER BY segment, channel;

SELECT segment, zip_code, COUNT(*) AS customers,
       100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY segment) AS pct_within_arm
FROM customer_experiment
GROUP BY segment, zip_code
ORDER BY segment, zip_code;
