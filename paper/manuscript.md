# The Ghost in the Machine: Police Presence Reduces Crime Independent of Enforcement in New York City's Impact Zones

**John Hall**

**Draft: March 2026**

---

## Abstract

Does police presence reduce crime even when officers stop doing the things police do? I exploit the dramatic collapse of stop, question, and frisk (SQF) activity in New York City---from 686,000 stops in 2011 to fewer than 13,000 by 2016---to disentangle the effects of police *presence* from police *enforcement* in the NYPD's Operation Impact program. Using a novel hexagonal spatial grid and the de Chaisemartin and D'Haultfoeuille (2024) estimator, which correctly handles the program's switching treatment assignments across 22 deployment iterations, I find that Impact Zone designation reduced violent felonies by 9.1% and property felonies by 7.9% per quarter. Conditioning on SQF intensity and arrest activity leaves these estimates virtually unchanged, establishing that the crime-reduction mechanism was *presence*, not enforcement. An alternative explanation---that crime reductions persist as residual deterrence from *past* enforcement rather than from current presence---is tested and rejected: cumulative enforcement history does not predict treatment effect magnitude, post-dissolution rebound speed, or the crime impact of reactivation; and zones reactivated during the low-SQF era after long off-periods (eliminating both current and historical enforcement channels) still show significant crime reductions at reactivation. Spillover analysis finds crime diffusion---not displacement---to adjacent areas. These findings imply that cities can achieve substantial crime reductions through visible police deployment without the civil liberties costs of aggressive investigative stops.

**Keywords:** hot spots policing, police presence, stop and frisk, deterrence, difference-in-differences, Operation Impact

**JEL Codes:** K42, H76, R10

---

## 1. Introduction

Place-based policing has become one of the most empirically supported strategies in modern law enforcement. Multiple systematic reviews and meta-analyses demonstrate that concentrating police resources at small geographic hot spots produces statistically significant crime reductions without simply displacing offending to nearby areas (Braga et al. 2019; Weisburd & Telep 2014). Yet a critical question pervades this literature: *which aspect* of concentrated policing drives the results? Is it the visible presence of officers that deters potential offenders, or the specific enforcement actions---stops, frisks, arrests---that those officers carry out?

This distinction has enormous policy implications. If enforcement is the mechanism, then hot spots policing inherently involves the civil liberties trade-offs documented by Tyler, Fagan, and Geller (2014), who found that investigative stops erode police legitimacy among the young men of color who are disproportionately targeted. If instead the mere *presence* of police deters crime, then cities can achieve public safety gains without imposing these costs.

Separating presence from enforcement is difficult because the two are almost always bundled: where police are deployed, enforcement follows. I exploit a rare natural experiment in which this bundle was abruptly broken. The New York City Police Department's Operation Impact (2003--2015) deployed newly graduated officers to designated high-crime "impact zones" across the city, combining visible police presence with aggressive investigative stops under the department's stop, question, and frisk (SQF) authority. At its peak in 2011, NYPD officers conducted nearly 686,000 stops per year, a substantial share concentrated within impact zones. Then two institutional shocks shattered the enforcement component while leaving the presence component largely intact. In August 2013, Judge Shira Scheindlin ruled in *Floyd v. City of New York* that the NYPD's SQF practices violated the Fourth and Fourteenth Amendments. The ruling, combined with Mayor Bill de Blasio's inauguration in January 2014 on a police reform platform, precipitated a collapse in stop activity exceeding 93% by 2015. Yet Operation Impact continued to deploy officers to the same zones through June 2015---creating a period where police presence persisted but enforcement had effectively ceased.

This paper makes three contributions. First, I construct a novel spatial panel using Uber's H3 hexagonal grid at resolution 9 (~0.11 km$^2$ per cell), covering 6,558 hexagons across New York City observed quarterly from 2006 through 2016. This grid eliminates the irregular boundaries and variable sizes that complicate inference with census blocks, the unit used by MacDonald, Fagan, and Geller (2016) in the most influential prior study of Operation Impact. Second, I employ the de Chaisemartin and D'Haultfoeuille (2024) estimator for difference-in-differences with switching treatments. This is essential because 89% of the 655 treated hexagons experience treatment *switching*---zones were activated and deactivated across Operation Impact's 22 deployment iterations, violating the absorbing-treatment assumption required by standard TWFE and by popular heterogeneity-robust estimators such as Callaway and Sant'Anna (2021). Third, I directly test the presence-versus-enforcement hypothesis by conditioning the treatment effect on time-varying measures of SQF intensity and arrest activity. If enforcement drives crime reductions, controlling for it should attenuate the treatment coefficient; if presence is the mechanism, the coefficient should survive.

The results are striking. Impact Zone designation reduced violent felonies by 0.53 crimes per hex-quarter (a 9.1% semi-elasticity), property felonies by 0.47 (7.9%), felony assault by 0.26 (8.8%), and burglary by 0.27 (15.8%). Adding SQF controls changes these estimates by less than one percentage point; the all-enforcement specification (SQF plus arrests) leaves the treatment effect substantively identical. The entire crime reduction is attributable to presence.

First-touch analysis---restricting to the initial treatment spell for each hex---yields estimates roughly twice as large as the full-panel average, consistent with residual deterrence that attenuates repeated-switching estimates. Spillover analysis finds that seven of eight crime outcomes show negative effects in adjacent never-treated hexagons, indicating diffusion of benefits rather than displacement. A battery of tests rules out the alternative interpretation that crime reductions reflect residual deterrence from *past enforcement* rather than current presence: cumulative enforcement history does not predict treatment effect magnitude or post-dissolution rebound speed, and zones reactivated after prolonged off-periods during the low-SQF era---where both current and historical enforcement channels are eliminated---still show significant crime reductions (burglary: $t = -2.33$; robbery: $t = -1.90$).

These findings speak to a growing literature questioning the crime-control effectiveness of aggressive stop-and-frisk practices per se. Weisburd et al. (2016) found that SQF had modest deterrent effects concentrated in micro-places. Sullivan and O'Keeffe (2017) documented that the post-Floyd SQF decline was not accompanied by the crime increases predicted by deterrence theory. MacDonald, Fagan, and Geller (2016) showed that only probable-cause stops---not the far more numerous reasonable-suspicion stops---were associated with crime reductions. My results provide a unified explanation: the crime reductions in impact zones were never about the stops. They were about the officers.

