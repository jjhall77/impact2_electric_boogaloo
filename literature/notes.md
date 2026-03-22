# Literature Notes: Operation Impact & Proactive Policing Research
Compiled: 2026-03-19
Project: Replication & Extension of MacDonald, Fagan & Geller (2016) — Effects of Local Police Surges on Crime and Arrests in NYC
Papers reviewed: 25

---

## I. THE REPLICATION TARGET

---

## MacDonald2016 — The Effects of Local Police Surges on Crime and Arrests in New York City

**Citation:** MacDonald, J., Fagan, J., & Geller, A. (2016). The effects of local police surges on crime and arrests in New York City. *PLoS ONE*, *11*(6), e0157223.

**Journal:** *PLoS ONE*, Vol. 11, No. 6 (June 2016)

**Key Findings:**
- Impact zones reduced total reported crimes by 12% (conditional FE Poisson, Model 1).
- Largest reductions in burglary (46%), robbery, and property felonies.
- Neighboring census block groups also experienced crime reductions of approximately 7%, indicating diffusion of benefits rather than displacement.
- Total arrests increased 53% in impact zones.
- Only probable cause stops (indicating observed criminal behavior) were associated with crime reductions; general suspicion stops had no measurable crime reduction effect.
- Permutation tests (1,000 iterations) confirmed results were not driven by autocorrelation in treatment timing.
- Five nested model specifications: baseline treatment effect, neighbor spillovers, event study leads/lags, dose-response (probable cause vs. non-probable cause stops), and precinct-specific time trends.

**Methods:** Difference-in-differences conditional fixed effects Poisson regression at the census block group × month level (2004–2012). Unit of analysis: 6,274 face blocks (census block group segments) across 76 precincts. Fixed effects: precinct × year-month. Clustered standard errors at precinct-month level. N = 840,297 (crime), 341,828 (arrests). Treatment: binary indicator for active impact zone status. Neighbor treatment coded for adjacent blocks.

**Relevance:** This is the paper being replicated. The central finding — that police presence reduced crime but the bulk of investigative stops did not contribute to those reductions — motivates the post-2012 extension examining what happened when SQF collapsed after Floyd v. NYC (2013).

**Notable Quotes:**
- "Police interventions of the sort undertaken by Operation Impact should pay careful attention that increased vigilance does not come at the cost of extra intrusion." (Conclusion)

**BibTeX:**
```bibtex
@article{macdonald2016effects,
  author    = {MacDonald, John and Fagan, Jeffrey and Geller, Amanda},
  title     = {The Effects of Local Police Surges on Crime and Arrests in New York City},
  journal   = {PLoS ONE},
  year      = {2016},
  volume    = {11},
  number    = {6},
  pages     = {e0157223},
  doi       = {10.1371/journal.pone.0157223}
}
```

---

## II. HOT SPOTS POLICING — THEORY & META-ANALYTIC EVIDENCE

---

## Koper1995 — Just Enough Police Presence: Reducing Crime and Disorderly Behavior by Optimizing Patrol Time in Crime Hot Spots

**Citation:** Koper, C. S. (1995). Just enough police presence: Reducing crime and disorderly behavior by optimizing patrol time in crime hot spots. *Justice Quarterly*, *12*(4), 649–672.

**Journal:** *Justice Quarterly*, Vol. 12, No. 4, pp. 649–672 (1995)

**Key Findings:**
- Police patrol presence at hot spots has diminishing returns — the optimal patrol dosage is approximately 10–15 minutes per visit.
- After police leave a hot spot, the deterrent effect persists for approximately 15 minutes before decay begins (the "Koper curve").
- Longer patrol visits beyond the 10–15 minute threshold do not produce proportionally greater deterrence.
- Suggests a strategy of brief, intermittent patrols rotating across hot spots rather than sustained saturation.

**Methods:** Survival analysis of systematic social observation data from the Minneapolis Hot Spots Patrol Experiment; modeled time until disorder/crime resumes after police departure.

**Relevance:** Foundational for understanding optimal police dosage at crime hot spots. Operation Impact deployed officers for extended, sustained periods; Koper's findings raise questions about whether Impact's continuous saturation was the optimal deployment strategy versus rotating brief visits.

**BibTeX:**
```bibtex
@article{koper1995just,
  author    = {Koper, Christopher S.},
  title     = {Just Enough Police Presence: Reducing Crime and Disorderly Behavior by Optimizing Patrol Time in Crime Hot Spots},
  journal   = {Justice Quarterly},
  year      = {1995},
  volume    = {12},
  number    = {4},
  pages     = {649--672}
}
```

---

## Weisburd2014 — Hot Spots Policing: What We Know and What We Need to Know

**Citation:** Weisburd, D. & Telep, C. W. (2014). Hot spots policing: What we know and what we need to know. *Journal of Contemporary Criminal Justice*, *30*(2), 200–220.

**Journal:** *Journal of Contemporary Criminal Justice*, Vol. 30, No. 2, pp. 200–220 (2014)

**Key Findings:**
- Hot spots policing is generally effective at reducing crime, with robust evidence from multiple RCTs and quasi-experiments.
- Six key knowledge gaps identified: (1) non-spatial displacement effects, (2) what specific tactics work best at hot spots, (3) effects on police legitimacy, (4) applicability to smaller cities, (5) long-term sustainability of effects, (6) whether localized effects translate to jurisdictional crime reductions.
- Problem-oriented policing approaches at hot spots may generate larger effects than simple directed patrol.
- The question of what police should *do* at hot spots — beyond simply being present — remains inadequately answered.

**Methods:** Narrative review and synthesis of the hot spots policing evidence base.

**Relevance:** Identifies the research gaps that MacDonald et al. (2016) and the planned extension directly address — particularly whether hot spots effects are sustained over time and whether they translate to precinct-wide crime reductions.

