# Replication Plan: MacDonald, Fagan & Geller (2016)

## Overview

This plan guides a de novo R replication of all five models (plus robustness
checks) from "The Effects of Local Police Surges on Crime and Arrests in
New York City" (PLOS ONE, 2016). The replication is followed by extensions
using modern staggered-DD estimators.

The core estimator throughout is **conditional fixed-effects Poisson**
(Hausman, Hall & Griliches 1984), implemented via `fixest::fepois()`.

---

## Current State

### Completed

- **`R/01_prep_panels.R`** — loads raw incident-level CSVs, collapses to
  fid x pct x ym panels, constructs all analysis variables:
  - `treatment` (carried from raw data)
  - `treatmentn` (neighbor spillover, built from zone activation dates)
  - Event study dummies (cumulated: `eventneg2`, `eventneg1`, `eventpos1`,
    `eventpos2`)
  - `year_pct_month` FE key
  - Model 4 interactions (`treatmentpc`, `cs_npc`, `treatmentnpc`)
- **`data/crime_panel.rds`** — 681,503 rows (8,256 fid x pct units, 108
  periods)
- **`data/arrest_panel.rds`** — 299,549 rows (7,223 fid x pct units, 90
  periods)

### Known Data Issues

1. **Panel is unbalanced.** Crime: median 101/108 periods per unit. Arrest:
   median 37/90. Conditional FE Poisson handles this naturally (units with
   all-zero outcomes within an FE group drop out).
2. **Blocks span multiple precincts.** 1,588 of 6,274 fids appear in >1
   precinct (up to 8). The observation unit is fid x pct, not just fid.
   This matches the Stata code, which uses `year_pct_month` as the FE
   group — treatment effects are identified from within-precinct-month
   variation across blocks.
3. **Raw data is incident-level**, not pre-aggregated. The collapse step
   sums crime/offense counts within fid x pct x ym. Block-level variables
   (treatment, stops, impact dummies) are constant within each cell and
   taken as first values.

---

## Phase 1: Exact Replication (Models 1-5)

### Script: `R/02_models_crime.R`

All models use **conditional FE Poisson** with cluster-robust SEs.

#### Outcome Variables

The crime and arrest files use different offense column numbers:

| | Crime file | Arrest file |
|---|---|---|
| crimes | crimes1, 3, 5, 6, 7, 10 | crimes1, 3, 5, 6, 7, 10 |
| offenses | offenses7, 15, 47 | offenses8, 18, 57 |
| total | offenses | offenses |

Mapping these to substantive categories requires cross-referencing the
paper's Table 2 / Table 3. The `crimes` variables likely correspond to:
crimes1 = total index crimes, crimes3 = robbery, crimes5 = burglary,
crimes6 = grand larceny, crimes7 = assault, crimes10 = murder + shooting.
Verify against published tables.

#### Model 1: Basic Treatment Effect

```
Stata:  xtpoisson Y treatment, fe i(year_pct_month) robust
fixest: fepois(Y ~ treatment | year_pct_month, data, vcov = "hetero")
```

Target: crimes1 coefficient = **-0.124** (crime), **+0.426** (arrest).

Run for all outcome variables listed above. This is the core specification
that says: within a precinct-month, did blocks in impact zones see fewer
crimes after designation?

#### Model 2: Neighbor Spillover

```
Stata:  xtpoisson Y treatment treatmentn, fe i(year_pct_month) robust
fixest: fepois(Y ~ treatment + treatmentn | year_pct_month, data, vcov = "hetero")
```

Target: treatmentn coefficient = **-0.072** (crime spillover).

Tests whether blocks adjacent to impact zones also saw crime reductions
(displacement vs. diffusion of benefits).

#### Model 3: Event Study

```
Stata:  xtpoisson Y eventneg2 eventneg1 eventpos1 eventpos2,
          fe i(year_pct_month) robust
fixest: fepois(Y ~ eventneg2 + eventneg1 + eventpos1 + eventpos2
          | year_pct_month, data, vcov = "hetero")
```

Target: pre-treatment coefficients near zero (parallel trends), post ~
**-0.10**.

Note: the event dummies are cumulative (neg2 includes neg1 period). These
are +/-2 month windows around designation, not a full dynamic event study.

#### Model 4: PC vs. NPC Stop Interactions

```
Stata:  xtpoisson Y treatment cs_probcause cs_npc treatmentpc treatmentnpc,
          fe i(year_pct_month) robust
fixest: fepois(Y ~ treatment + cs_probcause + cs_npc + treatmentpc
          + treatmentnpc | year_pct_month, data, vcov = "hetero")
```

Targets: treatmentpc = **-0.011**, treatmentnpc = **+0.002**.

Decomposes the treatment effect by stop type: probable-cause stops vs.
non-probable-cause stops, testing whether PC stops drive crime reduction
while NPC stops do not.

#### Model 5: Cubic B-Spline Trend

