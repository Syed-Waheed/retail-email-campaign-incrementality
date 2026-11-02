# Retail Email Campaign Incrementality

## Business problem
A retailer randomized 64,000 customers into Men's Email, Women's Email, or No Email and observed visits, conversions, and spend over the following two weeks. The objective is to estimate incremental campaign impact, compare the two treatments, and assess whether sending an email is economically worthwhile.

**Dataset source:** Kevin Hillstrom, *The MineThatData E-Mail Analytics and Data Mining Challenge* (2008). The original source describes 64,000 customers, randomized email/control arms, the two-week response window, pre-treatment covariates, and post-treatment visit, conversion, and actual-dollar spend. Source: https://blog.minethatdata.com/2008/03/minethatdata-e-mail-analytics-and-data.html

## Dashboard screenshot + Tableau Public link
**Status: pending publication.** Do not claim a Tableau Public URL until the dashboard is published. Follow `dashboard/tableau_build_spec.md`, then place the real URL in `dashboard/tableau_link.txt` and save the published dashboard screenshot as `dashboard/screenshot.png`.

## TL;DR
- Men's Email conversion lift vs No Email: **+0.6805 percentage points** (nominal 95% CI: +0.5014 to +0.8641 pp; Holm-adjusted p ≈ 6.093e-13).
- Women's Email conversion lift vs No Email: **+0.3111 percentage points** (nominal 95% CI: +0.1502 to +0.4745 pp; Holm-adjusted p ≈ 4.713e-4).
- Men's Email visit lift: **+7.6590 pp**; Women's Email visit lift: **+4.5233 pp**. Both confidence intervals were above zero.
- Mean spend lift per randomized customer: **+$0.7698** for Men's Email and **+$0.4244** for Women's Email. Bootstrap intervals were above zero; p-values used permutation tests.
- The uplift model's holdout ranking results were mixed. Treat targeting results as exploratory, not as a validated optimal policy. Campaign cost and contribution margin were not supplied by the dataset.

## Business question
Did either email generate incremental outcomes versus the randomized No Email control? Which treatment performs better? Are the results statistically and practically meaningful? Who should receive an email, and is it worthwhile after campaign cost and contribution margin?

## Data and scope
- 64,000 observations; the intended grain is one row per customer.
- Men's Email: 21,307; Women's Email: 21,387; No Email: 21,306.
- Pre-treatment covariates include recency, previous-year history/spend, past men's/women's purchase flags, ZIP category, new-customer indicator, and purchasing channel.
- Post-treatment outcomes include visit, conversion, and spend over a two-week window.
- All findings are specific to this historical retailer experiment and its observation window.

## Approach
1. Audited missingness, data types, binary fields, business-rule consistency, duplicates, and numeric tails without modifying raw records.
2. Checked pre-treatment randomization balance using standardized mean differences for numeric/binary variables and category proportions/Cramér's V for categorical variables.
3. Used DuckDB SQL aggregations to create arm-level and historical-spend segment tables; reconciled the SQL aggregation to all 64,000 source rows.
4. Estimated treatment-control rate differences, Newcombe confidence intervals for binary outcomes, two-proportion tests, bootstrap intervals for spend, and permutation p-values for spend.
5. Applied Holm correction to six planned treatment-control tests. Separately adjusted the three head-to-head Men's-vs-Women's comparisons.
6. Calculated power/MDE sensitivity under both the observed control conversion rate and the 0.9% rate stated in the project brief.
7. Fit a two-model/T-learner logistic-regression uplift baseline on pre-treatment covariates and evaluated it on a 30% holdout.
8. Created a formula-driven Excel economics sensitivity calculator with explicit editable assumptions.

## Findings
All six treatment-control comparisons remained statistically significant after Holm correction at alpha 0.05. Men's Email also showed higher observed visit, conversion, and spend outcomes than Women's Email; the three direct comparisons remained significant after their separate Holm correction.