**BibTeX:**
```bibtex
@article{weisburd2014hot,
  author    = {Weisburd, David and Telep, Cody W.},
  title     = {Hot Spots Policing: What We Know and What We Need to Know},
  journal   = {Journal of Contemporary Criminal Justice},
  year      = {2014},
  volume    = {30},
  number    = {2},
  pages     = {200--220}
}
```

---

## Braga2019a — Hot Spots Policing of Small Geographic Areas: Effects on Crime (Campbell Review)

**Citation:** Braga, A. A., Turchan, B., Papachristos, A. V., & Hureau, D. M. (2019). Hot spots policing of small geographic areas: Effects on crime. *Campbell Systematic Reviews*, *15*, e1046.

**Journal:** *Campbell Systematic Reviews*, Vol. 15, e1046 (2019)

**Key Findings:**
- 62 of 78 tests reported noteworthy crime reductions from hot spots policing interventions.
- Meta-analysis revealed a small but statistically significant mean effect size favoring hot spots policing.
- Effect sizes were smaller for randomized designs but remained significant.
- Diffusion of crime prevention benefits into adjacent areas was more common than displacement.
- Crime control gains were evident across drug offenses, disorder offenses, property crimes, and violent crimes.

**Methods:** Updated Campbell systematic review and meta-analysis; 65 studies with 78 tests; random effects models; includes 27 RCTs and 38 quasi-experimental designs.

**Relevance:** The definitive meta-analytic evidence base for hot spots policing. The finding that displacement is uncommon and diffusion of benefits is common supports MacDonald et al.'s Model 2 results showing crime reductions in neighboring blocks.

**BibTeX:**
```bibtex
@article{braga2019campbell,
  author    = {Braga, Anthony A. and Turchan, Brandon and Papachristos, Andrew V. and Hureau, David M.},
  title     = {Hot Spots Policing of Small Geographic Areas: Effects on Crime},
  journal   = {Campbell Systematic Reviews},
  year      = {2019},
  volume    = {15},
  pages     = {e1046}
}
```

---

## Braga2019b — Hot Spots Policing and Crime Reduction: An Update of an Ongoing Systematic Review and Meta-Analysis

**Citation:** Braga, A. A., Turchan, B. S., Papachristos, A. V., & Hureau, D. M. (2019). Hot spots policing and crime reduction: An update of an ongoing systematic review and meta-analysis. *Journal of Experimental Criminology*, *15*, 289–311.

**Journal:** *Journal of Experimental Criminology*, Vol. 15, pp. 289–311 (2019)

**Key Findings:**
- Journal companion to the Campbell review above; confirms small but statistically significant crime reduction effects.
- Results robust across various moderating variables (study design, intervention type, crime category).
- Diffusion of crime control benefits more common than displacement across the full body of evidence.

**Methods:** Same systematic review protocol as the Campbell review; random effects meta-analysis following Campbell Collaboration standards.

**Relevance:** Provides peer-reviewed journal version of the meta-analytic evidence supporting the general effectiveness of the hot spots approach underlying Operation Impact.

**BibTeX:**
```bibtex
@article{braga2019update,
  author    = {Braga, Anthony A. and Turchan, Brandon S. and Papachristos, Andrew V. and Hureau, David M.},
  title     = {Hot Spots Policing and Crime Reduction: An Update of an Ongoing Systematic Review and Meta-Analysis},
  journal   = {Journal of Experimental Criminology},
  year      = {2019},
  volume    = {15},
  pages     = {289--311}
}
```

---

## Nagin2015 — Deterrence, Criminal Opportunities, and Police

**Citation:** Nagin, D. S., Solow, R. M., & Lum, C. (2015). Deterrence, criminal opportunities, and police. *Criminology*, *53*(1), 74–100.

**Journal:** *Criminology*, Vol. 53, No. 1, pp. 74–100 (2015)

**Key Findings:**
- Developed a mathematical model of how police affect the distribution of criminal opportunities.
- Increasing police visibility in crime hot spots generates substantial marginal deterrent effects by heightening offenders' perceived risk of apprehension.
- The model shows why hot spots policing is more efficient than random patrol — concentrated presence changes the opportunity structure.
- The clearance rate is a fundamentally flawed metric of police performance; police affect crime primarily through their influence on the distribution of criminal opportunities rather than through post-crime apprehension.

**Methods:** Theoretical/mathematical model of criminal opportunity distribution and offender decision-making; formal optimization framework.

**Relevance:** Provides the theoretical foundation for why saturation patrols in impact zones could reduce crime — through altering the perceived risk landscape for offenders rather than through arrests. This aligns with MacDonald et al.'s finding that police presence mattered more than the volume of investigative stops.

**BibTeX:**
```bibtex
@article{nagin2015deterrence,
  author    = {Nagin, Daniel S. and Solow, Robert M. and Lum, Cynthia},
  title     = {Deterrence, Criminal Opportunities, and Police},
  journal   = {Criminology},
  year      = {2015},
  volume    = {53},
  number    = {1},
  pages     = {74--100}
}
```

---

## III. THE PHILADELPHIA FOOT PATROL EXPERIMENTS

---

## Ratcliffe2011 — The Philadelphia Foot Patrol Experiment: A Randomized Controlled Trial of Police Patrol Effectiveness

**Citation:** Ratcliffe, J. H., Taniguchi, T., Groff, E. R., & Wood, J. D. (2011). The Philadelphia Foot Patrol Experiment: A randomized controlled trial of police patrol effectiveness. *Criminology*, *49*(3), 795–831.

**Journal:** *Criminology*, Vol. 49, No. 3, pp. 795–831 (2011)

