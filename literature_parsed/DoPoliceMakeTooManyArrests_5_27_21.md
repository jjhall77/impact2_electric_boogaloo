# Do Police Make Too Many Arrests?

Sungwoo Cho Felipe Gonc¸alves Emily Weisburst∗

May 2021

Abstract

We ask whether reductions in arrests increase crime, a central question in the current debate about police reform in the United States. Identifying this causal eﬀect is diﬃcult, as changes in arrests are nonrandom and often reﬂect or coincide with changes in crime. We study changes in arrests after line-of-duty deaths of oﬃcers, events that are likely to impact peer police behavior through increased fear of job risk or emotional distress but are unlikely to directly aﬀect civilian criminal activity or community trust. We document that oﬃcer deaths are not preceded by changes in crime within cities, indicating that their timing is plausibly exogenous. These deaths lead to short-term but signiﬁcant reductions in arrests of all types, with the largest reductions in more discretionary arrests for lower level oﬀenses. Despite this drop in arrest activity, we ﬁnd no evidence of an increase in crime. Moreover, there does not appear to be a threshold level or duration of reduced arrest activity past which crime increases. Our ﬁndings suggest that police departments may be able to reduce marginal enforcement without incurring public safety costs.

JEL Classiﬁcation: J15, J18, K42 Keywords: Policing, Crime, Deterrence, Broken Windows, Ferguson Eﬀect, Community Trust.

∗Cho: UCLA Economics, chosw13@g.ucla.edu; Gonc¸alves: UCLA Economics, fgoncalves@econ.ucla.edu; Weisburst: UCLA Luskin School of Public Aﬀairs, Public Policy, weisburst@ucla.edu. We thank Bocar Ba, Martha Bailey, Aaron Chalﬁn, Elizabeth Cascio, Katherine Harris-Lagoudakis, Steven Mello, Jessica Merkle, Emily Owens, Arezou Zarasani, and Maria Zhu, as well as seminar participants at the Society of Labor Economics (SOLE), UCLA, University of Paris and Vanderbilt for helpful feedback. Thank you to Jude Benedict Baguio, Zerxes Bhadha, Halah Biviji, Sarah Borton, Yuchen Cui, Zheyuan Cui, Garrett Dahn, Ophelia Dong, Hector Esparza, Mabel Gao, Estephany Gomez-Bautista, Shubham Gupta, Chloe Jiang, Aaron Lee, Junyi Li, Alexandra Middler, Anh Nguyentran, Joanne Nie, Roopa Ravishankar, Kira Sehgal, Hayleigh Shields, Hersh Tilokani, Michael Ting, Kendra Viloria, Yuhe Wang, Cindy Yuan, Annie Zhang, Enming Zhang, Jennifer Zhang, and Andrew Hess for excellent research assistance. This project was supported by the UCLA Ziman Center for Real Estate and the California Center for Population Research.

Civilians value living in safe communities, but little agreement exists over the most eﬀective policy means to achieve public safety. Law enforcement make over 10 million arrests each year in the U.S., though fewer than 20% of these sanctions are for serious violent or property oﬀenses.1 Nearly all enforcement actions involve some social cost, and these costs must be weighed against their beneﬁts for crime reduction. While a large literature in economics and criminology has shown that increases in police manpower lead to reductions in crime (Chalﬁn and McCrary, 2017), relatively little is known about the eﬃcacy of the various dimensions of police enforcement. As pressure to reform policing in the U.S. has grown in recent years with rising protests, a crucial question is whether there are forms of enforcement that can be scaled back without sacriﬁcing public safety.

Police reform advocates argue that law enforcement should reduce its heavy reliance on sanctions for low-level oﬀenses, an approach popularized in the 1980s as part of a “broken windows” policing philosophy (Kohler-Hausmann, 2018; Speri, 2020; Silva, 2020).2 These calls for reform stem from growing concerns about the human and economic impact of low-level sanctions, which can impose long-term human capital, ﬁnancial, and employment costs (Mello, 2018; Bacher-Hicks and de la Campa, 2020) and often target minority groups (Goncalves and Mello, 2020) as well as ﬁnancially distressed communities (Department of Justice, 2015; Makowsky et al., 2019). Simultaneous to calls for reform, supporters of broken windows policing argue that aggressive enforcement of low-level oﬀenses has been instrumental in the decline in crime of the last thirty years (Bratton and Knobler, 2009; Zimring, 2011; Riley, 2020). These defenders also claim that public scrutiny following recent high-proﬁle police scandals has led to a decline in enforcement activity and, consequently, contributed to heightened levels of crime.3

In this paper, we evaluate whether reductions in police arrest activity lead to an increase in crime. Addressing this causal question is empirically diﬃcult. Large changes in arrests are generally nonrandom and often reﬂect or coincide with changes in underlying