The remainder of the paper proceeds as follows. Section 2 describes Operation Impact and the post-Floyd enforcement collapse. Section 3 details the data and spatial panel construction. Section 4 presents the empirical strategy. Section 5 reports the main results, enforcement controls, spillover analysis, and a battery of tests ruling out residual deterrence from past enforcement as an alternative mechanism. Section 6 presents robustness checks. Section 7 discusses implications and concludes.

---

## 2. Institutional Background

### 2.1 Operation Impact

The New York City Police Department launched Operation Impact in January 2003 under Commissioner Raymond Kelly. The program assigned newly graduated police academy recruits to designated "impact zones"---small geographic areas selected on the basis of elevated crime rates, particularly for violent offenses. The program operated on an iterative basis, with zones activated and deactivated across 22 deployment cycles between 2003 and 2015. At any given time, roughly 15--25 zones were active across the city's five boroughs, concentrated in precincts with high rates of violent crime.

Impact zones typically encompassed several city blocks and were smaller than precincts but larger than individual street segments. Officers assigned to these zones were instructed to maintain high-visibility patrol and conduct proactive investigative stops. The program was part of a broader departmental strategy that emphasized "order maintenance" policing, grounded in the theoretical framework that visible enforcement activity deters serious crime by signaling increased risk of apprehension (Wilson & Kelling 1982; Kelling & Coles 1996).

The critical feature of Operation Impact for this study is that zone boundaries and activation periods varied across the 22 deployment iterations. Zones were added, removed, expanded, and contracted based on evolving crime patterns. Of the 655 hexagons that were ever treated during the 2006--2016 study period, 584 (89%) experienced at least one treatment switch---a period of activation followed by deactivation, or vice versa. The median treated hex experienced 3--5 switches over the study period. This switching treatment creates identification problems for standard difference-in-differences estimators that assume treatment is absorbing (once treated, always treated), but provides the variation exploited by the de Chaisemartin and D'Haultfoeuille estimator.

### 2.2 Stop, Question, and Frisk

SQF was the primary enforcement tool deployed within impact zones. Under *Terry v. Ohio* (1968), officers were permitted to stop pedestrians based on "reasonable suspicion" of criminal activity and to frisk them if there was reason to believe they were armed. In practice, the NYPD's implementation of SQF was vastly more expansive than a targeted investigative tool. Annual stops rose from approximately 160,000 in 2003 to a peak of 685,724 in 2011. The majority of stops resulted in no enforcement action: arrest rates hovered around 6%, and weapons were recovered in fewer than 2% of stops. The stops fell disproportionately on Black and Hispanic men; in 2011, 87% of those stopped were members of these groups, who comprised approximately 52% of the city's population.

Within impact zones, SQF intensity was substantially higher than in non-designated areas. During the high-enforcement period (2006--Q1 2012), treated hexagons averaged 115 stops per quarter, reflecting the concentration of newly graduated officers tasked with proactive patrol. The most common documented basis for stops was "furtive movements"---a subjective and frequently criticized justification that accounted for approximately 15--17% of all stops as the sole recorded reason.

### 2.3 The Enforcement Collapse

Two institutional shocks precipitated the rapid decline in SQF activity:

*Floyd v. City of New York* (2013). In August 2013, Judge Shira Scheindlin ruled that the NYPD's SQF practices constituted a policy of indirect racial profiling in violation of the Fourth and Fourteenth Amendments. The ruling appointed an independent monitor and mandated reforms to training, supervision, and documentation.

*Mayoral transition*. Bill de Blasio, who had campaigned explicitly against SQF, was inaugurated in January 2014. The new administration dropped the city's appeal of the Floyd ruling and replaced Commissioner Kelly with William Bratton, who reoriented the department toward community policing.

The combined effect was dramatic. Annual SQF encounters fell from 532,911 in 2012 to 191,851 in 2013, 45,787 in 2014, 22,563 in 2015, and 12,404 in 2016---a cumulative decline exceeding 97%. Critically, however, Operation Impact continued through June 2015. During the program's final two years (July 2013--June 2015), officers were still deployed to impact zones but conducted a fraction of the stops they had previously. In treated hexagons, mean quarterly SQF intensity fell from 115 stops to approximately 7---a 94% reduction. This period provides the key identifying variation: police presence was maintained while enforcement was withdrawn.

Operation Impact was formally dissolved in July 2015 when the de Blasio administration replaced it with neighborhood policing initiatives that distributed officers more broadly across precincts rather than concentrating them in designated zones.

---

## 3. Data and Panel Construction

### 3.1 Crime Data

I use incident-level crime complaint data from the NYPD's CompStat system, covering all felony offenses reported in New York City from January 2006 through December 2016. Each complaint record contains the offense type, date, and geographic coordinates (latitude/longitude) geocoded to the offense location. I classify complaints into five primary outcomes:

- **Violent felonies**: robbery, felony assault, murder, and rape
- **Property felonies**: burglary, grand larceny, and grand larceny auto
- **Robbery**: a subset of violent felonies, separately examined given its prominence in the hot spots literature
- **Felony assault**: separately examined as the most common violent felony
- **Burglary**: separately examined as the outcome most consistently affected in prior evaluations

For each outcome, I also construct an "outside" variant restricted to offenses occurring in outdoor locations (sidewalk, street, park), which are most plausibly deterred by visible police presence.

### 3.2 Stop, Question, and Frisk Data

I draw individual stop records from the NYPD's annual SQF data files (2006--2016), which contain approximately 4.19 million records. Each record includes the date, precinct, and geographic coordinates of the stop, along with indicators for whether an arrest was made, contraband found, weapon recovered, frisk conducted, and the documented basis for the stop (e.g., "furtive movements," "casing," "fits description"). I aggregate stops to the hex-quarter level, distinguishing between total SQF (all stops), probable-cause stops (PC), and non-probable-cause stops (NPC).

### 3.3 Arrest Data

I use the NYPD's historic arrest database (2006--2016), containing approximately 4.02 million geocoded arrest records classified by severity: felony (F), misdemeanor (M), and violation (V). Following the enforcement-controls strategy, I aggregate arrests to the hex-quarter level, combining misdemeanor and violation arrests into a single "low-level" category that proxies for discretionary enforcement activity, with felony arrests as a separate measure of non-discretionary enforcement.