The conversion lift differences between the two email treatments should be reported in percentage points, not confused with relative percentage lift. The nominal confidence intervals in the scorecard were not adjusted to provide simultaneous coverage across all tests.

### Randomization and data integrity
- No missing values were found in the supplied dataframe.
- Binary variables had only 0/1 values; no negative recency/history/spend values, no conversion-without-visit rows, and no conversion/spend consistency violations were observed.
- The largest absolute SMD among checked numeric/binary covariates was 0.008631, indicating very small observed imbalance. Channel and ZIP proportions were also close across arms; bias-corrected Cramér's V displayed as 0.000000 to six decimals.
- There were 6,562 extra exact duplicate rows beyond the first appearance, with 7,634 rows involved in duplicated groups. As the available table did not include a customer ID, identical records could not be proven to represent duplicate customers; none were deleted.
- `history_segment` was validated as a bucketed representation of `history`; avoid treating both as independent feature signals without a specific justification.

## Experiment and model interpretation
Random assignment supports causal interpretation of treatment-versus-control average effects for the randomized population, assuming the assignment and analysis are handled as designed. Customer characteristics themselves were not randomized. Segment comparisons are exploratory, and the T-learner's individual-level uplift scores should not be treated as unquestionable causal truth.

The model holdout showed mixed ranking performance: the custom Qini-style area was negative for Men's Email (-6.486) and positive for Women's Email (+8.625). These are exploratory diagnostics from one holdout; the same holdout was used to compare several targeting fractions, so choosing a fraction based on these results risks policy-selection bias. Validate any proposed policy on a new independent sample or using a cross-fitting design before deployment.

## Business economics
The Excel calculator varies illustrative contribution margins (20%, 30%, 40%) and assumed email costs ($0.01, $0.10, $0.25 per recipient). These values are scenarios, not observed inputs or industry benchmarks. Under a 30% contribution-margin and $0.10/email scenario, the estimated incremental profit is approximately $2,790 for Men's Email and $584 for Women's Email; uncertainty intervals depend on the fixed assumptions, and Women's Email's interval crosses zero. This is not a verified profit forecast. Obtain business-approved cost and margin inputs before making a rollout decision.

## Limitations
- One historical retailer experiment from 2008; outcomes observed over two weeks.
- No customer ID in the supplied 12-column table, so exact duplicate rows cannot be distinguished from different customers with identical attributes/outcomes.
- Subgroup comparisons were exploratory and not adjusted for all possible slicing.
- The uplift baseline used a T-learner with logistic regression; low conversion counts make targeting estimates noisy.
- The holdout targeting fractions were compared on the same holdout; final policy choice requires independent validation.
- Economics depend on explicit assumptions for margin and email cost.

## How to reproduce
1. Create a Python environment and install `requirements.txt`.
2. Run `python data/download_data.py` from the project root to download the public CSV into `data/raw/hillstrom.csv`.
3. Save your working Jupyter notebook into `notebooks/01_experiment_analysis.ipynb`; use `notebooks/README.md` for the current notebook layout and workflow.
4. Load the CSV in Pandas, create a local DuckDB database, and execute the SQL files under `sql/` from Jupyter. VS Code SQL execution is optional; the SQL source files remain version-controlled and reproducible.
5. Re-run statistical analysis in Jupyter and refresh the workbook after changing any inputs or results.
6. Build and publish the Tableau dashboard using the guidance in `dashboard/tableau_build_spec.md`.

## Deliverables in this package
- `reports/retail_email_decision_workbook.xlsx`: master scorecard, head-to-head tests, segment effects, uplift policy diagnostics, assumption sheet, formula-driven economics calculator, and limitations.
- `DECISIONS.md` and `GLOSSARY.md`: decision log and terms.
- `reports/decision_memo.md`, `reports/resume_bullets.md`, and `reports/interview_defense.md`.
- `sql/` source queries and `data/download_data.py`.
- Tableau publication remains pending; no link or screenshot has been fabricated.