**Key Findings:**
- Foot patrols in violent crime hot spots reduced violent crime by 23% relative to matched controls during the 12-week experimental period.
- 249 additional officers deployed across 60 treatment beats (of 120 total) in Philadelphia.
- Net reduction of 53 violent crimes across treatment areas.
- No evidence of significant displacement to surrounding areas.

**Methods:** Randomized controlled trial with 120 hot spot beats (60 treatment, 60 control); power-equated block randomization; 12-week treatment period in summer 2009.

**Relevance:** One of the strongest experimental tests of hot spots foot patrol, directly analogous to Operation Impact's deployment of additional officers to designated zones. The 23% violent crime reduction is comparable in magnitude to Impact's effects, suggesting consistency across cities and experimental designs.

**BibTeX:**
```bibtex
@article{ratcliffe2011philadelphia,
  author    = {Ratcliffe, Jerry H. and Taniguchi, Travis and Groff, Elizabeth R. and Wood, Jennifer D.},
  title     = {The Philadelphia Foot Patrol Experiment: A Randomized Controlled Trial of Police Patrol Effectiveness},
  journal   = {Criminology},
  year      = {2011},
  volume    = {49},
  number    = {3},
  pages     = {795--831}
}
```

---

## Sorg2013 — Foot Patrol in Violent Crime Hot Spots: The Longitudinal Impact of Deterrence and Posttreatment Effects of Displacement

**Citation:** Sorg, E. T., Haberman, C. P., Ratcliffe, J. H., & Groff, E. R. (2013). Foot patrol in violent crime hot spots: The longitudinal impact of deterrence and posttreatment effects of displacement. *Criminology*, *51*(1), 65–101.

**Journal:** *Criminology*, Vol. 51, No. 1, pp. 65–101 (2013)

**Key Findings:**
- Revisiting the Philadelphia experiment, beats staffed for 22 weeks showed decaying deterrent effects during the experiment; 12-week beats did not show decay.
- No residual deterrence effects were observed after the experiment ended relative to controls.
- Displacement observed during the experiment decayed within 3 months post-experiment.
- Inverse displacement (previously displaced crime flowing back to target areas) is theoretically plausible and may contribute to deterrence decay.

**Methods:** Multilevel growth curve models analyzing pre-, during-, and post-experimental crime data from 120 hot spot beats; weighted displacement quotient analysis.

**Relevance:** Tests the longitudinal sustainability of hot spot policing effects — a central concern for Operation Impact, which was sustained for nearly a decade. The finding that deterrence effects evaporate when foot patrols are withdrawn is directly relevant to predicting what happened when Impact was wound down and SQF collapsed post-2012.

**BibTeX:**
```bibtex
@article{sorg2013foot,
  author    = {Sorg, Evan T. and Haberman, Cory P. and Ratcliffe, Jerry H. and Groff, Elizabeth R.},
  title     = {Foot Patrol in Violent Crime Hot Spots: The Longitudinal Impact of Deterrence and Posttreatment Effects of Displacement},
  journal   = {Criminology},
  year      = {2013},
  volume    = {51},
  number    = {1},
  pages     = {65--101}
}
```

---

## Sorg2017 — Explaining Dosage Diffusion During Hot Spot Patrols: An Application of Optimal Foraging Theory to Police Officer Behavior

**Citation:** Sorg, E. T., Wood, J. D., Groff, E. R., & Ratcliffe, J. H. (2017). Explaining dosage diffusion during hot spot patrols: An application of optimal foraging theory to police officer behavior. *Justice Quarterly*, *34*(6), 1044–1068.

**Journal:** *Justice Quarterly*, Vol. 34, No. 6, pp. 1044–1068 (2017)

**Key Findings:**
- Officers assigned to hot spot foot patrols frequently left their assigned areas during patrol shifts ("dosage diffusion").
- Applied optimal foraging theory to explain officer behavior: officers "foraged" for enforcement opportunities beyond their assigned beats.
- The time officers spent outside their beats was related to the perceived productivity of their assigned area.
- Dosage diffusion has direct implications for treatment fidelity in hot spots policing experiments and real-world implementations.

**Methods:** GPS tracking data of officers during the Philadelphia Foot Patrol Experiment; survival analysis and qualitative field observations.

**Relevance:** Raises important questions about treatment fidelity in Operation Impact. Even when officers are assigned to impact zones, they may spend significant time outside those zones, diluting treatment intensity. This dosage diffusion could attenuate measured effects of the program.

**BibTeX:**
```bibtex
@article{sorg2017explaining,
  author    = {Sorg, Evan T. and Wood, Jennifer D. and Groff, Elizabeth R. and Ratcliffe, Jerry H.},
  title     = {Explaining Dosage Diffusion During Hot Spot Patrols: An Application of Optimal Foraging Theory to Police Officer Behavior},
  journal   = {Justice Quarterly},
  year      = {2017},
  volume    = {34},
  number    = {6},
  pages     = {1044--1068}
}
```

---

## IV. CITYWIDE EFFECTS & HOT SPOTS STRATEGY VARIATION

---

## Tregle2025a — More Than Meets the Eye: Examining the Impact of Hot Spots Policing on the Reduction of City-Wide Crime

**Citation:** Tregle, B., Smith, M. R., Fahmy, C., & Tillyer, R. (2025). More than meets the eye: Examining the impact of hot spots policing on the reduction of city-wide crime. *Crime Science*, *14*, 3.

**Journal:** *Crime Science*, Vol. 14, Article 3 (2025)

**Key Findings:**
- Hot spots policing can produce citywide crime reductions, not just localized effects.
- A Texas city with a two-year hot spots intervention showed significant citywide violent crime reduction compared to two control cities.
- Sustained reductions extended beyond the designated hot spots into the broader jurisdiction.
- Addresses a critical gap identified by Weisburd & Telep (2014) about whether localized effects translate to jurisdictional outcomes.