- 1Federal Bureau of Investigation (FBI) Uniform Crime Report. 2018. Table 29. https://ucr.fbi.gov/ crime-in-the-u.s/2018/crime-in-the-u.s.-2018/topic-pages/tables/table-29.
- 2See for example, Campaign Zero, https://www.joincampaignzero.org/brokenwindows; Karma, Roge. 9/8/2020.
- 3A notable example given of the so-called Ferguson Eﬀect is Baltimore: in the three months after the death of Freddie Gray in April 2015, the city experienced 116 homicides, 53 more than for the same period in the previous year. In contrast, the total number of arrests made by the Baltimore Police Department actually declined over this period, from 12,153 in May-July of 2014 to 6,770 in May-July of 2015. (Calculation from Jacob Kaplan’s Data Tool: https://jacobdkaplan.com/crime.html)


crime rates. We address this identiﬁcation challenge by examining changes in police arrest behavior following a line-of-duty death of a fellow oﬃcer. We estimate responses to these line-of-duty oﬃcer deaths using diﬀerence-in-diﬀerences event study models that exploit the staggered occurrence of events across agencies.

We argue that an oﬃcer death shifts peer oﬃcer behavior, potentially through increasing fear of job risk or emotional distress. Line-of-duty deaths are acutely salient for police oﬃcer peers and could plausibly aﬀect their willingness to engage with civilians and make arrests. However, these events are unlikely to aﬀect community social unrest or underlying civilian criminal activity. Indeed, we show evidence from Google search trends that oﬃcer deaths attract limited attention in the community, in contrast with the signiﬁcant attention paid towards high-proﬁle deaths by police. This setting is therefore uniquely suited to evaluating the impact of changes in arrests on crime rates.

We examine data from over 2,000 municipalities between 2000-2018 and document that a line-of-duty death is followed by a signiﬁcant short-term decline in police arrest activity. This eﬀect is present for all types of arrests, including serious violent and property crime oﬀenses. While the percentage change across all categories is similar, the reduction in number of arrests is substantially greater for lower-level oﬀenses. Using a series of event-study speciﬁcations, we conﬁrm that these events are not preceded by signiﬁcant changes in crime or arrest activity, suggesting that their timing is exogenous to the criminal environment. While the average impact we identify is short-lived (one to two months), the magnitude of the eﬀect is substantial, on the order of a 5-10% reduction in arrests and a 20% reduction in traﬃc stops. Similarly-sized percent changes in police employment have been shown to cause signiﬁcant reductions in crime (e.g. Evans and Owens, 2007; Chalﬁn and McCrary, 2018; Weisburst, 2019; Mello, 2019; Chalﬁn et al., 2020).

In contrast to the observed decline in arrest activity after a line-of-duty death, we ﬁnd small and statistically insigniﬁcant impacts on reported crimes. Our 95% conﬁdence intervals rule out increases of greater than 3.6% in serious “index” crimes, or the most serious violent and property crimes deﬁned by the Federal Bureau of Investigation (FBI).4 Our point estimates suggest an elasticity of crime to total arrests of 0.46 for violent crime and -0.14 for

4Index crimes include murder, rape, robbery, burglary, theft, and motor vehicle theft. We consider murder separately from other violent crime to account for changes in this outcome related to the oﬃcer death itself (see Section 5).

property crime, notably less negative than the estimates of the crime-to-police employment elasticity found in the literature (see Figure 6). We then consider heterogeneity by magnitude of arrest decline and fail to ﬁnd evidence of a threshold reduction in arrests above which crime increases. We similarly investigate heterogeneity by duration of arrest reduction and fail to ﬁnd evidence of crime increases, even for departments with arrest declines that last ﬁve or more months. Collectively, these ﬁndings suggest that reforms which induce modest reductions in police arrest activity, and particularly enforcement against low-level oﬀending, may not come at the cost of rising crime rates.

We argue that our estimates reﬂect the causal impact of a marginal reduction in arrest activity on crime. This interpretation requires assuming that arrest activity is the only variable directly impacted by the line-of-duty death, and we provide several pieces of evidence to rule out potential violations of this assumption. To address the concern that oﬀenders directly respond to the oﬃcer death separately from the arrest decline, we inspect the pattern of results in cities where oﬃcer death events did not lead to any arrest decline, and here we similarly ﬁnd no impact on crime rates. To probe whether other dimensions of enforcement than arrest respond, we consider use-of-force deaths by police, and we ﬁnd no change after an oﬃcer line-of-duty death. Further, we leverage detailed data on a case study in Dallas, TX, where we conﬁrm the results in the national sample and provide additional evidence that police presence and use-of-force do not change following the line-of-duty death of an oﬃcer. We also use this case study to corroborate that the decline in arrest activity is a behavioral response rather than a reduction in the number of working oﬃcers. These ﬁndings ameliorate concerns about an exclusion restriction violation, whereby the oﬃcer death changes the criminal environment beyond its impact on arrest activity.

An additional challenge when estimating the impact of arrests on crime rates is that measured crime is a function of police reporting behavior. Some crime reports initiate with oﬃcer pro-activity, and even in cases where oﬃcers respond to a 911 call, they have discretion over whether a crime report is written and the incident is included in the crime rate. If oﬃcers respond to the death of a co-worker by reducing their propensity to record crimes, this eﬀect will bias us away from ﬁnding an increase in crime. To address this concern, we hand-collected a large data set of 911 calls from over 60 police departments in the United States. These calls originate with civilians and therefore are unaﬀected by changes in oﬃcer reporting behavior. Using this data, we estimate that the frequency of calls does

not signiﬁcantly change after an oﬃcer death. Further, we ﬁnd that the propensity of oﬃcers to write a crime report conditional on a call does not decrease after a peer death. Concerns about the impact of oﬃcer reporting practices on oﬃcial crime statistics are regularly raised in the policing literature (Mosher et al., 2010), and our novel data collection allows us to address this issue.

Our estimates directly relate to mounting calls to curtail the practice of broken windows policing, whose central tenets include the aggressive enforcement of laws against lowlevel oﬀending (Kelling and Wilson, 1982). An existing literature explores the impact of broken windows policing on crime, largely focusing on New York City, where the philosophy has been prominently adopted and where crime has declined dramatically since the 1990s. Researchers exploiting variation over time in misdemeanor arrests have shown that increases in arrest activity are associated with declines in overall crime (Kelling and Sousa, 2001; Corman and Mocan, 2005; Rosenfeld et al., 2007). Similarly, a number of studies have investigated the eﬀects of geographically-focused policing interventions that increase both police presence and enforcement activity for low-level crimes and found reductions in crime (e.g. Braga and Bond, 2008; MacDonald et al., 2016). However, reviews of this literature note that these programs are multi-faceted and that the largest crime reducing eﬀects appear to be generated by programs that successfully involve the community, rather than those that are driven by order-maintenance strategies that aggressively penalize individuals (Braga et al., 2015; Weisburd et al., 2015). Further, Harcourt and Ludwig (2006) note that observational data studies in this literature potentially suﬀer from mean reversion bias: increases in enforcement are targeted towards areas with recent spikes in crime, and the increased enforcement tends to coincide with a reversion of the crime rate back to its historic average. We provide valuable new insights to the literature on broken windows policing by both expanding the scope of cities under study and exploiting variation in enforcement that is plausibly exogenous.

This study also relates to a growing literature on the impact of heightened scrutiny of the police on their behavior and on criminal outcomes. Several papers ﬁnd that oﬃcers change their behavior after policing reforms and heightened scrutiny that follow a policing scandal (Prendergast, 2001, 2021; Shi, 2009; Heaton, 2010; Sullivan and O’Keeﬀe, 2017; Rivera and Ba, 2019). Using recent data, Cheng and Long (2018) and Premkumar (2020) document that high-proﬁle deaths of civilians at the hands of police lead to reductions in

oﬃcer discretionary enforcement. In another recent study, Devi and Fryer Jr (2020), ﬁnd that federal investigations of police departments are linked to both decreases in arrest activity and increases in crime when these investigations follow a viral video of a police use-of-force incident. At the same time, research suggests that police scandals may degrade civilian trust in law enforcement and could directly aﬀect civilian behavior, including civilian willingness to report crime, potentially complicating the use of these events to measure the impact of arrest reductions on crime (Desmond et al., 2016; Zoorob, 2020; Desmond et al., 2020). We address a distinct but related question of whether similar reductions in arrest activity can be achieved without crime increases in an environment where distrust in the police is not elevated from a high-proﬁle police use-of-force incident.

A number of other papers study institutional changes in policing whose eﬀects include a reduction in arrest activity. Chandrasekher (2016) and Mas (2006) document reductions in police enforcement during and after union contract negotiations and ﬁnd varying degrees of crime increase as a result. In contrast, McCrary (2007) ﬁnds that court-ordered racial quotas for police hiring lead to a reduction in arrests but no signiﬁcant increase in reported crimes, and Owens et al. (2018) similarly ﬁnd that an intervention aimed at slowing down police decision-making processes led to a reduction in arrests but did not lead to citywide crime increases. We contribute to this literature by focusing explicitly on the impact of arrest reductions in a setting where other features of the police agency are not altered by policy.

Lastly, we contribute to the literature on policing and crime by collating numerous data sources to address multiple aspects of our setting. These data include monthly crime and arrest statistics and on-the-job oﬃcer deaths from the F.B.I. Uniform Crime Reports, data on traﬃc fatalities from the National Highway Traﬃc Safety Administration (NHTSA), records of traﬃc stops from the Stanford Open Policing Project, internet search popularity from Google Trends, and contextual information on oﬃcer deaths from the Oﬃcer Down Memorial Page website. We supplement these publicly accessible sources with data on 911 calls acquired through individual open records requests to police departments across the U.S. This data collection covers over 60 cities and, to the best of our knowledge, represents the largest composite of 911 data used in an academic study to date. We additionally compile micro-data on multiple aspects of police activity from the Dallas Police Department to further probe mechanisms using a case study of an oﬃcer death in 2018.

## 1 Background: The Police Response to Oﬃcer Deaths

Approximately 60 police oﬃcers are feloniously killed each year in the United States. While this outcome is relatively rare, the job of a police oﬃcer is dangerous relative to other professions; in terms of total fatalities it ranks among the top 20 most dangerous occupations in the U.S.5 Nearly all felonious killings of oﬃcers result from gunshot wounds, with a minority of these deaths resulting from vehicle collisions. Oﬃcers who are killed are demographically representative of typical police oﬃcers; the average oﬃcer killed is a 38-40 year old white male with over 10 years of service in his department.6

Though oﬃcer line-of-duty deaths are statistically rare, these incidents are acutely salient to other oﬃcers. Police scholars have long noted that a preoccupation with death and fatality risk is central to police culture, and oﬃcers often view their work in “life-ordeath” terms (Marenin, 2016; Sierra-Ar´evalo, 2016). Oﬃcers are formally instructed about the potential perils of their work and how to protect their lives in the ﬁeld, beginning with their training in the police academy. When an oﬃcer dies while on duty, their police department will typically commemorate the death with a formal police funeral, which often includes dress uniforms, dedicated music, a 21-gun salute, and a symbolic last radio call to the fallen oﬃcer or “end of watch call.” After an oﬃcer has died, peers within their department will often place mourning bands on their shields in memory of the oﬃcer. Across the U.S., police departments hold yearly memorial ceremonies and hold commemorative fundraisers in honor of police oﬃcers who have died, often over National Police Week in mid-May.7 Several national institutions focus on the commemoration of police oﬃcers who have died in the ﬁeld; these include the National Law Enforcement Memorial Fund, Law Enforcement United and the Oﬃcer Down Memorial Page. Ethnographic research highlights the fact that oﬃcer deaths become a part of the “organizational memory” of a department, long after the deaths occur, through physical memorial plaques in headquarters, commemorative wrist bracelets, and even memorial tattoos (Sierra-Ar´evalo, 2019).

While oﬃcer deaths are not generally associated with increases in civil unrest, police

- 5Stebbins, Samuel, Evan Comen and Charles Stockdale. 1/9/2018. “Workplace fatlities: 25 most dangerous jobs in America.” USA Today. https://www.usatoday.com/story/money/careers/2018/01/09/workplace-fatalities-25-most-dangerousjobs-america/1002500001/
- 6FBI Uniform Crime Report. 2019. Summary Tables 14, 15 & 28. Law Enforcement Oﬃcers Killed or Assaulted (LEOKA). https://ucr.fbi.gov/leoka/2019/topic-pages/oﬃcers-feloniously-killed
- 7See policeweek.org.


departments have in some recent cases responded to deaths of oﬃcers by tying these incidents to rising distrust in the police. As an example, in 2014, two New York City Police Department oﬃcers were shot and killed while sitting in their patrol car by an individual who intentionally sought to target police oﬃcers.8 In the aftermath, many rank and ﬁle oﬃcers expressed the sentiment that the event was due to an abandonment of the department by Mayor Bill de Blasio. As stated by Patrick Lynch, the head of the NYPD union, “[The oﬃcers’ blood] starts on the steps of City Hall, in the oﬃce of the mayor.” At the funeral for the oﬃcers, the majority of the attending NYPD oﬃcers turned their backs to de Blasio during his remarks.9 In the month after the death, news outlets reported that arrest and citation activity by the department had declined signiﬁcantly, seemingly as a protest against the public and the mayor for their perceived ill will towards the department.10

In general, police could change their arrest behavior in the wake of a peer death as a result of mourning or because a peer death can serve as a reminder of the dangers of the job. A priori, it is not altogether clear in which direction a line-of-duty death of an oﬃcer will impact fellow oﬃcers’ behavior on the job. In recent work, Holz et al. (2019) analyze the impact of oﬃcer injuries in the Chicago Police Department and ﬁnd that, after one of their peers has been injured in the ﬁeld, oﬃcers do not change their arrest behavior but increase use-of-force and reduce their responsiveness to service requests, eﬀects that the authors argue are linked to an increased perception of fear on-the-job. Indeed, the sociological literature on policing has frequently noted that oﬃcers’ perception of pervasive on-the-job risks – the “danger imperative” (Sierra-Ar´evalo, 2016) – may contribute to excessive levels of enforcement and use-of-force (Legewie, 2016; Ouellet et al., 2019; Skolnick and Fyfe, 1993; Stoughton, 2014). In contrast, Sloan (2019) studies unprovoked ambushes of police oﬃcers in Indianapolis, Indiana and ﬁnds that these events cause oﬃcers to reduce the number of arrests they make, without increasing use-of-force. Likewise, it is possible that the line-ofduty death of a fellow oﬃcer and its acute reminder of the inherent risks of police work may

- 8Mueller, Benjamin and Al Baker. 12/20/2014. “2 N.Y.P.D. Oﬃcers Killed in Brooklyn Ambush; Suspect Commits Suicide.” The New York Times. https://www.nytimes.com/2014/12/21/nyregion/two-policeoﬃcers-shot-in-their-patrol-car-in-brooklyn.html
- 9Flegenheimer, Matt. 12/21/2014. “For Mayor de Blasio and New York Police, a Rift is Ripped Open.” The New York Times. https://www.nytimes.com/2014/12/22/nyregion/a-widening-rift-between-de-blasioand-the-police-is-savagely-ripped-open.html


10Baker, Al and J. David Goodman. 12/31/2014. “Arrest Statistics Decline Sharply; Police Unions Deny an Organized Slowdown.” The New York Times. https://www.nytimes.com/2015/01/01/nyregion/arreststatistics-decline-sharply-police-unions-deny-an-organized-slowdown.html

lead to a reduction in oﬃcers’ discretionary arrest enforcement. Ultimately, the aggregate eﬀect can only be determined empirically. Our project provides the ﬁrst national empirical estimate of the responsiveness of oﬃcer arrest behavior to an oﬃcer death, and we ﬁnd that police respond to peer deaths by reducing arrest activity in the short-term and do not ﬁnd aggregate evidence that other dimensions of policing, including use-of-force, change.11

While oﬃcer deaths are memorialized by other oﬃcers, awareness of these events is less pronounced among community members. Oﬃcer deaths do not tend to attract the public attention that is created by high-proﬁle police killings of civilians, which are often followed by widespread protests and social unrest. Figure 1 plots the average Google search intensity of 137 high-proﬁle deaths of civilians at the hands of police versus 82 oﬃcers killed in the ﬁeld since 2010 using Google Trends data in the state where each event occurred.12 While Google Trends does not provide values for total number of searches, it provides a measure of relative search volume. All quantities are reported relative to the time period with highest search volume, which is given a value of 100. Multiple search terms can be included at once, and we include as a benchmark a set of search terms related to heart disease (the leading cause of death in the U.S.), which is searched relatively frequently and is not seasonal in search volume. We search each civilian and oﬃcer death separately within the state where the event occurred and plot the average search intensities alongside the benchmark search term.

In relative terms, the public is far more aware of the civilian deaths at the hands of police in our sample versus the oﬃcer deaths, with the average civilian death having a search popularity value that is over 3 times the size of the average oﬃcer death. Search intensity for a civilian death persists to some degree in the weeks following a death, with subsequent spikes that may be associated with protests of the incident or an announcement of whether the involved oﬃcers will be charged. In contrast, the public awareness of an oﬃcer death quickly levels to zero after these events. Collectively, this evidence supports our assumption that while oﬃcer deaths are highly salient for other oﬃcers, the awareness of these deaths among community members is relatively minimal and short-lived. As a result, we argue that

- 11As discussed in Section 7 we do not ﬁnd an eﬀect of line-of-duty oﬃcer deaths on police use-of-force in our national sample.
- 12Information on high-proﬁle deaths of civilians is taken from “Black Lives Matter 805 Resource and Action Guide.” Information on oﬃcer line-of-duty deaths is acquired from the Oﬃcer Down Memorial Page and is described in more detail in Appendix A3.


oﬃcer deaths are unlikely to spark a change in criminal activity or civilian behavior in the community, especially when compared to high-proﬁle civilian deaths, which are highly salient and frequently followed by periods of social unrest. We include additional investigation of this assumption in Section 7.

In our paper, we view oﬃcer deaths as treatments that shift oﬃcer behavior but do not aﬀect civilian behavior. This presumption, consistent with the evidence above, allows us to interpret any change in crime that results from a reduction in arrest behavior following an oﬃcer death as a result of this change in police activity.

## 2 Conceptual Framework

Our objective is to identify the impact of a police oﬃcer fatality on their department’s arrest activity and subsequently identify the impact of any changes in arrests on crime. The majority of our outcomes may be subject to reporting error and are potentially a simultaneous function of crime, reporting, and arrests. In this section, our purpose is to state clearly what assumptions we make about the measurement of each of our outcomes.

Our study treatment is an oﬃcer death, which we argue directly aﬀects oﬃcer arrest behavior but does not directly aﬀect victim reporting or civilian oﬀending behavior. Our ﬁrst objective is to quantify how an oﬃcer death changes the arrest activity of police oﬃcers, conditional on oﬀenses that have occurred. Our second objective is to measure any changes in crime that result from this change in arrests.

Our data can be broadly grouped into two categories: police enforcement activity and crime activity. The production of the number of arrests of type k is a function of the underlying frequency of the crime, the probability of reporting by a victim, and the probability of a police arrest, conditional on victim reporting:

TotalArrestsk = TotalCrimek × VictimReportingk × ArrestProbabilityk

One of our primary objects of interest will be the impact of an oﬃcer death on the number of arrests by a department.13 The goal is to use information on TotalArrestsk to

13The relationships outlined in this section are simpliﬁed such that each crime is associated with a single victim and a single suspect. In practice, crimes can include multiple victims and suspects. The interpretation of outcomes in this study is comparable when there is more than one victim/suspect under the assumption that the number of victims/suspects does not change with the study treatment, a line-of-duty oﬃcer death.

measure changes in the department’s enforcement activity, or ArrestProbabilityk. However, any change could also reﬂect responses by victims or civilian oﬀenders. As we note above, one of our key identifying assumptions is that oﬃcer deaths do not directly aﬀect the frequency of crime. It may still be the case that VictimReportingk or TotalCrimek respond to a change in ArrestProbabilityk after an oﬃcer death. We directly address potential changes in TotalCrimek through examining crime data (below).

To identify a response of ArrestProbabilityk to an oﬃcer death, we will pay particular attention to the impact on arrests for lower level oﬀenses. We group these oﬀenses into “quality of life” arrests, the most minor categories such as disorderly conduct, liquor violations, and drug possession, and non-index arrests, or any intermediate category between the most serious violent and property index crimes and “quality of life” arrests. These arrest types are more likely to result from interactions that are initiated by oﬃcers rather than civilian complaints (equivalent to VictimReportingk = 1 in the relationship above). We will additionally appeal to data on traﬃc stops to identify changes in ArrestProbabilityk. As is the case of low-level arrests, traﬃc stops are oﬃcer-initiated and do not depend on victim choices to report driving oﬀenses (equivalent to VictimReportingk = 1).

To evaluate the impact of an oﬃcer death on criminal oﬀending, we consider the production of a crime report for crime type k, which is a function of the frequency of oﬀenses, victim reporting, and the police oﬃcer’s choice to write an incident report:

CrimeReportsk = TotalCrimesk × VictimReportingk × ReportProbabilityk

Our goal here is to evaluate the impact of an oﬃcer’s death on the frequency of observable reported crime, CrimeReportsk, where the relationship is posited to be due to any changes in the number of true crimes, TotalCrimesk. However, changes to the observed reported number of crimes, CrimeReportsk, may also be aﬀected by victim reporting or by reporting by the police conditional on the number of crimes committed. To address these concerns, we will use data on 911 calls for service. These records include all calls made to the police and are not ﬁltered by the police, or in this case ReportProbabilityk = 1. Therefore, any impact of an oﬃcer death on 911 calls will be a function of only underlying crime and victim reporting. Police reporting rates can also be directly estimated by looking at the share of calls that become an incident report, which corresponds to ReportProbabilityk. While the

frequency of 911 calls is still a function of victim reporting, as we have argued in Section 1, oﬃcer deaths are not as widely salient as civilian deaths by the police and are unlikely to directly aﬀect victim reporting behavior.

Lastly, we will assess how traﬃc fatalities, which are a function of traﬃc oﬀending, respond to changes in ArrestProbabilityk that follow an oﬃcer death. This outcome is not a function of victim or police reporting (VictimReportingk = 1 and ReportProbabilityk=1), as these incidents are very likely to be reported regardless of civilian trust or police department reporting practices and therefore are a true proxy for underlying traﬃc oﬀending (Kalinowski et al., 2017).

## 3 Data

## 3.1 Data Sources

This study combines national and local data sets from a large number of sources. Our sample includes 2,089 municipal police departments and covers the period of 2000-2018. A total of 171 oﬃcer deaths occur within 103 police departments during our sample period. A detailed accounting of the data sources, sample restrictions, and data cleaning used can be found in Appendix A3.

Information on oﬃcer deaths at the month by police department level is derived from the Law Enforcement Oﬃcers Killed or Assaulted (LEOKA) series of the Federal Bureau of Investigation (FBI) Uniform Crime Report (UCR). The analysis considers only oﬃcer deaths that result from felonious killings and excludes deaths resulting from accidents. This data is linked to information collected on oﬃcer deaths by the Oﬃcer Down Memorial Page website to determine cause of death.14

The arrest and crime data at the month by department level is also sourced from the FBI UCR data on crime reports and arrests. We include only law enforcement agencies who report crime and arrest outcomes at the monthly level but impose no additional restrictions related to city population size. This sample restriction diﬀers from prior work that relies on annual data reporting. As part of our data cleaning we detect and omit the most extreme outliers in this data (see Appendix A3), though our results are robust to this cleaning process

14We exclude 19 oﬃcer fatalities coded in the LEOKA data that could not be veriﬁed by either the Oﬃcer Down Memorial Page or an external source.

(see Table A2, speciﬁcation (9)).

Our crime and community activity outcomes also include records of the number of 911 calls for 69 cities in our sample. We have hand-collected these records through ﬁling open records requests to police departments across the U.S., as this data is not available in any systematic or aggregated form at the national level. To our knowledge, this collection represents the largest sample of 911 calls that has been used in a quantitative research study to date. This data covers the period of 2005-2018, though the number of years varies by city.

We also incorporate data on traﬃc stops collected by the Stanford Open Policing Project through open records requests. This data source covers 24 cities in our sample. As a complement, we measure traﬃc fatalities in each city in our sample using data from the Fatality Analysis Reporting System (FARS) of the National Highway Traﬃc Safety Administration (NHTSA).

Lastly, we include data on yearly demographic characteristics of the cities in our sample from the U.S. Census and the American Community Survey. These variables allow us to control for changing demographic composition in the cities covered by our analysis sample (see Section 4).

## 3.2 Summary Statistics

Approximately 10 oﬃcer deaths occur in each year within our sample of 2,089 police departments, though there is variation in the number of deaths that occur each year.15 The monthly pattern of oﬃcer deaths suggests that there may be some seasonality in this outcome throughout the year, with the highest number of deaths observed in the summer months (Figure 2). Over 90% of the oﬃcer deaths in our sample result from gunshot wounds (Table 1). Similar to the national statistics, oﬃcers who are killed in the sample are demographically representative; the average oﬃcer death is of a 37 year old white male with 11 years of experience.

Appendix Table A1 summarizes demographic characteristics of the sample at the yearly level. The average city in the sample has 39 thousand residents, is 69% white, has a poverty rate of 13%, and a median household income of $46 thousand dollars. In contrast,

15As noted above, the national total is approximately 60 deaths per year. Our sample is restricted to cities that regularly report monthly FBI crime data. See the Data Appendix for additional details on sample construction.

treated law enforcement agencies serve populations that are larger, more racially diverse, and more likely to live in poverty; on average, these cities have 252 thousand residents, are 54% white, and have a poverty rate of 16%. Treated cities are deﬁned by having an oﬃcer death event; in turn, these departments also experience a greater number of oﬃcer assaults that result in injury each year (82 vs. 10 in the full sample).

Our estimation focuses on arrest and crime outcomes at the department by month level. Table 1 shows that the average department in our sample reports 0.2 murders, 18 other violent crimes and 120 property crimes per month. The average police department makes 155 arrests per month, of which 84 are for “quality of life” or low-level oﬀenses, 0.17 are for murder, 9 are for other violent crimes, and 21 are for property crimes.16 For the sub-sample of agencies that have traﬃc stop and traﬃc fatality information, the average department makes over 5,000 traﬃc stops each month and the average city experiences 0.2 fatal traﬃc accidents. In accordance with the fact that treated agencies serve much larger cities, treated agencies also have substantially higher levels of reported crime and make more arrests and traﬃc stops than the average department in the sample.

Given the clear diﬀerences between our treatment and control agencies, we employ a diﬀerence-in-diﬀerences model which includes detailed controls and department-speciﬁc ﬁxed eﬀects to control for baseline diﬀerences in outcome levels across agencies. Further, our models are robust to restricting the sample to include only treated agencies and exploiting variation in the timing of oﬃcer deaths, which provides reassurance that the baseline diﬀerences across the treatment and control agencies do not bias the results (see Table A2, speciﬁcation (2)).

## 4 Empirical Strategy

Our empirical strategy exploits the staggered occurrence of oﬃcer deaths over time in a diﬀerence-in-diﬀerences framework. A baseline regression will allow for eﬀects to vary by the

16In this paper, we exclude murder arrests and murder crimes from index violent crime or arrest sums and measure these outcomes separately. We do this to easily see the eﬀects on murder (which is related to the oﬃcer death treatment) separately from other violent crimes.

time horizon from the date of the incident:

Yit =δ0Dit0 + δ1Dit1 + δ2−11Dit2−11 + δ12+Dit12+ (1)

+ βXi,yr(t) + πi,m(t) + θt + γit + it

In our primary speciﬁcations, we deﬁne our outcomes as Yit = log(yit + 1) to approximate percentage changes and account for zero values for each outcome category, yit; however, we show that our results are robust to other functional forms in Section 6. The dummy variables Dit0, Dit1, Dit2−11, Dit12+ indicate that a department is 0, 1, 2 to 11, and 12 or more months after the occurrence of an oﬃcer death, respectively, and the coeﬃcients δitk will indicate the time-path of the eﬀect.

We include a vector of covariates at the department-by-year level, Xi,yr(t) to account for city-level demographic variation (summarized in Appendix Table A1). These controls include city-by-year level age, sex, and race composition, as well as total population, median household income, poverty rate, and unemployment rate. City-by-month ﬁxed eﬀects, πi,m(t), remove all within-city seasonality in the outcome that is constant across years. We also include ﬁxed-eﬀects that vary at the year-by-month level, θt, which account for all samplewide variation in the outcome over time. Lastly, we include a department-speciﬁc linear time trend γit to account for varying trajectories of crime and arrest outcomes across departments.

We consider an oﬃcer death event to be any instance where one or more oﬃcers in a department died in a particular month.17 Some cities experience oﬃcer deaths at multiple points in time within our sample period. We allow these events enter our speciﬁcation additively, denote each oﬃcer death event by d, and maintain one panel per city:

Yit =

d

δ0d0idt + δ1d1idt δ2−11d2idt−11 + δ12+d12+idt (2)

+ βXi,yr(t) + πi,m(t) + θt + γit + it

The interpretation of our coeﬃcients δk is that they represent the time-path of the eﬀect of the average oﬃcer death event in a city (Sandler and Sandler, 2014; Neilson and Zimmerman, 2014). This formulation is equivalent to calculating time period lag variables for each event

17In Appendix Table A2, we show that our results are robust to counting each oﬃcer death in a city-month as its own event.

and then summing these lag variables across multiple events within a police department panel.

A key assumption of our empirical design is that the occurrence of an oﬃcer death is not correlated with time-varying shocks to the outcome. A partial test of this assumption is to check that an oﬃcer death does not appear to impact an outcome prior to the date of the incident. To evaluate this hypothesis, we will also run an event study version of the above regression, where we include indicators for each month around the date of the incident:

Yit =

δkDidtk + βXi,yr(t) + πi,m(t) + θt + γit + it (3)

d k∈{−T,T}

k= 1

To test that our treatment does not have signiﬁcant pre-trends, we check that the values of δk for k < −1 are statistically insigniﬁcant.

Our sample includes all felonious deaths of oﬃcers on duty in the years 2000 to 2018. We conduct a number of robustness checks to verify the validity of our results and assumptions of our speciﬁcation which are detailed in Section 6. These include restricting the analysis to treated cities, estimating the model outcomes in levels and per capita terms, entering multiple oﬃcer deaths within a department-month additively, and creating a separate panel for each oﬃcer death treatment (vs. each treated city). Additionally, we pay careful attention to issues raised surrounding diﬀerence-in-diﬀerences event study models in the literature (Borusyak and Jaravel, 2017; Goodman-Bacon, 2018; Sun and Abraham, 2020) and include a number of robustness speciﬁcations to address these concerns.

## 5 Results

Table 2 presents the central results. First, we examine murder crime and murder arrest outcomes, as these outcomes capture the study treatment, or the felonious death of an oﬃcer in the ﬁeld. We test murder outcomes separately from violent crime outcomes (excluding murder from these violent crime/arrests) so that we can easily measure their relationship to an oﬃcer death treatment. The top panel shows that the death of an oﬃcer while on duty coincides with a 33% increase in reported murder and a 12% increase in murder arrests. We interpret this concurrent increase in murder as being a function of the oﬃcer death itself; in fact, when this model is estimated in levels, the ﬁrst month coeﬃcient on reported murder is

statistically indistinguishable from 1 (Appendix Table A2, speciﬁcation (10)), corresponding to the treatment of an oﬃcer death.

Policing activity is highly responsive to an oﬃcer death in the short-term. Total arrests decline by 7% in the month of an oﬃcer death, and these declines are similar in percentage magnitude across index (7%), non-index (7%), and “quality of life” arrests (6%). The magnitude of these coeﬃcients are roughly halved in the second month after the oﬃcer death and are smaller and insigniﬁcant three to twelve months (the long-term eﬀect) after the incident. Traﬃc stop declines are large but insigniﬁcant in the ﬁrst month and are 27% in the second month following an oﬃcer death, while the long-term eﬀect is a smaller and statistically insigniﬁcant 8% decline. Relative to the treatment group mean, this two month decline in arrests corresponds to an average decrease of 3,174 traﬃc stops and 106 arrests, of which 14 arrests are for index violent and property crimes, 53 arrests are for “quality of life” oﬀenses, and 36 arrests are for other non-index oﬀenses in each treated city.18 Collectively, this pattern of results shows that police reduce their enforcement activity following an oﬃcer death over the short-term and that this reduction is driven by a decline in enforcement of less serious oﬀenses.

How does this sizable reduction in arrests aﬀect crime outcomes? The third panel of Table 2 shows that crime and community activity does not increase as a result of this reduction in enforcement. Reported violent and property crime show no change within a year of an oﬃcer death. Our estimates imply that we can rule out increases in index crimes of more than 3.6% (3.4%) in the month of an oﬃcer death (month after) with 95% conﬁdence. Over the longer-term, the estimates imply that we can rule out a 2.7% increase in index crime. The pattern of ﬁndings shows that a reduction in police enforcement of lower level oﬀenses does not result in an increase in criminal activity.

Our ﬁnding of null crime eﬀects from a marginal reduction in arrests is new to the economics literature on policing, and it is therefore useful to benchmark our estimates to this prior work. To do so, we convert our estimates into elasticity form by dividing our violent and property crime coeﬃcients by the total arrest coeﬃcient in period 0.19 Our property and violent crime elasticity estimates are not signiﬁcantly negative, -0.14 for property crime

- 18The sub-category arrest counts are calculated from the coeﬃcients on each arrest type and therefore do

not sum directly to 106.

- 19The associated standard errors are constructed with the delta method: var(Elasticity) =


var(βcrime)/βarrest2 + var(βarrest) ∗ βcrime2 /βarrest4 .

and 0.46 for violent crime, and do not statistically diﬀer from 0. Figure 6 shows that these elasticities are notably less negative than estimates given by the extensive literature on police manpower, which has generally found large and signiﬁcant reductions in crime from increased police employment (e.g. Evans and Owens, 2007; Chalﬁn and McCrary, 2018; Weisburst, 2019; Mello, 2019; Chalﬁn et al., 2020). These elasticity comparisons serve to emphasize that our null results for crime are small relative to the expected increases from a comparable decline in manpower. This comparison also provides new evidence that the established deterrence impact of police manpower, which could induce changes in both police presence and arrest activity, likely operates through the former rather than the latter.

Next, we investigate changes in 911 calls for service. As discussed in Section 2, this outcome is a function of crimes that occur and victim decisions to report these crimes but is not a function of police enforcement. This “less ﬁltered” proxy for criminal activity also does not increase after an oﬃcer death. Instead, our point estimate for the short-term 911 call response is negative. These estimates are somewhat more precisely estimated than the coeﬃcients on index crime impacts in the short-term, and we can rule out a greater than 5.0% increase in 911 calls across all time horizons post oﬃcer fatality.

Lastly, we ﬁnd that the number of fatal traﬃc accidents does not change following an oﬃcer death. While traﬃc enforcement has been shown to aﬀect traﬃc oﬀending (DeAngelo and Hansen, 2014; Goncalves and Mello, 2017), existing studies primarily focus on state highway patrols, which play a larger role in traﬃc enforcement than municipal police forces, which are the focus of this study. The traﬃc fatality outcome has the advantage that it is a function of traﬃc oﬀenses and is a proxy for reckless driving but is not a function of either victim reporting or police reporting. Despite the large decrease in traﬃc stops following an oﬃcer death, the number of fatal traﬃc accidents does not change. Here, we can rule out increases in traﬃc fatalities of more than 4.9% within the ﬁrst month, 4.2% in the second month, and 0.1% in the remainder of the year, with 95% conﬁdence.

## 6 Robustness

We conduct several robustness checks to probe our ﬁndings. First, we conﬁrm that our results are not driven by time-varying shocks to crime which are correlated with the likelihood of an oﬃcer death. Figures 5 plots the event coeﬃcients at the month level around the month

of an oﬃcer death separately for violent and property crimes. The coeﬃcients provide visual evidence that there is no change in crime that precedes an oﬃcer death. In Figure A1, we plot event study ﬁgures for each sub-category of index crimes and continue to ﬁnd no evidence of pre-period changes in crime. Moreover, Figure 3 clearly displays a singular increase in reported murder that coincides with our treatment event of a felonious death of an oﬃcer and no pre-period changes in murders.

In Figure A3, we re-estimate the model dropping one treatment city at a time and plot the distribution of results. This exercise conﬁrms that the estimates are not driven by outlier observations, as the total range of estimates are substantively close to the model estimate. Moreover, all of the alternative estimates are well within the conﬁdence intervals implied by the baseline model.

Next, we randomize the timing of oﬃcer deaths among treated agencies (holding the number of deaths per agency ﬁxed) and re-estimate the model 100 times using these randomized placebo treatments in Figure A4. Our model estimate for the ﬁrst month decline in arrests lies well outside the distribution of estimates in the placebo distribution, conﬁrming that the results we ﬁnd are actually a function of the treatment and are unlikely to be driven by chance.

Appendix Table A2 includes a number of alternative speciﬁcation tests, all of which ﬁnd similar results to our preferred speciﬁcation. We conﬁrm that the estimates are similar when we restrict the sample to treated cities (2). Our estimates are robust to an alternative model that constructs a panel for each oﬃcer death treatment, rather than a panel for each city (3), and the results are also similar when we consider multiple oﬃcer deaths from the same event additively (4) rather than as a single event.

Next, we include a speciﬁcation that removes the city-speciﬁc linear time trend from the model (5) and the city-by-calendar month ﬁxed eﬀects from the model (6). In speciﬁcation (7), we show that the results are robust to adding state-by-year ﬁxed eﬀects to the model, which ﬂexibly control for state-level policy changes. To address the possibility that there could be unobserved trends in violence towards police at the city-by-month level, we control for monthly variation in assaults against oﬃcers that result in injuries in (8); these speciﬁcations compare the impact of an oﬃcer death holding ﬁxed the number of assaults against oﬃcers.

We ﬁnd similar results when we use raw data that has not been cleaned for outliers or

other errors (9) (See Appendix A3 for details on outlier cleaning). The results are likewise robust to considering alternate functional forms, using a levels model (10), a per capita model (11), or an inverse hyperbolic sine model (12).

Several recent papers document potential issues with the standard diﬀerence-in-diﬀerences

design and suggest modiﬁed speciﬁcations, and we consider the robustness of our estimates to these approaches. To address the issue that time ﬁxed eﬀects are partly identiﬁed by treated agencies (Borusyak and Jaravel, 2017; Goodman-Bacon, 2018), we re-weight the data to increase the importance of untreated cities (untreated city weight=1000, treated city weight=1). Doing so eﬀectively removes treated cities from the estimation of time ﬁxed eﬀects, and our results are unchanged (13). Sun and Abraham (2020) show that event study designs in the presence of treatment eﬀect heterogeneity can produce estimands for each event-time coeﬃcient that are contaminated by coeﬃcients for other time periods. To address this concern, we present their estimator in (14), which explicitly constructs each event-time estimand as a positively-weighted average of cohort-speciﬁc treatment eﬀects. We also present a graphical version of their approach with pre-period coeﬃcients in Appendix Figure A5. This approach does not change our conclusions, though their speciﬁcation does require treating each line-of-duty death as its own panel. To apply the logic of their approach to our baseline data structure with summed events within each city panel, we estimate a speciﬁcation in (15) where the untreated agencies and all treated agency pre-periods are overweighted (untreated city weight=1000, treated city pre-period weight = 1000, treated city post-period weight=1).20 Our results remain unchanged using this approach.

## 7 Alternative Hypotheses

In this section we directly consider alternative explanations for the pattern of ﬁndings. A possible explanation for why we ﬁnd no increase in crime after an oﬃcer death is that police not only reduce the number of arrests that they make but also reduce the number of crime reports that they ﬁle. In several cases, police have some discretion over which victim complaints are oﬃcially ﬁled as criminal incidents. If oﬃcers are less likely to ﬁle criminal reports after a peer oﬃcer death, the estimates of changes to reported crime could be biased downward. Indeed, a large literature in criminology has highlighted concerns about

20A treated agency’s pre-period is set as the months before any line-of-duty death within our sample.

the potential for crime reports to be manipulated by changes in oﬃcer reporting standards (Bayley, 1983; Marvell and Moody, 1996; Mosher et al., 2010). While we show in Section 5 that the total volume of 911 calls does not increase in the period after an oﬃcer line-ofduty death, we can measure changes in oﬃcer reporting directly among the large share of cities in our 911 data that record whether a call results in a criminal incident report being written. We are therefore uniquely able to address whether changes in police reporting are biasing our estimates of a crime eﬀect, which we do in Table 2. We ﬁnd that this conversion rate is unaltered by an oﬃcer death, suggesting that oﬃcers do not respond to these events by reporting fewer criminal incidents. Our estimates are quite precise and can rule out a greater than 0.9% decrease in the reporting rate, oﬀ a base of 20%. This test provides greater conﬁdence in the null eﬀects we identify for reported index crimes using the FBI UCR data.

In addition to providing direct information on police reporting practices, our 911 data cover a larger range of crimes than the UCR crime reports. The fact that we continue to ﬁnd no impact of an oﬃcer line-of-duty death and resulting arrest reduction on this broader indicator of crime indicates that we are not missing impacts on lower level oﬀending.

Akin to concerns about crime increasing following a high-proﬁle civilian death at the hands of police, we might be concerned that an oﬃcer death itself directly causes civilian criminal activity or victim reporting to change. In particular, it might be the case that civilians fear that they will face a stronger punitive response after an oﬃcer death and are consequently deterred from oﬀending. Any decline in oﬀending resulting directly from the reaction to an oﬃcer death could mask an increase in crime resulting from the reduction of arrests, leading to a biased conclusion about the impact of arrests on crime. To address this concern, we ask whether cities with no arrest declines actually experience a reduction in crime, as the above story would suggest. In Section 8.1 below, we split the sample by the size of arrest declines in treated cities. We observe a ﬂat relationship between the magnitude of arrest decline and level of crime change, and we do not see declines in crime for departments with no arrest declines, corroborating our claim that an oﬃcer death does not directly impact oﬀending.

At the same time, victims could be more apprehensive about reporting crime incidents following an oﬃcer death. Here, we appeal to evidence of community or crime activity discussed in Section 1 and 5. Most importantly, the Google Trends analysis suggests that civilians are relatively unaware of oﬃcer deaths when they occur and as a result will be less

likely to respond to these events (Figure 1). Additionally, our measures of 911 calls and traﬃc fatalities show that complainant reports of oﬀenses and driving oﬀenses do not appear to change substantially after an oﬃcer death. In particular, traﬃc fatalities, which are not a function of victim reporting, do not change in the wake of an oﬃcer death.

Next, it could be the case that police not only reduce arrests but also increase use-offorce following a line-of-duty death, consistent with research conducted in single jurisdictions (Holz et al., 2019; Legewie, 2016). We examine this question using national data on civilians killed by police from the UCR Supplemental Homicide Report and the crowd-sourced data resource, Fatal Encounters, in Table A5. We do not ﬁnd evidence of any signiﬁcant change in the number of civilians killed by police following a line-of-duty oﬃcer death using our national sample. In Section 9 below, we utilize a case study in Dallas, TX and conﬁrm with richer data that use-of-force does not change after the oﬃcer death.

Lastly, an alternative explanation for the channel of the de-policing response is that the decline in arrests is attributable to the direct eﬀect of the incapacitation of a single oﬃcer resulting from the death and the corresponding loss in manpower, rather than a change in the behavior of fellow oﬃcers. Similarly, there is the possibility that our arrest decline is due to fellow oﬃcers taking leave because of their colleague’s death.

If either scenario were the case, our results would partly reﬂect a decline in oﬃcer manpower rather than a broad behavioral change in arrest enforcement intensity. However, these alternative stories are implausible given the size of the treatment eﬀects we observe. If we make the conservative assumption that half of the oﬃcers employed in a police department are patrol oﬃcers that regularly make arrests, the average oﬃcer in our treated cities makes 3.2 arrests per month. In contrast, the ﬁrst month coeﬃcient in our models implies an average decline of 67 arrests, or roughly equivalent to 21 oﬃcers making zero arrests in this focal month. Even if the oﬃcer who died was exceptionally active in making arrests, it is very unlikely that their loss is driving the results that we ﬁnd, nor is it likely that 21 oﬃcers would reduce their arrest activity to zero after a colleague’s line-of-duty death.

A related hypothesis is that, in the wake of an oﬃcer’s death, patrol oﬃcers are rerouted to work on apprehending the perpetrator of the murder, leading to a decline in their arrest activity. Figure 3 and Table 2 document an increase in murder arrests in the month of the oﬃcer death but no signiﬁcant change in the months after. We take this ﬁnding to suggest that the typical investigation and arrest of the suspect occurs within the ﬁrst month,

reducing the plausibility of the second-month eﬀect being driven by oﬃcer time reallocation. In our Dallas case study, we directly inspect the number of patrolling oﬃcers and ﬁnd a very small change after the line-of-duty death, serving as an additional validation that reduced oﬃcer presence is not generating the arrest decline. We therefore conclude that the more plausible story is a behavioral response by oﬃcers.

## 8 Heterogeneity

In this section, we consider how our arrest and crime impacts vary by diﬀerent dimensions of the treatment and outcomes. In particular, we ask wether the null ﬁnding of no increase in crime persists for subsamples of cities with particularly large or sustained declines in arrests.

## 8.1 Arrest to Crime Curve

Our regressions show that on average, a 7% decline in arrests following an oﬃcer death does not translate to any increase in crime rates. In this section, we investigate variation in eﬀect sizes across cities in our sample to provide additional insight about the way that crime might respond to a larger (or smaller) reduction in arrest activity. To do so, we ﬁrst estimate residuals of arrests and crimes conditional on the ﬁxed eﬀects in the model but excluding the treatment indicators, Dit. We then calculate the diﬀerence between residuals in the month of an oﬃcer death, t = 0, versus the residual for the month prior to the oﬃcer death, t = −1, for both the crime and arrest outcomes. These diﬀerences in residuals approximate the single month eﬀect of an oﬃcer death on both arrests and crime rates in each city.

Figure 7 plots the residual change in arrest against the residual change in crime, allowing us to trace an “arrest to crime curve.” We plot binned values of the residuals overlaid with a local linear regression of the full sample of residuals. The top ﬁgure presents the crime residuals for the ﬁrst month and shows a ﬂat relationship with the size of an arrest decline. The 10-90 percentile range of the change in residual arrests corresponds to a range of an 31.1% decline to an 8.4% increase in arrests. Over this support, the standard errors of the local linear regression reject crime increases of more than 6.5%, with 95% conﬁdence. In the bottom ﬁgure, we plot the crime residuals for the entire year after the oﬃcer death, and we similarly do not ﬁnd evidence of crime increases for any magnitude of an arrest decline. If anything, the crime impacts for cities with bigger arrest declines appear to be somewhat

more negative.

## 8.2 Length of Arrest Decline and Crime Eﬀect

One challenge with interpreting our ﬁnding of a null impact on crime is that the observed reduction in arrests is relatively short-lived. How much information does this null ﬁnding provide for answering how crime would respond in an environment where police permanently reduce their enforcement against low-level oﬀending?

While a two month reduction in low-level arrests is certainly not a permanent change, the literature on the impacts of police presence has documented responses to changes in policing at much shorter time horizons. Di Tella and Schargrodsky (2004), Klick and Tabarrok (2005), and Draca et al. (2011) analyze the impact of rapid increases in police presence in small geographic regions after a terrorist attack or heightened threat of an attack, and these studies all estimate reductions in criminal activity that are detectable within a week of the increased police presence. Similarly, Weisburd (2016) ﬁnds in Dallas, TX, that reductions in the presence of police oﬃcers in a police beat lead to increases in car theft, and the crime response is within an hour of the police reduction. This previous literature highlights that, while our estimates do not speak directly to a permanent change in arrest activity, they can rule out short-term responses that are commonly observed for changes in police presence and thus are informative about diﬀerences in the crime elasticity to with respect to manpower versus arrest activity.

Nevertheless, we will probe this issue directly in our data. Speciﬁcally, we ask whether our crime eﬀects diﬀer by cities with arrest declines of varying durations. We take our residuals calculated in Section 8.1 and calculate for each city the number of consecutive months after an oﬃcer death where the residual is lower than the residual for the month prior to the death. We bin arrest decline durations into medium-term categories (0 months to 5 or more months) given the distribution of eﬀects in our sample. We then plot the postfatality crime residual for each city, separately by length of the arrest reduction, as shown in Figure 8. For each duration of arrest eﬀect, we also plot the 10th and 90th percentile of the crime residual.

The top panel presents the crime impact for the ﬁrst month. We see that the average residual crime eﬀect is close to zero for all time horizons. This ﬁnding is perhaps not

surprising, since a sustained arrest decline is not likely to lead to a markedly diﬀerent impact in the ﬁrst month. In the bottom panel, we plot the crime residuals averaged over the entire year after the oﬃcer death. While the range of residual eﬀects is much larger than for the one month time horizon, we continue to ﬁnd practically zero average eﬀects for all durations of arrest decline and a negative average crime eﬀect for cities with arrest declines that last ﬁve or more months. The results indicate that, similar to the previous analysis, there does not appear to be a duration of arrest decline beyond which crime increases. Overall, we conclude that our results do not suggest that a particular length of eﬀect will lead to increased crime.

## 8.3 Police Department and Oﬃcer Characteristics

While we show in the previous section that our ﬁnding of no crime increase persists when examining heterogeneity in the magnitude and duration of arrest decline; in this section, we explore variation in the arrest and crime impacts of an oﬃcer line-of-duty death by the characteristics of the agency and incident.

The top left panel of Figure A6 asks how our primary estimates vary with city-level characteristics, and we ﬁnd evidence of heterogeneous arrest eﬀects. The arrest decline is more negative in cities with a below-median population, roughly 15%, though the diﬀerence between below-median and above-median cities is statistically insigniﬁcant. This pattern is also evident when dividing cities by assaults on oﬃcers per oﬃcer capita, the crime rate, and oﬃcers per population. These ﬁndings are consistent with the hypothesis that the decline in arrest activity is due to the salience and shock of the incident, which will be more uncommon in small police departments.

The top right and bottom panel present how our crime impacts vary by city characteristics, separately for the month of the incident and the year following the incident, and we largely continue to ﬁnd insigniﬁcant impacts. The only marginally signiﬁcant positive crime eﬀect is for cities with a below median population. One interpretation of this coeﬃcient is that the more substantial decline in arrests among small cities is leading to an increase in crime. However, we do not ﬁnd signiﬁcant impacts for cities with few assaults on oﬃcers per oﬃcer capita, a low crime rate, or few oﬃcers per population, nor do we ﬁnd positive crime impacts when stratifying directly on arrest reductions, as we showed in Section 8.1. Because we are by design considering the signiﬁcance of several coeﬃcients at once, we interpret this

positive signiﬁcant eﬀect as an artifact of multiple hypothesis testing.

Figure A7 conducts a similar exercise splitting the treatment events according to observable characteristics of the oﬃcer who died. Arrest responses to oﬃcer death events appear larger for younger and less experienced oﬃcers and oﬃcers who are white and male. However, again, the event groups with larger arrest reductions do not exhibit a pattern of larger crime increases in response.

## 8.4 Crime and Arrest Sub-Types

Next, we estimate the model separately for each crime and arrest sub-type in the analysis to explore which categories are driving changes in the aggregate outcome sums. Table A3 displays the sub-type results for index crimes and index crime arrests. For index crime, we observe a decline in aggravated assaults and an increase in burglaries post treatment; but these changes are not robust to the more ﬂexible event study formulation of the model shown in Figure A1. Figure A1 and Table A3 both show that none of the sub-categories of index crime show a signiﬁcant post-treatment increase. For index crime arrests, we ﬁnd signiﬁcant decreases in robbery arrests and motor vehicle theft arrests.

The sub-category results for “quality of life” arrests and non-index arrests show several categories with large point estimates but few individual categories that are statistically signiﬁcant for the ﬁrst or second month. The results suggest that the arrest declines in these categories are driven by large decreases in arrests for drug possession, prostitution, and driving under the inﬂuence of alcohol (DUI) (which is classiﬁed as a mid-level “non-index” oﬀense) (Table A4). The results imply that over the two month period following an oﬃcer death, oﬃcers make 22 fewer arrests for drug possession, 2.3 fewer arrests for prostitution, and 14 fewer DUI arrests in each treated city.21 Given that we observe a large reduction in DUI arrests, we explicitly measure the subset of fatal traﬃc accidents that involve a drunk driver (Table A5). These alcohol-related accidents do not respond to the reduction in DUI arrests associated with an oﬃcer death.

21We assume that uncategorized arrests are likely to be for oﬀenses that are not listed as options for reporting in UCR. Given the broad number of oﬀense categories available for reporting in UCR, we argue that these arrests are for other low-level oﬀenses.

## 9 Case Study: Dallas Police Department

Our ﬁndings above document a decline in police arrests after an oﬃcer line-of-duty death and no change in crime rates. We argue that the arrest response is due to heightened fear of workplace risk or emotional distress among oﬃcers and that other dimensions of policing and the criminal environment are unchanged, allowing us to infer the impact of marginal changes in arrests on crime.

To further probe the assumptions of our design, we study a particular line-of-duty death of an oﬃcer working for the Dallas Police Department, where we have collected detailed information on 911 calls, crimes, arrests, and use-of-force, as well as information on the oﬃcers involved in diﬀerent forms of police activity. These rich data allow us to assess various dimensions of oﬃcer behavior and test whether arrest activity is the sole dimension of behavior that responds to a line-of-duty death.

On Tuesday, April 24, 2018, Dallas police oﬃcer Rogelio Santander was shot by a shoplifting suspect at a Home Depot store during an attempt to arrest the individual.22 Oﬃcer Santander died from the gunshot injury the following morning; two other oﬃcers were critically wounded in the incident. The suspect ﬂed the scene but was detained later the same day.23

We examine the impact of this event on policing and crime in Dallas by plotting the time path of weekly activity around the initial incident date of April 24. We plot the same outcome around April 24 of the previous year as a credible counterfactual absent the oﬃcer death.

Panel A of Figure 9 shows the number of arrests made and documents a similar pattern to our baseline results. From a pre-period base of around 600 weekly arrests, arrest activity declines to 400-500 weekly arrests, a larger percentage decline than our nationwide ﬁnding. This reduction in activity persists for 9 weeks but appears to return to the pre-period average afterwards. Interestingly, the reduction in arrests is city-wide rather than concentrated in the Northeast division where Oﬃcer Santander worked (see Figure A8). Next, we conﬁrm the patterns observed in the nationwide analysis; we see no systematic change in total crime

- 22Our data coverage for Dallas includes the time period 2014-2019. This time period includes the nationally covered shooting of 5 police oﬃcers in Dallas in July of 2016. While this event is included in our main national data set, we focus on the April 2018 event as it is more typical of the oﬃcer deaths in our sample, and was not highly publicized in the media.
- 23https://www.odmp.org/officer/23665-police-officer-rogelio-santander-jr


reports, the frequency of calls to the police, or probability of reporting a crime conditional on receiving a 911 call (Panels B - D). Figure A8 shows a similarly striking pattern in arrest and crime outcomes at the daily level.

In Panel E, we plot the probability of an arrest conditional on a response to a call for service, and we ﬁnd a notable reduction in this arrest rate after the oﬃcer death. This ﬁnding suggests that some of the decline in enforcement occurs even among incidents reported by civilians rather than solely through reductions in oﬃcer-initiated activity. It also provides evidence that the reduction in arrests is a behavioral response by oﬃcers, likely from heightened fear, rather than a reduction in manpower from the oﬃcer death and from other oﬃcers taking time oﬀ or being re-assigned. As further evidence on this question, Panel F plots the total number of oﬃcers we observe responding to calls for service, a measure of workplace attendance. Relative to the previous year, the number of working oﬃcers seems to decline slightly, with roughly 25 fewer oﬃcers working relative to a base of 1675 oﬃcers. This decline of less than 2% is small relative to the 15-30% reduction in arrests, further corroborating that oﬃcer presence is not likely to be driving our main ﬁnding.

Panel G plots the number of instances of non-shooting use-of-force by Dallas oﬃcers. We see a similarly ﬂat time path to the year prior, suggesting that oﬃcers are not responding to the incident by changing this dimension of enforcement. Another possible police response to a line-of-duty death could be to change the allocation of oﬃcers within the city, which we display in Panel H by plotting the number of oﬃcers responding to calls for service in high crime beats. We ﬁnd a short-term increase in oﬃcer presence in these areas that dissipates within two weeks after the initial incident. Part of this increase is given by the response to the shooting of Oﬃcer Santander, which occurred in a high crime beat. While this adjusted set of allocations could act as its own deterrent against crime (Draca et al., 2011; Weisburd, 2016), this short-term and quantitatively small increase in presence is likely not great enough to have an impact on criminal oﬀending.

Collectively, the case study we investigate in Dallas provides further conﬁrmation that oﬃcers are responding to the death of a peer by reducing arrest activity, that the decline is not driven by eﬀective declines in manpower, and that 911 calls and crime do not increase. Further, we continue to ﬁnd that dimensions of enforcement other than arrests are largely unchanged.

## 10 Conclusion

This study examines the causal impact of reducing police arrest activity on public safety. Using data on over 2,000 police departments between 2000-2018, we ﬁnd that police respond to an oﬃcer line-of-duty death by reducing their quantity of arrests, particularly arrests for low-level oﬀenses. Our research collates data from numerous sources, including information on arrests, reported crimes, 911 calls for service, traﬃc stops, and traﬃc fatalities, to provide evidence that an oﬃcer death directly reduces police arrest behavior but does not have an independent or direct impact on either police reports of crime or civilian behavior. Critically, we ﬁnd that these reductions in arrests do not come at the cost of increases in serious crime.

By tracing an “arrest to crime curve” using variation across our treated cities, we do not ﬁnd a threshold level beyond which an arrest reduction results in a crime increase. Moreover, examining treatment eﬀects that last for diﬀering amounts of time, we do not ﬁnd evidence that arrest declines which are sustained for longer periods result in crime increases. Our results provide new insights into prior work that has found that police employment reduces crime, and suggests that the channel of this eﬀect is likely due to deterrence related to police presence, rather than increased arrest activity. Because the observed decline in enforcement is concentrated among arrests for low-level oﬀenses, we argue that low-level arrests could be reduced from current levels without causing meaningful increases in crime.

Our ﬁndings raise important questions for future research. In contrast to our results, some research has found crime-reducing beneﬁts of particular types of enforcement, such as hot spots policing (Blattman et al., 2017) and forms of “focused” deterrence that target small groups of frequent oﬀenders (Braga et al., 2018; Chalﬁn et al., 2021). More research is needed to provide precise information on which forms of arrests and sanctions provide crime-reducing beneﬁts.

While our analysis beneﬁts from utilizing quasi-experimental variation in police enforcement, we observe relatively short-term ﬂuctuations in arrests, and an open question is how crime responds to permanent reductions in arrests. Related work on the reclassiﬁcation of oﬀenses from felonies to misdemeanors in California ﬁnds that these changes reduced arrests and had no impact on violent crime, while modestly increasing property crime (Dominguez et al., 2019). Separately, examinations of the decriminalization of marijuana show limited evidence of subsequent crime increases (Adda et al., 2014; Chu and

Townsend, 2019; Dragone et al., 2019). As police departments and municipalities may begin to alter their approach to enforcement in the coming years, more research will be needed to understand whether a permanent change in low-level enforcement or decriminalization policies would likewise aﬀect public safety and community trust in police.

A full appraisal of any dimension of law enforcement requires weighing the collateral costs on the individuals who are sanctioned, including potential reductions in earnings and employment. The growing chorus of protests against police use-of-force and misconduct have made clear the dissatisfaction of many with the state of American policing, and recent research has documented the numerous harms of law enforcement overreach. Our study argues that, at least in the context of enforcement of low-level oﬀenses, these harms are unlikely to be justiﬁed by crime-reducing beneﬁts.

## References

Adda, J., B. McConnell, and I. Rasul (2014). Crime and the depenalization of cannabis possession: Evidence from a policing experiment. Journal of Political Economy 122(5), 1130–1202.

Bacher-Hicks, A. and E. de la Campa (2020). Social Costs of Proactive Policing: The Impact of NYC’s Stop and Frisk Program on Educational Attainment. Working paper.

Bayley, D. (1983). Knowledge of the Police. In M. Punch (Ed.), Control in the Police Organization, pp. 18–35. NCJ-88943.

Blattman, C., D. Green, D. Ortega, and S. Tob´n (2017). Place-based interventions at scale: The direct and spillover eﬀects of policing and city services on crime. Technical report, National Bureau of Economic Research.

Borusyak, K. and X. Jaravel (2017). Revisiting event study designs. Available at SSRN 2826228. Braga, A. A. and B. J. Bond (2008). Policing crime and disorder hot spots: A randomized controlled trial.

Criminology 46(3), 577–607.

Braga, A. A., D. Weisburd, and B. Turchan (2018). Focused deterrence strategies and crime control: An updated systematic review and meta-analysis of the empirical evidence. Criminology & Public Policy 17(1), 205–250.

Braga, A. A., B. C. Welsh, and C. Schnell (2015). Can policing disorder reduce crime? A systematic review and meta-analysis. Journal of Research in Crime and Delinquency 52(4), 567–588.

Bratton, W. and P. Knobler (2009). The turnaround: How America’s Top Cop Reversed the Crime Epidemic. Random House.

Chalﬁn, A., B. Hansen, E. K. Weisburst, and M. C. Williams (2020). Police Force Size and Civilian Race. National Bureau of Economic Research.

Chalﬁn, A., M. LaForest, and J. Kaplan (2021). Can precision policing reduce gun violence? evidence from “gang takedowns” in new york city.

- Chalﬁn, A. and J. McCrary (2017). Criminal Deterrence: A Review of the Literature. Journal of Economic Literature 55(1), 5–48.
- Chalﬁn, A. and J. McCrary (2018). Are US Cities Underpoliced? Theory and Evidence. Review of Economics and Statistics 100(1), 167–186.


Chandrasekher, A. C. (2016). The eﬀect of police slowdowns on crime. American Law and Economics Review 18(2), 385–437.

Cheng, C. and W. Long (2018). The Eﬀect of Highly Publicized Police-Related Deaths on Policing and Crime: Evidence from Large US Cities. Working Paper.

Chu, Y.-W. L. and W. Townsend (2019). Joint culpability: The eﬀects of medical marijuana laws on crime. Journal of Economic Behavior & Organization 159, 502–525.

Corman, H. and N. Mocan (2005). Carrots, sticks, and broken windows. The Journal of Law and Economics 48(1), 235–266.

DeAngelo, G. and B. Hansen (2014). Life and Death in the Fast Lane: Police Enforcement and Traﬃc Fatalities. American Economic Journal: Economic Policy 6(2), 231–57.

Department of Justice, U. (2015). The Ferguson Report: Department of Justice Investigation of the Ferguson Police Department. Department of Justice.

Desmond, M., A. V. Papachristos, and D. S. Kirk (2016). Police violence and citizen crime reporting in the black community. American sociological review 81(5), 857–876.

Desmond, M., A. V. Papachristos, and D. S. Kirk (2020). Evidence of the eﬀect of police violence on citizen crime reporting. American sociological review 85(1), 184–190.

Devi, T. and R. G. Fryer Jr (2020). Policing the Police: The Impact of “Pattern-or-Practice” Investigations on Crime. National Bureau of Economic Research.

Di Tella, R. and E. Schargrodsky (2004). Do police reduce crime? Estimates using the allocation of police forces after a terrorist attack. American Economic Review 94(1), 115–133.

Dominguez, P., M. Lofstrom, and S. Raphael (2019). The Eﬀect of Sentencing Reform on Crime Rates: Evidence from California’s Proposition 47. Institute of Labor Economics (IZA).

Draca, M., S. Machin, and R. Witt (2011). Panic on the streets of London: Police, crime, and the July 2005 terror attacks. American Economic Review 101(5), 2157–81.

Dragone, D., G. Prarolo, P. Vanin, and G. Zanella (2019). Crime and the legalization of recreational

marijuana. Journal of economic behavior & organization 159, 488–501. Evans, W. N. and E. G. Owens (2007). COPS and Crime. Journal of Public Economics 91(1-2), 181–201. Goncalves, F. and S. Mello (2017). Does the Punishment Fit the Crime? Speeding Fines and Recidivism.

Working Paper. Goncalves, F. and S. Mello (2020). A Few Bad Apples? Racial Bias in Policing. Working Paper. Goodman-Bacon, A. (2018). Diﬀerence-in-diﬀerences with Variation in Treatment Timing. National Bureau

of Economic Research. Harcourt, B. E. and J. Ludwig (2006). Broken Windows: New Evidence from New York City and a Five-city Social Experiment. The University of Chicago Law Review, 271–320. Heaton, P. (2010). Understanding the Eﬀects of Antiproﬁling Policies. The Journal of Law and Economics 53(1), 29–64. Holz, J., R. Rivera, and B. A. Ba (2019). Spillover Eﬀects in Police Use of Force. U of Penn, Inst for Law & Econ Research Paper (20-03). Kalinowski, J., S. L. Ross, M. B. Ross, et al. (2017). Endogenous Driving Behavior in Veil of Darkness Tests for Racial Proﬁling. Human Capital and Economic Opportunity (HCEO) Working Paper 17.

- Kaplan, J. (2020a). Jacob Kaplan’s Concatenated Files: Uniform Crime Reporting Program Data: Law Enforcement Oﬃcers Killed and Assaulted (LEOKA) 1960-2018. Inter-university Consortium for Political and Social Research (ICPSR).
- Kaplan, J. (2020b). Jacob Kaplan’s Concatenated Files: Uniform Crime Reporting Program Data: Oﬀenses Known and Clearances by Arrest, 1960-2018. Inter-university Consortium for Political and Social Research (ICPSR).
- Kaplan, J. (2020c). Jacob Kaplan’s Concatenated Files: Uniform Crime Reporting (UCR) Program Data: Arrests by Age, Sex, and Race, 1974-2018. Inter-university Consortium for Political and Social Research (ICPSR).


- Kaplan, J. (2020d). Jacob Kaplan’s Concatenated Files: Uniform Crime Reporting (UCR) Program Data: Supplementary Homicide Reports, 1976-2019. Inter-university Consortium for Political and Social Research (ICPSR).


Kelling, G. L. and W. H. Sousa (2001). Do police matter?: An analysis of the impact of New York City’s

police reforms. CCI Center for Civic Innovation at the Manhattan Institute. Kelling, G. L. and J. Q. Wilson (1982). Broken windows. Atlantic monthly 249(3), 29–38. Klick, J. and A. Tabarrok (2005). Using terror alert levels to estimate the eﬀect of police on crime. The

Journal of Law and Economics 48(1), 267–279. Kohler-Hausmann, I. (2018). Misdemeanorland: Criminal Courts and Social Control in an Age of Broken Windows Policing. Princeton University Press. Legewie, J. (2016). Racial proﬁling and use of force in police stops: How local events trigger periods of increased discrimination. American journal of sociology 122(2), 379–424. Levitt, S. D. (1997). Using electoral cycles in police hiring to estimate the eﬀects of police on crime. American Economic Review 87(3), 270–290. Levitt, S. D. (2002). Using electoral cycles in police hiring to estimate the eﬀects of police on crime: Reply. American Economic Review 92(4), 1244–1250. MacDonald, J., J. Fagan, and A. Geller (2016). The Eﬀects of Local Police Surges on Crime and Arrests in New York City. PLOS One 11(6), e0157223. Makowsky, M. D., T. Stratmann, and A. Tabarrok (2019). To Serve and Collect: The Fiscal and Racial Determinants of Law Enforcement. The Journal of Legal Studies 48(1), 189–216. Marenin, O. (2016). Cheapening Death: Danger, Police Street Culture, and the Use of Deadly Force. Police Quarterly 19(4), 461–487. Marvell, T. B. and C. E. Moody (1996). Speciﬁcation problems, police levels, and crime rates. Criminology 34(4), 609–646. Mas, A. (2006). Pay, Reference points, and Police Performance. The Quarterly Journal of Economics 121(3), 783–821. McCrary, J. (2002). Using electoral cycles in police hiring to estimate the eﬀect of police on crime: Comment. American Economic Review 92(4), 1236–1243. McCrary, J. (2007). The eﬀect of court-ordered hiring quotas on the composition and quality of police. American Economic Review 97(1), 318–353.

- Mello, S. (2018). Speed Trap or Poverty Trap? Fines, Fees, and Financial Wellbeing. Working Paper.
- Mello, S. (2019). More COPS, Less Crime. Journal of Public Economics 172, 174–200. Mosher, C. J., T. D. Miethe, and T. C. Hart (2010). The mismeasure of crime. Sage Publications.


Neilson, C. A. and S. D. Zimmerman (2014). The Eﬀect of School Construction on Test Scores, School Enrollment, and Home Prices. Journal of Public Economics 120, 18–31.

Ouellet, M., S. Hashimi, J. Gravel, and A. V. Papachristos (2019). Network exposure and excessive use of force: Investigating the social transmission of police misconduct. Criminology & Public Policy 18(3), 675–704.

Owens, E., D. Weisburd, K. L. Amendola, and G. P. Alpert (2018). Can you build a better cop? experimental evidence on supervision, training, and policing in the community. Criminology & Public Policy 17(1), 41–87.

Premkumar, D. (2020). Intensiﬁed Scrutiny and Bureaucratic Eﬀort: Evidence from Policing and Crime After High-Proﬁle, Oﬃcer-Involved Fatalities. Working Paper.

Prendergast, C. (2001). Selection and Oversight in the Public Sector, with the Los Angeles Police Department as an Example. National Bureau of Economic Research.

Prendergast, C. (2021). ’drive and wave’: The response to lapd police reforms after rampart. University of

Chicago, Becker Friedman Institute for Economics Working Paper (2021-25). Riley, J. L. (2020). Good Policing Saves Black Lives. Wall Street Journal. Rivera, R. and B. A. Ba (2019). The Eﬀect of Police Oversight on Crime and Allegations of Misconduct:

Evidence from Chicago. U of Penn, Inst for Law & Econ Research Paper (19-42). Rosenfeld, R., R. Fornango, and A. F. Rengifo (2007). The impact of order-maintenance policing on New York City homicide and robbery rates: 1988-2001. Criminology 45(2), 355–384. Sandler, D. H. and R. Sandler (2014). Multiple Event Studies in Public Finance and Labor Economics: A Simulation Study with Applications. Journal of Economic and Social Measurement 39(1-2), 31–57. Shi, L. (2009). The Limit of Oversight in Policing: Evidence from the 2001 Cincinnati Riot. Journal of

Public Economics 93(1-2), 99–113. Sierra-Ar´evalo, M. (2016). American Policing and the Danger Imperative. Available at SSRN 2864104. Sierra-Ar´evalo, M. (2019). The Commemoration of Death, Organizational Memory, and Police Culture.

Criminology 57(4), 632–658. Silva, C. (2020). Law Professor On Misdemeanor Oﬀenses And Racism In The Criminal System. NPR. Skolnick, J. H. and J. J. Fyfe (1993). Above the law: Police and the excessive use of force. Free Press New

York. Sloan, C. (2019). The Eﬀect of Violence Against Police on Police Behavior. Working Paper. Speri, A. (2020). Police Make More than 10 Million Arrests a Year, But That Doesn’t Mean They’re Solving

Crimes. The Intercept. Stoughton, S. W. (2014). Policing Facts. Tulane Law Review 88(5), 847. Sullivan, C. M. and Z. P. O’Keeﬀe (2017). Evidence that curtailing proactive policing can reduce major

crime. Nature Human Behaviour 1(10), 730–737. Sun, L. and S. Abraham (2020). Estimating dynamic treatment eﬀects in event studies with heterogeneous treatment eﬀects. Journal of Econometrics.

Weisburd, D., J. C. Hinkle, A. A. Braga, and A. Wooditch (2015). Understanding the mechanisms underlying broken windows policing: The need for evaluation evidence. Journal of research in crime and delinquency 52(4), 589–608.

Weisburd, S. (2016). Police presence, rapid response rates, and crime prevention. Review of Economics and Statistics, 1–45.

Weisburst, E. K. (2019). Safety in Police Numbers: Evidence of Police Eﬀectiveness from Federal COPS Grant Applications. American Law and Economics Review 21(1), 81–109.

Zimring, F. E. (2011). The City that Became Safe: New York’s Lessons for Urban Crime and its Control. Oxford University Press.

Zoorob, M. (2020). Do police brutality stories reduce 911 calls? reassessing an important criminological ﬁnding. American sociological review 85(1), 176–183.

## Tables & Figures

### Table 1: Summary Statistics

Full Sample Treated Agencies

Mean S.D. N Mean S.D N Murder Outcomes

Murder Oﬀenses 0.210 ( 1.508) 472719 2.419 ( 6.037) 23158 Murder Arrests 0.167 ( 1.289) 334492 1.565 ( 4.943) 17926 Policing Activity

Arrests 155.2 ( 488.7) 334573 954.4 (1728.8) 17935

Index Arrests 29.3 ( 96.6) 334565 175.4 ( 340.9) 17953 Violent Arrests 8.8 ( 42.7) 334550 62.5 ( 160.0) 17942 Property Arrests 20.5 ( 59.0) 334545 112.9 ( 199.4) 17954

Non-Index Arrests 41.9 ( 140.1) 334540 267.1 ( 510.6) 17957 Quality of Life Arrests 84.1 ( 268.6) 334537 512.4 ( 936.5) 17946

Traﬃc Stops 5283.5 (8484.6) 1945 7270.8 (9820.0) 595 Crime and Community Activity

Index Crimes 137.5 ( 539.7) 472724 1111.7 (2024.5) 23248 Violent Crimes 17.6 ( 98.7) 472724 173.3 ( 391.2) 23288 Property Crimes 119.9 ( 449.7) 472724 939.4 (1671.1) 23247

911 Calls for Service 15094.6 (17301.5) 5822 27458.4 (21368.7) 2135 Crime Report Rate (911 Calls) 0.19 ( 0.10) 4483 0.20 ( 0.11) 1831 Fatal Traﬃc Accidents 0.19 ( 0.79) 371820 1.27 ( 2.79) 16932

Number of Agencies 2089 Number of Treated Agencies 103 Total Oﬃcer Death Events 171 Treatments Per City (Treated) 1.66

Oﬃcer Characteristics Cause of Death Gunﬁre: 168 Vehicular Assault: 7 Other: 5 Race White: 134 Black: 24 Other: 22 Gender Male: 170 Female: 10 Age 37.17 ( 9.34) Experience 11.10 ( 8.23)

Notes: The number of agencies, number of treated agencies and total oﬃcer death events are from the data with crime activity outcomes. For arrest activity outcomes, they are 1480, 80, and 133, respectively. For the traﬃc stop outcomes, they are 24, 7, and 21. For the traﬃc accident outcome, they are 1640, 75, and 116. For 911 call outcomes, they are 69, 23, and 59. All arrest and crime subcategories exclude murder outcomes. Violent crimes and arrests include rape, robbery and aggravated assault. Property crimes and arrests include burglary, theft and motor vehicle theft. See Table A3 and Table A4 for the list of crime and arrest sub-types. “Crime Report Rate (911 Calls)” is the share of calls that result in an oﬃcer writing a crime incident report. The oﬃcer characteristics are from the Oﬃcer Down Memorial Page. Other causes of death include assault and stabbed.

### Table 2: Impact of an Oﬃcer Death on Policing and Crime

### 36

1st Month 2nd Month Long-Term Outcome Mean

(t=0) S.E. (t=1) S.E. (t=2,...,11) S.E. Full Treated N Murder Outcomes

Murder Oﬀenses 0.325*** ( 0.047) -0.003 ( 0.037) 0.004 ( 0.013) 0.21 2.42 472719 Murder Arrests 0.122*** ( 0.045) 0.052 ( 0.034) 0.022 ( 0.025) 0.17 1.57 334492 Policing Activity

Arrests -0.070*** ( 0.024) -0.041* ( 0.022) -0.000 ( 0.021) 155.2 954.4 334572

Index Arrests -0.072** ( 0.030) -0.005 ( 0.026) 0.004 ( 0.022) 29.3 175.4 334565 Violent Arrests -0.078** ( 0.037) -0.040 ( 0.027) -0.029 ( 0.023) 8.8 62.5 334550 Property Arrests -0.075** ( 0.032) -0.015 ( 0.033) -0.001 ( 0.027) 20.5 112.9 334545

Non-Index Arrests -0.072*** ( 0.024) -0.062** ( 0.025) 0.000 ( 0.021) 41.9 267.1 334540 Quality of Life Arrests -0.061** ( 0.031) -0.043 ( 0.032) 0.000 ( 0.030) 84.1 512.4 334537

Traﬃc Stops -0.163 ( 0.111) -0.269** ( 0.123) -0.086 ( 0.107) 5288.0 7348.0 1918 Crime and Community Activity

Index Crimes 0.006 ( 0.015) 0.006 ( 0.014) 0.005 ( 0.011) 137.5 1111.7 472724 Violent Crimes -0.032 ( 0.024) 0.014 ( 0.023) -0.022 ( 0.014) 17.6 173.3 472724 Property Crimes 0.010 ( 0.016) 0.003 ( 0.015) 0.007 ( 0.012) 119.9 939.4 472724

911 Calls for Service -0.003 ( 0.017) 0.015 ( 0.018) 0.003 ( 0.013) 15096.5 27515.7 5737 Crime Report Rate (911 Calls) 0.001 ( 0.004) -0.001 ( 0.005) 0.003 ( 0.003) 0.19 0.20 4418 Fatal Traﬃc Accidents -0.037 ( 0.044) -0.021 ( 0.032) -0.019 ( 0.015) 0.19 1.27 371820

Notes: All regressions include a vector of covariates at the department-by-year level, department-by-calendar month and year-by-month ﬁxed eﬀects and department-speciﬁc linear time trends. Regressions also include a dummy variable for 12 or more months after the occurrence of an oﬃcer death. Outcomes are deﬁned as outcome means are given in levels. Standard errors are clustered at the department level. The number of agencies, number of treated agencies, and total oﬃcer death events for crime outcomes are 2089, 103, and 171, respectively. For arrest activity outcomes, they are 1480, 80, and 133. For the traﬃc stop outcome, they are 24, 7, and 21. For traﬃc accident outcome, they are 1640, 75 and 116. For 911 call outcomes, they are 69, 23, and 59. All arrest and crime subcategories exclude murder outcomes. Violent crimes and arrests include rape, robbery and aggravated assault. Property crimes and arrests include burglary, theft and motor vehicle theft. See Table A3 and Table A4 for the list of crime and arrest sub-types. “Crime Report Rate (911 Calls)” is the share of calls that result in an oﬃcer writing a crime incident report. * p<0.1,** p

Figure 1: Google Trends Analysis

A. Civilians Killed by Police

### B. Oﬃcers Killed in the Line-of-Duty

|01530456075<br><br>Search Popularity<br><br>(Myocardial Infarction)<br><br>-2024681012 Search Popularity<br><br>-26 -24 -22 -20 -18 -16 -14 -12 -10 -8 -6 -4 -2 0 2 4 6 8 10 12 14 16 18 20 22 24 26<br><br><br>Weeks Since Event<br><br>|Civilian Deaths (Black Lives Matter) N=137|
|---|
|
|---|


|01530456075<br><br>Search Popularity<br><br>(Myocardial Infarction)<br><br>-2024681012 Search Popularity<br><br>-26 -24 -22 -20 -18 -16 -14 -12 -10 -8 -6 -4 -2 0 2 4 6 8 10 12 14 16 18 20 22 24 26<br><br><br>Weeks Since Event<br><br>|Ofﬁcer Deaths (Ofﬁcer Down Memorial Page) N=82|
|---|
|
|---|


-2024681012 Search Popularity

01530456075

-2024681012 Search Popularity

01530456075

(Myocardial Infarction)

(Myocardial Infarction)

Search Popularity

Search Popularity

Notes: Each search term is an exact ﬁrst and last name for the individual. We identify high-proﬁle civilian deaths using a list compiled by Black Lives Matter, and identify oﬃcer deaths by linking the FBI LEOKA data we use in this project to records from the Oﬃcer Down Memorial Page to obtain oﬃcer names. Each search is centered around the time period of -1. Each search is benchmarked by topical searches for the most common cause of death, heart disease, which is relatively stable in popularity across time and locations within the U.S. Google Trends plots relative search intensity with a maximum search popularity in each search of 100. Relative search intensity is calculated in the year around the event in the state of the event.

Figure 2: Variation in Oﬃcer Deaths

A. Oﬃcer Deaths by Year

### B. Oﬃcer Deaths by Month

|0246810121416182022 Number of Incidents<br><br>2000 2002 2004 2006 2008 2010 2012 2014 2016 2018 Year<br><br>|
|---|


0246810121416182022 Number of Incidents

|0246810121416182022 Number of Incidents<br><br>1 2 3 4 5 6 7 8 9 10 11 12 Month<br><br>|
|---|


46810121416182022 Number of Incidents

##### Notes: In 2,089 departments in our sample, there are a total of 171 oﬃcer death events in which 180 oﬃcers were killed.

Figure 3: Event-Study: Murder Outcomes

A. Murder Oﬀenses

|-.2-.10.1.2.3.4.5<br><br>-6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 Months Relative to an Ofﬁcer Death<br><br><br>|
|---|


-.2-.10.1.2.3.4.5

### B. Murder Arrests

|-.2-.10.1.2.3.4.5<br><br>-6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 Months Relative to an Ofﬁcer Death<br><br><br>|
|---|


-.10.1.2.3.4.5

##### Notes: All regressions include a vector of covariates at the department-by-year level, department-by-calendar month and year-by-month ﬁxed eﬀects and department-speciﬁc linear time trends. Months -6 and 6 include all months before month -6 and all months after month 6, respectively. Standard errors are clustered at the department level.

Figure 4: Event-Study: Arrests

A. Violent Arrests

|-.2-.15-.1-.050.05.1.15.2<br><br>-6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 Months Relative to an Ofﬁcer Death<br><br><br>|
|---|


- -.2-.15-.1-.050.05.1.15.2

B. Property Arrests

|-.2-.15-.1-.050.05.1.15.2<br><br>-6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 Months Relative to an Ofﬁcer Death<br><br><br>|
|---|


-.15-.1-.050.05.1.15.2

C. Non-Index Arrests

|-.2-.15-.1-.050.05.1.15.2<br><br>-6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 Months Relative to an Ofﬁcer Death<br><br><br>|
|---|


- -.2-.15-.1-.050.05.1.15.2


### D.Quality of Life Arrests

|-.2-.15-.1-.050.05.1.15.2<br><br>-6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 Months Relative to an Ofﬁcer Death<br><br><br>|
|---|


Notes: All regressions include a vector of covariates at the department-by-year level, department-by-calendar month and year-by-month ﬁxed eﬀects and department-speciﬁc linear time trends. Months -6 and 6 include all months before month -6 and all months after month 6, respectively. Standard errors are clustered at the department level. See Table A4 for the list of arrest sub-types. Violent arrests include rape, robbery and aggravated assault. Property arrests include burglary, theft and motor vehicle theft.

Figure 5: Event-Study: Crimes

A. Violent Crimes

|-.2-.15-.1-.050.05.1.15.2<br><br>-6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 Months Relative to an Ofﬁcer Death<br><br><br>|
|---|


-.2-.15-.1-.050.05.1.15.2

### B. Property Crimes

|-.2-.15-.1-.050.05.1.15.2<br><br>-6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 Months Relative to an Ofﬁcer Death<br><br><br>|
|---|


.15-.1-.050.05.1.15.2

##### Notes: All regressions include a vector of covariates at the department-by-year level, department-by-calendar month and year-by-month ﬁxed eﬀects and department-speciﬁc linear time trends. Months -6 and 6 include all months before month -6 and all months after month 6, respectively. Standard errors are clustered at the department level. Violent crimes include rape, robbery, and aggravated assault. Property crimes include burglary, theft, and motor vehicle theft.

Figure 6: Estimates of the Police Employment Elasticity of Crime

- A. Violent Crimes

|Levitt (1997)<br><br>McCrary (2002)<br><br>Levitt (2002)<br><br>Evans and Owens (2007)<br><br>Lin (2009)<br><br>Draca, Machin and Witt (2011)*<br><br>Chalﬁn and McCrary (2018)<br><br>Mello (2019)<br><br>Weisburst (2019)<br><br>This Paper<br><br>-4.5 -4 -3.5 -3 -2.5 -2 -1.5 -1 -.5 0 .5 1 1.5<br><br>Estimates of the Police Elasticity of Crime<br><br>|Average Crime Elasticity|
|---|
|
|---|


- B. Property Crimes


|Levitt (1997)<br><br>McCrary (2002)<br><br>Levitt (2002)<br><br>Evans and Owens (2007)<br><br>Lin (2009)<br><br>Draca, Machin and Witt (2011)*<br><br>Chalﬁn and McCrary (2018)<br><br>Mello (2019)<br><br>Weisburst (2019)<br><br>This Paper<br><br>-4.5 -4 -3.5 -3 -2.5 -2 -1.5 -1 -.5 0 .5 1 1.5<br><br>Estimates of the Police Elasticity of Crime<br><br>|Average Crime Elasticity|
|---|
|
|---|


Notes: The estimates of the police elasticities of violent and property crimes are from recent articles. Draca et al. (2011) estimates an elasticity of total crime with respect to police employment. For the Levitt (1997) estimates, we take the elasticity estimates from McCrary (2002) correcting for a coding error in the original paper. The estimates from this paper use the crime elasticity with respect to arrest enforcement. The red bars represent the average elasticities of all articles excluding our estimates, weighted by the inverse of their variance.

Figure 7: Arrest to Crime Curve

A. Month Eﬀect (t = 0)

|-.5-.4-.3-.2-.10.1.2.3 Residual Change in Crimes<br><br>-.6 -.5 -.4 -.3 -.2 -.1 0 .1 .2 .3 Residual Change in Arrests<br><br><br>|Local Linear Regression Binned Residual 10-90 Percentile Range Model Estimate|
|---|
|
|---|


-.5-.4-.3-.2-.10.1.2.3 Residual Change in Crimes

### B. Year Eﬀect (t = 0,...,11)

|-8-6-4-20246 Residual Change in Crimes<br><br>-.6 -.5 -.4 -.3 -.2 -.1 0 .1 .2 .3 Residual Change in Arrests<br><br><br>|Local Linear Regression Binned Residual 10-90 Percentile Range Model Estimate|
|---|
|
|---|


Notes: The residual changes in arrest and crime are estimated conditional on covariates, a department-speciﬁc linear time trend, department-by-calendar month and year-by-month ﬁxed eﬀects and diﬀerenced relative to the month prior to a line-of-duty death. Each plot has 50 binned values of the residuals. Residuals that are below 5th percentile or above 95th percentile are dropped from the plots. The gray bars represent the 90-10 percentile range.

Figure 8: Crime Impact by Length of Arrest Decline

A. Month Eﬀect (t = 0)

|-.5-.4-.3-.2-.10.1.2.3 Residual Change in Crimes<br><br>0 1 2 3 and 4 5 or more Number of Months of Negative Effect<br><br>|Treated Agency Mean 10-90 Percentile Range|
|---|
|
|---|


-.5-.4-.3-.2-.10.1.2.3 Residual Change in Crimes

### B. Year Eﬀect (t = 0,...,11)

|-10-8-6-4-2024 Residual Change in Crimes<br><br>0 1 2 3 and 4 5 or more Number of Months of Negative Effect<br><br>|Treated Agency Mean 10-90 Percentile Range|
|---|
|
|---|


Notes: The residual changes in arrest and crime are estimated conditional on covariates, a department-speciﬁc linear time trend, department-by-calendar month and year-by-month ﬁxed eﬀects and diﬀerenced relative to the month prior to a line-of-duty oﬃcer death. The length of eﬀect is determined by the number of consecutive months where the department’s estimated arrest residuals are more negative than the residual for the month prior to the line-of-duty oﬃcer death. Each plot shows the treated department’s values of the residuals. The gray bars represent the 90-10 percentile range for each duration group.

Figure 9: Case Study in Dallas, Texas

A. Arrests

|400500600700800900<br><br>-9 -6 -3 0 3 6 9 12 15 Weeks Relative to Line-of-Duty Ofﬁcer Death<br><br>|Event Year (2018) Year Prior (2017)|
|---|
|
|---|


400500600700800900

### B. Crime

|38004000420044004600<br><br>-9 -6 -3 0 3 6 9 12 15 Weeks Relative to Line-of-Duty Ofﬁcer Death<br><br>|Event Year (2018) Year Prior (2017)|
|---|
|
|---|


38004000420044004600

### C. 911 Calls

|600070008000900010000<br><br>-9 -6 -3 0 3 6 9 12 15 Weeks Relative to Line-of-Duty Ofﬁcer Death<br><br>|Event Year (2018) Year Prior (2017)|
|---|
|
|---|


600070008000900010000

### D. Crime Report Rate (911 Calls)

|.31.32.33.34.35.36<br><br>-9 -6 -3 0 3 6 9 12 15 Weeks Relative to Line-of-Duty Ofﬁcer Death<br><br>|Event Year (2018) Year Prior (2017)|
|---|
|
|---|


Notes: This ﬁgure plots outcomes using data from the Dallas Police Department around the date of the shooting of Oﬃcer Rogelio Santander on April 24, 2018. Data is plotted using calendar weeks, with week 0 containing the shooting event. Data from the Dallas Police Department were obtained via open records requests to the department. Crime is measured when any oﬃcial crime report is logged, and is not restricted to serious oﬀenses (Panel B). The crime report rate is the share of 911 calls that result in a crime report being written by a responding oﬃcer (Panel D).

Figure 9: Case Study in Dallas, Texas (Continued)

E. Arrest Rate (911 Calls)

|.01.015.02.025<br><br>-9 -6 -3 0 3 6 9 12 15 Weeks Relative to Line-of-Duty Ofﬁcer Death<br><br>|Event Year (2018) Year Prior (2017)|
|---|
|
|---|


.01.015.02.025

### F. Number of Oﬃcers

|1600165017001750<br><br>-9 -6 -3 0 3 6 9 12 15 Weeks Relative to Line-of-Duty Ofﬁcer Death<br><br>|Event Year (2018) Year Prior (2017)|
|---|
|
|---|


1600165017001750

### G. Non-Shooting use-of-force

|1020304050<br><br>-9 -6 -3 0 3 6 9 12 15 Weeks Relative to Line-of-Duty Ofﬁcer Death<br><br>|Event Year (2018) Year Prior (2017)|
|---|
|
|---|


1020304050

### H. Number of Oﬃcers (High Crime Beats)

|1350<br><br>| | | | | | | | | | | |
|---|---|---|---|---|---|---|---|---|---|---|
| | | | | | | | | | | |
| | | | | | | | | | | |
| | | | | | | | | | | |
| | | | | | | | | | | |
| | | | | | | | | | | |
<br><br>1400145015001550<br><br>-9 -6 -3 0 3 6 9 12 15 Weeks Relative to Line-of-Duty Ofﬁcer Death<br><br>|Event Year (2018) Year Prior (2017)|
|---|
|
|---|


Notes: This ﬁgure plots outcomes using data from the Dallas Police Department around the date of the shooting of Oﬃcer Rogelio Santander on April 24, 2018. Data is plotted using calendar weeks, with week 0 containing the shooting event. Data from the Dallas Police Department were obtained via open records requests to the department. The arrest rate is the share of 911 calls that result in an arrest (Panel E). Non-shooting use-of-force is calculated using “Response to Resistance” data published by the Dallas Police Department (Panel G). Panel F and H plot the number of oﬃcers observed responding to any 911 call in the whole city and high crime beats, respectively. High crime beats are deﬁned as beats in the top 25th percentile of total crime reports.

## A1 Appendix Tables & Figures

### Table A1: Summary Demographic Characteristics

Full Sample Treated Agencies

Mean S.D. N Mean S.D N Characteristics of Cities

Number of Police Oﬃcers 73.3 ( 325.0) 39492 597.4 (1304.0) 1943 Number of Oﬃcers Killed by Felony 0.005 ( 0.081) 39492 0.093 ( 0.323) 1943 Number of Oﬃcers Assaulted 10.2 ( 47.3) 39492 82.0 ( 179.7) 1943 % Black 8.3 ( 13.2) 39492 16.0 ( 18.7) 1943 % Hispanic 15.5 ( 20.0) 39492 21.0 ( 19.9) 1943 % White 68.9 ( 24.3) 39492 54.3 ( 23.5) 1943 % Male 48.6 ( 3.4) 39492 48.8 ( 1.9) 1943 % Female-Headed Household 31.5 ( 8.3) 39492 34.0 ( 7.2) 1943 % Age <14 20.2 ( 4.8) 39492 20.6 ( 4.7) 1943 % Age 15-24 14.2 ( 6.5) 39492 16.4 ( 6.7) 1943 % Age 25-44 27.0 ( 5.2) 39492 28.5 ( 4.0) 1943 % Age >45 38.6 ( 8.5) 39492 34.4 ( 7.9) 1943 % < High School 15.6 ( 10.8) 39492 16.8 ( 9.2) 1943 % High School Graduate 28.4 ( 9.5) 39492 25.3 ( 7.4) 1943 % Some College 28.4 ( 7.3) 39492 29.1 ( 5.6) 1943 % College Graduate or More 27.6 ( 16.3) 39492 28.7 ( 13.7) 1943 Unemployment Rate 4.8 ( 3.2) 39492 5.5 ( 2.3) 1943 Poverty Rate 12.7 ( 8.8) 39492 15.6 ( 7.5) 1943 Median Household Income 45562.2 (21611.3) 39492 40890.1 (14732.2) 1943 Population 39148.9 (125621.8) 39492 252467.6 (481169.9) 1943

Number of Agencies 2089 Number of Treated Agencies 103

Notes: The characteristics information are from the data with crime activity outcomes. Oﬃcer related information are from the FBI’s Law Enforcement Oﬃcer Killed or Assaulted (LEOKA) that covers the period 2000-2018. Demographics data come from the 2000 U.S. Census and the American Community Survey 5-year estimates from 2010 to 2018. For years 2001 to 2009, the demographics information are linearly interpolated.

### Table A2: Robustness Speciﬁcations

1st Month 2nd Month Long-Term Outcome Mean (t=0) S.E. (t=1) S.E. (t=2,...,11) S.E. Full Treated N

- (1) Baseline Speciﬁcation Murder Oﬀenses 0.325*** ( 0.047) -0.003 ( 0.037) 0.004 ( 0.013) 0.21 2.42 472719 Arrests -0.070*** ( 0.024) -0.041* ( 0.022) -0.000 ( 0.021) 155.2 954.4 334572 Violent Crimes -0.032 ( 0.024) 0.014 ( 0.023) -0.022 ( 0.014) 17.6 173.3 472724 Property Crimes 0.010 ( 0.016) 0.003 ( 0.015) 0.007 ( 0.012) 119.9 939.4 472724
- (2) Restrict to Treated Cities Murder Oﬀenses 0.327*** ( 0.048) -0.002 ( 0.037) 0.004 ( 0.013) 2.42 2.42 23158 Arrests -0.070*** ( 0.023) -0.040* ( 0.021) -0.002 ( 0.019) 954.4 954.4 17935 Violent Crimes -0.035 ( 0.024) 0.009 ( 0.023) -0.027* ( 0.014) 173.3 173.3 23288

- Property Crimes 0.008 ( 0.017) 0.003 ( 0.014) 0.008 ( 0.011) 939.4 939.4 23247

(3) Separate Panel for Each Event

Murder Oﬀenses 0.315*** ( 0.046) 0.000 ( 0.035) 0.004 ( 0.011) 0.60 6.52 488208 Arrests -0.076*** ( 0.022) -0.048** ( 0.020) -0.007 ( 0.017) 266.8 1912.5 346821 Violent Crimes -0.024 ( 0.022) 0.020 ( 0.022) -0.015 ( 0.012) 41.9 416.9 488218

- Property Crimes 0.009 ( 0.014) 0.003 ( 0.013) 0.007 ( 0.009) 233.0 2037.2 488217


- (4) Counting Multiple Oﬃcer Deaths Additively Murder Oﬀenses 0.304*** ( 0.045) 0.005 ( 0.032) 0.009 ( 0.011) 0.21 2.42 472719 Arrests -0.065*** ( 0.020) -0.040* ( 0.021) -0.002 ( 0.020) 155.2 954.4 334572 Violent Crimes -0.023 ( 0.020) 0.017 ( 0.021) -0.017 ( 0.013) 17.6 173.3 472724 Property Crimes 0.009 ( 0.015) 0.004 ( 0.013) 0.004 ( 0.010) 119.9 939.4 472724


### 48

### 49

### Table A2: Robustness Speciﬁcations (Continued)

1st Month 2nd Month Long-Term Outcome Mean (t=0) S.E. (t=1) S.E. (t=2,...,11) S.E. Full Treated N

- (5) Drop Time Trend Murder Oﬀenses 0.313*** ( 0.047) -0.015 ( 0.035) -0.008 ( 0.011) 0.21 2.42 472719 Arrests -0.114*** ( 0.024) -0.085*** ( 0.022) -0.048** ( 0.021) 155.2 954.4 334572 Violent Crimes -0.026 ( 0.026) 0.023 ( 0.024) -0.016 ( 0.018) 17.6 173.3 472724 Property Crimes -0.016 ( 0.019) -0.022 ( 0.018) -0.018 ( 0.015) 119.9 939.4 472724
- (6) Drop Agency × Month Murder Oﬀenses 0.331*** ( 0.046) 0.002 ( 0.035) 0.006 ( 0.013) 0.21 2.42 472719 Arrests -0.070*** ( 0.024) -0.035 ( 0.023) -0.001 ( 0.021) 155.2 954.4 334573 Violent Crimes -0.034 ( 0.023) 0.011 ( 0.024) -0.021 ( 0.014) 17.6 173.3 472724 Property Crimes 0.004 ( 0.017) -0.003 ( 0.016) 0.008 ( 0.012) 119.9 939.4 472724
- (7) Add State-by-Year FE Murder Oﬀenses 0.327*** ( 0.047) -0.002 ( 0.036) 0.006 ( 0.013) 0.21 2.42 472719 Arrests -0.073*** ( 0.024) -0.043* ( 0.022) 0.002 ( 0.021) 155.2 954.4 334572 Violent Crimes -0.030 ( 0.024) 0.017 ( 0.024) -0.017 ( 0.015) 17.6 173.3 472724 Property Crimes 0.010 ( 0.016) 0.004 ( 0.014) 0.007 ( 0.011) 119.9 939.4 472724
- (8) Control for Oﬃcer Assaults Murder Oﬀenses 0.326*** ( 0.047) -0.003 ( 0.037) 0.005 ( 0.013) 0.21 2.42 472719 Arrests -0.076*** ( 0.024) -0.045** ( 0.021) -0.004 ( 0.020) 155.2 954.4 334572 Violent Crimes -0.040* ( 0.024) 0.010 ( 0.025) -0.028* ( 0.015) 17.6 173.3 472724 Property Crimes 0.009 ( 0.016) 0.003 ( 0.015) 0.007 ( 0.011) 119.9 939.4 472724


### Table A2: Robustness Speciﬁcations (Continued)

1st Month 2nd Month Long-Term Outcome Mean (t=0) S.E. (t=1) S.E. (t=2,...,11) S.E. Full Treated N

#### (9) Raw Data

Murder Oﬀenses 0.373*** ( 0.053) -0.001 ( 0.036) 0.002 ( 0.013) 0.21 2.41 473899 Arrests -0.080*** ( 0.027) -0.037* ( 0.022) 0.004 ( 0.021) 155.2 953.3 335376 Violent Crimes -0.032 ( 0.024) 0.024 ( 0.026) -0.023* ( 0.014) 17.6 173.1 473694 Property Crimes 0.012 ( 0.016) 0.008 ( 0.016) 0.008 ( 0.012) 119.9 940.3 473904

### 50

#### (10) Levels Model

Murder Oﬀenses 0.718*** ( 0.248) 0.006 ( 0.244) -0.161 ( 0.145) 0.21 2.42 472719 Arrests -26.496 (35.904) 10.028 (52.167) 14.943 (41.393) 155.2 954.4 334572 Violent Crimes -5.568 ( 7.863) -4.512 ( 8.535) -6.453 ( 8.083) 17.6 173.3 472724 Property Crimes -28.295 (23.469) -6.267 (17.467) -28.153 (21.297) 119.9 939.4 472724

#### (11) Per Capita Model (Per 100K Residents)

Murder Oﬀenses 1.526*** ( 0.293) 0.030 ( 0.098) 0.002 ( 0.036) 0.21 2.42 472719 Arrests -32.363*** (10.396) -20.429** ( 9.930) -5.058 ( 8.513) 155.2 954.4 334572 Violent Crimes -1.527 ( 1.185) -0.345 ( 1.272) -0.936 ( 0.942) 17.6 173.3 472724 Property Crimes -0.836 ( 5.988) 2.351 ( 5.562) 4.098 ( 5.175) 119.9 939.4 472724

#### (12) Inverse Hyperbolic Sine Model

Murder Oﬀenses 0.417*** ( 0.060) -0.007 ( 0.046) 0.007 ( 0.015) 0.21 2.42 472719 Arrests -0.072*** ( 0.024) -0.042* ( 0.023) -0.000 ( 0.021) 155.2 954.4 334572 Violent Crimes -0.038 ( 0.028) 0.017 ( 0.026) -0.027* ( 0.015) 17.6 173.3 472724 Property Crimes 0.011 ( 0.017) 0.004 ( 0.016) 0.007 ( 0.012) 119.9 939.4 472724

### 51

### Table A2: Robustness Speciﬁcations (Continued)

1st Month 2nd Month Long-Term Outcome Mean (t=0) S.E. (t=1) S.E. (t=2,...,11) S.E. Full Treated N

- (13) Re-weight (Overweight Untreated Obs.) Murder Oﬀenses 0.325*** ( 0.046) -0.003 ( 0.037) 0.004 ( 0.013) 0.21 2.42 472719 Arrests -0.070*** ( 0.024) -0.041* ( 0.022) 0.000 ( 0.021) 155.2 954.4 334572 Violent Crimes -0.032 ( 0.024) 0.014 ( 0.023) -0.022 ( 0.014) 17.6 173.3 472724 Property Crimes 0.012 ( 0.019) 0.004 ( 0.020) 0.008 ( 0.018) 119.9 939.4 472724
- (14) Sun & Abraham (2020) IW Estimator Murder Oﬀenses 0.318*** ( 0.034) 0.001 ( 0.030) 0.003 ( 0.007) 0.60 6.52 488208 Arrests -0.067*** ( 0.022) -0.038* ( 0.021) 0.004 ( 0.008) 266.8 1912.5 346821 Violent Crimes -0.025 ( 0.023) 0.020 ( 0.021) -0.016** ( 0.007) 41.9 416.9 488218 Property Crimes 0.011 ( 0.015) 0.004 ( 0.014) 0.008 ( 0.005) 233.0 2037.2 488217
- (15) Re-weight (Overweight Untreated and Pre-period Obs.) Murder Oﬀenses 0.290*** ( 0.053) -0.041 ( 0.045) -0.026 ( 0.019) 0.21 2.42 472719 Arrests -0.087*** ( 0.023) -0.060** ( 0.024) -0.015 ( 0.020) 155.2 954.4 334572 Violent Crimes -0.042 ( 0.029) 0.000 ( 0.027) -0.036* ( 0.020) 17.6 173.3 472724 Property Crimes 0.010 ( 0.021) -0.001 ( 0.021) -0.003 ( 0.020) 119.9 939.4 472724


Notes: The baseline speciﬁcation is a replicate of output in Table 2 and each subsequent model is a variant of this baseline. Model (2) restricts the sample to treated cities. Model (3) uses a separate panel for each oﬃcer death treatment rather than each department. Model (4) counts multiple death events additively rather than as a single event. Model (5) and (6) drop the department speciﬁc linear time trend and agency-by-month ﬁxed eﬀect, respectively. Model (7) adds state by year ﬁxed eﬀects. Model (8) controls for monthly variation in assaults against oﬃcers that result in injuries. Model (9) uses the uncleaned raw data. Models (10), (11) and (12) consider alternate functional forms, using a levels, an inverse hyperbolic sine and a per capita, respectively. Model (13) re-weights the data with control city weight=1000 and treated city weight=1. Model (14) uses Sun and Abraham (2020)’s proposed estimator and Model (15) re-weights the data with control city weight=1000, treated city pre-period weight = 1000 and treated city weight=1.. Standard errors are clustered at the department level. * p<0.1,** p<0.05, *** p<0.01.

### 52

### Table A3: Index Crimes and Arrests by Type

1st Month 2nd Month Long-Term Outcome Mean (t=0) S.E. (t=1) S.E. (t=2,...,11) S.E. Full Treated N

- A. Murder Outcomes Murder Oﬀenses 0.325*** ( 0.047) -0.003 ( 0.037) 0.004 ( 0.013) 0.21 2.42 472719 Murder Arrests 0.122*** ( 0.045) 0.052 ( 0.034) 0.022 ( 0.025) 0.17 1.57 334492
- B. Index Crime Rape -0.013 ( 0.031) 0.007 ( 0.035) 0.001 ( 0.019) 1.2 10.4 469489 Robbery -0.011 ( 0.028) 0.002 ( 0.029) -0.015 ( 0.015) 5.8 64.2 470383 Aggravated Assault -0.049* ( 0.029) 0.004 ( 0.026) -0.022 ( 0.017) 10.6 98.9 470886 Burglary 0.055** ( 0.024) 0.016 ( 0.025) 0.019 ( 0.017) 23.8 196.0 471459 Theft -0.030 ( 0.026) -0.019 ( 0.021) -0.014 ( 0.017) 80.9 590.5 472080 Motor Vehicle Theft -0.004 ( 0.027) -0.003 ( 0.029) -0.002 ( 0.020) 15.3 153.7 471221
- C. Index Arrests Rape 0.003 ( 0.036) -0.020 ( 0.032) 0.012 ( 0.018) 0.28 2.11 332335 Robbery -0.060* ( 0.033) -0.067 ( 0.047) 0.010 ( 0.022) 1.8 15.7 332413 Aggravated Assault -0.054 ( 0.037) -0.023 ( 0.028) -0.043 ( 0.026) 6.7 44.9 332866 Burglary 0.028 ( 0.040) 0.014 ( 0.046) 0.021 ( 0.027) 3.8 20.5 332932 Theft -0.066 ( 0.042) -0.012 ( 0.038) -0.009 ( 0.030) 15.2 80.6 333363 Motor Vehicle Theft -0.065 ( 0.043) -0.113 ( 0.072) -0.059 ( 0.069) 1.5 12.0 332826


Notes: All regressions include a vector of covariates at the department-by-year level, department-by-calendar month and year-by-month ﬁxed eﬀects and department-speciﬁc linear time trends. Regressions also include a dummy variable for 12 or more months after the occurrence of an oﬃcer death. Outcomes are deﬁned as outcome means are given in levels. Standard errors are clustered at the department level. * p<0.1,** p<0.05, *** p<0.01.

### 53

### Table A4: Non-Index Arrest Outcomes by Type

1st Month 2nd Month Long-Term Outcome Mean (t=0) S.E. (t=1) S.E. (t=2,...,11) S.E. Full Treated N

- A. Non-Index Arrests Manslaughter 0.031 ( 0.020) 0.022 ( 0.025) 0.001 ( 0.013) 0.01 0.10 333130 Arson 0.030 ( 0.043) -0.050 ( 0.037) 0.008 ( 0.017) 0.15 0.85 333204 Other Assault -0.015 ( 0.033) -0.050 ( 0.036) 0.002 ( 0.029) 13.9 88.7 333300 Weapons -0.038 ( 0.041) -0.007 ( 0.036) -0.012 ( 0.022) 2.4 17.2 333177 Prostitution -0.058 ( 0.042) -0.090* ( 0.050) -0.038 ( 0.042) 1.3 15.7 333132 Other Sex Oﬀense -0.047 ( 0.033) -0.017 ( 0.046) -0.016 ( 0.027) 0.96 6.88 333155 Family Oﬀense 0.018 ( 0.067) 0.066 ( 0.051) 0.047 ( 0.051) 0.55 3.79 333163 DUI -0.099** ( 0.041) -0.095** ( 0.041) -0.009 ( 0.030) 12.9 69.4 333298 Drug Sale -0.085 ( 0.068) -0.043 ( 0.068) -0.052 ( 0.065) 4.0 35.6 333233 Forgery 0.006 ( 0.040) -0.021 ( 0.041) 0.008 ( 0.028) 1.04 5.12 333169 Fraud 0.010 ( 0.046) -0.006 ( 0.046) 0.066** ( 0.033) 1.74 8.20 333265 Embezzlement -0.009 ( 0.054) -0.000 ( 0.038) 0.026 ( 0.029) 0.23 1.10 333159 Stolen Property 0.048 ( 0.061) 0.075 ( 0.058) 0.077 ( 0.061) 1.52 7.01 333189 Runaway 0.032 ( 0.042) 0.017 ( 0.043) 0.013 ( 0.043) 1.19 8.10 333160
- B. Quality of Life Arrests Disorderly Conduct -0.008 ( 0.046) -0.035 ( 0.044) 0.018 ( 0.038) 5.4 29.3 333350 Suspicious Person -0.001 ( 0.001) -0.000 ( 0.000) -0.000 ( 0.000) 0.00 0.00 333298 Curfew/Loitering -0.056 ( 0.063) 0.021 ( 0.048) -0.015 ( 0.062) 2.4 31.7 333293 Vandalism -0.052 ( 0.043) -0.058 ( 0.045) -0.036 ( 0.031) 3.0 17.2 333351 Gambling -0.016 ( 0.033) 0.000 ( 0.032) -0.002 ( 0.020) 0.06 0.66 333230 Vagrancy 0.016 ( 0.070) -0.017 ( 0.067) 0.036 ( 0.072) 0.56 5.93 333246 Drunkenness -0.024 ( 0.061) 0.016 ( 0.063) 0.025 ( 0.056) 8.9 43.3 333392 Liquor -0.015 ( 0.069) -0.068 ( 0.071) 0.002 ( 0.056) 5.0 28.0 333384 Drug Possession -0.098 ( 0.063) -0.125* ( 0.066) -0.052 ( 0.073) 17.9 100.1 333369 Uncategorized Arrests -0.030 ( 0.043) -0.005 ( 0.041) 0.036 ( 0.044) 40.9 257.0 333523


Notes: All regressions include a vector of covariates at the department-by-year level, department-by-calendar month and year-by-month ﬁxed eﬀects and department-speciﬁc linear time trends. Regressions also include a dummy variable for 12 or more months after the occurrence of an oﬃcer death. Outcomes are deﬁned as outcome means are given in levels. Standard errors are clustered at the department level. * p<0.1,** p<0.05, *** p<0.01.

### 54

### Table A5: Additional Outcomes

1st Month 2nd Month Long-Term Outcome Mean (t=0) S.E. (t=1) S.E. (t=2,...,11) S.E. Full Treated N

Traﬃc Accidents Fatal Traﬃc Accidents -0.037 ( 0.044) -0.021 ( 0.032) -0.019 ( 0.015) 0.19 1.27 371820

Accidents involving Alcohol 0.043 ( 0.052) 0.002 ( 0.043) 0.011 ( 0.024) 0.07 0.43 329664 Fatal Use-of-Force

Supplementary Homicide Report 0.016 ( 0.015) -0.013 ( 0.013) 0.001 ( 0.007) 0.01 0.07 472724 Fatal Encounters 0.040 ( 0.026) 0.002 ( 0.024) -0.003 ( 0.008) 0.01 0.12 473904

Notes: All regressions include a vector of covariates at the department-by-year level, department-by-calendar month and year-by-month ﬁxed eﬀects and department-speciﬁc linear time trends. Regressions also include a dummy variable for 12 or more months after the occurrence of an oﬃcer death. Outcomes are deﬁned as outcome means are given in levels. Standard errors are clustered at the department level. “Accidents involving alcohol” is the number of fatal traﬃc accidents with at least one driver with the blood alcohol concentration 0.01 g/dL or higher involved in a crash. Oﬃcer Involved Deaths panel includes two measures of civilians killed by police. First, the “Felon Killed by Police” measure is a count of deaths at the hands of oﬃcers from the Supplementary Homicide Report of the FBI UCR series. Second, count of civilians killed by police from a crowd-sourced data series. Both measures exclude records of deaths of suspects involved in the line-of-duty oﬃcer death event during month 0, as well as records of civilian deaths that occur before the oﬃcer death in month 0. * p<0.1,** p<0.05, *** p<0.01.

Figure A1: Event-Study: Index Crimes

A. Rape

### B. Burglary

|-.2-.15-.1-.050.05.1.15.2<br><br>-6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 Months Relative to an Ofﬁcer Death<br><br><br>|
|---|


-.2-.15-.1-.050.05.1.15.2

### C. Robbery

|-.2-.15-.1-.050.05.1.15.2<br><br>-6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 Months Relative to an Ofﬁcer Death<br><br><br>|
|---|


-.2-.15-.1-.050.05.1.15.2

E. Aggravated Assault

|-.2-.15-.1-.050.05.1.15.2<br><br>-6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 Months Relative to an Ofﬁcer Death<br><br><br>|
|---|


|-.2-.15-.1-.050.05.1.15.2<br><br>-6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 Months Relative to an Ofﬁcer Death<br><br><br>|
|---|


-.15-.1-.050.05.1.15.2

D. Theft

|-.2-.15-.1-.050.05.1.15.2<br><br>-6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 Months Relative to an Ofﬁcer Death<br><br><br>|
|---|


F. Motor Vehicle Theft

|-.2-.15-.1-.050.05.1.15.2<br><br>-6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 Months Relative to an Ofﬁcer Death<br><br><br>|
|---|


-.2-.15-.1-.050.05.1.15.2

##### Notes: All regressions include a vector of covariates at the department-by-year level, department-by-calendar month and year-by-month ﬁxed eﬀects and department-speciﬁc linear time trends. Months -6 and 6 include all months before month -6 and all months after month 6, respectively. Standard errors are clustered at the department level.

Figure A2: Event-Study: 911 Calls and Traﬃc Outcomes

A. 911 Calls

### B. Crime Report Rate (911 Calls)

|-.1-.075-.05-.0250.025.05.075.1<br><br>-6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 Months Relative to an Ofﬁcer Death<br><br><br>|
|---|


|-.02-.015-.01-.0050.005.01.015.02<br><br>-6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 Months Relative to an Ofﬁcer Death<br><br><br>|
|---|


-.1-.075-.05-.0250.025.05.075.1

-.015-.01-.0050.005.01.015.02

D. Traﬃc Stops

### C. Traﬃc Fatalities

|-.1-.050.05.1.15.2.25.3<br><br>-6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 Months Relative to an Ofﬁcer Death<br><br><br>|
|---|


|-.4-.3-.2-.10.1.2.3.4.5.6<br><br>-6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 Months Relative to an Ofﬁcer Death<br><br><br>|
|---|


-.1-.050.05.1.15.2.25.3

E. Fatal Use-of-Force (FBI SHR)

F. Fatal Use-of-Force (Fatal Encounters)

|-.2-.15-.1-.050.05.1.15.2<br><br>-6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 Months Relative to an Ofﬁcer Death<br><br><br>|
|---|


|-.2-.15-.1-.050.05.1.15.2<br><br>-6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 Months Relative to an Ofﬁcer Death<br><br><br>|
|---|


-.2-.15-.1-.050.05.1.15.2

##### Notes: All regressions include a vector of covariates at the department-by-year level, department-by-calendar month and year-by-month ﬁxed eﬀects and department-speciﬁc linear time trends. Months -6 and 6 include all months before month -6 and all months after month 6, respectively. Standard errors are clustered at the department level. Panels E and F measure fatal use-of-force by police oﬃcers; both measures exclude records of deaths of suspects involved in the line-of-duty oﬃcer death event during month 0, as well as records of civilian deaths that occur before the line-of-duty oﬃcer death in month 0.

Figure A3: Distribution of Coeﬃcients Dropping Single Treated Agency

- Arrest - t = 0

|010203040<br><br>-.12 -.1 -.08 -.06 -.04 -.02 0 .02 .04 .06 .08 .1 .12 Arrest - Month 0 Coefﬁcient<br><br>|Model Estimate 95% Conﬁdence Interval|
|---|
|
|---|


010203040

Crime - t = 0

|010203040<br><br>-.12 -.1 -.08 -.06 -.04 -.02 0 .02 .04 .06 .08 .1 .12 Offense - Month 0 Coefﬁcient<br><br>|Model Estimate 95% Conﬁdence Interval|
|---|
|
|---|


010203040

- Arrest - t = 1


Crime - t = 1

|010203040<br><br>-.12 -.1 -.08 -.06 -.04 -.02 0 .02 .04 .06 .08 .1 .12 Arrest - Month 1 Coefﬁcient<br><br>|Model Estimate 95% Conﬁdence Interval|
|---|
|
|---|


|010203040<br><br>-.12 -.1 -.08 -.06 -.04 -.02 0 .02 .04 .06 .08 .1 .12 Offense - Month 1 Coefﬁcient<br><br>|Model Estimate 95% Conﬁdence Interval|
|---|
|
|---|


010203040

Arrest - t = 2,...,11

Crime - t = 2,...,11

|010203040<br><br>-.12 -.1 -.08 -.06 -.04 -.02 0 .02 .04 .06 .08 .1 .12 Arrest - Month 2-11 Coefﬁcient<br><br>|Model Estimate 95% Conﬁdence Interval|
|---|
|
|---|


|010203040<br><br>-.12 -.1 -.08 -.06 -.04 -.02 0 .02 .04 .06 .08 .1 .12 Offense - Month 2-11 Coefﬁcient<br><br>|Model Estimate 95% Conﬁdence Interval|
|---|
|
|---|


010203040

##### Notes: All regressions include a vector of covariates at the department-by-year level, department-by-calendar month and year-by-month ﬁxed eﬀects and department-speciﬁc linear time trends. Regressions also include a dummy variable for 12 or more months after the occurrence of an oﬃcer death. Standard errors are clustered at the department level. We re-estimate the model dropping one treatment city at a time. There are 80 treated cities for the arrest outcome and 103 treated cities for the crime outcome.

Figure A4: Placebo Treatment Timing

Arrest - t = 0

### Crime - t = 0

|010203040<br><br>-.12 -.1 -.08 -.06 -.04 -.02 0 .02 .04 .06 .08 .1 .12 Arrest - Month 0 Coefﬁcient<br><br>|95% Percentile Range Model Estimate|
|---|
|
|---|


|010203040<br><br>-.12 -.1 -.08 -.06 -.04 -.02 0 .02 .04 .06 .08 .1 .12 Offense - Month 0 Coefﬁcient<br><br>|95% Percentile Range Model Estimate|
|---|
|
|---|


010203040

010203040

### Arrest - t = 1

Crime - t = 1

|010203040<br><br>-.12 -.1 -.08 -.06 -.04 -.02 0 .02 .04 .06 .08 .1 .12 Arrest - Month 1 Coefﬁcient<br><br>|95% Percentile Range Model Estimate|
|---|
|
|---|


|010203040<br><br>-.12 -.1 -.08 -.06 -.04 -.02 0 .02 .04 .06 .08 .1 .12 Offense - Month 1 Coefﬁcient<br><br>|95% Percentile Range Model Estimate|
|---|
|
|---|


010203040

Arrest - t = 2,...,11

Crime - t = 2,...,11

|010203040<br><br>-.12 -.1 -.08 -.06 -.04 -.02 0 .02 .04 .06 .08 .1 .12 Arrest - Month 2-11 Coefﬁcient<br><br>|95% Percentile Range Model Estimate|
|---|
|
|---|


|010203040<br><br>-.12 -.1 -.08 -.06 -.04 -.02 0 .02 .04 .06 .08 .1 .12 Offense - Month 2-11 Coefﬁcient<br><br>|95% Percentile Range Model Estimate|
|---|
|
|---|


010203040

##### Notes: All regressions include a vector of covariates at the department-by-year level, department-by-calendar month and year-by-month ﬁxed eﬀects and department-speciﬁc linear time trends. Regressions also include a dummy variable for 12 or more months after the occurrence of an oﬃcer death. Standard errors are clustered at the department level. The timing of oﬃcer deaths among treated agencies is randomized holding the number of oﬃcer deaths per agency constant. The model is re-estimated 100 times to construct the placebo distribution.

Figure A5: Event-Study: Sun and Abraham (2020)

A. Total Arrests

|-.2-.15-.1-.050.05.1.15.2<br><br>-6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 Months Relative to an Ofﬁcer Death<br><br><br>|
|---|


-.2-.15-.1-.050.05.1.15.2

### B. Index Crimes

|-.2-.15-.1-.050.05.1.15.2<br><br>-6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 Months Relative to an Ofﬁcer Death<br><br><br>|
|---|


2-.15-.1-.050.05.1.15.2

##### Notes: This ﬁgure plots Sun and Abraham (2020)’s proposed “interaction-weighted” coeﬃcient estimator. This estimator combines cohort-speciﬁc treatment eﬀects, based on treatment timing, using strictly positive weights. All regressions include a vector of covariates at the department-by-year level, department-by-calendar month and year-by-month ﬁxed eﬀects and department-speciﬁc linear time trends. Months -6 and 6 include all months before month -6 and all months after month 6, respectively. Standard errors are clustered at the department level.

Figure A6: Crimes and Arrests by Department Characteristics

### 60

Arrest (t = 0)

Crime (t = 0)

|(Median = 0.002)<br><br>Ofﬁcers Per Population<br><br>(Median = 7.7)<br><br>% Black Population<br><br>(Median = 0.003)<br><br>Ofﬁcer Assaults Per Ofﬁcer<br><br>(Median = 0.05)<br><br>Crime Rate<br><br>(Median = 0.9)<br><br>Arrests Per Crime<br><br>(Median = 2.1)<br><br>Arrest Race Disparity<br><br>(Median = 67890.0)<br><br>Population<br><br>-.4 -.3 -.2 -.1 0 .1 .2<br><br>|Above Median Below Median|
|---|
|
|---|


|(Median = 0.002)<br><br>Ofﬁcers Per Population<br><br>(Median = 7.7)<br><br>% Black Population<br><br>(Median = 0.003)<br><br>Ofﬁcer Assaults Per Ofﬁcer<br><br>(Median = 0.05)<br><br>Crime Rate<br><br>(Median = 0.9)<br><br>Arrests Per Crime<br><br>(Median = 2.1)<br><br>Arrest Race Disparity<br><br>(Median = 67890.0)<br><br>Population<br><br>-.15 -.1 -.05 0 .05<br><br>|Above Median Below Median|
|---|
|
|---|


Crime (t = 0,...,11)

|(Median = 0.002)<br><br>Ofﬁcers Per Population<br><br>(Median = 7.7)<br><br>% Black Population<br><br>(Median = 0.003)<br><br>Ofﬁcer Assaults Per Ofﬁcer<br><br>(Median = 0.05)<br><br>Crime Rate<br><br>(Median = 0.9)<br><br>Arrests Per Crime<br><br>(Median = 2.1)<br><br>Arrest Race Disparity<br><br>(Median = 67890.0)<br><br>Population<br><br>-.15 -.1 -.05 0 .05 .1 .15<br><br>|Above Median Below Median|
|---|
|
|---|


Notes: All regressions include a vector of covariates at the department-by-year level, department-by-calendar month and year-by-month ﬁxed eﬀects and department-speciﬁc linear time trends. Regressions also include a dummy variable for 12 or more months after the occurrence of an oﬃcer death. Standard errors are clustered at the department level. This ﬁgure uses the demographics data from the 2000 U.S. Census, the American Community Survey 5-year estimates from 2010 to 2018 and the FBI’s Law Enforcement Oﬃcer Killed or Assaulted (LEOKA). Each category uses the ﬁrst reported measure to split by median. The Arrest Race Disparity is the ratio of arrests for Black civilians per Black population to arrests for white civilians per white population.

Figure A7: Crimes and Arrests by Oﬃcer Death Characteristics

### 61

Arrest (t = 0)

Crime (t = 0)

|White<br><br>Black<br><br>Male<br><br>Female<br><br>Age < 36 yrs<br><br>Age > 36 yrs<br><br>Experience < 9 yrs<br><br>Experience > 9 yrs<br><br>Gunﬁre<br><br>Vehicular Assault<br><br>-.4 -.3 -.2 -.1 0 .1 .2<br><br>|
|---|


|White<br><br>Black<br><br>Male<br><br>Female<br><br>Age < 36 yrs<br><br>Age > 36 yrs<br><br>Experience < 9 yrs<br><br>Experience > 9 yrs<br><br>Gunﬁre<br><br>Vehicular Assault<br><br>-.15 -.1 -.05 0 .05 .1<br><br>|
|---|


Crime (t = 0,...,11)

|White<br><br>Black<br><br>Male<br><br>Female<br><br>Age < 36 yrs<br><br>Age > 36 yrs<br><br>Experience < 9 yrs<br><br>Experience > 9 yrs<br><br>Gunﬁre<br><br>Vehicular Assault<br><br>-.15 -.1 -.05 0 .05 .1 .15<br><br>|
|---|


Notes: This ﬁgure uses a separate panel for each oﬃcer death treatment. For oﬃcer death events including multiple oﬃcer deaths, whether black or female oﬃcer was involved and average oﬃcer age and experience are used. All regressions include a vector of covariates at the department-by-year level, department-by-calendar month and year-by-month ﬁxed eﬀects and department-speciﬁc linear time trends. Regressions also include a dummy variable for 12 or more months after the occurrence of an oﬃcer death. Standard errors are clustered at the department level. This ﬁgure uses records of oﬃcer death characteristics from the Oﬃcer Down Memorial Page.

Figure A8: Case Study in Dallas, Texas

Results by Day A. Arrests

### B. Crime

|406080100120140<br><br>-30 -20 -10 0 10 20 30 40 50 60 70 80 Days Relative to Line-of-Duty Ofﬁcer Death<br><br>|Event Year (2018) Year Prior (2017)|
|---|
|
|---|


|500550600650700750<br><br>-30 -20 -10 0 10 20 30 40 50 60 70 80 Days Relative to Line-of-Duty Ofﬁcer Death<br><br>|Event Year (2018) Year Prior (2017)|
|---|
|
|---|


500550600650700750

406080100120140

### Results for Northeast Division C. Arrests

D. Crime

|406080100120140<br><br>-9 -6 -3 0 3 6 9 12 15 Weeks Relative to Line-of-Duty Ofﬁcer Death<br><br>|Event Year (2018) Year Prior (2017)|
|---|
|
|---|


|600650700750800<br><br>-9 -6 -3 0 3 6 9 12 15 Weeks Relative to Line-of-Duty Ofﬁcer Death<br><br>|Event Year (2018) Year Prior (2017)|
|---|
|
|---|


406080100120140

Results for Other Divisions E. Arrests

F. Crime

|200250300350400<br><br>-9 -6 -3 0 3 6 9 12 15 Weeks Relative to Line-of-Duty Ofﬁcer Death<br><br>|Event Year (2018) Year Prior (2017)|
|---|
|
|---|


|32003400360038004000<br><br>-9 -6 -3 0 3 6 9 12 15 Weeks Relative to Line-of-Duty Ofﬁcer Death<br><br>|Event Year (2018) Year Prior (2017)|
|---|
|
|---|


32003400360038004000

##### Notes: This ﬁgure plots outcomes using data from the Dallas Police Department around the date of the shooting of Oﬃcer Rogelio Santander on April 24, 2018 (similar to Figure 9). Panels A and B show the arrest and crime eﬀect at the daily level. Panels C and D show the weekly results for the police division where Oﬃcer Santander worked. Panels E and F show the results for other police divisions in Dallas.

## A2 Google Search Trends Description

Each search term is an exact ﬁrst and last name for the individual. We identify highproﬁle civilian deaths using a list compiled by Black Lives Matter, and identify oﬃcer deaths by linking the FBI LEOKA data we use in this project to records from the Oﬃcer Down Memorial Page to obtain oﬃcer names. Each search is centered around the time period of -1. Further, each search is benchmarked by topical searches for the most common cause of death, heart disease, which is relatively stable in popularity across time and locations within the U.S. Google Trends plots relative search intensity with a maximum search popularity in each search of 100.

## A3 Data Appendix

## A3.1 Data Sources

Law Enforcement Oﬃcers Killed or Assaulted (UCR LEOKA) The FBI’s Law Enforcement Oﬃcers Killed or Assaulted (LEOKA) data set contains detailed information on total oﬃcer employment and oﬃcers that are killed or assaulted in the ﬁeld for each month. We use oﬃcers feloniously killed in the line-of-duty as a measure of oﬃcer deaths and all assaults on sworn oﬃcers whether or not the oﬃcers suﬀered injuries. We utilize the version cleaned and formatted by Jacob Kaplan available from ICPSR (Kaplan, 2020a). This dataset covers the period 2000-2018.

Crime Oﬀense Data (UCR Crime) The Uniform Crime Reporting Program Data: Oﬀenses Known and Clearances By Arrest data set contains oﬀenses reported to law enforcement agencies. The crimes reported are homicide, forcible rape, robbery, aggravated assault, burglary, larceny-theft, and motor vehicle theft for each month. We utilize the version cleaned and formatted by Jacob Kaplan available from ICPSR (Kaplan, 2020b). This dataset covers the period 2000-2018.

Arrest Data (UCR Arrest) The Uniform Crime Reporting Program Data: The Arrests by Age, Sex, and Race data set contains the number of arrests for each crime type by age, sex and race. We use the total arrests and arrest sub-types in our analysis. We utilize the version cleaned and formatted by Jacob Kaplan available from ICPSR (Kaplan, 2020c). This dataset covers the period 2000-2018.

Use-of-Force Data (UCR Supplementary Homicide Reports) The Uniform Crime Reporting Program Data: Supplementary Homicide Reports data set contains the number of homicides. We utilize the version cleaned and formatted by Jacob Kaplan available from ICPSR (Kaplan, 2020d) covering the period 2000-2018. We use the “felons killed by police” circumstance in our analysis after restricting the sample to the agencies with other UCR outcomes. There are 582 agencies with at least one such event. Agency-by-month-level outcome is replaced as zeros when missing if the agency has reported any murder and follow the outlier cleaning method described below.

Use-of-Force Data (Fatal Encounters) Fatal Encounters is a national crowd-sourced database of all deaths through police interaction. We remove suicidal deaths from our analysis and restrict the sample to the agencies with other UCR outcomes. The data set covers the period 2000-2018 and we use 906 agencies with at least one such event.

Traﬃc Stop Data We use the standardized traﬃc stop data from the Stanford Open Policing Project. Each row of the data represents a traﬃc stop that include information on date, location, subject and oﬃcer characteristics and stop characteristics. We collapse the data at city-month level and drop the ﬁrst and last month for each city to account for incomplete months. Each city has diﬀerent period coverage and Pittsburgh, Pennsylvania and Gilbert, Arizona have the longest period (February 2008 to April 2014). We use 25 cities.

Traﬃc Accident Data: Fatality Analysis Reporting System (FARS) We use the Fatality Analysis Reporting System (FARS) of the National Highway Traﬃc Safety Administration (NHTSA) to create measure of traﬃc fatalities and those involving alcohol. The data include information on fatal injuries in a vehicle crashes. We collapse the accident-level data at city-month level to generate counts. For the accidents involving alcohol, we use the number of drunk drivers involved in a crash. This data element is most reliable from 2008 to 2014 when drivers with the blood alcohol concentration (BAC) 0.01 g/dL or greater are counted. Prior to 2008, all individuals involved in accidents are counted. After 2014, the BAC level measure is changed to 0.001 g/dL or greater for counting. The data covers 1,766 cities from 2000 to 2018 for any accidents and 1,561 cities from 2008 to 2014 for accidents involving alcohol.

911 Call Dispatch Data We have hand-collected administrative 911 dispatch call records through submitting open-records requests to cities across the U.S. This study includes 69 cities with dispatch data. The data sets for each city vary in the way that they record calls and must be cleaned in order to harmonize the data across cities. Each data set collected is ﬁrst cleaned to exclude records of interactions that were initiated by oﬃcers rather than a civilian complainant call, which are sometimes included in dispatch data when an oﬃcer reports his location in such an interaction to a dispatcher. These may include records of oﬃcers assisting other oﬃcers in distress, assisting the ﬁre department, or responding to traﬃc violations. We code domestic violence calls using key words included in the 911 call description ﬁeld. High-, medium- and low-severity calls are classiﬁed by utilizing the priority code ranking for calls. Lastly, we calculate the share of calls that result in an oﬃcer writing a crime incident report or “Crime Report Rate (911 Calls)” through examining the outcome or disposition of each call which is coded as a ﬁeld in our data.

Demographic Data (U.S. Census and American Community Survey) We use the 2000 United States Census and the American Community Survey (ACS) 5-year estimates from 2010 to 2018 to provide information on city characteristics. Speciﬁcally, we report each city’s population, share Black, Hispanic and white, share male, the share of femaleheaded household, the share in each age category, the share in each education category, the

unemployment rate, the poverty rate and median household income. We linearly interpolate for years 2001 to 2009.

## A3.2 Sample Restrictions and Identifying Outliers

The UCR data suﬀer from reporting and measurement issues. To alleviate concerns about data quality, we take following procedures to extensively clean the outcomes of interest. First, we restrict our analysis to municipal police departments serving cities with population larger 2,000 residents and to period 2000-2018. Then, we keep departments that consistently report these outcomes after replacing any negative arrest or crime values as missing. Speciﬁcally, we only retain agencies that report crimes monthly each year in the period 2000-2018 (for example, this procedure drops agencies that report annually or biannually).

To clean the potential outliers in the UCR data, we separately regress each arrest and crime outcomes on a cubic polynomial of time for each department. These outcomes are the raw values plus one to account for the large number of zeros in the data. Then, we calculate the percent deviation of the predicted value from the actual value and replace the value as missing when it is greater than the 99.875th percentile or below the 0.125th percentile of these percent deviations within population groups. These population groups are departments serving cities with population size of 2,000-4,999, 5,000-9,999, 10,000-24,999, 25,000-49,999, 50,000-99,999 and 100,000 or higher and are deﬁned using the ﬁrst reported population in the data. Finally, we take same procedure to clean larger group categories of arrest and crime by type. Then, we replace any subgroups of outcomes as missing if the larger group category is identiﬁed as an outlier.

We merge the UCR data together using the originating agency identiﬁers, the Traﬃc Stop, FARS and 911 Calls data using the city name and Census data using the Federal Information Processing Standards (FIPS) Place code.