```
Stata:  xtpoisson Y treatment bs1 bs2 bs3, fe i(fid) robust
fixest: fepois(Y ~ treatment + bs1 + bs2 + bs3 | fid, data, vcov = "hetero")
```

Note: this model switches FE from `year_pct_month` to `fid`, and replaces
time FE with precinct-specific cubic B-spline bases. Requires generating
spline bases per precinct using `splines::bs()`.

### Script: `R/03_models_arrest.R`

Parallel structure to `02_models_crime.R` but with arrest outcomes and the
arrest-specific offense columns (offenses8, 18, 57).

### Script: `R/04_tables.R`

Use `modelsummary` to produce formatted coefficient tables matching the
paper's Tables 2-5. Output to `output/`.

---

## Phase 2: Validation

### Coefficient Comparison

After running all models, populate the replication status table in
`README.md` with replicated coefficients. Acceptable tolerance: coefficients
within ~10% of published values (differences may arise from Stata vs. R
numerical precision, or from the incident-level collapse).

### Diagnostics to Log

Record in `logs/CHANGELOG.md`:
- Any outcome variables that cannot be identified (column name mapping)
- Observations dropped by conditional FE Poisson (all-zero groups)
- Differences in N between our panels and the paper's reported N
- Coefficient discrepancies exceeding tolerance and hypothesized causes

### Robustness: Permutation Test

The paper reports a placebo/permutation test (max placebo coefficient =
-0.020 vs. true effect of -0.124). This is not in the provided Stata code.
Implementation:
1. Randomly reassign treatment across blocks (maintaining treatment rate)
2. Re-estimate Model 1
3. Repeat 1,000 times
4. Compare distribution of placebo coefficients to true estimate
5. Report p-value and plot distribution

Script: `R/05_permutation.R`

---

## Phase 3: Extensions

### 3a. Staggered-DD Estimators

The original paper uses a conventional TWFE-style approach. With 15 impact
zones activated over 9 years, treatment timing is staggered, making the
TWFE estimator potentially biased under heterogeneous treatment effects
(Goodman-Bacon 2021).

**Goodman-Bacon decomposition** (`bacondecomp`): Decompose the TWFE
estimate into timing-group components. Shows whether "forbidden
comparisons" (late-treated as controls for early-treated) drive the result.

**Callaway & Sant'Anna** (`did` package): Estimate group-time ATTs using
never-treated or not-yet-treated as controls. Aggregate to overall ATT and
dynamic event study. Requires defining cohorts by first treatment period
(map impact zone to activation date).

**Sun & Abraham** (`fixest::sunab()`): Interaction-weighted estimator
directly in fixest. Drop-in replacement for Model 1 specification. Compare
IW estimate to conventional TWFE.

Key implementation decision: the unit of analysis. The current panel has
`fid x pct` as the unit. For staggered-DD, we need a clean cohort
assignment per unit. Blocks in multiple precincts or multiple impact zones
need careful handling. Consider collapsing to fid-level (summing across
precincts) for the extension analysis.

Script: `R/06_staggered_dd.R`

### 3b. Block-Level Re-Analysis

The original analysis is at the census block group level with
precinct-month FE. The extension would use block-level data (if available)
for finer spatial resolution. Depends on data access.

### 3c. Racial Disparity Decomposition

Extend Model 4 by examining racial composition of stops. The data contains
stop-and-frisk variables but racial breakdowns would need additional SQF
microdata (available from NYC open data for 2003-2013).

### 3d. Post-Floyd Reform Period

Examine whether the policing patterns identified in the 2004-2012 period
changed after the Floyd v. NYC ruling (2013) and subsequent reforms.
Requires extending the panel with post-2012 crime data from NYC open data.

---

## File Map

```
R/
  01_prep_panels.R       [done]  Load, collapse, construct variables
  02_models_crime.R      [todo]  Models 1-5, crime outcomes
  03_models_arrest.R     [todo]  Models 1-5, arrest outcomes
  04_tables.R            [todo]  Formatted output tables
  05_permutation.R       [todo]  Permutation test robustness
  06_staggered_dd.R      [todo]  Callaway-Sant'Anna, Sun-Abraham, Bacon

data-raw/                        Raw CSVs (gitignored)
data/                            Processed .rds panels (gitignored)
output/                          Tables and figures (gitignored)
logs/CHANGELOG.md                Analysis decisions and discrepancies
```

---

## Immediate Next Steps

1. **Map outcome variable names to paper tables.** Confirm which `crimes`
   and `offenses` columns correspond to which substantive categories.
2. **Write `R/02_models_crime.R`.** Start with Model 1 (crimes1) and
   compare coefficient to -0.124.
3. **Iterate.** If coefficient matches, run all crime outcomes and models.
   If not, diagnose: check N, check FE specification, check collapse logic.
4. **Repeat for arrests** in `R/03_models_arrest.R`.
5. **Format tables** and update `README.md` status.