**Methods:** Interrupted time series analysis (ITSA) comparing seven years of violent crime data across three major Texas cities; one treatment city vs. two control cities.

**Relevance:** If hot spots policing produces citywide effects, then Operation Impact's deployments across many precincts could have contributed to NYC's overall crime decline — and conversely, the withdrawal of Impact could have citywide consequences. Directly relevant to the extension analysis.

**BibTeX:**
```bibtex
@article{tregle2025more,
  author    = {Tregle, Brandon and Smith, Michael R. and Fahmy, Chantal and Tillyer, Rob},
  title     = {More Than Meets the Eye: Examining the Impact of Hot Spots Policing on the Reduction of City-Wide Crime},
  journal   = {Crime Science},
  year      = {2025},
  volume    = {14},
  pages     = {3}
}
```

---

## Tregle2025b — Hot Spots Policing: Assessing the Impact on Officer-Initiated Activity

**Citation:** Tregle, B., Tillyer, R., & Smith, M. (2025). Hot spots policing: Assessing the impact on officer-initiated activity. *Police Quarterly*, *28*(4), 435–459.

**Journal:** *Police Quarterly*, Vol. 28, No. 4, pp. 435–459 (2025)

**Key Findings:**
- Different hot spots strategies produce different community burdens.
- High-visibility (HV) deterrence strategies had NO effect on self-initiated officer activity (stops, searches, arrests).
- Proactive, offender-focused (OF) approaches produced statistically significant increases in four of five categories of self-initiated activity.
- Suggests hot spots policing is "not monolithic" — the mechanism matters.

**Methods:** Multi-year quasi-experimental comparison of HV vs. OF hot spots treatment areas in Dallas, TX; analysis of officer-initiated activity data.

**Relevance:** Directly relevant because Operation Impact combined both high-visibility presence AND offender-focused enforcement (SQF). This paper suggests the HV component alone could achieve crime reductions without the increased community burden — supporting MacDonald et al.'s finding that general suspicion stops added no crime reduction value.

**BibTeX:**
```bibtex
@article{tregle2025hot,
  author    = {Tregle, Brandon and Tillyer, Rob and Smith, Michael},
  title     = {Hot Spots Policing: Assessing the Impact on Officer-Initiated Activity},
  journal   = {Police Quarterly},
  year      = {2025},
  volume    = {28},
  number    = {4},
  pages     = {435--459}
}
```

---

## V. STOP, QUESTION, AND FRISK — EFFECTIVENESS & DETERRENCE

---

## Weisburd2015 — Do Stop, Question, and Frisk Practices Deter Crime?

**Citation:** Weisburd, D., Wooditch, A., Weisburd, S., & Yang, S.-M. (2015). Do stop, question, and frisk practices deter crime? Evidence at microunits of space and time. *Criminology & Public Policy*, *15*(1).

**Journal:** *Criminology & Public Policy*, Vol. 15, No. 1 (2015)

**Key Findings:**
- SQFs produce a significant yet modest deterrent effect on crime at the micro-geographic level.
- Approximately 2% crime reduction associated with weekly changes in SQF activity at the street segment level.
- The effect is concentrated at crime hot spots, consistent with place-based deterrence.
- Cannot fully separate the effect of SQF from the effect of increased police presence/deployment that accompanies SQF activity.

**Methods:** Space-time interaction models using NYC SQF data geocoded to street segments; panel data with daily and weekly crime counts.

**Relevance:** Attempts to isolate SQF's crime-deterrent effect at micro-levels in NYC. MacDonald et al. (2016) cite this study but note its inability to separate deployment effects from stop effects. The modest effect size is consistent with MacDonald et al.'s finding that only probable-cause stops had measurable crime reduction effects.

**BibTeX:**
```bibtex
@article{weisburd2015stop,
  author    = {Weisburd, David and Wooditch, Alese and Weisburd, Sarit and Yang, Sue-Ming},
  title     = {Do Stop, Question, and Frisk Practices Deter Crime? Evidence at Microunits of Space and Time},
  journal   = {Criminology \& Public Policy},
  year      = {2015},
  volume    = {15},
  number    = {1}
}
```

---

## Petersen2023 — Police Stops to Reduce Crime: A Systematic Review and Meta-Analysis

**Citation:** Petersen, K., Weisburd, D., Fay, S., Eggins, E., & Mazerolle, L. (2023). Police stops to reduce crime: A systematic review and meta-analysis. *Campbell Systematic Reviews*, *19*, e1302.

**Journal:** *Campbell Systematic Reviews*, Vol. 19, e1302 (2023)

**Key Findings:**
- Police stop interventions associated with 13% reduction in area-level crime (95% CI: −16%, −9%).
- Diffusion of crime control benefits: 7% reduction in displacement areas.
- However, stops associated with 46% increase in odds of mental health issues, 36% increase in physical health issues among stopped individuals.
- Significantly more negative attitudes toward police (g = −0.38) and higher self-reported delinquency (g = 0.30) among stopped individuals.
- Negative individual effects more pronounced for youth.
- Hot spots policing and problem-oriented policing show larger crime reductions without similar individual-level harms.

**Methods:** Campbell systematic review and meta-analysis; 40 studies, 58 effect sizes; random effects models with REML; covers 90,904 people and 20,876 places.

**Relevance:** The most comprehensive meta-analysis of pedestrian stops. The dual finding — stops reduce area-level crime but harm individuals stopped — frames the core tension of Operation Impact. The 13% area-level reduction is remarkably consistent with MacDonald et al.'s 12% finding, but documented individual harms suggest alternative strategies could achieve similar results with fewer costs.

