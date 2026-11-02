-- Grain: one row per customer. Run through DuckDB from Jupyter.
SELECT COUNT(*) AS source_rows FROM customer_experiment;

DESCRIBE customer_experiment;

SELECT
  COUNT(*) FILTER (WHERE recency < 0) AS negative_recency,
  COUNT(*) FILTER (WHERE history < 0) AS negative_history,
  COUNT(*) FILTER (WHERE spend < 0) AS negative_spend,
  COUNT(*) FILTER (WHERE conversion > visit) AS conversion_without_visit,
  COUNT(*) FILTER (WHERE conversion = 0 AND spend > 0) AS positive_spend_without_conversion,
  COUNT(*) FILTER (WHERE conversion = 1 AND spend = 0) AS conversion_with_zero_spend
FROM customer_experiment;
