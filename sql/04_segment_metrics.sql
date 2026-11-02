-- Grain: one row per experimental arm x history segment.
SELECT
    segment,
    history_segment,
    COUNT(*) AS customers,
    SUM(visit) AS visits,
    SUM(conversion) AS conversions,
    SUM(spend) AS total_spend,
    AVG(visit) AS visit_rate,
    AVG(conversion) AS conversion_rate,
    AVG(spend) AS avg_spend_per_customer
FROM customer_experiment
GROUP BY segment, history_segment
ORDER BY segment, history_segment;
