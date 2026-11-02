-- Pre-treatment features only. Post-treatment outcomes are labels/evaluation outcomes,
-- never predictors. history_segment is omitted because it is derived from history.
SELECT
    recency,
    history,
    mens,
    womens,
    newbie,
    channel,
    zip_code,
    segment,
    visit,
    conversion,
    spend
FROM customer_experiment;
