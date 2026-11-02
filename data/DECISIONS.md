## D009 — Exact duplicate rows
The audit found repeated complete rows. Because the available dataset does not
contain a customer identifier, identical rows cannot be established as duplicate
customers. We therefore retain all 64,000 experimental observations and do not
deduplicate based on complete-row equality alone.

The duplicate counts reconcile as follows:
64,000 total rows - 57,438 unique complete rows = 6,562 repeated observations.


## D010 — Experimental group structure
The dataset contains exactly three experimental groups: Men's Email,
Women's Email, and No Email. Group counts reconcile exactly to the full
64,000-row dataset.

The treatment arms are descriptively similar in size, but arm-size similarity
alone is not treated as proof of successful randomization. Pre-treatment
covariate balance will be assessed separately.

## D011 — Preserve raw category labels
Original categorical values are retained as provided in the source data.
The `Surburban` spelling is not corrected during the audit because changing
raw labels is unnecessary for the current analysis and could alter provenance.

## D012 — Business-rule validation
No negative values were found in `recency`, `history`, or `spend`.

No observations violated the expected relationship `conversion <= visit`.

The dataset also showed complete consistency between conversion and spend:
there were no customers with positive spend without conversion and no converted
customers with zero spend.

No observations were removed based on these checks.

## D013 — Spend distribution
Customer-level `spend` is highly zero-heavy and right-skewed in this dataset,
with the upper tail materially exceeding the median.

For treatment comparisons, spend will therefore not be analyzed using the same
default approach as binary conversion/visit outcomes. We will use customer-level
mean spend and bootstrap confidence intervals to quantify uncertainty.


## D014 — Outlier handling
IQR-based detection found no high-end recency observations and identified a
substantial upper tail in historical spend.

The `history` observations above the IQR fence are not automatically treated
as errors because unusually high historical customer spend can represent
legitimate customers.

For `spend`, the IQR is zero because the distribution is highly concentrated
at zero. Therefore the conventional 1.5 × IQR outlier rule is not useful for
identifying invalid spend observations. No spend observations are removed or
winsorized during the audit.

The repeated maximum spend value of 499.00 will be investigated before the
final spend methodology is locked.


## D015 — Maximum spend investigation
The observed maximum spend is 499.00 and occurs for 12 customers. The next
highest observed values are below 499 and vary across customers.

The repeated maximum is therefore noted as a potential boundary feature, but
the audit does not provide enough evidence to classify 499.00 as a data cap,
error, or truncation. The original values are retained unchanged.


## D016 — History and history_segment
The observed ranges within `history_segment` align with the bucket labels in
the dataset, confirming that `history_segment` represents discretized historical
spend.

For modeling, continuous `history` will generally be preferred because it
retains more information and avoids unnecessary duplication. The categorical
`history_segment` will be retained for interpretable reporting and selected
segment analysis where appropriate.


## D017 — Numeric and binary randomization balance
Pre-treatment balance was assessed by comparing Men's Email and Women's Email
against the No Email control using descriptive group values and standardized
mean differences.

The largest observed absolute SMD was below 0.01 for both treatment-control
comparisons, indicating very small observed differences across the checked
pre-treatment covariates (`recency`, `history`, `mens`, `womens`, `newbie`).

This is treated as evidence of strong observed balance, not proof that all
possible customer characteristics were perfectly balanced.

## D018 — Categorical randomization balance
Pre-treatment categorical balance was assessed for `channel` and `zip_code`
using within-arm category proportions and Cramer's V.

The category distributions were very similar across Men's Email, Women's Email,
and No Email. The bias-corrected Cramer's V values were effectively zero at the
reported precision.

Together with the very small SMDs from the numeric/binary balance analysis,
the evidence indicates strong observed balance across the measured
pre-treatment covariates.


## D019 — SQL analytical layer
A local DuckDB database will be used for reproducible SQL analysis.
The `customer_experiment` table preserves the customer-level experiment grain:
one row represents one customer.

The SQL layer will be used for aggregations, reconciliation, and analytical
tables. Python/Jupyter will be used for statistical inference, bootstrap,
power analysis, and uplift modeling.


## D021 — Primary experiment outcome
Conversion is treated as the primary behavioral outcome because the core
business question is whether the email increased purchasing behavior.

Visit is treated as a secondary engagement outcome, while spend is treated as
the primary economic outcome.

## D022 — Conversion inference
For treatment-versus-control conversion comparisons, absolute conversion-rate
difference is the primary effect size.

Relative lift is reported as a secondary descriptive metric.

Two-sided hypothesis tests with alpha = 0.05 and 95% confidence intervals are
used. Confidence intervals for the difference in independent proportions use
Newcombe's method.

Raw p-values are retained for transparency but will not be treated as final
significance decisions until the planned multiple-comparison adjustment is
applied.

## D024 — Visit results

Both email treatments showed positive observed visit lift relative to No Email.

Men's Email:
- Absolute lift: +7.6590 percentage points
- Nominal 95% CI: +6.9953 to +8.3227 percentage points

