# Extension Plan: Operation Impact Zones Beyond 2012

## Motivation

MacDonald, Fagan & Geller (2016) studied Operation Impact from 2004-2012,
a period of intense, geographically targeted enforcement by the NYPD.
Their central finding: deploying rookies to high-crime "impact zones"
reduced crime (particularly robbery and burglary) while increasing
arrests, with probable-cause stops driving the crime reduction.

Two major policy shocks occurred shortly after their study period:

1. **Floyd v. City of New York (2013):** The federal court ruled NYPD's
   stop-and-frisk practices unconstitutional, leading to a dramatic
   reduction in stops citywide. Stop-and-frisk encounters fell from
   ~685,000 in 2011 to ~46,000 by 2015.

2. **Mayoral transition (Jan 2014):** Mayor de Blasio promised a reformed
   version of Operation Impact emphasizing community policing over
   aggressive enforcement. Enforcement intensity plummeted.

These shocks create a powerful natural experiment: **What happens to crime
in impact zones when the enforcement mechanism is removed?** If the
original crime reductions were driven by deterrence (stops, visible
police presence), we should see crime rebound. If they reflect lasting
structural changes (community investment, improved physical environment,
displacement of criminal networks), effects should persist.

---

## Open Questions from the Original Paper

### 1. Treatment effect durability
The paper shows crime reduction during active enforcement but cannot
speak to whether gains persist. With the post-2012 enforcement collapse,
we can directly test this.

### 2. Mechanism decomposition
Model 4 separates probable-cause from non-probable-cause stops, but the
paper cannot fully disentangle whether crime fell because of:
- Deterrence (visible police presence)
- Incapacitation (arrests removing offenders)
- Legitimate detection (PC stops finding contraband/weapons)
- Unconstitutional harassment (NPC stops displacing people)

The post-Floyd period lets us test the deterrence channel: if crime
rebounds when stops collapse but arrests remain roughly stable, that
points to deterrence over incapacitation.

### 3. Treatment effect heterogeneity
Our Phase 3 staggered-DD analysis revealed that early zones (2004-2006)
had much larger effects than later zones. Is this because:
- Earlier zones were in higher-crime areas with more room to improve?
- The NYPD learned and improved zone selection over time?
- Treatment intensity (rookies per zone) declined in later waves?
- Diminishing returns to saturation policing?

### 4. Spillover dynamics
The original neighbor spillover estimates (Model 2) are attenuated and
imprecise. Extending the analysis temporally can reveal whether
displacement eventually materializes when enforcement drops.

### 5. Racial disparities in enforcement
The paper's Model 4 decomposes PC vs NPC stops but does not analyze the
racial composition of those stopped. The SQF microdata (available for
the full period) allows testing whether impact zones
disproportionately targeted minority residents.

### 6. Differential crime category responses
The original paper shows heterogeneous effects across crime types
(robbery/burglary decrease, weapons/other felony increase). Does this
pattern reverse when enforcement declines?

---

## Research Design

### Design 1: Extended Panel (2004-2019)

Re-run the original specification on an extended panel that covers both
the enforcement period (2004-2012) and the de-enforcement period
(2013-2019). End at 2019 to avoid COVID-19 confounds.

**Key treatment variables:**
- `treatment_active`: 1 when zone is active AND enforcement is high
  (original treatment, 2004-2012)
- `treatment_post`: 1 when zone is active but enforcement has collapsed
  (2013-2019)
- `treatment_ever`: 1 for any block that was ever in an impact zone,
  from activation date onward (tests persistent vs transient effects)

**Models:**
- Model A: `Y ~ treatment_active + treatment_post | year_pct_month`
  - Tests whether the crime effect persists after enforcement drops
- Model B: Add enforcement intensity (stops per block-month) as a
  time-varying measure
- Model C: Event study around the Floyd decision (Aug 2013) for
  impact zone blocks vs. controls

### Design 2: Difference-in-Differences-in-Differences (DDD)

- First difference: impact zone vs. non-impact zone
- Second difference: pre-treatment vs. post-treatment (zone activation)
- Third difference: high-enforcement era vs. low-enforcement era

This directly tests whether the *interaction* between zone designation
and enforcement intensity drives crime outcomes.

### Design 3: Staggered treatment reversal

Use the heterogeneous timing of the enforcement collapse (stops fell
at different rates across precincts/zones) to estimate a "reverse
treatment effect" using Callaway & Sant'Anna or Sun & Abraham,
treating the enforcement withdrawal as a new treatment.

---

## Data Requirements

### Data you need to pull:

#### 1. NYPD Complaint Data (Incident-Level Crime)
- **Source:** NYC Open Data — NYPD Complaint Data Historic
- **URL:** https://data.cityofnewyork.us/Public-Safety/NYPD-Complaint-Data-Historic/qgea-i56i
- **Years:** 2013-2019 (to extend the 2004-2012 panel)
- **Fields needed:** Complaint date, precinct, offense description,
  offense code, geographic identifiers (lat/lon for spatial join to
  census blocks / impact zones)
- **Notes:** Will need to geocode or spatial-join to census blocks
  and impact zone shapefiles. Offense codes need to be mapped to the
  same crime categories used in the original data.

#### 2. NYPD Arrest Data (Incident-Level Arrests)
- **Source:** NYC Open Data — NYPD Arrest Data (Year to Date / Historic)
- **URL:** https://data.cityofnewyork.us/Public-Safety/NYPD-Arrests-Data-Historic-/8h9b-rp9u
- **Years:** 2013-2019
- **Fields needed:** Arrest date, precinct, offense description,
  charge code, geographic coordinates
- **Notes:** Same geocoding requirement as crime data.

#### 3. Stop, Question, and Frisk (SQF) Microdata
- **Source:** NYC Open Data / NYPD SQF Reports
- **URL:** https://data.cityofnewyork.us/Public-Safety/The-Stop-Question-and-Frisk-Data/ftxv-d5ix (or annual files)
- **Years:** 2003-2019 (full range)
- **Fields needed:** Date, precinct, suspect race, suspected crime,
  reason for stop, whether physical force used, whether frisked,
  whether searched, weapon/contraband found, geographic coordinates
- **Use:** (a) Compute `stops`, `cs_probcause`, `cs_npc` at the
  block-month level for the extended panel; (b) Decompose stops by
  race for the racial disparity analysis; (c) Measure enforcement
  intensity pre/post Floyd

#### 4. Census Block / Block Group Geography
- **Source:** US Census Bureau TIGER/Line Shapefiles
- **URL:** https://www.census.gov/cgi-bin/geo/shapefiles/
- **Years:** 2010 (to match original study period)
- **Fields needed:** Census block or block group polygons for NYC
  (FIPS: 36061, 36047, 36081, 36005, 36085)
- **Use:** Spatial join of crime/arrest/SQF data to census blocks,
  and then to impact zone membership using existing shapefiles

#### 5. Impact Zone Shapefiles (already available)
- **Location:** `data-raw/Operation Impact Zones/SHP Files/`
- **Coverage:** All iterations through the last activation (Impact 22,
  dated 2014-07-25)
- **Use:** Define which census blocks fall in impact zones and which
  are never-treated controls. The shapefiles include the final
  iteration of Operation Impact, giving the full geographic scope.

#### 6. Precinct-Level Controls (optional but recommended)
- **Source:** NYC Open Data or NYPD staffing records
- **Variables:** Officer headcount per precinct, 311 complaints,
  precinct population estimates
- **Use:** Control for precinct-level confounders that vary over time

---

## Econometric Methods

### Recommended modern approaches:

#### 1. Borusyak, Jaravel & Spiess (2024) — Imputation Estimator
- R package: `didimputation`
- Advantage: Most efficient among heterogeneity-robust DD estimators;
  directly handles count data through Poisson specification; handles
  both treatment adoption and treatment reversal
- Recommended as the primary modern estimator

#### 2. de Chaisemartin & D'Haultfoeuille (2020, 2024)
- R package: `DIDmultiplegt` / `did_multiplegt_dyn`
- Advantage: Handles treatment intensity variation (not just binary
  on/off), which is relevant since enforcement intensity varied
  continuously across zones and time
- Especially useful for the "dose-response" analysis of stops → crime

#### 3. Callaway, Sant'Anna & Zhao (2024) — DR DiD with Covariates
- Latest version of the `did` package supports:
  - Time-varying covariates (enforcement intensity)
  - Doubly-robust estimation
  - Treatment effect dynamics
- Already used in Phase 3; extend to the post-enforcement period

#### 4. Synthetic Difference-in-Differences (Arkhangelsky et al. 2021)
- R package: `synthdid`
- Advantage: Combines synthetic control (re-weighting) with DiD;
  works well when parallel trends is questionable (as Model 5's
  cubic trend results suggest)
- Especially relevant for the pre/post Floyd comparison

#### 5. Regression Discontinuity in Time (RDiT)
- For the Floyd decision (Aug 2013): use an RD design around the
  court ruling date, comparing crime trends just before vs after
- Stronger identification than simple pre/post comparison

---

## Suggested Literature

### Staggered DD / Heterogeneous Treatment Effects
- Borusyak, Jaravel & Spiess (2024). "Revisiting Event Study Designs:
  Robust and Efficient Estimation." *Review of Economic Studies*
