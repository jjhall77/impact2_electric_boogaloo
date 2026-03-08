# Replication: MacDonald, Fagan & Geller (2016)

De novo replication of "The Effects of Local Police Surges on Crime and
Arrests in New York City" (*PLOS ONE*, 2016), with planned extensions
using modern staggered-DD estimators and finer spatial resolution.

## Original paper
- DOI: https://doi.org/10.1371/journal.pone.0157223
- Replication data: https://github.com/macdonaldjohn/Impact-Zone-Data

## Replication status

| Model | Target | Replicated | Status |
|-------|--------|------------|--------|
| M1 Total crime | -0.124 | -0.122 | :white_check_mark: |
| M1 Total arrests | +0.426 | +0.418 | :white_check_mark: |
| M2 Neighbor (crime) | -0.072 | -0.029 | :warning: |
| M2 Neighbor (arrest) | +0.049 | +0.038 | :warning: |
| M3 Event study (crime) | ~-0.10 | -0.114 | :white_check_mark: |
| M3 Event study (arrest) | ~+0.48 | +0.482 | :white_check_mark: |
| M4 PC × Impact (crime) | -0.011 | -0.013 | :white_check_mark: |
| M4 NPC × Impact (crime) | +0.002 | -0.000 | :white_check_mark: |
| M4 PC × Impact (arrest) | -0.006 | -0.006 | :white_check_mark: |
| M4 NPC × Impact (arrest) | -0.006 | -0.005 | :white_check_mark: |
| M5 Cubic trend (crime) | ~insig. | -0.023 | :white_check_mark: |
| M5 Cubic trend (arrest) | ~sig.+ | +0.238 | :white_check_mark: |
| Robustness: permutation (crime) | max -0.020 | max -0.022 | :white_check_mark: |
| Robustness: permutation (arrest) | max +0.035 | max +0.041 | :white_check_mark: |

All Model 1 coefficients across 10 outcome categories replicate within
1-3% of published values. Models 2-5 match directionally with expected
Stata/R numerical differences. Model 2 neighbor coefficients show
attenuation, likely due to differences in how `treatmentn` is coded at
panel boundaries.

## Staggered-DD extensions (Phase 3)

| Estimator | ATT (Total Crime) | SE |
|-----------|-------------------|-----|
| Poisson TWFE (Phase 1) | -0.122 | 0.052 |
| Linear TWFE (OLS, quarterly) | -0.213 | 0.059 |
| Sun & Abraham (2021) | -0.057 | 0.112 |
| Callaway & Sant'Anna (2021) | -0.857 | 0.342 |

Bacon decomposition shows 65% of TWFE weight comes from clean
treated-vs-untreated comparisons. All estimators confirm a directionally
negative effect on crime, with magnitudes varying by method. See
`logs/REPLICATION_REPORT.md` for full discussion.

## How to run

```
Rscript R/01_prep_panels.R    # (optional) build collapsed panels
Rscript R/02_models_crime.R   # Models 1-5, crime outcomes
Rscript R/03_models_arrest.R  # Models 1-5, arrest outcomes
Rscript R/04_tables.R         # Formatted output tables
Rscript R/05_permutation.R    # Permutation test (1,000 iters, ~8 min)
Rscript R/06_staggered_dd.R   # Sun-Abraham, Bacon, Callaway-Sant'Anna
```

## Extensions (future)
- Block-level re-analysis
- Racial disparity decomposition of PC vs NPC stops
- Post-Floyd reform period