**BibTeX:**
```bibtex
@article{petersen2023police,
  author    = {Petersen, Kevin and Weisburd, David and Fay, Sydney and Eggins, Elizabeth and Mazerolle, Lorraine},
  title     = {Police Stops to Reduce Crime: A Systematic Review and Meta-Analysis},
  journal   = {Campbell Systematic Reviews},
  year      = {2023},
  volume    = {19},
  pages     = {e1302}
}
```

---

## NAS2018 — Proactive Policing: Effects on Crime and Communities

**Citation:** National Academies of Sciences, Engineering, and Medicine (2018). *Proactive Policing: Effects on Crime and Communities.* Washington, DC: The National Academies Press.

**Publisher:** National Academies Press (2018)

**Key Findings:**
- Hot spots policing generates statistically significant crime reductions without simply displacing crime; diffusion of benefits is common.
- SQF as a general citywide strategy has mixed evidence; focused uses targeting gun crime hot spots show consistent short-term effects.
- Focused deterrence programs generate large crime reduction effects.
- Community-oriented policing does not show consistent crime prevention benefits.
- Aggressive misdemeanor arrest-based broken windows approaches generate small to null crime impacts.
- Proactive policing may raise Fourth Amendment and Equal Protection concerns even when not inherently unconstitutional.

**Methods:** Consensus study report by a 15-member expert committee; systematic review of evidence across multiple proactive policing strategies over 2 years.

**Relevance:** The definitive review of proactive policing evidence. Operation Impact is a prototypical case of the place-based and person-focused strategies reviewed. The conclusion that SQF has mixed evidence citywide but more consistent evidence when focused at specific crime places directly bears on interpreting MacDonald et al.'s findings and planning the extension.

**BibTeX:**
```bibtex
@book{nas2018proactive,
  author    = {{National Academies of Sciences, Engineering, and Medicine}},
  title     = {Proactive Policing: Effects on Crime and Communities},
  publisher = {The National Academies Press},
  year      = {2018},
  address   = {Washington, DC},
  doi       = {10.17226/24928}
}
```

---

## VI. RACIAL BIAS & DISPARITIES IN STOP-AND-FRISK

---

## Gelman2007 — An Analysis of the NYPD's Stop-and-Frisk Policy in the Context of Claims of Racial Bias

**Citation:** Gelman, A., Fagan, J., & Kiss, A. (2007). An analysis of the New York City Police Department's "stop-and-frisk" policy in the context of claims of racial bias. *Journal of the American Statistical Association*, *102*(479), 813–823.

**Journal:** *Journal of the American Statistical Association*, Vol. 102, No. 479, pp. 813–823 (2007)

**Key Findings:**
- After controlling for precinct-level crime rates, Blacks and Hispanics were stopped more frequently than whites.
- Hit rates (arrests, seizures of weapons/contraband) were lower for minority stops than for white stops, suggesting lower thresholds for stopping minorities.
- Racial disparities persisted even after controlling for precinct-level variation in crime.
- Established a hierarchical modeling framework for benchmarking stop rates against crime-specific rates.

**Methods:** Multilevel Poisson regression analyzing 175,000+ stops in 1998–1999 across 75 NYC precincts; benchmarked stop rates against precinct-level crime rates and population demographics.

**Relevance:** Fagan is a co-author of both this paper and the MacDonald et al. replication target. This paper established the statistical framework for analyzing racial bias in NYPD SQF, which directly informed the Operation Impact analysis. The finding that minority stops had lower hit rates is consistent with the later finding that general suspicion stops had no crime reduction benefit.

**BibTeX:**
```bibtex
@article{gelman2007analysis,
  author    = {Gelman, Andrew and Fagan, Jeffrey and Kiss, Alex},
  title     = {An Analysis of the {New York City Police Department's} ``Stop-and-Frisk'' Policy in the Context of Claims of Racial Bias},
  journal   = {Journal of the American Statistical Association},
  year      = {2007},
  volume    = {102},
  number    = {479},
  pages     = {813--823}
}
```

---

## Goel2016 — Precinct or Prejudice? Understanding Racial Disparities in New York City's Stop-and-Frisk Policy

**Citation:** Goel, S., Rao, J. M., & Shroff, R. (2016). Precinct or prejudice? Understanding racial disparities in New York City's stop-and-frisk policy. *The Annals of Applied Statistics*, *10*(1), 365–394.

**Journal:** *The Annals of Applied Statistics*, Vol. 10, No. 1, pp. 365–394 (2016)

**Key Findings:**
- In over 40% of criminal possession of a weapon (CPW) stops, the likelihood of finding a weapon was less than 1%, raising concerns about whether "reasonable suspicion" was met.
- Blacks and Hispanics were disproportionately stopped in low hit-rate contexts.
- Racial disparities traced to two factors: (1) lower thresholds for stopping *anyone* in high-crime, predominantly minority areas (especially public housing), and (2) lower thresholds for stopping minorities relative to similarly situated whites.
- By conducting only the 6% of stops statistically most likely to yield weapons, police could recover the majority of weapons while mitigating racial disparities.

**Methods:** Bayesian hierarchical model estimating ex ante probability of weapon recovery for each CPW stop; analysis of approximately 3 million stops over 5 years in NYC.

**Relevance:** Directly analyzes NYPD SQF data during the same period as Operation Impact. Demonstrates that most stops in high-crime areas (including impact zones) had extremely low hit rates, supporting MacDonald et al.'s finding that general suspicion stops had no crime reduction benefit.

**BibTeX:**
```bibtex
@article{goel2016precinct,
  author    = {Goel, Sharad and Rao, Justin M. and Shroff, Ravi},
  title     = {Precinct or Prejudice? Understanding Racial Disparities in {New York City's} Stop-and-Frisk Policy},
  journal   = {The Annals of Applied Statistics},
  year      = {2016},
  volume    = {10},
  number    = {1},
  pages     = {365--394}
}
```

