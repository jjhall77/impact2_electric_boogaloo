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

## 2026-03-08 | Phase 3 staggered-DD extensions complete

### Panel construction

Built a balanced quarterly panel (6,274 fids x 36 quarters = 225,864
rows) by aggregating incident-level data to fid x quarter and filling
zeros. Treatment cohorts defined by earliest impact zone activation,
consolidated to 9 annual cohorts (2004-2012). 4,697 never-treated fids
serve as controls.

### Sun & Abraham (2021)

Interaction-weighted estimator via `fixest::sunab()`. Aggregate ATTs:
- Total crime: -0.057 (SE 0.112) — attenuated vs TWFE OLS (-0.213)
- Robbery: -0.335 (SE 0.074)
- Violent Felony: +0.836 (SE 0.289) — sign flip vs Poisson TWFE

The attenuation suggests treatment effect heterogeneity across cohorts.
Large SEs are typical for interaction-weighted estimators with many
relative-period coefficients on sparse count data.

### Goodman-Bacon (2021) decomposition

Run on a matched subsample (1,577 treated + 1,577 never-treated fids).
Weight decomposition:
- Treated vs Untreated: 64.7% weight, avg estimate -0.239
- Later vs Earlier Treated: 14.5% weight, avg estimate -0.030
- Later vs Always Treated: 13.9% weight, avg estimate +0.358
- Earlier vs Later Treated: 7.0% weight, avg estimate -0.298

Weighted average (-0.130) matches the full-panel TWFE. Most weight
(65%) falls on clean treated-vs-untreated comparisons, suggesting
limited forbidden-comparison bias.

### Callaway & Sant'Anna (2021)

Group-time ATTs using never-treated controls. Overall ATT = -0.857
(SE 0.342). Dropped 339 fids in the earliest cohort (no pre-treatment
data). Group-specific ATTs show strong heterogeneity: early cohorts
(2005: -1.34, 2006: -2.00) show large effects; later cohorts (2007-2011)
show smaller or positive effects.

### Key finding

All staggered-DD estimators confirm a directionally negative effect of
Operation Impact on crime, but magnitudes and precision vary. The Bacon
decomposition is reassuring: the TWFE result is primarily driven by
clean comparisons. The heterogeneity across cohorts (larger effects for
early zones) is substantively interesting and warrants further analysis.

## 2026-03-08 | Extension plan drafted (EXTENSION_PLAN.md)

Created a comprehensive plan for extending the analysis past the last
Operation Impact iteration (2012) through 2019, exploiting the post-Floyd
v. City of New York (2013) enforcement collapse and the de Blasio
mayoral transition (2014) as natural experiments.

### Key components

- **6 open questions** identified from the original paper: treatment
  effect durability, mechanism decomposition (deterrence vs incapacitation),
  treatment effect heterogeneity across cohorts, spillover dynamics,
  racial disparities in enforcement, and differential crime category
  responses to enforcement withdrawal.

- **3 research designs:** (1) Extended panel 2004-2019 with active vs
  post-enforcement treatment indicators, (2) DDD (zone × activation ×
  enforcement era), (3) staggered treatment reversal using heterogeneous
  timing of the enforcement collapse.

- **Data requirements:** NYPD complaint data, arrest data, and SQF
  microdata from NYC Open Data (2013-2019), Census TIGER/Line block
  geography, plus existing impact zone shapefiles through Impact 22.

- **Modern econometric methods:** Borusyak-Jaravel-Spiess imputation
  estimator, de Chaisemartin-D'Haultfoeuille for treatment intensity,
  Synthetic DiD, and Regression Discontinuity in Time around the Floyd
  decision.

- **Literature suggestions** spanning staggered DD methodology, policing
  and crime economics, and stop-and-frisk/Floyd v. NYC research.

### File organization

- Moved `Operation Impact Zones/` from project root to `data-raw/`
- Extension plan saved as `EXTENSION_PLAN.md` in project root

## 2026-03-15 | Python cross-validation and 75th Precinct robustness

### Python cross-validation (python/01_model1_replication.py)

Re-estimated all 20 Model 1 coefficients (10 crime + 10 arrest) using
`pyfixest` v0.25.4 (Python port of R `fixest`). Results:

- All 20 coefficients match R within 0.0004 (mean |diff| = 0.0002)
- Confirms treatment effects are not an artifact of the R `fixest`
  implementation
- N values match R exactly for most outcomes
- pyfixest v0.40.1 requires Python 3.10+; used v0.25.4 for Python 3.9
  compatibility

### 75th Precinct exclusion (R/07_robustness_no75.R)

Re-estimated Model 1 excluding precinct 75 (East New York, Brooklyn).
The 75th Precinct has a treatment rate of 55% (vs 11% overall) with
170 unique blocks, representing 3.1% of crime rows and 3.9% of arrest
rows.

Results:
- Zero sign flips across all 20 outcomes
- Crime: mean |diff| = 0.0052, max = 0.0114 (Burglary)
- Arrest: mean |diff| = 0.0070, max = 0.0255 (Burglary)
- All effects remain substantively unchanged, confirming results are not
  driven by a single precinct
- Largest movement: arrest Burglary (0.374 → 0.400), indicating the
  75th Precinct slightly attenuated the burglary arrest coefficient