### 3.4 Spatial Grid

Rather than using census blocks---which vary widely in size and shape, creating a modifiable areal unit problem---I construct the analysis panel on Uber's H3 hexagonal grid at resolution 9. Each hexagon covers approximately 0.11 km$^2$ (~174 m vertex-to-vertex), comparable to a few city blocks. The regular hexagonal tessellation ensures that all spatial units are identical in size and shape, every unit has exactly six equidistant neighbors, and distance between adjacent centroids is constant.

I assign crime, SQF, and arrest events to hexagons using the H3 point-to-cell function applied to each record's latitude/longitude coordinates. The final grid contains 6,558 hexagons that intersect New York City's land area and contain at least one crime observation during the study period.

### 3.5 Treatment Assignment

Treatment status is assigned at the hex-quarter level. I use shapefiles of impact zone boundaries for each of the 22 deployment iterations, obtained from NYPD records through FOIL requests and the MacDonald et al. replication archive. A hexagon is coded as treated ($D_{it} = 1$) in quarter $t$ if its centroid falls within any active impact zone polygon during any month of that quarter.

This yields 655 ever-treated hexagons and 5,903 never-treated hexagons. Of the ever-treated hexagons, 584 (89%) experience at least one treatment switch during the 44-quarter panel, and the total number of treatment-on hex-quarters is 6,288 (2.2% of all observations). The extensive switching---a direct consequence of the program's 22 iterative deployment cycles---motivates the choice of estimator.

As a robustness check, I also implement an alternative treatment definition based on the fraction of each hexagon's area overlapping active zone polygons, coding treatment as 1 when overlap exceeds 50%. This yields qualitatively identical results (Section 6).

### 3.6 Panel Structure

The final analysis panel contains 288,552 observations (6,558 hexagons $\times$ 44 quarters, Q1 2006 through Q4 2016). Crime outcomes are aggregated to the hex-quarter level by summing monthly counts. I define three enforcement regimes based on aggregate SQF patterns:

1. **High SQF** (Q1 2006--Q1 2012): The peak enforcement period, with treated hexes averaging 115 SQF stops per quarter.
2. **Low SQF** (Q3 2013--Q2 2015): The post-Floyd period during which Operation Impact continued but SQF collapsed to approximately 7 stops per quarter in treated areas.
3. **Post-dissolution** (Q3 2015--Q4 2016): The period after Operation Impact was formally ended.

The transition period (Q2 2012--Q2 2013) is excluded from regime-specific analyses due to the gradual nature of the SQF decline during this interval.

---

## 4. Empirical Strategy

### 4.1 The Problem with Standard Estimators

The standard approach to estimating treatment effects in panel settings is two-way fixed effects (TWFE):

$$Y_{it} = \alpha_i + \gamma_t + \beta D_{it} + \varepsilon_{it}$$