---

## MacDonald2019 — Using Shifts in Deployment and Operations to Test for Racial Bias in Police Stops

**Citation:** MacDonald, J. M. & Fagan, J. (2019). Using shifts in deployment and operations to test for racial bias in police stops. *AEA Papers and Proceedings*, *109*, 148–151.

**Journal:** *AEA Papers and Proceedings*, Vol. 109, pp. 148–151 (2019)

**Key Findings:**
- Used the July 2007 expansion of impact zones in Brooklyn and Queens as a natural experiment.
- Impact zone formation increased arrests, summons, and frisks disproportionately for Blacks and Hispanics.
- Recovery rates for weapons and contraband did not differ by race, suggesting race-neutral search standards.
- However, the increased volume of stops fell primarily on Black and Hispanic residents.
- Applied a triple-difference (DDD) estimator combining temporal, spatial, and racial variation.

**Methods:** Difference-in-difference-in-differences with entropy distance weighting (doubly robust estimator); NYC SQF data from 2007.

**Relevance:** By the same authors as the replication target — directly tests for racial bias in Operation Impact's SQF activities. Establishes that while search thresholds appeared race-neutral, the volume imposed a racially disparate burden, a key finding for understanding equity implications.

**BibTeX:**
```bibtex
@article{macdonald2019using,
  author    = {MacDonald, John M. and Fagan, Jeffrey},
  title     = {Using Shifts in Deployment and Operations to Test for Racial Bias in Police Stops},
  journal   = {AEA Papers and Proceedings},
  year      = {2019},
  volume    = {109},
  pages     = {148--151}
}
```

---

## VII. POLICE LEGITIMACY & CONSTITUTIONAL COSTS

---

## Tyler2014 — Street Stops and Police Legitimacy: Teachable Moments in Young Urban Men's Legal Socialization

**Citation:** Tyler, T. R., Fagan, J., & Geller, A. (2014). Street stops and police legitimacy: Teachable moments in young urban men's legal socialization. *Journal of Empirical Legal Studies*, *11*(4), 751–785.

**Journal:** *Journal of Empirical Legal Studies*, Vol. 11, No. 4, pp. 751–785 (2014)

**Key Findings:**
- More police stops experienced or witnessed by young men were associated with diminished perceptions of police legitimacy.
- The impact was mediated by evaluations of fairness and lawfulness, not simply by the number or intrusiveness of stops.
- Lowered legitimacy was associated with reduced law-abidingness and willingness to cooperate with legal authorities.
- 85% of 18–26 year old males in the sample had been stopped at least once; 46% in the past year.
- Each police-citizen contact is framed as "a teachable moment" that builds or undermines legitimacy.

**Methods:** Telephone survey of 1,261 young men ages 18–26 in 37 NYC neighborhoods, stratified by SQF stop rates; structural equation modeling of relationships between stops, procedural justice perceptions, legitimacy, and law-related behaviors.

**Relevance:** Examines the legitimacy costs of NYPD's SQF regime during the Operation Impact period. Even if impact zones reduced crime, the massive increase in stops may have undermined police legitimacy among young men of color, potentially generating long-term costs for public safety cooperation. Fagan is a co-author of both this paper and the replication target.

**BibTeX:**
```bibtex
@article{tyler2014street,
  author    = {Tyler, Tom R. and Fagan, Jeffrey and Geller, Amanda},
  title     = {Street Stops and Police Legitimacy: Teachable Moments in Young Urban Men's Legal Socialization},
  journal   = {Journal of Empirical Legal Studies},
  year      = {2014},
  volume    = {11},
  number    = {4},
  pages     = {751--785}
}
```

---

## Meares2015 — Programming Errors: Understanding the Constitutionality of Stop-and-Frisk as a Program, Not an Incident

**Citation:** Meares, T. L. (2015). Programming errors: Understanding the constitutionality of stop-and-frisk as a program, not an incident. *The University of Chicago Law Review*, *82*, 159–179.

**Journal:** *The University of Chicago Law Review*, Vol. 82, pp. 159–179 (2015)

**Key Findings:**
- Fundamental mismatch between Terry v. Ohio's individual-incident framework and modern programmatic SQF.
- Terry authorized individual stops based on individualized suspicion, but SQF was implemented as a mass program targeting demographic groups.
- The constitutional framework fails to account for the cumulative effect of repeated stops on the same individuals and communities.
- NYPD stops increased from 160,851 in 2003 to 685,724 in 2011 — a programmatic scale.
- Fourth Amendment reasonableness should consider the programmatic nature of SQF, not just individual encounters.

**Methods:** Legal analysis and constitutional theory.

**Relevance:** Operation Impact was precisely the type of programmatic SQF deployment that Meares critiques. The program systematically deployed officers to conduct mass stops in designated zones, creating a programmatic experience for residents that diverges from the individualized reasonable suspicion standard of Terry.

**BibTeX:**
```bibtex
@article{meares2015programming,
  author    = {Meares, Tracey L.},
  title     = {Programming Errors: Understanding the Constitutionality of Stop-and-Frisk as a Program, Not an Incident},
  journal   = {The University of Chicago Law Review},
  year      = {2015},
  volume    = {82},
  pages     = {159--179}
}
```

---

## VIII. THE DE-POLICING DEBATE — ENFORCEMENT WITHDRAWAL & CRIME

---

## Sullivan2017 — Evidence That Curtailing Proactive Policing Can Reduce Major Crime

**Citation:** Sullivan, C. M. & O'Keeffe, Z. P. (2017). Evidence that curtailing proactive policing can reduce major crime. *Nature Human Behaviour*, *1*, 0211.

