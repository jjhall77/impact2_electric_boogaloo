# Research Plan: Does Police Presence Reduce Crime?

## Central Question

**Does the mere presence of police officers at hot spots reduce crime,
independent of enforcement activity (stops, arrests)?**

Operation Impact (2003–2015) provides a rare natural experiment to
disentangle presence from enforcement. Officers were deployed to
designated impact zones throughout the program's life, but their
enforcement activity — measured by stop-and-frisk encounters — changed
dramatically over time. Three distinct regimes emerged:

| Regime | Period | Officers present? | SQF activity |
|--------|--------|:-----------------:|:------------:|
| **Presence + Enforcement** | 2006–2011 | Yes | High (470K–686K/yr) |
| **Presence Only** | 2012–mid 2015 | Yes | Collapsing → near zero |
| **Neither** | After 7/1/2015 | No (zones dissolved) | Zero |

The transition from Regime 1 to Regime 2 was driven by the citywide
collapse of SQF, which began in early 2012 — well before the Floyd v.
NYC ruling (Aug 2013). NPC stops fell 93% from 2011 to 2014 while
officers remained assigned to impact zones. The formal dissolution of
Operation Impact on July 1, 2015 removed both presence and enforcement.

### Competing predictions

| Theory | Prediction: Regime 2 (presence only) | Prediction: Regime 3 (neither) |
|--------|--------------------------------------|--------------------------------|
| **Presence hypothesis** (Nagin et al. 2015, Koper 1995) | Crime stays low — officers are still there | Crime rebounds — officers leave |
| **Enforcement hypothesis** (standard deterrence) | Crime rebounds — stops gone, deterrence gone | Crime stays low or rebounds further |
| **Null / structural factors** | Crime stays low — other factors drive trends | Crime stays low — policing never mattered |

---

## Outcomes

| Outcome | Components (OFNS_DESC) |
|---------|------------------------|
| **Violent crime** | Murder & non-negl. manslaughter, Robbery, Felony assault |
| **Property crime** | Burglary, Grand larceny, Grand larceny of motor vehicle |

---

## Spatial Unit: H3 Hexagonal Grid

Uniform hexagonal grid (Uber H3, resolution 9, ~0.11 km² per cell)
overlaid on NYC. Each complaint, arrest, and SQF record is assigned to
a hex via its lat/lon coordinates. Impact zone membership is determined
by centroid-in-polygon overlay with the impact zone shapefiles.

Advantages over census blocks: uniform area, exactly 6 equidistant
neighbors (clean spillover analysis), no MAUP, politically neutral.

### Implementation

- Python `h3` library: `h3.latlng_to_cell(lat, lng, resolution=9)`
- Spatial join: `shapely` / `geopandas` for overlay with impact zone
  polygons (Impacts 1–22 + Jan 2015 updated zones)
- Neighbor rings: `h3.grid_ring(cell, k)` for spillover analysis
- Panel: hex × month, Jan 2006 – Dec 2016

---

## Phase 0: Data Preparation

### 0a. H3 Grid Construction
1. Assign every complaint, arrest, and SQF record to an H3 res-9 cell
2. Overlay impact zone shapefiles (all iterations) onto the grid
3. For each hex, determine: ever-treated, first treatment date, which
   iterations it was in
4. Define neighbor rings (ring 1 = adjacent hexes)

### 0b. Panel Construction
1. Aggregate to hex × month: crime counts (violent, property), arrest
   counts, SQF counts (total, PC, NPC)
2. Fill zeros for hex-months with no events
3. Merge treatment indicators and enforcement intensity measures
4. Create precinct × year-month fixed effect identifiers

### 0c. SQF Crosswalk
1. Harmonize field names across SQF annual files (2006–2016)
2. Classify each stop as PC or NPC using MacDonald et al. criteria
3. Validate: do annual PC/NPC totals match known benchmarks?

---

## Phase 1: Baseline Replication (2006–2012)