Women's Email:
- Absolute lift: +4.5233 percentage points
- Nominal 95% CI: +3.8894 to +5.1574 percentage points

These intervals and the current p-values are unadjusted for multiple
comparisons. Final significance decisions will account for the planned
treatment-outcome comparisons.

Higher visit rates alone do not establish that a campaign is economically
profitable.

-- FROM STAGE 3C

## D025 — Spend bootstrap results

Customer-level mean spend was compared between each treatment and the
No Email control. Percentile bootstrap confidence intervals were estimated
using 3,000 resamples.

Men's Email:
- Estimated spend lift per customer: +0.7698
- Nominal 95% bootstrap CI: 0.5017 to 1.0603

Women's Email:
- Estimated spend lift per customer: +0.4244
- Nominal 95% bootstrap CI: 0.1775 to 0.6749

Both intervals are above zero. These are unadjusted statistical results,
not estimates of incremental profit. Campaign costs and contribution
margin remain to be evaluated.

## D026 — Multiple-testing adjustment

The six planned treatment-versus-control comparisons were adjusted using
Holm's procedure to control the family-wise error rate at alpha = 0.05.

All six comparisons remained statistically significant after adjustment.

The adjusted p-values support evidence of treatment effects relative to
the no-email control. They do not establish that Men's Email is statistically
superior to Women's Email because a direct treatment-versus-treatment
comparison has not yet been performed.

The confidence intervals calculated earlier remain nominal 95% intervals.
They have not been adjusted to provide simultaneous coverage across all six
comparisons.


## D027 — Conversion power and MDE

MDE was estimated for 80% power under two-sided tests, using both the
0.9% conversion baseline from the project brief and the observed control
baseline in the dataset.

Using the observed control conversion rate of approximately 0.5726%:
- Standard alpha = 0.05: MDE was approximately 0.223 percentage points.
- Conservative alpha = 0.05/6: MDE was approximately 0.282 percentage points.

These are approximate planning estimates based on a two-independent-proportions
power calculation. They are not guarantees of detection or substitutes for
the observed treatment-effect estimates and confidence intervals.


## D028 — Direct conversion comparison

Men's Email had an observed conversion rate of 1.25311%, compared with
0.88371% for Women's Email.

The observed difference (Men's minus Women's) was +0.36939 percentage points,
with a nominal 95% confidence interval of +0.17463 to +0.56626 percentage
points and a raw p-value of 0.00021.

This is a secondary head-to-head comparison. Its final significance
interpretation will account for multiple testing within the planned
head-to-head outcome family. It does not, on its own, determine which
campaign is more profitable.

## D029 — Direct visit comparison

Men's Email had an observed visit rate of 18.27568%, compared with
15.14004% for Women's Email.

The observed difference (Men's minus Women's) was +3.13565 percentage points,
with a nominal 95% confidence interval of +2.42841 to +3.84277 percentage
points.

The confidence interval indicates a positive difference before adjustment
for the planned head-to-head outcome comparisons. The displayed p-value
of 0.0 is a precision/formatting artifact, not an exact zero probability.

## D030 — Exploratory historical-spend segmentation

Treatment-control outcomes were compared within each historical-spend segment.
Men's Email showed positive observed conversion lift across all seven segments.
Women's Email showed mixed observed conversion lift, including negative
estimates in two middle segments.

These subgroup results are descriptive and exploratory. Segment sizes and
conversion counts vary, and no segment-specific uncertainty or multiple-testing
adjustment has yet been applied. These point estimates alone will not determine
the final targeting policy.


## D031 — Campaign economics sensitivity

Campaign economics were estimated under illustrative contribution margins
of 20%, 30%, and 40%, and assumed email costs of $0.01, $0.10, and $0.25
per recipient.

The estimated financial outcome changes materially with the assumptions.
Men's Email has a higher estimated spend lift per customer and therefore
a higher break-even email cost at the same contribution margin.

These are scenario estimates, not observed profits or verified industry
benchmarks. Profit intervals reflect uncertainty in spend lift under fixed
margin and cost assumptions; they do not capture uncertainty in the
assumptions themselves.

No final deployment recommendation will be made until the business confirms
the relevant cost and margin inputs.

## D032 — Uplift modeling conclusion

A two-model T-learner was trained for each email treatment versus control,
using pre-treatment customer characteristics.

The models were evaluated on randomized holdout data using policy gains,
Qini-style area, bootstrap uncertainty, repeated train/holdout splits,
and a historical-spend ranking baseline.

Men's Email:
- The historical-spend baseline had a higher Qini-style area than the T-learner.
- The T-learner's Qini-style area changed sign across the three splits.

Women's Email:
- The T-learner had a higher Qini-style area than the historical-spend baseline
  on the initial holdout.
- Its Qini-style area was positive across three splits, but bootstrap uncertainty
  did not establish a reliably positive overall ranking advantage.

These evaluations are exploratory and use the same underlying dataset.
The repeated splits are not independent experiments, and the holdout was
used during model development.

The T-learner is therefore retained as a portfolio prototype. No claim is made
that individual-level targeting or any targeting fraction is optimal.