**Journal:** *Nature Human Behaviour*, Vol. 1, Article 0211 (2017)

**Key Findings:**
- During the NYPD "slowdown" in late 2014/early 2015, civilian complaints of major crimes (burglary, felony assault, grand larceny) decreased.
- Sharp reductions in proactive policing (SQF, summonses, low-level arrests) were associated with fewer reports of major crime.
- The authors argue this implies that aggressively enforcing minor legal statutes incites more severe criminal acts.
- Challenges both broken windows theory and deterrence perspectives.

**Methods:** Analysis of weekly NYPD crime complaints, arrests, summonses, and SQF during the political shock following the killing of two NYPD officers in December 2014; interrupted time series / regression discontinuity approach.

**Relevance:** Directly relevant to the post-2012 extension. If proactive policing actually increases major crime (as Sullivan and O'Keeffe claim), the curtailment of Operation Impact and SQF after Floyd should have reduced crime. However, see Chalfin et al. (2024) below, which challenges these findings as non-robust.

**BibTeX:**
```bibtex
@article{sullivan2017evidence,
  author    = {Sullivan, Christopher M. and O'Keeffe, Zachary P.},
  title     = {Evidence That Curtailing Proactive Policing Can Reduce Major Crime},
  journal   = {Nature Human Behaviour},
  year      = {2017},
  volume    = {1},
  pages     = {0211}
}
```

---

## Chalfin2024 — Does Proactive Policing Really Increase Major Crime? A Replication Study

**Citation:** Chalfin, A., Mitre-Becerril, D., & Williams, M. C. (2024). Does proactive policing really increase major crime? A replication study of Sullivan and O'Keeffe (Nature Human Behaviour, 2017). *Journal of Comments and Replications in Economics*, *3*, 1–34.

**Journal:** *Journal of Comments and Replications in Economics (JCRE)*, Vol. 3, pp. 1–34 (2024)

**Key Findings:**
- The Sullivan and O'Keeffe (2017) finding that the NYPD slowdown reduced major crime does not hold under scrutiny.
- After correcting for data errors, using different specifications, and accounting for timing issues, the original result disappears or reverses.
- No robust evidence that the curtailment of proactive policing in late 2014/early 2015 reduced major crime in NYC.
- The original paper's results were driven by specific modeling choices and data construction decisions.

**Methods:** Replication study using the same NYPD data as Sullivan and O'Keeffe; extensive sensitivity analyses across specifications, time windows, and crime definitions.

**Relevance:** Directly relevant to the extension plan. The NYPD slowdown occurred after Floyd v. NYC. If proactive policing curtailment did not increase crime (contra Sullivan and O'Keeffe), this supports the view that the SQF decline may not have compromised public safety — a central question for extending MacDonald et al. beyond 2012.

**BibTeX:**
```bibtex
@article{chalfin2024proactive,
  author    = {Chalfin, Aaron and Mitre-Becerril, David and Williams, Morgan C.},
  title     = {Does Proactive Policing Really Increase Major Crime? A Replication Study of {Sullivan and O'Keeffe} ({Nature Human Behaviour}, 2017)},
  journal   = {Journal of Comments and Replications in Economics},
  year      = {2024},
  volume    = {3},
  pages     = {1--34}
}
```

---

## Devi2020 — Policing the Police: The Impact of "Pattern-or-Practice" Investigations on Crime

**Citation:** Devi, T. & Fryer, R. G., Jr. (2020). Policing the police: The impact of "pattern-or-practice" investigations on crime. NBER Working Paper No. 27324.

**Journal:** NBER Working Paper Series, No. 27324 (June 2020)

**Key Findings:**
- Federal investigations of police departments NOT preceded by viral incidents led to reduced homicides and crime.
- Investigations preceded by viral incidents of deadly force (Baltimore, Chicago, Cincinnati, Riverside, Ferguson) led to approximately 893 excess homicides and 34,000 excess felonies over two years.
- The mechanism appears to be abrupt reduction in policing activity (e.g., Chicago police-civilian interactions dropped ~90% post-announcement).
- Cities without viral incidents saw no change in policing quantity or crime.
- Viral shootings alone (without investigation) did not increase crime.

**Methods:** Synthetic control method combined with staggered difference-in-differences; analysis of 42 police departments investigated by DOJ; monthly UCR crime data; supplementary policing data from 15 departments via FOIA requests.

**Relevance:** Highly relevant to the post-2012 extension. Floyd v. NYC (2013) was a major legal intervention that similarly constrained proactive policing. However, Floyd was not preceded by the kind of viral deadly force incident that Devi and Fryer find drives crime increases, so the extension analysis may expect a different trajectory.

**BibTeX:**
```bibtex
@techreport{devi2020policing,
  author      = {Devi, Tanaya and Fryer, Roland G., Jr.},
  title       = {Policing the Police: The Impact of ``Pattern-or-Practice'' Investigations on Crime},
  institution = {National Bureau of Economic Research},
  year        = {2020},
  type        = {Working Paper},
  number      = {27324}
}
```

---

## Cho2021 — Do Police Make Too Many Arrests?

**Citation:** Cho, S., Goncalves, F., & Weisburst, E. (2021). Do police make too many arrests? Working paper, UCLA.

**Journal:** Working Paper, UCLA (2021)

**Key Findings:**
- Line-of-duty officer deaths lead to 5–10% short-term reductions in all types of arrests, with largest reductions in discretionary low-level offense arrests and 20% reduction in traffic stops.
- Despite the drop in arrest activity, no evidence of crime increase.
- The crime-to-arrest elasticity (0.46 for violent, −0.14 for property) is notably less negative than the crime-to-police-employment elasticity.
- No threshold level or duration of reduced arrest activity was found beyond which crime increases.
- Suggests police departments may reduce marginal enforcement without public safety costs.

**Methods:** Difference-in-differences event study exploiting staggered line-of-duty officer deaths across 2,000+ municipalities (2000–2018); supplemented by 911 call data from 60+ cities and a Dallas case study.

**Relevance:** Challenges the premise that aggressive enforcement (a core feature of Operation Impact) is necessary for crime control. If marginal arrest reductions do not increase crime, the massive arrest increases in impact zones (53% per MacDonald et al.) may have imposed costs on communities without proportional crime benefits.

**BibTeX:**
```bibtex
@unpublished{cho2021police,
  author = {Cho, Sungwoo and Goncalves, Felipe and Weisburst, Emily},
  title  = {Do Police Make Too Many Arrests?},
  year   = {2021},
  note   = {Working Paper, UCLA}
}
```

---

## IX. POLICE STAFFING & WELFARE ECONOMICS

---

## Chalfin2018 — Are U.S. Cities Underpoliced? Theory and Evidence

**Citation:** Chalfin, A. & McCrary, J. (2018). Are U.S. cities underpoliced? Theory and evidence. *The Review of Economics and Statistics*, *100*(1), 167–186.

**Journal:** *The Review of Economics and Statistics*, Vol. 100, No. 1, pp. 167–186 (2018)

**Key Findings:**
- Documented substantial measurement error in UCR police data; prior regression-based estimates are too small by a factor of 4–5.
- Measurement error-corrected police elasticity of murder is approximately −0.67.
- U.S. cities are substantially underpoliced from a social welfare perspective.
- Each additional dollar spent on police yields approximately $1.63 in reduced victim costs.
- Murder alone accounts for 60% of per-capita expected crime costs, making violent crime the dominant welfare consideration.

**Methods:** Panel data analysis of 242 medium-to-large U.S. cities (1960–2010); measurement error correction using dual survey data (UCR vs. ASG); welfare framework for optimal police staffing.

**Relevance:** Provides the welfare economics framework for evaluating police deployment strategies like Operation Impact. If cities are underpoliced, then programs deploying additional officers to high-crime areas may be welfare-enhancing even if specific enforcement tactics (SQF) are questionable.

**BibTeX:**
```bibtex
@article{chalfin2018underpoliced,
  author    = {Chalfin, Aaron and McCrary, Justin},
  title     = {Are {U.S.} Cities Underpoliced? Theory and Evidence},
  journal   = {The Review of Economics and Statistics},
  year      = {2018},
  volume    = {100},
  number    = {1},
  pages     = {167--186}
}
```

---

## X. NYPD INSTITUTIONAL CONTEXT

---

## White2014 — The New York City Police Department, Its Crime Control Strategies and Organizational Changes, 1970–2009

**Citation:** White, M. D. (2014). The New York City Police Department, its crime control strategies and organizational changes, 1970–2009. *Justice Quarterly*, *31*(1), 74–95.

**Journal:** *Justice Quarterly*, Vol. 31, No. 1, pp. 74–95 (2014)

**Key Findings:**
- Documents the historical evolution of NYPD crime control strategies from the crisis years of the 1970s through the Compstat era.
- Major organizational changes: adoption of Compstat (1994), broken windows policing, expansion of police force, and Operation Impact.
- Crime declined dramatically from the 1990s onward, but attributing causation to specific policing strategies is complicated by simultaneous socioeconomic changes.
- Multiple waves of reform transformed NYPD from reactive to proactive policing.

**Methods:** Historical analysis and literature review of NYPD organizational changes and crime trends over four decades.

**Relevance:** Provides essential institutional context for understanding how Operation Impact fit within NYPD's broader strategic evolution and the Compstat-driven, data-informed policing model from the mid-1990s onward.

**BibTeX:**
```bibtex
@article{white2014nypd,
  author    = {White, Michael D.},
  title     = {The {New York City Police Department}, Its Crime Control Strategies and Organizational Changes, 1970--2009},
  journal   = {Justice Quarterly},
  year      = {2014},
  volume    = {31},
  number    = {1},
  pages     = {74--95}
}
```

---

## Fagan2012 — Policing, Crime and Legitimacy in New York and Los Angeles

**Citation:** Fagan, J. & MacDonald, J. (2012). Policing, crime and legitimacy in New York and Los Angeles: The social and political contexts of two historic crime declines. Columbia Law School Public Law & Legal Theory Working Paper No. 12-315.

**Journal:** Columbia Law School Working Paper No. 12-315 (2012)

**Key Findings:**
- Compares the crime decline trajectories and policing models of NYC and Los Angeles.
- Both cities experienced historic crime declines through different policing approaches.
- NYC relied on aggressive proactive policing (SQF, broken windows), while LA emphasized community policing reforms after the Rampart scandal.
- The legitimacy costs of aggressive policing may undermine long-term crime control.
- Policing is framed as an urban amenity that shapes citizen perceptions of neighborhood quality.

**Methods:** Comparative case study; historical and institutional analysis of two cities' policing regimes and crime trends.

**Relevance:** By the same authors as the replication target, this provides the broader theoretical context. It suggests NYC's approach (including Operation Impact) achieved crime reduction but at potential legitimacy costs, while LA achieved comparable results through less aggressive means.

**BibTeX:**
```bibtex
@techreport{fagan2012policing,
  author      = {Fagan, Jeffrey and MacDonald, John},
  title       = {Policing, Crime and Legitimacy in {New York} and {Los Angeles}: The Social and Political Contexts of Two Historic Crime Declines},
  institution = {Columbia Law School},
  year        = {2012},
  type        = {Public Law \& Legal Theory Working Paper},
  number      = {12-315}
}
```

---