**Goal:** Validate the hex grid approach by replicating MacDonald et al.'s
core finding — impact zones reduced crime during the high-enforcement
period.

### Specification

Conditional fixed-effects Poisson:

```
Y_ht ~ treatment_ht | precinct_yearmonth_h
```

- `Y_ht` = crime count (violent or property) in hex h, month t
- `treatment_ht` = 1 if hex is inside an active impact zone
- Fixed effects: precinct × year-month (absorbs all precinct-level
  time-varying shocks)

### Tests

1. Do we recover negative treatment effects on violent and property
   crime, consistent with MacDonald et al.?
2. Neighbor hex effects: displacement vs diffusion?
3. Sensitivity to H3 resolution (res 8 vs 9 vs 10)?
4. Sensitivity to treatment assignment rule (centroid vs area overlap)?

---

## Phase 2: Presence vs. Enforcement (2006–2016)

**Goal:** Test whether police presence alone reduces crime by exploiting
the three enforcement regimes.

### Specification: Three-Regime Model

```
Y_ht ~ treatment_presence_enforcement_ht
     + treatment_presence_only_ht
     + treatment_post_dissolution_ht
     | precinct_yearmonth_h
```

Where:
- `treatment_presence_enforcement` = hex in active zone × high-enforcement
  regime (2006–2011). This is the MacDonald et al. treatment.
- `treatment_presence_only` = hex in active zone × presence-only regime
  (2012 – 6/30/2015). Officers assigned but SQF near zero.
- `treatment_post_dissolution` = hex in former zone × post-dissolution
  (7/1/2015 – 12/2016). Officers reassigned, zones dissolved.

### Key comparisons

| Comparison | What it tests |
|------------|---------------|
| `presence_enforcement` < 0 | Replicates MacDonald et al. (crime reduction during full program) |
| `presence_only` < 0 | **Presence alone reduces crime** |
| `presence_only` ≈ 0 | Presence without enforcement has no effect |
| `presence_only` ≈ `presence_enforcement` | Enforcement adds nothing beyond presence |
| `post_dissolution` > `presence_only` | Crime rebounds when officers leave |
| `post_dissolution` ≈ 0 | No rebound — structural factors sustain gains |

### Regime boundary definitions

The boundary between Regime 1 (presence + enforcement) and Regime 2
(presence only) is defined empirically from the EDA. The SQF inflection
point is approximately Q1 2012 (Impact XVII). We test sensitivity to
this boundary:
- Primary: January 2012 (start of Impact XVII, SQF already falling)
- Alternative 1: July 2012 (Impact XVIII, SQF decline accelerates)
- Alternative 2: January 2013 (Impact XIX, SQF below 200K/year pace)

Dissolution is fixed at July 1, 2015 (official end of Operation Impact).

### Specification: Dose-Response

```
Y_ht ~ pc_stops_ht + npc_stops_ht + treatment_ht | precinct_yearmonth_h
```

Replaces the binary regime indicators with continuous enforcement
intensity. Tests whether:
- PC stops reduce crime (MacDonald et al. Model 4 finding)
- NPC stops have no effect (MacDonald et al. Model 4 finding)
- The treatment indicator captures residual presence effects beyond
  what stop counts explain

If `treatment_ht` remains significant after controlling for stop
intensity, that is direct evidence of a presence effect.

---

## Phase 3: Event Study Around Dissolution (7/1/2015)

**Goal:** Trace the dynamic path of crime in former impact zones before
and after officers are withdrawn.

### Specification

```
Y_ht ~ Σ_k β_k × 1(t = dissolution + k) × ever_treated_h
     | precinct_yearmonth_h
```

Event study with monthly leads/lags around July 2015, ±12 months.
Estimated separately for violent and property crime.

### What to look for

- **Pre-dissolution coefficients near zero:** Impact zones and controls
  were trending similarly before dissolution (parallel trends validation)
