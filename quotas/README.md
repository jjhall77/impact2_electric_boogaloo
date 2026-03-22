# SQF Quota Analysis

Separate investigation into whether NYPD officers faced implicit or explicit
monthly stop quotas, using temporal patterns in SQF data (2006–2016).

## Data

SQF files in `../data-raw/sqf/` (2006–2016, ~4.19M stops).

Key fields:
- `datestop`: exact date (MMDDYYYY)
- `timestop`: time (HHMM)
- `pct`: precinct
- `arstmade`: arrest made (Y/N)
- `contrabn`: contraband found (Y/N)
- `wepfound`: weapon found (Y/N)
- `frisked`, `searched`: frisk/search flags
- `cs_*`: circumstance/reason codes (furtive movements, etc.)
- Various force fields (`pf_*`)

**No individual officer IDs available.** `ser_num` is a sequential counter,
not a badge number. Analysis must be at precinct-day or citywide-day level.

## Analyses

1. `01_within_month_timing.py` — Hockey-stick test: daily stop counts by
   day-of-month, controlling for day-of-week
2. `02_first_of_month_cliff.py` — Discontinuity at month boundaries
3. `03_quality_degradation.py` — Stop quality (arrest rate, hit rate) by
   day-of-month position
4. `04_precinct_heterogeneity.py` — Do some precincts show stronger patterns?
   (proxy for command-level quota pressure)

## Limitations

- No officer-level analysis possible (no badge/shield numbers in data)
- Cannot do McCrary bunching test on officer-month totals
- Precinct-level patterns may reflect shift scheduling, not quotas
- Academy class deployment (Jan/Jul spikes) is a confounder for monthly patterns
