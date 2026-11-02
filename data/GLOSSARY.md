## Exact Duplicate Row
A record whose complete set of column values matches another record exactly.
An exact duplicate row is not necessarily a duplicate customer when a unique
customer identifier is unavailable.

## Randomization Balance
The extent to which treatment groups are comparable on pre-treatment
characteristics. Balance is assessed using descriptive differences rather
than relying only on statistical significance.

## Experimental Arm
One of the groups created by the experiment: Men's Email, Women's Email,
or No Email.

## Right-Skewed Distribution
A distribution where a relatively small number of large values create a long
tail toward higher values.

## Zero-Heavy Distribution
A distribution containing a very large proportion of zero observations.

## Outlier
An observation that is unusually far from the rest of the data. An outlier is
not automatically an error and should not be removed without evidence.

## Standardized Mean Difference (SMD)
A scale-independent measure of the difference between groups on a variable.
It expresses the group difference relative to the variable's variability,
making differences across variables easier to compare.

Small absolute SMD values indicate that groups are similar on the measured
pre-treatment characteristic.

## Cramér's V
An effect-size measure for the association between two categorical variables.
It ranges from 0 to 1, where values closer to 0 indicate weaker association.

In this project it is used as a descriptive diagnostic for whether experimental
assignment is associated with categorical pre-treatment characteristics.


## DuckDB
A lightweight analytical SQL database suitable for local data analysis.
It allows the project to maintain a reproducible SQL analysis layer without
requiring a separate database server.