- **Post-dissolution coefficients > 0:** Crime increases after officers
  leave — supports presence hypothesis
- **Post-dissolution coefficients ≈ 0:** No rebound — officers weren't
  doing anything, or structural factors dominate
- **Timing of rebound (if any):** Immediate (within 1–2 months) suggests
  deterrence. Gradual (3–6 months) suggests offenders slowly learn
  about reduced police presence (Koper curve in reverse)

---

## Phase 4: Modern Causal Methods

### 4a. Heterogeneity-Robust Staggered DiD

Impact zones activated at different times across 2003–2014. Apply
modern estimators to handle treatment effect heterogeneity:

- **Callaway & Sant'Anna (2021):** Group-time ATTs using never-treated
  hexes as controls. Tests whether early vs late zones had different
  effects.
- **Sun & Abraham (2021):** Interaction-weighted estimator for clean
  event-study plots.
- **Borusyak, Jaravel & Spiess (2024):** Imputation estimator —
  most efficient, handles count data.

### 4b. Continuous Treatment (de Chaisemartin & D'Haultfoeuille)

Model enforcement intensity as a continuous treatment. Directly
estimates the causal effect of marginal changes in SQF on crime.
Particularly useful for the 2012–2015 period when intensity varied
continuously across zones and time.

### 4c. Synthetic Difference-in-Differences

**Arkhangelsky et al. (2021):** Combines synthetic control with DiD.
Apply to the dissolution event: construct synthetic control hexes that
match treated hexes' pre-dissolution trajectory, then estimate the
effect of dissolution.

### 4d. Augmented Synthetic Control

**Ben-Michael, Feller & Rothstein (2021):** Bias-corrected synthetic
control at the precinct level. Useful as a complement to the hex-level
analysis — each treated precinct gets a synthetic counterfactual
constructed from untreated precincts.

---

## Phase 5: Mechanism Analysis

### 5a. What Were Officers Doing in Regime 2?

If presence reduces crime but SQF collapsed, what were officers
actually doing? Test using arrest data as a proxy:
- Did arrest patterns change in impact zones during Regime 2?
- Did the composition of arrests shift (more felony, fewer misdemeanor)?
- Did response times or 911 call patterns change?

### 5b. Spillover Analysis

Using H3 neighbor rings:
- Did crime increase in hexes *adjacent* to impact zones after
  dissolution (displacement)?
- Or did adjacent hexes also see crime declines (diffusion of
  presence benefits)?

### 5c. Heterogeneity by Zone Characteristics

- Do early zones (activated 2003–2006) show different rebound patterns
  than late zones (activated 2010–2014)?
- Do zones in high-poverty vs low-poverty precincts respond differently
  to officer withdrawal?

---

## Data Inventory

| Dataset | Records | Period | Key fields |
|---------|--------:|--------|------------|
| NYPD Complaints | 4.78M | 2006–2024 | RPT_DT, OFNS_DESC, lat/lon |
| NYPD Arrests | 4.02M | 2006–2016 | ARREST_DATE, LAW_CAT_CD, lat/lon |
| SQF | 4.19M | 2006–2016 | datestop, pct, arstmade, searched, contrabn, weapons, lat/lon |
| Impact zone shapefiles | 22+ iterations | 2003–2015 | Zone polygons with precinct, start date |
| Precinct shapefiles | 2 versions | Pre/post Nov 2013 | Precinct boundary polygons |

---

## Phasing Summary

| Phase | Description | Depends on |
|-------|-------------|------------|
| 0 | Data prep: H3 grid, spatial joins, panel construction | — |
| 1 | Baseline replication: 2006–2012 on hex grid | Phase 0 |
| 2 | Three-regime model + dose-response: presence vs enforcement | Phase 0 |
| 3 | Event study around dissolution (7/1/2015) | Phase 0 |
| 4 | Modern causal methods | Phases 1–3 |
| 5 | Mechanisms, spillovers, heterogeneity | Phases 2–3 |