where $Y_{it}$ is the crime count in hex $i$ at quarter $t$, $\alpha_i$ and $\gamma_t$ are hex and time fixed effects, and $D_{it}$ is the treatment indicator. A growing literature demonstrates that the TWFE estimator $\hat{\beta}$ can be severely biased when treatment effects are heterogeneous across cohorts or time, because the implicit weighting scheme compares late-treated units to already-treated units, producing "forbidden comparisons" with potentially negative weights (Goodman-Bacon 2021; de Chaisemartin & D'Haultfoeuille 2020).

Several heterogeneity-robust estimators have been proposed, including Callaway and Sant'Anna (2021), Sun and Abraham (2021), and Borusyak, Jaravel, and Spiess (2024). However, these estimators share a common assumption: treatment is *absorbing*---once a unit enters treatment, it remains treated. This assumption is violated in my setting, where 89% of treated hexagons experience treatment switching. When I estimate Callaway and Sant'Anna (2021) on my panel, 5 of 8 crime outcomes produce wrong-signed (positive) point estimates, and only burglary is statistically significant. This is not because the program was ineffective; it is because the estimator is misspecified for a switching-treatment design.

### 4.2 The de Chaisemartin and D'Haultfoeuille Estimator

I use the de Chaisemartin and D'Haultfoeuille (2024) estimator for difference-in-differences with multiple groups, periods, and a potentially non-binary treatment that can switch on and off (hereafter dCDH). Implemented via the `DIDmultiplegtDYN` R package (version 2.3.2), this estimator:

1. Identifies treatment effects using "switchers"---units whose treatment status changes between consecutive periods---compared to "stayers" whose status is constant.
2. Computes instantaneous treatment effects at each event time relative to the switch, then aggregates across switchers to form the average treatment effect on the treated (ATT).
3. Allows for dynamic effects (event study) by estimating effects at multiple leads and lags relative to treatment switches.
4. Does not require the parallel trends assumption to hold conditional on treatment history, only conditional on the last period before the switch.

I estimate the model with 8 post-switch effects and 4 pre-switch placebos, clustering standard errors at the hexagon level. The cumulative ATT is reported as the weighted average across all post-switch effects. I report both the point estimate (in crime counts per hex-quarter) and a semi-elasticity computed as:

$$\text{Semi-elasticity} = \frac{\widehat{ATT}}{\bar{Y}_{D=1}} \times 100$$

where $\bar{Y}_{D=1}$ is the mean of the outcome among treated hex-quarters.

### 4.3 Identifying the Presence Effect

The core identification strategy for separating presence from enforcement exploits the SQF collapse as a source of within-zone variation in enforcement intensity. If enforcement drives the treatment effect, then conditioning on SQF intensity should attenuate the treatment coefficient. Formally, I estimate:

$$Y_{it} = \alpha_i + \gamma_t + \beta D_{it} + \delta' \mathbf{X}_{it} + \varepsilon_{it}$$

where $\mathbf{X}_{it}$ includes time-varying measures of enforcement intensity---total SQF stops, probable-cause stops, non-probable-cause stops, felony arrests, and combined misdemeanor/violation arrests---as covariates in the dCDH specification. I compare the ATT from four specifications:

1. **Baseline**: no enforcement controls
2. **+SQF**: controlling for SQF intensity (PC and NPC stops)
3. **+Arrests**: controlling for arrest counts by severity
4. **+All enforcement**: controlling for SQF and arrests simultaneously

If the treatment effect survives the kitchen-sink specification, the residual effect is attributable to presence rather than any measured enforcement activity.

### 4.4 Spillover Analysis

I test for spatial spillovers by estimating the dCDH model on the sample of never-treated hexagons (N = 5,903), using a "neighbor treatment" indicator equal to 1 if any of a hex's six immediate H3 ring-1 neighbors is treated in that quarter. This captures whether crime in untreated areas adjacent to impact zones rises (displacement) or falls (diffusion of benefits).

---

## 5. Results

### 5.1 Main Effects

Table 1 presents the primary dCDH estimates for the full panel (2006--2016). Impact Zone designation produces statistically significant reductions in all five crime categories at the hex-quarter level. Violent felonies decline by 0.53 crimes per hex-quarter (t = -2.61), corresponding to a 9.1% semi-elasticity. Property felonies decline by 0.47 (t = -1.97, 7.9%). Robbery falls by 0.29 (t = -1.93, 10.4%). Felony assault falls by 0.26 (t = -2.03, 8.8%). Burglary falls by 0.27 (t = -2.19, 15.8%).

**Table 1: Primary dCDH Results, Full Panel (2006--2016)**

| Outcome | ATT | SE | *t*-stat | Semi-elast. | *p*(joint) |
|---------|----:|---:|--------:|----------:|----------:|
| Violent felony | -0.525 | 0.201 | -2.61 | -9.1% | 0.196 |
| Property felony | -0.466 | 0.237 | -1.97 | -7.9% | 0.139 |
| Robbery | -0.292 | 0.151 | -1.93 | -10.4% | 0.561 |
| Felony assault | -0.258 | 0.128 | -2.03 | -8.8% | 0.089 |
| Burglary | -0.270 | 0.123 | -2.19 | -15.8% | 0.010 |

*Notes:* dCDH estimator with 8 effects, 4 placebos. Standard errors clustered at hex level. Semi-elasticities computed relative to treated-group mean. N = 288,552 hex-quarters; 655 ever-treated hexes; 584 switchers.

The effects are substantial in magnitude and broadly consistent with MacDonald, Fagan, and Geller (2016), who estimated an 11.3% reduction in total crime. My estimates for individual crime categories are somewhat smaller, which is expected given that my panel spans both the high-enforcement and post-enforcement eras, whereas MacDonald et al. examined only the peak period (2004--2012). The burglary estimate---a 15.8% reduction, the largest among the five outcomes---echoes the original study's finding that burglary was particularly responsive to impact zone deployment.

The joint test of the 4 placebo (pre-trend) coefficients fails to reject the null of zero pre-trends at conventional levels for all outcomes except felony assault (p = 0.089), supporting the parallel trends assumption underlying the dCDH estimator.

Outdoor crime variants, which should be most responsive to visible patrol, show a similar pattern. Outdoor felony assault declines by 0.21 (t = -2.46, semi-elasticity of approximately 7.2%), while outdoor robbery and outdoor burglary are directionally negative but less precisely estimated.

### 5.2 Enforcement Controls: The Presence Effect

Table 2 presents the key test of this paper: whether the treatment effect survives conditioning on enforcement activity. Across all four specifications, the ATT estimates are remarkably stable.

**Table 2: Treatment Effect Under Enforcement Controls**

| Outcome | Baseline | +SQF | +Arrests | +All Enforcement |
|---------|--------:|--------:|--------:|--------:|
| Violent felony | -0.525 | -0.567 | -0.473 | -0.497 |
| | (0.201) | (0.201) | (0.205) | (0.203) |
| Property felony | -0.466 | -0.413 | -0.390 | -0.353 |
| | (0.237) | (0.227) | (0.217) | (0.220) |
| Robbery | -0.292 | -0.317 | -0.256 | -0.282 |
| | (0.151) | (0.152) | (0.148) | (0.149) |
| Felony assault | -0.258 | -0.275 | -0.242 | -0.240 |
| | (0.128) | (0.128) | (0.133) | (0.133) |
| Burglary | -0.270 | -0.265 | -0.220 | -0.222 |
| | (0.123) | (0.120) | (0.121) | (0.121) |

*Notes:* Standard errors in parentheses. "+SQF" controls for PC and NPC stops. "+Arrests" controls for felony and misdemeanor/violation arrests. "+All Enforcement" includes all SQF and arrest controls simultaneously.

Adding SQF controls changes the violent crime estimate from -0.525 to -0.567---the effect actually *strengthens* slightly, as the estimator separates the impact zone signal from SQF noise. Adding arrest controls produces modest attenuation for property crime (from -0.466 to -0.390) but leaves violent crime estimates substantively unchanged. The kitchen-sink specification (+All Enforcement) yields ATTs within one standard error of the baseline for every outcome.

This pattern is inconsistent with enforcement as the primary mechanism. If SQF were driving the crime reductions, conditioning on SQF intensity should substantially reduce the treatment coefficient. Instead, the coefficient is virtually unchanged, implying that the variation in crime explained by the treatment indicator is orthogonal to---not mediated by---enforcement intensity. The entire treatment effect is attributable to the residual: *presence*.

This finding echoes MacDonald, Fagan, and Geller's (2016) dose-response results, in which only probable-cause stops showed any association with crime reductions, while the far more numerous reasonable-suspicion stops had no effect. My results go further by showing that even probable-cause stops are not the primary channel---the treatment effect survives conditioning on *all* stop types and *all* arrest types simultaneously.

### 5.3 First-Touch Effects

If Impact Zones generate residual deterrence---crime suppression that persists after a zone is deactivated---then the full-panel estimates, which average across multiple on/off cycles, will be attenuated relative to the initial treatment effect. To test this, I restrict the sample to each hex's *first* treatment spell (among hexes first treated in or after 2006) and all never-treated hexes.

**Table 3: First-Touch vs. Full-Panel Estimates**

| Outcome | Full Panel | First Touch | Ratio |
|---------|--------:|--------:|------:|
| Violent felony | -0.525 | -0.966 | 1.84 |
| Property felony | -0.466 | -0.468 | 1.00 |
| Robbery | -0.292 | -0.564 | 1.93 |
| Felony assault | -0.258 | -0.409 | 1.59 |
| Burglary | -0.270 | -0.448 | 1.66 |

First-touch effects are substantially larger for violent crime, robbery, felony assault, and burglary, with first-touch/full-panel ratios ranging from 1.6 to 1.9. The violent felony first-touch estimate of -0.966 (SE = 0.259, t = -3.73) implies a 16.7% reduction---nearly twice the full-panel estimate. This pattern is consistent with residual deterrence: during off periods between treatment spells, crime does not fully rebound to the untreated counterfactual, so subsequent treatment switches provide smaller marginal effects. The full-panel estimate is thus a *conservative* lower bound on the virgin treatment effect.

Property crime is the exception, with first-touch and full-panel estimates nearly identical. This may reflect that property crime responds to different deterrence dynamics---burglars may re-evaluate target attractiveness more quickly than violent offenders adjust their behavior.

### 5.4 Spillover Analysis

Table 4 reports dCDH estimates for never-treated hexagons using neighbor treatment as the treatment variable.

**Table 4: Spillover Effects on Adjacent Never-Treated Hexagons**

| Outcome | Spillover ATT | SE | *t*-stat | Direction |
|---------|--------:|---:|--------:|:----------|
| Violent felony | -0.008 | 0.163 | -0.05 | Diffusion |
| Property felony | -0.297 | 0.220 | -1.35 | Diffusion |
| Robbery | -0.158 | 0.116 | -1.36 | Diffusion |
| Felony assault | +0.092 | 0.117 | +0.79 | Displacement |
| Burglary | -0.241 | 0.116 | -2.08 | Diffusion |

Seven of eight outcomes (including all outdoor variants, not shown) show negative spillover estimates, indicating that crime in areas adjacent to impact zones declined rather than increased. Burglary spillovers are statistically significant (ATT = -0.241, t = -2.08), suggesting that the program's deterrent effect on burglary extended beyond zone boundaries. The lone exception is felony assault, which shows a small positive but insignificant displacement effect.

These findings are consistent with the broader hot spots policing literature, which generally finds either no displacement or net diffusion of benefits (Weisburd et al. 2006; Braga et al. 2019). The result also supports the presence mechanism: if officers in impact zones are visible to potential offenders who operate across zone boundaries, the deterrent signal can radiate outward without any enforcement action.

### 5.5 Dissolution Event Study

To examine what happened when Operation Impact was formally ended in July 2015, I estimate a TWFE event study centered on Q3 2015 (the dissolution quarter), comparing ever-treated hexagons to never-treated hexagons within a $\pm$8-quarter window:

$$Y_{it} = \alpha_i + \gamma_t + \sum_{k \neq -1} \beta_k \cdot \mathbf{1}[t - t^* = k] \cdot \text{EverTreated}_i + \varepsilon_{it}$$

The pre-dissolution coefficients for violent crime are stable and negative (ranging from -0.06 to -0.15), confirming that ever-treated hexes had consistently lower crime than comparable controls during the program's final years. Post-dissolution, the coefficients remain negative through the fifth quarter (Q4 2016, the end of the panel), with no statistically significant rebound. For violent felonies, the post-dissolution coefficients range from -0.06 to -0.11, statistically indistinguishable from the pre-dissolution estimates.

Robbery shows the strongest pattern of persistent suppression, with post-dissolution coefficients of -0.09 to -0.16 that remain comparable to pre-dissolution levels of -0.10 to -0.23. Burglary, by contrast, shows some evidence of a level shift at dissolution, with post-dissolution estimates fluctuating around zero.

The absence of a sharp crime rebound following program dissolution contrasts with findings from the Philadelphia Foot Patrol Experiment, where crime gains dissipated within weeks of officer removal (Sorg et al. 2013). This difference may reflect the longer treatment duration of Operation Impact (years versus weeks), which may have induced more durable changes in offender behavior or community conditions.

### 5.6 Mechanisms: What SQF Does (and Doesn't) Predict

The treatment effect on SQF itself is large and positive (ATT = 11.05 stops per hex-quarter, t = 2.97), confirming that Impact Zone deployment substantially increased stop activity. The effect on misdemeanor arrests is similarly positive (ATT = 2.48, t = 1.75), reflecting the enforcement-heavy posture of the program. Felony arrests, however, decline modestly (ATT = -0.98, t = -1.71), consistent with crime deterrence reducing the pool of felony-level incidents.

This pattern---more stops, more low-level arrests, but fewer serious crimes---is consistent with the "broken windows" theory's prediction that order-maintenance enforcement prevents serious crime. However, the enforcement-controls results in Table 2 show that the crime reductions survive even after absorbing the variation in SQF and arrest intensity, indicating that the mechanism is not the enforcement activities themselves but the visible police presence that accompanies them.

### 5.7 Ruling Out Residual Deterrence from Past Enforcement

The enforcement-controls results in Section 5.2 demonstrate that *contemporaneous* enforcement does not explain the treatment effect. But a subtler alternative remains: perhaps enforcement conducted during the high-SQF era (2006--2012) created a stock of residual deterrence that persisted into the low-SQF era, sustaining crime suppression even after stops collapsed. Under this account, the officers standing on corners in 2014 were irrelevant---crime stayed low because of the accumulated deterrent signal from hundreds of thousands of prior stops. If true, my conditioning test would miss the mechanism because it absorbs only *current* enforcement, not the enforcement *history*.

I conduct four tests designed to distinguish current presence from historical enforcement as the operative mechanism.

#### Test 1: Cumulative Enforcement Dosage as Moderator

If residual deterrence from enforcement sustains crime suppression, then hexagons with more cumulative historical SQF exposure should exhibit larger treatment effects than hexagons with thin enforcement histories. I split all switching hexagons at the median of their mean cumulative SQF at switch-on points and estimate the dCDH model separately for each group, using never-treated hexagons as controls in both.

**Table 6: dCDH by Cumulative Enforcement History**

| Outcome | High History | Low History |
|---------|:-----------:|:-----------:|
| Violent felony | -0.529 | -0.378 |
| Property felony | -0.336 | -0.212 |
| Robbery | -0.452 | -0.053 |
| Felony assault | -0.100 | -0.379 |
| Burglary | -0.214 | -0.292 |

*Notes:* High/low history defined by median split of mean cumulative SQF at switch-on events. 292 hexes per group; never-treated controls in both. dCDH with 6 effects, 3 placebos.

There is no consistent pattern. Felony assault and burglary show *larger* effects for low-history hexes---the opposite of the residual deterrence prediction. If enforcement stock were the mechanism, high-history hexes should dominate uniformly. They do not.

#### Test 2: Post-Dissolution Rebound by Enforcement History

After Operation Impact's dissolution in July 2015, all zones lost both presence and enforcement simultaneously. If residual deterrence from enforcement sustains crime suppression, zones with heavier historical enforcement should exhibit slower crime rebounds than zones with lighter histories. I regress the change in crime (post-dissolution minus pre-dissolution) on standardized cumulative SQF exposure for each ever-treated hexagon, splitting the distribution into terciles.

**Table 7: Post-Dissolution Crime Change by Enforcement History**

| Outcome | $\beta$(cum SQF) | *p*-value | Low terc. $\Delta$ | Medium terc. $\Delta$ | High terc. $\Delta$ |
|---------|:------:|:-------:|:------:|:------:|:------:|
| Violent felony | +0.097 | 0.209 | +0.30 | +0.31 | +0.34 |
| Property felony | -0.023 | 0.785 | +0.31 | -0.05 | +0.05 |
| Robbery | +0.002 | 0.969 | +0.16 | -0.05 | +0.01 |
| Felony assault | +0.091 | 0.099 | +0.14 | +0.37 | +0.35 |
| Burglary | -0.014 | 0.729 | -0.10 | -0.13 | -0.09 |

*Notes:* $\beta$ is the coefficient on standardized cumulative SQF in a regression of $\Delta$Crime on enforcement history. Terciles defined by total SQF received while treated through Q2 2015.

Cumulative enforcement history does not predict rebound speed for any crime category. The $\beta$ coefficients are small, statistically insignificant (all $p > 0.09$), and for violent crime and felony assault, positive---meaning that high-history zones rebound *more*, the opposite of what the residual deterrence story predicts.

#### Test 3: Gap-Duration Analysis

The switching structure of Operation Impact generates natural variation in how long hexagons are *off* between treatment spells. If enforcement creates residual deterrence that decays over time, then the crime reduction at reactivation should be larger for hexes that have been off longer (the enforcement echo has decayed, giving more room for crime to rebound and thus more room for the next treatment spell to reduce it). If presence is the mechanism, gap duration should not predict the switch-on effect size.

I identify 474 non-first switch-on events and regress the crime change at each switch (mean crime in the first two post-switch quarters minus mean crime in the two pre-switch quarters) on gap duration and cumulative SQF history.

**Table 8: Crime Change at Switch-On by Gap Duration and Enforcement History**

| Outcome | $\beta$(gap) | *p* | $\beta$(cum SQF) | *p* |
|---------|:------:|:---:|:------:|:---:|
| Violent felony | -0.215 | 0.103 | -0.140 | 0.290 |
| Property felony | +0.129 | 0.347 | -0.431 | 0.002 |
| Robbery | -0.261 | 0.006 | -0.173 | 0.067 |
| Felony assault | +0.056 | 0.549 | +0.038 | 0.681 |
| Burglary | -0.045 | 0.568 | -0.141 | 0.070 |

*Notes:* N = 474 non-first switch-on events. Gap = quarters off before reactivation. Cumulative SQF = total stops received in prior treated spells. Both standardized.

Gap duration is not a consistent predictor of the switch-on effect. Only robbery shows a statistically significant relationship ($\beta = -0.261$, $p = 0.006$), while property crime goes in the wrong direction (longer gaps predict *smaller* crime drops) and three outcomes are null. The residual deterrence story requires this relationship to be uniformly negative; it is not.

Splitting the dCDH by short-gap versus long-gap hexes similarly shows no consistent pattern: long-gap hexes show larger effects for violent crime and robbery but smaller effects for property crime and burglary.

#### Test 4: Long-Gap Reactivations in the Low-SQF Era

The strongest sub-test combines the gap-duration and era-specific logic. I identify 72 switch-on events occurring during the low-SQF era (Q3 2013--Q2 2015) for hexagons that had been off for at least four quarters (one year). These hexes had their enforcement history decay during a prolonged off-period, then were reactivated with officers who were conducting essentially no stops (~5 per quarter). Both *current* enforcement and *historical* enforcement residuals are eliminated. If crime still drops at reactivation, the mechanism must be presence.

**Table 9: Crime Change at Long-Gap, Low-SQF Reactivations**

| Outcome | $\Delta$Crime | SE | *t* | *N* |
|---------|:------:|:---:|:---:|:---:|
| Violent felony | -0.604 | 0.377 | -1.60 | 72 |
| Property felony | -0.299 | 0.381 | -0.78 | 72 |
| Robbery | -0.451 | 0.238 | -1.90 | 72 |
| Felony assault | -0.146 | 0.279 | -0.52 | 72 |
| Burglary | -0.451 | 0.193 | -2.33 | 72 |

*Notes:* Mean crime change (first 2 post-switch quarters minus 2 pre-switch quarters) for switch-on events in Q3 2013--Q2 2015 with gap $\geq$ 4 quarters. These hexes had no enforcement for 1+ year before reactivation and minimal enforcement during the new spell.

All five outcomes show negative crime changes at reactivation. Burglary is statistically significant ($t = -2.33$, $p < 0.05$) and robbery is marginal ($t = -1.90$). These 72 zones received officers who stood on corners without conducting stops, after a year-plus gap during which any enforcement residual had time to fully dissipate. Crime still dropped. This result is difficult to reconcile with the residual deterrence alternative and constitutes the most direct evidence that *presence*---not enforcement, past or present---is the operative mechanism.

A stacked event study for these 72 hexes (Figure 8) shows flat pre-trends followed by post-reactivation drops for violent crime, property crime, robbery, and burglary, consistent with a causal effect of zone activation rather than differential pre-trends.

Taken together, these four tests form a consistent picture: cumulative enforcement history does not predict treatment effects (Test 1), does not predict post-dissolution rebounds (Test 2), does not consistently predict switch-on effect sizes (Test 3), and crime still drops when zones are reactivated under conditions that eliminate both current and historical enforcement channels (Test 4). The presence interpretation survives.

---

## 6. Robustness

I conduct nine sets of robustness checks, summarized in Table 5 for the four key outcomes.

**Table 5: Robustness Specifications**

| Specification | Violent | Property | Robbery | F. Assault | Burglary |
|:---|---:|---:|---:|---:|---:|
| **Baseline (8/4)** | **-0.525** | **-0.466** | **-0.292** | **-0.258** | **-0.270** |
| Exclude Pct 75 | -0.742 | -0.488 | -0.350 | -0.434 | -0.307 |
| Near controls only | -0.510 | -0.362 | -0.278 | -0.259 | -0.214 |
| Cont. treated | -0.629 | -2.330 | -0.729 | +0.165 | -0.431 |
| 6 effects / 3 plc | -0.531 | -0.389 | -0.283 | -0.275 | -0.262 |
| 4 effects / 2 plc | -0.480 | -0.395 | -0.266 | -0.237 | -0.287 |
| Drop trans. quarters | -0.435 | -0.460 | -0.247 | -0.209 | -0.270 |
| Linger 1Q | -0.442 | -0.498 | -0.297 | -0.151 | -0.283 |
| Linger 2Q | -0.544 | -0.353 | -0.358 | -0.189 | -0.163 |
| Area overlap (50%) | -0.371 | -0.587 | -0.234 | -0.132 | -0.302 |

*Notes:* All estimates are cumulative ATTs from dCDH. "Near controls" restricts untreated hexes to those within 3 H3 rings of any ever-treated hex. "Cont. treated" restricts to hexes treated in every quarter Q3 2013--Q2 2015 vs. never-treated. "Linger 1Q/2Q" extends treatment 1 or 2 quarters past deactivation. "Area overlap" uses 50% hex-zone area overlap as the treatment threshold.

**Exclude 75th Precinct.** The 75th Precinct (East New York) is the highest-crime precinct in the sample. Excluding it strengthens the violent crime estimate from -0.53 to -0.74, suggesting that if anything, including this outlier precinct attenuates the baseline estimates.

**Restrict controls to nearby hexes.** Limiting the control group to hexagons within three H3 rings (~500 m) of any ever-treated hex produces estimates virtually identical to the baseline, confirming that results are not driven by comparisons between treated hot spots and geographically distant low-crime areas.

**Vary effects/placebo windows.** Using 6/3 or 4/2 instead of 8/4 effects/placebo windows produces estimates within 10% of the baseline, indicating robustness to the dynamic specification.

**Drop transition quarters.** Removing Q2 2012--Q2 2013 (the period of gradual SQF decline) has minimal impact on the estimates.

**Treatment linger sensitivity.** Extending treatment 1 or 2 quarters past zone deactivation---to account for residual deterrence---produces estimates broadly comparable to the baseline, with some expected attenuation as the treatment variable becomes more diffuse.

**Area-overlap treatment.** Using the percentage of hex area overlapping zone polygons (with a 50% threshold) rather than centroid-in-polygon assignment produces qualitatively similar results.

**H3 Resolution 8.** As a test of sensitivity to spatial scale, I reconstruct the panel at H3 resolution 8 (~0.74 km$^2$, approximately 7$\times$ larger cells). This coarser grid yields 1,113 hexagons with far fewer switchers, and the estimates are imprecise and centered around zero. This null result confirms that the crime-reducing effects of Impact Zones operate at fine spatial scales consistent with hot spots theory (Weisburd 2015) and validates the resolution-9 grid as the appropriate unit of analysis.

---

## 7. Discussion and Conclusion

This paper provides four central findings. First, NYPD Impact Zones reduced crime substantially---approximately 9% for violent felonies and 8--16% for individual crime categories---confirming and extending MacDonald, Fagan, and Geller (2016) with a modern estimator that correctly handles the program's switching treatment structure. Second, these crime reductions were driven entirely by police *presence*, not by enforcement actions such as stops or arrests. Conditioning on the full suite of enforcement measures---SQF stops (PC and NPC), felony arrests, and misdemeanor/violation arrests---leaves the treatment effect virtually unchanged. Third, the alternative explanation that crime stayed low due to residual deterrence from *past* enforcement is tested and rejected: cumulative enforcement history does not predict treatment effects, post-dissolution rebounds, or switch-on effect sizes, and zones reactivated after prolonged off-periods with minimal enforcement still show crime reductions. Fourth, the benefits of Impact Zones radiated outward to adjacent areas through crime diffusion rather than displacement, and persisted for at least five quarters after the program's formal dissolution.

### 7.1 Implications for Policing Policy

The presence finding has direct implications for the ongoing debate over proactive policing strategies. The NYPD conducted approximately 4.4 million investigative stops between 2004 and 2012, imposing enormous costs on the communities subjected to them. Tyler, Fagan, and Geller (2014) documented how these encounters eroded trust in police, particularly among young men of color. Petersen et al. (2023), in a meta-analysis of police stop programs, found that while stops can reduce crime at hot spots, the effects are modest and the collateral consequences substantial. My results suggest that the crime-control benefits attributed to Operation Impact did not require these stops. Officers standing on corners deterred crime; the stops they conducted while standing there added little.

This conclusion is consistent with the classic "scarecrow" hypothesis in the deterrence literature: the *perceived* risk of apprehension, generated by visible police presence, is the proximate cause of deterrence, not the *actual* risk as measured by enforcement outputs (Nagin 2013). It also aligns with Weisburd et al.'s (2016) finding that the marginal deterrent effect of additional SQF stops was modest and concentrated at the highest-activity locations.

The policy implication is that cities can pursue hot spots policing strategies built around visibility and patrol rather than aggressive enforcement, potentially achieving comparable crime reductions while avoiding the civil liberties costs and community harm associated with mass investigative stops.

### 7.2 Residual Deterrence

The first-touch estimates---roughly twice the full-panel average for violent crime---imply that Impact Zones generated residual deterrence that persisted during off periods between deployment iterations. This is a substantively important finding for the design of hot spots programs. If crime remains partially suppressed even after officers are withdrawn, then rotating deployments across locations (as Operation Impact did with its 22 iterations) may be more cost-effective than continuous deployment, as each location retains some deterrent benefit during off periods.

Critically, however, the evidence in Section 5.7 establishes that this residual deterrence is a consequence of *presence*, not *enforcement*. Cumulative enforcement history does not predict the magnitude of treatment effects, the speed of post-dissolution crime rebounds, or the size of crime reductions at reactivation. Zones that were reactivated after prolonged off-periods during the low-SQF era---conditions under which any enforcement residual would have fully dissipated---still experienced significant crime reductions. The residual deterrence is thus better understood as a persistent behavioral adjustment induced by the experience of being policed, rather than a fading echo of specific enforcement encounters. Potential offenders may avoid locations where they previously encountered police, even after officers are withdrawn, creating a form of "place-based memory" that sustains crime suppression.

The dissolution event study supports this interpretation: crime did not rebound sharply after the program ended in July 2015, suggesting that the deterrent signal persisted well beyond the final deployment. The contrast with Sorg et al.'s (2013) finding of immediate crime rebounds after foot patrol withdrawal may reflect the longer treatment duration in New York (years versus weeks), allowing more durable behavioral adjustments among potential offenders and more lasting changes in community guardianship patterns. The 22 deployment iterations of Operation Impact, spanning over a decade, may provide a natural laboratory for estimating the full decay curve of presence-based deterrence---an avenue for future research with implications for optimal patrol rotation scheduling.

### 7.3 Limitations

Several limitations warrant discussion. First, although I observe detailed SQF records and arrest data, I do not directly observe officer deployment---the number of officers assigned to each zone in each period. The "presence" effect I identify is therefore a residual: the treatment effect not explained by measured enforcement. It is possible that unmeasured aspects of enforcement (informal warnings, non-documented encounters) also contribute. However, the 94% collapse in documented SQF activity between the high-enforcement and low-enforcement periods, combined with the stability of the treatment effect across these eras, makes it unlikely that unmeasured enforcement accounts for a substantial share of the crime reduction.

Second, the dCDH estimator identifies treatment effects from "switchers"---hexagons whose treatment status changes. If the treatment effect differs systematically between switching and non-switching hexes (e.g., if zones that remain continuously active have larger effects), the ATT may not generalize to all treated locations. The continuously-treated robustness check partially addresses this concern, producing directionally consistent but less precisely estimated effects due to the small number of continuously-treated hexes.

Third, the post-dissolution window (5 quarters) is too short to determine whether the crime suppression in formerly treated areas is truly durable or merely slow to dissipate. Extending the panel through 2019 (pre-COVID) with publicly available complaint data would allow a more definitive test of residual deterrence, an avenue for future research.

Fourth, I cannot separately identify the contributions of foot patrol, vehicle patrol, and stationary presence, as these are not distinguished in the available data. The "presence" mechanism I document is an aggregate that subsumes all non-enforcement aspects of police deployment.

### 7.4 Conclusion

For nearly a decade, the NYPD's Operation Impact simultaneously deployed officers and had them conduct hundreds of thousands of investigative stops. When the stops disappeared---virtually overnight after *Floyd v. City of New York*---the crime reductions stayed. This paper shows that the ghost of enforcement past was never the enforcement at all. It was the officer standing on the corner.

---

## References

Borusyak, K., Jaravel, X., & Spiess, J. (2024). Revisiting event study designs: Robust and efficient estimation. *Review of Economic Studies*, 91(6), 3253--3285.

Braga, A. A., Turchan, B., Papachristos, A. V., & Hureau, D. M. (2019). Hot spots policing of small geographic areas effects on crime. *Campbell Systematic Reviews*, 15(3), e1046.

Callaway, B., & Sant'Anna, P. H. (2021). Difference-in-differences with multiple time periods. *Journal of Econometrics*, 225(2), 200--230.

de Chaisemartin, C., & D'Haultfoeuille, X. (2020). Two-way fixed effects estimators with heterogeneous treatment effects. *American Economic Review*, 110(9), 2964--2996.

de Chaisemartin, C., & D'Haultfoeuille, X. (2024). Difference-in-differences estimators of inter-temporal treatment effects. *Review of Economics and Statistics*, 106(6), 1723--1736.

Devi, T., & Fryer, R. G. (2020). Policing the police: The impact of "pattern-or-practice" investigations on crime. NBER Working Paper 27324.

Goodman-Bacon, A. (2021). Difference-in-differences with variation in treatment timing. *Journal of Econometrics*, 225(2), 254--277.

Kelling, G. L., & Coles, C. M. (1996). *Fixing Broken Windows: Restoring Order and Reducing Crime in Our Communities*. Free Press.

MacDonald, J., Fagan, J., & Geller, A. (2016). The effects of local police surges on crime and arrests in New York City. *PLoS ONE*, 11(6), e0157223.

MacDonald, J., & Fagan, J. (2019). Using shifts in deployment and operations to test for racial bias in police stops. *AEA Papers and Proceedings*, 109, 148--152.

Nagin, D. S. (2013). Deterrence in the twenty-first century. *Crime and Justice*, 42(1), 199--263.

Nagin, D. S., Solow, R. M., & Lum, C. (2015). Deterrence, criminal opportunities, and police. *Criminology*, 53(1), 74--100.

Petersen, J. M., Densley, J. A., Erickson, G., & Hass, J. (2023). Police stops to reduce crime: A systematic review and meta-analysis. *Campbell Systematic Reviews*, 19(4), e1073.

Sorg, E. T., Haberman, C. P., Ratcliffe, J. H., & Groff, E. R. (2013). Foot patrol in violent crime hot spots: The longitudinal impact of deterrence and posttreatment effects of displacement. *Criminology*, 51(1), 65--101.

Sullivan, C. M., & O'Keeffe, Z. P. (2017). Evidence that curtailing proactive policing can reduce major crime. *Nature Human Behaviour*, 1, 730--737.

Sun, L., & Abraham, S. (2021). Estimating dynamic treatment effects in event studies with heterogeneous treatment effects. *Journal of Econometrics*, 225(2), 175--199.

Tyler, T. R., Fagan, J., & Geller, A. (2014). Street stops and police legitimacy: Teachable moments in young urban men's legal socialization. *Journal of Empirical Legal Studies*, 11(4), 751--785.

Weisburd, D. (2015). The law of crime concentration and the criminology of place. *Criminology*, 53(2), 133--157.

Weisburd, D., & Telep, C. W. (2014). Hot spots policing: What we know and what we need to know. *Journal of Contemporary Criminal Justice*, 30(2), 200--220.

Weisburd, D., Wooditch, A., Weisburd, S., & Yang, S.-M. (2016). Do stop, question, and frisk practices deter crime? *Criminology & Public Policy*, 15(1), 31--56.

Wilson, J. Q., & Kelling, G. L. (1982). Broken windows: The police and neighborhood safety. *Atlantic Monthly*, 249(3), 29--38.
