# Changelog

Running log of analysis decisions, results, and discrepancies encountered
during replication.

## Format
Each entry: `YYYY-MM-DD | topic | notes`

---

## 2026-03-08 | Phase 1 replication complete

### Data structure discovery

Raw CSVs are at **incident level**, not block-month aggregated. Each row
is an offense/arrest record with lawcode identifiers. Block-level variables
(treatment, stops, impact dummies) are constant within fid x pct x ym and
repeated across records. Models must be run on raw uncollapsed data to
match the paper's N (~840K crime, ~342K arrest).

The collapsed panel (01_prep_panels.R → data/*.rds) produces incorrect
coefficients for the Poisson models. It remains useful for descriptive
statistics and future extensions.

### Variable-to-label mapping

Column names in the data do **not** follow the order of the paper's table
columns. Mapping was confirmed empirically by matching Model 1 coefficients:

| Code (crime) | Code (arrest) | Paper label |
|---|---|---|
| crimes1 | offenses | Total |
| offenses47 | offenses57 | Robbery |
| offenses15 | offenses18 | Assault |
| offenses7 | offenses8 | Burglary |
| crimes10 | crimes10 | Weapons |
| crimes7 | crimes7 | Misd. |
| crimes6 | crimes6 | Other Felony |
| crimes5 | crimes5 | Drugs |
| crimes3 | crimes3 | Property Felony |
| offenses | crimes1 | Violent Felony |

### treatmentn construction

The Stata code uses `year==YYYY` (not `year>=YYYY`) when building the
neighbor spillover indicator. This means `treatmentn` is coded only in
the activation year of each impact zone, not persistently across all
subsequent years. Initial implementation with `>=` produced attenuated
Model 2 neighbor coefficients; switching to `==` improved the match but
some attenuation remains (crime neighbor: -0.029 vs target -0.072).

### Coefficient comparison: Model 1

All 20 coefficients (10 crime + 10 arrest) replicate within 3% of
published values. Largest absolute discrepancy: Property Felony arrests
(1.146 vs 1.174, diff = -0.028). Typical discrepancy: 0.002-0.005.

| | Max |diff| | Mean |diff| | Direction match |
|---|---|---|---|
| Crime (10 outcomes) | 0.012 | 0.005 | 10/10 |
| Arrest (10 outcomes) | 0.028 | 0.008 | 10/10 |

### N differences

Crime N differences between ours and paper are small (0-450 obs), driven
by fixest's singleton/zero-outcome group dropping. Arrest N differences
are slightly larger (5-1400 obs), possibly due to Stata vs R handling of
missing values in the arrest panel.

Observations dropped by conditional FE Poisson (crime Model 1):
- Largest: Other Felony (42,503 dropped) — many zero-count groups
- Smallest: Violent Felony (12 dropped)

### Model 2-5 notes

- **Model 2 (Neighbor):** Impact coefficients match well. Neighbor
  coefficients are directionally correct but attenuated compared to
  published values. Likely cause: subtle differences in how singleton
  observations are handled when treatmentn has lower variation.
- **Model 3 (Event study):** Event dummy coefficients are consistent with
  the paper's Figure 3 pattern (pre-treatment near zero, post negative).
- **Model 4 (PC vs NPC):** Interaction coefficients match closely
  (within 0.001-0.003 for most outcomes).
- **Model 5 (Cubic trend):** Qualitative results match the paper's
  description: treatment effect shrinks and becomes insignificant for
  total crime, but robbery/assault/burglary remain significant. Arrest
  effects remain positive and significant.

## 2026-03-08 | Phase 2 validation complete

### Permutation test (R/05_permutation.R)

Shuffled treatment assignment within year_pct_month groups 1,000 times
and re-estimated Model 1. Results replicate the paper's finding that the
true estimates fall far outside the placebo distribution.

| | True coef | Placebo range | Placebo SD | Paper max placebo |
|---|---|---|---|---|
| Crime (Total) | -0.122 | [-0.022, +0.016] | 0.006 | -0.020 |
| Arrest (Total) | +0.418 | [-0.035, +0.041] | 0.012 | +0.035 |

- p < 0.001 for both crime and arrest (0/1000 placebo coefficients
  exceeded the true estimate in either direction)
- Our max placebo for crime (-0.022) is very close to the paper's (-0.020)
- Our max placebo for arrest (+0.041) is close to the paper's (+0.035)
- Placebo distributions are centered at zero as expected
- Plots saved to output/permutation_crime.png and output/permutation_arrest.png

### SE differences

Standard errors are generally within 10-20% of published values. Our SEs
tend to be slightly larger, consistent with fixest's default clustering
behavior vs Stata's sandwich estimator. The paper reports SEs "clustered
by precinct-month-year", which aligns with clustering at year_pct_month.