- de Chaisemartin & D'Haultfoeuille (2020). "Two-Way Fixed Effects
  Estimators with Heterogeneous Treatment Effects." *AER*
- Roth, Sant'Anna, Bilinski & Poe (2023). "What's Trending in
  Difference-in-Differences?" *Journal of Econometrics*

### Policing and Crime
- MacDonald, Fagan & Geller (2016). "The Effects of Local Police
  Surges on Crime and Arrests in New York City." *PLOS ONE*
  (the paper being replicated)
- Weisburd et al. (2016). "Do Stop, Question, and Frisk Practices
  Deter Crime?" *Criminology & Public Policy*
- Sullivan & O'Keeffe (2017). "Evidence that Curtailing Proactive
  Policing Can Reduce Major Crime." *Nature Human Behaviour*
- Chalfin & McCrary (2018). "Are US Cities Underpoliced?"
  *Review of Economics and Statistics*
- Mello (2019). "More COPS, Less Crime." *Journal of Public Economics*
- Ang et al. (2021). "Police Reform and the Dismantling of Legal
  Estrangement." *NBER Working Paper*

### Stop-and-Frisk / Floyd v. NYC
- Goel, Rao & Shroff (2016). "Precinct or Prejudice? Understanding
  Racial Disparities in New York City's Stop-and-Frisk Policy."
  *Annals of Applied Statistics*
- Fryer (2019). "An Empirical Analysis of Racial Differences in
  Police Use of Force." *Journal of Political Economy*
- Weisburd, Wooditch, Weisburd & Yang (2016). "Do Stop, Question,
  and Frisk Practices Deter Crime?" *Criminology & Public Policy*
- Cassell & Fowles (2018). "What Caused the 2016 Chicago Homicide
  Spike? An Empirical Examination of the ACLU Effect."
  *University of Illinois Law Review*

### Treatment Effect Durability / Place-Based Interventions
- Blattman et al. (2021). "Place-Based Interventions at Scale:
  The Direct and Spillover Effects of Policing and City Services
  on Crime." *Journal of the European Economic Association*
- Braga, Papachristos & Hureau (2014). "The Effects of Hot Spots
  Policing on Crime." *Annals of the American Academy*
- Weisburd et al. (2022). "The Long-Term Effects of Hot Spots
  Policing on Crime: A Randomized Controlled Trial."

---

## Implementation Plan

### Phase 4a: Data Acquisition and Panel Construction
1. Download NYPD complaint, arrest, and SQF data (2013-2019)
2. Geocode to census blocks using NYC PLUTO or TIGER/Line
3. Spatial join to impact zone shapefiles
4. Map offense codes to the 10 crime categories from the original study
5. Construct `stops`, `cs_probcause`, `cs_npc` from SQF microdata
6. Append to existing 2004-2012 panel
7. Create extended balanced panel (fid x month, 2004-2019)

### Phase 4b: Extended Panel Analysis
1. Re-estimate Models 1-5 on the 2004-2019 panel
2. Add `treatment_post` indicator for the de-enforcement period
3. Estimate DDD model (zone x activation x enforcement era)
4. Event study around Floyd (Aug 2013): dynamic effects for +/-24 months
5. Test treatment durability: does crime rebound in former impact zones?

### Phase 4c: Enforcement Mechanism Analysis
1. Plot enforcement intensity (stops per block-month) over time for
   impact zones vs. controls
2. Estimate dose-response: how does crime respond to marginal changes
   in enforcement intensity? (de Chaisemartin & D'Haultfoeuille)
3. Test deterrence vs incapacitation: do arrests remain stable when
   stops drop?

### Phase 4d: Racial Disparity Analysis
1. Merge SQF microdata with race of stopped individual
2. Compute racial composition of stops per block-month
3. Estimate Models 1 and 4 separately by race of stopped person
4. Test whether NPC stops disproportionately targeted minorities
5. Examine whether racial disparities changed post-Floyd

### Phase 4e: Modern Estimators
1. Borusyak-Jaravel-Spiess imputation estimator on extended panel
2. Synthetic DiD for the Floyd policy shock
3. RDiT around the Floyd decision date
4. Compare all estimates in a single summary table

### Phase 4f: Writeup
1. Compile results into a working paper draft
2. Produce publication-quality figures and tables
3. Discussion section: policy implications for place-based policing

---

## Timeline and Feasibility Notes

- Data acquisition (Phase 4a) is the bottleneck. NYC Open Data files
  are large (crime data: ~7M records) and require geocoding.
- The impact zone shapefiles are already available through Impact 22
  (the final iteration). All geographic matching is feasible.
- The core models can be adapted from the existing R scripts with
  minimal modification—mainly appending the new data period.
- The racial disparity analysis requires the SQF microdata, which
  is well-documented and has been extensively used in prior research.
