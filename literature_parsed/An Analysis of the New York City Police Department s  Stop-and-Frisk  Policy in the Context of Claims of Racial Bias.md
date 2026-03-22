### Journal of the American Statistical Association

ISSN: 0162-1459 (Print) 1537-274X (Online) Journal homepage: www.tandfonline.com/journals/uasa20

## An Analysis of the New York City Police Department's “Stop-and-Frisk” Policy in the Context of Claims of Racial Bias

#### Andrew Gelman, Jeﬀrey Fagan & Alex Kiss

To cite this article: Andrew Gelman, Jeﬀrey Fagan & Alex Kiss (2007) An Analysis of the New York City Police Department's “Stop-and-Frisk” Policy in the Context of Claims of Racial Bias, Journal of the American Statistical Association, 102:479, 813-823, DOI: 10.1198/016214506000001040

To link to this article: https://doi.org/10.1198/016214506000001040

Published online: 01 Jan 2012.

Submit your article to this journal

Article views: 19179

View related articles

Citing articles: 118 View citing articles

Full Terms & Conditions of access and use can be found at https://www.tandfonline.com/action/journalInformation?journalCode=uasa20

# An Analysis of the New York City Police Department’s “Stop-and-Frisk” Policy in the Context of Claims of Racial Bias

##### Andrew GELMAN, Jeffrey FAGAN, and Alex KISS

Recent studies by police departments and researchers conﬁrm that police stop persons of racial and ethnic minority groups more often than whites relative to their proportions in the population. However, it has been argued that stop rates more accurately reﬂect rates of crimes committed by each ethnic group, or that stop rates reﬂect elevated rates in speciﬁc social areas, such as neighborhoods or precincts. Most of the research on stop rates and police–citizen interactions has focused on trafﬁc stops, and analyses of pedestrian stops are rare. In this article we analyze data from 125,000 pedestrian stops by the New York Police Department over a 15-month period. We disaggregate stops by police precinct and compare stop rates by racial and ethnic group, controlling for previous race-speciﬁc arrest rates. We use hierarchical multilevel models to adjust for precinct-level variability, thus directly addressing the question of geographic heterogeneity that arises in the analysis of pedestrian stops. We ﬁnd that persons of African and Hispanic descent were stopped more frequently than whites, even after controlling for precinct variability and race-speciﬁc estimates of crime participation.

KEY WORDS: Criminology; Hierarchical model; Multilevel model; Overdispersed Poisson regression; Police stops; Racial bias.

###### 1. BIAS IN POLICE STOPS?

Police Department (NYPD) during the 1990s has been widely credited as a major source of the city’s sharp crime decline (Zimring 2006).

In the late 1990s, popular, legal, and political concerns were raised across the United States about police harassment of minority groups in their everyday encounters with law enforcement. These concerns focused on the extent to which police were stopping people on the highways for “driving while black” (see Weitzer 2000; Harris 2002; Lundman and Kaufman 2003). Additional concerns were raised about racial bias in pedestrian stops of citizens by police predicated on “zero-tolerance” policies to control quality-of-life crimes and policing strategies concentrated in minority communities that targeted illegal gun possession and drug trafﬁcking (see Fagan, Zimring, and Kim 1998; Greene 1999; Skolnick and Caplovitz 2001; Fagan and Davies 2000, 2003; Fagan 2002; Gould and Mastrofski 2004). These practices prompted angry reactions among minority citizens that widened the breach between different racial/ethnic groups in their trust in the police (Lundman and Kaufman 2003; Tyler and Huo 2003; Weitzer and Tuch 2002), provoking a crisis of legitimacy with legal, moral, and political dimensions (see Wang 2001; Russell 2002; Harris 2002).

But near the end of the decade there were repeated complaints of harassment of minority communities, especially by the elite Street Crimes Unit (Spitzer 1999). These complaints came in the context of the well-publicized assault by police of Abner Louima and the shootings of Amadou Diallo and Patrick Dorismond. Citizen complaints about aggressive “stop and frisk” tactics ultimately provoked civil litigation that alleged racial bias in the patterns of “stop and frisk,” leading to a settlement that regulated the use of this tactic and established extensive monitoring requirements (Kelvin Daniels et al. v. City of New York 2004).

We address this dispute by estimating the extent of racially disparate impacts of what came to be known as the “New York strategy.” We analyze the rates at which New Yorkers of different ethnic groups were stopped by the police on the city streets, to assess the central claim that race-speciﬁc stop rates reﬂect nothing more than race-speciﬁc crime rates. This study is based on work performed with the New York State Attorney General’s Ofﬁce (Spitzer 1999) and reviewed by the U.S. Commission on Civil Rights (2000). Key statistical issues are the baselines used to compare rates (recognized as a problem by Miller 2000; Walker 2001; Smith and Alpert 2002) and local variation in the intensity of policing, as performed by the Street Crimes Unit and implicitly recommended by Wilson and Kelling (1982) and others. We use multilevel modeling (see Raudenbush and Bryk 2002 for an overview and Sampson, Raudenbush, and Earls 1997; Sampson and Raudenbush 1999; Weidner, Frase, and Pardoe 2004 for examples in studies of crime) to adjust for local variation in comparing the rates of police stops of different ethnic groups in New York City.

In an era of declining crime rates, policy debates on policing strategies often pivot on the evaluation of New York City’s policing strategy during the 1990s, a strategy involving aggressive stops and searches of pedestrians for a wide range of crimes (Eck and Maguire 2000; Skogan and Frydl 2004). The policy was based on the lawful practice of “temporarily detaining, questioning, and, at times, searching civilians on the street” (Spitzer 1999). The U.S. Supreme Court has ruled police stopand-frisk procedures to be constitutional under certain restrictions (Terry v. Ohio 1968). The approach of the New York City

Andrew Gelman is Professor, Department of Statistics and Department of Political Science, Columbia University, New York, NY 10027 (E-mail: gelman@stat.columbia.edu). Jeffrey Fagan is Professor, Law School and School of Public Health, Columbia University, New York, NY 10027 (E-mail: jfagan@law.columbia.edu). Alex Kiss is Biostatistician, Department of Research Design and Biostatistics, Sunnybrook and Women’s College Health Sciences Center, Toronto, Ontario, Canada. The authors thank the New York City Police Department, the New York State Division of Criminal Justice Services, and the Ofﬁce of the New York State Attorney General for providing data for this research. Tamara Dumanovsky and Dong Xu made signiﬁcant contributions to the analysis. Joe Bafumi, Rajeev Dehejia, Jim Liebman, Dan Rabinowitz, Caroline Rosenthal Gelman, and several reviewers provided helpful comments. Support for this research was provided in part by National Science Foundation grants SES-9987748 and SES-0318115. All opinions are those of the authors.

Were the police disproportionately stopping ethnic minorities? We address this question in several different ways using data on police stops and conclude that members of minority groups were stopped more often than whites, both in comparison to their overall population and to the estimated rates of

© 2007 American Statistical Association

Journal of the American Statistical Association September 2007, Vol. 102, No. 479, Applications and Case Studies

DOI 10.1198/016214506000001040 813

crime that they have committed. We do not necessarily conclude that the NYPD engaged in discriminatory practices, however. The summary statistics that we study here cannot directly address questions of harassment or discrimination, but rather reveal statistical patterns that are relevant to these questions.

Because this is a controversial topic that has been studied in various ways, we go into some detail in Sections 2 and 3 on the historical background and available data. We present our models and results in Sections 4 and 5, and provide some discussion in Section 6.

###### 2. BACKGROUND 2.1 Race, Neighborhoods, and Police Stops

Nearly a century of legal and social trends has set the stage for the current debate on race and policing. Historically, close surveillance by police has been a part of everyday life for African-Americans and other minority groups (see, e.g., Musto 1973; Kennedy 1997). More recently, in Whren et al. v. U.S. (1996), the U.S. Supreme Court allowed the use of race as a basis for a police stop as long as there were other factors motivating the stop. In Brown v. Oneonta (2000), a federal district court permitted the use of race as a search criterion if there was an explicit racial description of the suspect.

The legal standard for police conduct in citizen stops derives from Terry v. Ohio (1968), which involved a pedestrian stop that set the parameters of the “reasonable suspicion” standard for police conduct in detaining citizens for search or arrest. Recently, the courts have expanded the concept of “reasonable suspicion” to include location as well as behavior. For example, the U.S. Supreme Court, in Illinois v. Wardlow (2000), noted that although a person’s presence in a “high-crime area” does not meet the standard for a particularized suspicion of criminal activity, a location’s characteristics are relevant to determining whether a behavior is sufﬁciently suspicious to warrant further investigation. Because “high-crime areas” often have high concentrations of minority citizens (Massey and Denton 1993), this logic places minority neighborhoods at risk for elevating the suspiciousness of their residents.

Early studies suggested that both the racial characteristics of the suspect and the racial composition of the suspect’s neighborhood inﬂuence police decisions to stop, search, or arrest a suspect (Bittner 1970; Reiss 1971). Particularly in urban areas, suspect race interacts with neighborhood characteristics to animate the formation of suspicion among police ofﬁcers (Thompson 1999; Smith, Makarios, and Alpert 2006). Alpert, MacDonald, and Dunham (2005) found that police are more likely to view a minority citizen as suspicious—leading to a police stop—based on nonbehavioral cues, while more often relying on behavioral cues to develop suspicion for white citizens.

But police also may substitute racial characteristics of communities for racial characteristics of individuals in their cognitive schema of suspicion, resulting in elevated stop rates in neighborhoods with high concentrations of minorities. For example, in a study of policing in three cities, Smith (1986) showed that suspects in poor neighborhoods were more likely to be arrested, in an analysis controlling for suspect behavior and type of crime. The suspect’s race and the racial composition of the suspect’s neighborhood were also signiﬁcant predictors of police response. Coercive police responses may relate

to the perception that poor neighborhoods may have limited capacity for social control and self-regulation. This strategy was formalized in the inﬂuential “broken windows” essay of Wilson and Kelling (1982), who argued that police responses to disorder were critical to communicate intolerance for crime and to halt its contagious spread. Others have disputed this claim, however (see Harcourt 1998, 2001; Sampson and Raudenbush 1999; Taylor 2000), arguing that race is often used as a substitute for neighborhood conditions as a marker of suspicion by police.

Police have defended racially disparate patterns of stops on the grounds that minorities commit disproportionately more crimes than whites (especially the types of crimes that capture the attention of police), and that the spatial concentration and disparate impacts of crimes committed by and against minorities justiﬁes more aggressive enforcement in minority communities (MacDonald 2001). Police cite such differences in crime rates to justify racial imbalances even in situations where they have a wide range of possible targets or where suspicion of criminal activity would not otherwise justify a stop or search (Kennedy 1997; Harcourt 2001; Rudovsky 2001). Using this logic, police claim that the higher stop rates of AfricanAmericans and other minorities simply represent reasonable and efﬁcient police practice (see, e.g., Bratton and Knobler 1998; Goldberg 1999). Police often point to the high rates of seizures of contraband, weapons, and fugitives in such stops, and also to a reduction of crime, to justify such aggressive policing (Kelling and Cole 1996).

Whether racially disparate stop rates reﬂect disproportionate crime rates or intentional, racially biased targeting by police of minorities at rates beyond what any racial differences in crime rates might justify lies at the heart of the social and legal controversy on racial proﬁling and racial discrimination by police (Fagan 2002; Ayres 2002a; Harris 2002). This controversy has been the focus of public and private litigation (Rudovsky 2001), political mobilization, and self-scrutiny by several police departments (see Garrett 2001; Walker 2001; Skolnick and Caplovitz 2001; Gross and Livingston 2002).

###### 2.2 Approaches to Studying Data on Police Stops

Recent evidence supports perceptions among minority citizens that police disproportionately stop African-American and Hispanic motorists, and that once stopped, these citizens are more likely to be searched or arrested (Cole 1999; Veneiro and Zoubeck 1999; Harris 1999; Zingraff et al. 2000; Gross and Barnes 2002). For example, two surveys with nationwide probability samples, completed in 1999 and in 2002, showed that African-Americans were far more likely than others to report being stopped on the highways by police (Langan, Greenfeld, Smith, Durose, and Levin 2001; Durose, Schmitt, and Langan 2005). Both surveys showed that minority drivers also were more likely to report being ticketed, arrested, handcuffed, or searched by police, and that they more often were threatened with force or had force used against them. These disparities exact social costs that, according to Loury (2002), animate culturally meaningful forms of stigma that reinforce racial inequalities, especially in the practice of law enforcement.

“Suspicious behavior” is the spark for both pedestrian and trafﬁc stops (Alpert et al. 2005). Pedestrian stops are at the

very core of policing, used to enforce narcotics and weapons laws, to identify fugitives or other persons for whom warrants may be outstanding, to investigate reported crimes and “suspicious” behavior, and to improve community quality of life. For the NYPD, a “stop” intervention provides an occasion for the police to have contact with persons presumably involved in low-level criminality without having to effect a formal arrest, and under the lower constitutional standard of “reasonable suspicion” (Spitzer 1999). Indeed, because low-level “quality of life” and misdemeanor offenses were more likely to be committed in the open, the “reasonable suspicion” standard is more easily satisﬁed in these sorts of crimes (Rudovsky 2001).

However, in pedestrian and trafﬁc violations, the range of suspicious behaviors in neighborhood policing is sufﬁciently broad to challenge efforts to identify an appropriate baseline against which to compare race-speciﬁc stop rates (see Miller 2000; Smith and Alpert 2002; Gould and Mastrofski 2004). Accordingly, attributing bias is difﬁcult; causal claims about discrimination would require far more information about such baselines than the typical administrative (observational) datasets can supply. Research in situ that relies on direct observation of police behavior (e.g., Gould and Mastrofski 2004; Alpert et al. 2005) requires ofﬁcers to articulate the reasons for their actions, a task that is vulnerable to numerous validity threats. Instead, reliable evidence of ethnic bias would require experimental designs that control for other factors so as to isolate differences in outcomes that could only be attributed to race or ethnicity. Such experiments are routinely used in tests of discrimination in housing and employment (see, e.g., Pager 2003). But observational studies that lack such controls are often embarrassed by omitted variable biases; few studies can control for all of the variables that police consider in deciding whether to stop or search someone.

Another approach to studying racial disparities bypasses the question of whether police intend to discriminate on the basis of ethnicity or race and instead focuses on disparate impacts of police stop strategies. In this approach, comparisons of “hit rates,” or efﬁciencies in the proportion of stops that yield positive results, serve as evidence of disparate impacts of police stops. This approach can show when the racial disproportionality of a particular policy or decision making outcome is not justiﬁed by heightened institutional productivity. In the context of proﬁling, outcome tests assume that the ex post probability that a police search will uncover drugs or other contraband is a function of the degree of probable cause that police use in deciding to stop and search a suspect (Ayres 2002a). A ﬁnding that searches of minorities are less productive than searches of whites could be evidence that police have a lower threshold of probable cause when searching minorities. At the very least, it is a sign of differential treatment of minorities that in turn produces a disparate impact.

Knowles, Persico, and Todd (2001) considered this “hit rate” approach theoretically as well as empirically in a study ﬁnding that of the drivers on I-95 in Maryland stopped by police on suspicion of drug trafﬁcking, African-Americans were as likely as whites to have drugs in their cars. The accompanying theoretical analysis posits a dynamic process that considers the behaviors of both police and citizens of different races and integrates their decisions in an equilibrium where police calibrate their

behavior to the probabilities of detecting illegal behavior and citizens in different racial groups adjust their propensities to accommodate the likelihood of detection. They concluded that the search for drugs was an efﬁcient allocation of police resources, despite the disparate impacts of these stops on minority citizens (Lamberth 1997; Ayres 2002a,b; Gross and Barnes 2002).

However, this analysis omits several factors that might bias these claims, such as racial differences in the attributes that police consider when deciding which motorists to stop, search, or arrest (see, e.g., Alpert et al. 2005; Smith et al. 2006). Moreover, the randomizing equilibrium assumptions in the approach of Persico et al.—that both police and potential offenders adjust their behavior in response to the joint probabilities of carrying contraband and being stopped—tend to average across heterogeneous conditions both in police decision making and in offenders’ propensities to crime (Dharmapala and Ross 2004), and discount the effects of race-speciﬁc sensitivities toward crime decisions under varying conditions of detection risk by police stop (Dominitz and Knowles 2005). Addressing these two concerns, Dharmapala and Ross (2004) identiﬁed different equilibria that lead to different conclusions about racial prejudice in police stops and searches.

We consider hit rates brieﬂy (see Sec. 5.3), but our main analysis attempts to resolve these supply-side or omittedvariable problems by controlling for race-speciﬁc rates of the targeted behaviors in patrolled areas, assessing whether stop and search rates exceed what we would predict from knowledge of the crime rates of different racial groups. This approach indexes stop behavior to observables about the probability of crime or guilt among different racial groups. Moreover, by disaggregating data across neighborhoods, our probability estimates explicitly incorporate the externalities of neighborhood and race that historically have been observed in policing (Skogan and Frydl 2004). This approach requires estimates of the supply of individuals engaged in the targeted behaviors (see Miller 2000; Fagan and Davies 2000; Walker 2001; Smith and Alpert 2002).

To be sure, a ﬁnding that police are stopping and searching minorities at a higher rate than is justiﬁed by their participation in crime does not require inferring that police engaged in disparate treatment at a minimum, however, it does provide evidence that whatever criteria the police used produced an unjustiﬁed disparate impact.

###### 3. DATA 3.1 “Stop and Frisk” in New York City

The NYPD has a policy of keeping records on stops (on “UF-250 Forms”). This information was collated for all stops (about 175,000 in total) from January 1998 through March 1999 (Spitzer 1999). The police are not required to ﬁll out a form for every stop. Rather, there are certain conditions under which the police are required to ﬁll out the form. These “mandated stops” represent 72% of the stops recorded, with the remaining reports being of stops for which reporting was optional. To address concerns about possible selection bias in the nonmandated stops, we repeated our main analyses (shown in Fig. 2) for the mandated stops only; the total rates of stops changed, but the relative rates for different ethnic groups remained essentially unchanged.

The UF-250 form has a place for the police ofﬁcer to record the “Factors which caused ofﬁcer to reasonably suspect person stopped (include information from third persons and their identity, if known).” We examined these forms and the reasons for the stops for a citywide sample of 5,000 cases, along with 10,869 others, representing 50% of the cases in a nonrandom sample of 8 of the 75 police precincts, chosen to represent a spectrum of racial population characteristics, crime problems, and stop rates, guided by the policy questions in the original study (Spitzer 1999, p. 158). The following examples (from Spitzer 1999) illustrate the rules that motivated police decisions to stop suspects and demonstrate the social and behavioral factors that police apply in the process of forming reasonable suspicion:

- • “At TPO [time and place of occurrence] male was with person who ﬁt description of person wanted for GLA [grand larceny auto] in 072 pct. log ...upon approach male discarded small coin roller which contained 5 bags of alleged crack.”
- • “At T/P/O R/O [reporting ofﬁcer] did observe below named person along w/3 others looking into numerous parked vehicles. R/O did maintain surveillance on individuals for approx. 20 min. Subjects subsequently stopped to questioned [sic] w/ neg results.”
- • “Slashing occurred at Canal street; person ﬁt description; person was running.”
- • “Several men getting in and out of a vehicle several times.”
- • “Def. Did have on a large bubble coat with a bulge in right pocket.”
- • “Person stopped did stop [sic] walking and reverse direction upon seeing police. Attempted to enter store as police approached; Frisked for safety.”


Based on federal and state law, some of these reasons for stopping a person are constitutional and some are not. For example, courts have ruled that a bulge in the pocket is not sufﬁcient reason for the police to stop a person without his or her consent (People v. DeBour 1976; People v. Holmes 1996), and that walking away from the police is not a sufﬁcient cause to stop and frisk a person (Brown v. Texas 1979; but see Illinois v. Wardlow 2000). However, when the police observe illegal activity, weapons (including “waistband bulges”), a person who ﬁts a description, or suspicious behavior in a crime area, then stops and frisks have been ruled constitutional (Spitzer 1999).

The New York State Attorney General’s ofﬁce used rules such as these to characterize the rationales for 61% of the stops in the sample as articulating a “reasonable suspicion” that would justify a lawful stop, 15% of the stops as not articulating a reasonable suspicion, and 24% as providing insufﬁcient information on which to base a decision. For the controversial Street Crimes Unit, 23% of stops were judged to not articulate a reasonable suspicion. (There was no strong pattern by ethnicity here; the rate of stops judged to be unreasonable was about the same for all ethnic groups.) The stops judged to be without “reasonable suspicion” indeed seemed to be weaker, in that only 1 in 29 of these stops led to arrests, compared with 1 in 7 of the stops with reasonable suspicion.

###### 3.2 Aggregate Rates of Stops for Each Ethnic Group

With this as background, we analyze the entire stop-andfrisk dataset to see to what extent different ethnic groups were stopped by the police. We focus on blacks (AfricanAmericans), Hispanics (Latinos), and whites (EuropeanAmericans). The categories are as recorded by the police making the stops. We exclude members of other ethnic groups (approximately 4% of the stops) because of the likelihood of ambiguities in classiﬁcations. With such a low frequency of “other,” even a small rate of misclassiﬁcation can cause large distortions in the estimates for that group. For example, if only 4% of blacks, Hispanics, and whites were mistakenly labeled as “other,” this would nearly double the estimates for the “other” category while having very little effects on the three major groups. (See Hemenway 1997 for an extended discussion of the problems that misclassiﬁcations can cause in estimates of a small fraction of the population.) To give a sense of the data, Figure 1 displays the number of stops for blacks, Hispanics, and whites over the 15-month period, separately showing stops associated with each of four types of offenses (“suspected charges” as characterized on the UF-250 form): violent crimes, weapons offenses, property crimes, and drug crimes.

In total, blacks and Hispanics represented 51% and 33% of the stops, despite being only 26% and 24%, of the city population based on the 1990 Census. The proportions change little if we use 1998 population estimates and count only males age 15–30, which is arguably a better baseline. For one of our supplementary analyses, we also use the population for each ethnic group within each precinct in the city. Population estimates for the police precincts with low residential populations but high daytime populations due to commercial and business activity were adjusted using the U.S. Census Bureau “journey ﬁle,” provided by the New York City Department of City Planning (see Spitzer 1999, app. I, table 1.A.1a). The journey ﬁle uses algorithms based on time traveled to work and the distribution of job classiﬁcations to estimate the day and night populations of census tracts. Tracts were aggregated to their corresponding police precinct to construct day and night population estimates, and separate stop estimates were computed for daytime and nighttime intervals. For these analyses, we aggregated separate estimates of stops by day and night to compute total stop rates for each precinct.

Perhaps a more relevant comparison, however, is to the number of crimes committed by members of each ethnic group. For example, then New York City Police Commissioner Howard Saﬁr stated (Saﬁr 1999),

The racial/ethnic distribution of the subjects of “stop and frisk” reports reﬂects the demographics of known violent crime suspects as reported by crime victims. Similarly, the demographics of arrestees in violent crimes also correspond with the demographics of known violent crime suspects.

Data on actual crimes are not available, of course, so as a proxy we use the number of arrests within New York City in the previous year, 1997, as recorded by the Division of Criminal Justice Services (DCJS) of New York State and categorized by ethnic group and crime type. This was deemed to be the best available measure of local crime rates categorized by ethnicity and directly address concerns such as Saﬁr’s that stop rates be related to the ethnicity of crime suspects. We use the previous year’s DCJS arrest rates to represent the frequency of

Figure 1. Number of police stops in each of 15 months, characterized by type of crime and ethnicity of person stopped (—–, blacks; − − −−, Hispanics; ······, whites).

crimes that the police might suspect were committed by members of each ethnic group. When compared in that way, the ratio of stops to DCJS arrests was 1.24 for whites, 1.54 for blacks, and 1.72 for Hispanics; based on this comparison, blacks are stopped 23% more often than whites and Hispanics are stopped 39% more often than whites.

###### 4. MODELS

The summaries given so far describe average rates for the whole city. But suppose that the police make more stops in high-crime areas but treat the different ethnic groups equally within any locality. Then the citywide ratios could show signiﬁcant differences between ethnic groups even if stops were determined entirely by location rather than by ethnicity. To separate these two kinds of predictors, we performed multilevel analyses using the city’s 75 precincts. Allowing precinct-level effects is consistent with theories of policing such as “broken windows” that emphasize local, neighborhood-level strategies (Wilson and Kelling 1982; Skogan 1990). Because it is possible that the patterns are systematically different in neighborhoods with different ethnic compositions, we divided the precincts into three categories in terms of their black population: precincts that were less than 10% black, 10–40% black, and more than 40% black. We also accounted for variation in stop rates between the precincts within each group. Each of the three categories represents roughly 1/3 of the precincts in the city, and we performed separate analyses for each set.

###### 4.1 Hierarchical Poisson Regression Model

For each ethnic group e = 1,2,3 and precinct p, we modeled the number of stops, yep, using an overdispersed Poisson re-

gression with indicators for ethnic groups, a hierarchical model for precincts, and nep, the number of DCJS arrests for that ethnic group in that precinct (multiplied by 15/12 to scale to a 15-month period), as a baseline or offset,

15 12

nepeμ+αe+βp+ ep ,

yep ∼ Poisson

βp ∼ N(0,σβ2), (1) ep ∼ N(0,σ2),

where the coefﬁcients αe (which we constrained to sum to 0) control for ethnic groups, the βp’s adjust for variation among precincts (with variance σβ), and the ep’s allow for overdispersion, that is, variation in the data beyond that explained by the Poisson model. We ﬁt the model using Bayesian inference with a noninformative uniform prior distribution on the parameters μ, α, σβ, and σ .

In classical generalized linear modeling or generalized estimating equations, overdispersion can be estimated using a chisquared statistic, with standard errors inﬂated by the square root of the estimated overdispersion (McCullagh and Nelder 1989). In our analysis, we are already using Bayesian inference to model the variation among precincts, and so the overdispersion simply represents another variance component in the model; the resulting inferences indeed have larger standard errors than would be obtained from the nonoverdispersed regression (which would correspond to σ = 0), and these posterior standard errors can be checked using, for example, cross-validation of precincts.

Of most interest, however, are the exponentiated coefﬁcients exp(αe), which represent relative rates of stops compared with

arrests, after controlling for precinct. By comparing stop rates to arrest rates, we can also separately analyze stops associated with different types of crimes. We conducted separate comparisons for violent crimes, weapons offenses, property crimes, and drug crimes. For each, we modeled the number of stops yep by ethnic group e and precinct p for that crime type, using as a baseline the DCJS arrest count nep for that ethnic group, precinct, and crime type. (The subsetting by crime type is implicit in this notation; to keep notation simple, we did not introduce an additional subscript for the four categories of crime.)

We thus estimated model (1) for 12 separate subsets of the data, corresponding to the four crime types and the three categories of precincts (<10% black population, 10–40% black, and >40% black). Computations were easily performed using the Bayesian software BUGS (Spiegelhalter, Thomas, Best, Gilks, and Lunn 1994, 2003), which implements Markov chain Monte Carlo simulation from R (R Project 2000; Sturtz, Ligges, and Gelman 2005). For each ﬁt, we simulated three several independent Markov chains from different starting points, stopping when the simulations from each chain alone were as variable as those from all of the chains mixed together (Gelman and Rubin 1992). We then gathered the last half of the simulated chains and used these to compute posterior estimates and standard errors. For the analyses reported in this article, 10,000 iterations were always sufﬁcient for mixing of the sequences. We report inferences using posterior means and standard deviations, which are reasonable summaries given the large sample size (see, e.g., Gelman, Carlin, Stern, and Rubin 2003, chap. 4).

###### 4.2 Alternative Model Speciﬁcations

In addition to ﬁtting model (1) as described earlier, we consider two forms of alternative speciﬁcations: ﬁrst, ﬁtting the same model but changing the batching of precincts, and second, altering the role played in the model by the previous year’s arrests. We compare the ﬁts under these alternative models to assess sensitivity to details of model speciﬁcation.

Modeling Variability Across Precincts. The batching of precincts into three categories is convenient and makes sense, because neighborhoods with different levels of minority populations differ in many ways, including policing strategies applied to each type (Fagan and Davies 2000). Thus, ﬁtting the model separately to each group of precincts is a way to include contextual effects. However, there is an arbitrariness to this division. We explore this by partitioning the precincts into different numbers of categories and seeing how the model estimates change.

Another approach to controlling for systematic variation among precincts is to include precinct-level predictors, which can be included along with the individual precinct-level effects in the multilevel model (see, e.g., Raudenbush and Bryk 2002). As discussed earlier, the precinct-level information that is of greatest interest and also has the greatest potential to affect our results, is the ethnic breakdown of the population. Thus we consider as regression predictors the proportion of black and Hispanic in the precinct, replacing model (1) by

yep ∼ Poisson

15 12

nepeμ+αe+ζ1z1p+ζ2z2p+βp+ ep , (2)

where z1p and z2p represent the proportion of the population in precinct p that are black and Hispanic. We also consider vari-

ants of model (2) including the quadratic terms, z21p, z22p, and z1pz2p, to examine sensitivity to nonlinearity.

Modeling the Relation of Stops to Previous Year’s Arrests. We also consider different ways of using the number of DCJS arrests nep in the previous year, which plays the role of a baseline (or offset, in generalized linear models terminology) in model (1). Including the past arrest rate as an offset makes sense because we are interested in the rate of stops per crime, and we are using past arrests as a proxy for crime rate and for police expectations about the demographics of perpetrators. Another option is to include the logarithm of the number of past arrests as a linear predictor instead,

yep ∼ Poisson

15 12

eγ lognep+μ+αe+βp+ ep . (3)

Model (3) reduces to the offset model (1) if γ = 1. We thus can ﬁt (3) and see whether the inferences for αe change compared with the earlier model that implicitly ﬁxes γ to 1.

We can take this idea further by modeling past arrests as a proxy of the actual crime rate. We attempt to do this in two ways, is each approach labeling the true crime rate for each ethnicity in each precinct as θep, with separate hierarchical Poisson regressions for this year’s stops and last year’s arrests (as always, including the factor 1512 to account for our 15 months of stop data). In the ﬁrst formulation, we model last year’s arrests as Poisson distributed with mean θ,

15 12

θepeμ+αe+βp+ ep ,

yep ∼ Poisson

nep ∼ Poisson(θep), (4) logθep = logNep + ˜αe + β˜p + ˜ep.

Here we are using Nep, the population of ethnic group e in precinct p, as a baseline for the model of crime frequencies. The second-level error terms β˜ and ˜ are given normal hyperprior distributions as for model (1).

Our second two-stage model is similar to (4) but with the new error term ˜ moved to the model for nep,

15 12

θepeμ+αe+βp+ ep ,

yep ∼ Poisson

nep ∼ Poisson(θepe˜ep), (5) logθep = logNep + ˜αe + β˜p.

Under this model, arrest rates nep are equal to the underlying crime rates, θep, on average, but with overdispersion compared with the Poisson error distribution.

###### 5. RESULTS 5.1 Primary Regression Analysis

Table 1 shows the estimates from model (1) ﬁt to each of four crime types in each of three categories of precinct. The randomeffects standard deviations σβ and σ are substantial, indicating the relevance of hierarchical modeling for these data. [Recall that these effects are all on the logarithmic scale, so that an

Table 1. Estimates and standard errors for the constant term μ, ethnicity parameters αe, and the precinct-level and precinct-by-ethnicity–level variance parameters σβ and σ , for the hierarchical Poisson regression model (1), ﬁt separately to three categories of precinct and four crime types

Crime type Parameter Violent Weapons Property Drug

Proportion black in precinct

<10% Intercept −.85(.07) .13(.07) −.58(.21) −1.62(.16)

- α1 [blacks] .40(.06) .16(.05) −.32(.06) −.08(.09)
- α2 [Hispanics] .13(.06) .12(.04) .32(.06) .17(.10)
- α3 [whites] .53(.06) .28(.05) .00(.06) .08(.09) σβ .33(.08) .38(.08) 1.19(.20) .87(.16) σ .30(.04) .23(.04) .32(.04) .50(.07)


10–40% Intercept −.97(.07) .42(.07) −.89(.16) −1.87(.13)

- α1 [blacks] .38(.04) .24(.04) −.16(.06) −.05(.05)
- α2 [Hispanics] .08(.04) .13(.04) .25(.06) .12(.06)
- α3 [whites] −.46(.04) −.36(.04) −.08(.06) −.07(.05) σβ .49(.07) .47(.07) 1.21(.17) .90(.13) σ .24(.03) .24(.03) .38(.04) .32(.04)


>40% Intercept −1.58(.10) .29(.11) −1.15(.19) −2.62(.12)

- α1 [blacks] .44(.06) .30(.07) −.03(.07) .09(.06)
- α2 [Hispanics] .11(.06) .14(.07) .04(.07) .09(.07)
- α3 [whites] .55(.08) .44(.08) .01(.07) .18(.09) σβ .48(.10) .47(.11) .96(.18) .54(.11) σ .24(.05) .37(.05) .42(.07) .28(.06)


NOTE: The estimates of eμ+αe are displayed graphically in Figure 2, and alternative model speciﬁcations are shown in Table 3.

Figure 2. Estimated rates eμ+αe at which people of different ethnic groups were stopped for different categories of crime, as estimated from hierarchical regressions (1) using previous year’s arrests as a baseline and controlling for differences between precincts. Separate analyses were done for the precincts that had <10%, 10–40%, and >40% black population. For the most common stops—violent crimes and weapons offenses—blacks and Hispanics were stopped about twice as often as whites. Rates are plotted on a logarithmic scale. Numerical estimates and standard errors are given in Table 1.

effect of .3, for example, corresponds to a multiplicative effect of exp(.3) = 1.35, or a 35% increase in the probability of being stopped.]

The parameters of most interest are the rates of stops (compared with previous year’s arrests) for each ethnic group, eμ αe, for e = 1,2,3. We display these graphically in Figure 2. Stops for violent crimes and weapons offenses were the most controversial aspect of the stop-and-frisk policy (and represent more than two-thirds of the stops), but for completeness we display all four categories of crime here.

Figure 2 shows that for the most frequent categories of stops—those associated with violent crimes and weapons offenses—blacks and Hispanics were much more likely to be stopped than whites, in all categories of precincts. For violent crimes, blacks and Hispanics were stopped 2.5 times and 1.9 times as often as whites, and for weapons crimes, blacks and Hispanics were stopped 1.8 times and 1.6 times as often as whites. In the less common categories of stops, whites were slightly more often stopped for property crimes and more often stopped for drug crimes in proportion to their previous year’s arrests in any given precinct.

###### 5.2 Alternative Forms of the Model

Fitting the alternative models described in Section 4.2 yielded results similar to those of our main analysis. We discuss each alternative model in turn.

Figure 3 displays the estimated rates of stops for violent crimes compared with the previous year’s arrests for each of the three ethnic groups, for analyses dividing the precincts into 5, 10, and 15 categories ordered by the percentage of black population in the precinct. For simplicity, we give results only for violent crimes; these are typical of the alternative analyses for all four crime types. For each of the three graphs in Figure 3, the model is estimated separately for each of the three groups of precincts, and these estimates are connected in a line for each ethnic group. Compared with the upper-left plot in Figure 2, which shows the results from dividing the precincts into three categories, we see that dividing into more groups adds noise to the estimation but does not change the overall pattern of differences among the groups.

Table 2 shows the results from model (2), which is ﬁt to all 75 precincts but controls for the proportions of blacks and

Hispanics in precincts. The inferences are similar to those obtained from the main analysis discussed in Section 5.1. Including quadratic terms and interactions in the precinct-level model (2) and including the precinct-level predictors in the models ﬁt to each of the three subsets of the data also had little effect on the parameters of interest, αe.

Table 3 displays parameter estimates from the models that differently incorporate the previous year’s arrest rates nep. For conciseness, results are displayed only for violent crimes, and for simplicity we include all 75 precincts in the models. (Similar results were obtained when ﬁtting the model separately in each of three categories of precincts and for the other crime types.) The ﬁrst two columns of Table 3 shows the result from our main model (1) and the alternative model (3), which includes lognep as a regression predictor. The two models differ only in that the ﬁrst restricts γ to be 1, but as we can see, γ is estimated very close to 1 in the regression formulation, and the coefﬁcients αe remain essentially unchanged. (The intercept changes a bit because lognep does not have a mean of 0.)

The last two columns in Table 3 show the estimates from the two-stage regression models (4) and (5). The models differ in their estimates of the variance parameters σβ and σ , but the estimates of the key parameters αe are essentially the same in the original model.

We also performed analyses including indicators for the month of arrest. These analyses did not add anything informative to the comparison of ethnic groups.

###### 5.3 Hit Rates: Proportions of Stops That Led to Arrests

A different way to compare ethnic groups is to look at the fraction of stops on the street that lead to arrests. Most stops do not lead to arrests, and most arrests do not come from stops. In the analysis described earlier, we studied the rate at which the police stopped people of different groups. Now we look brieﬂy at what happens with these stops.

In the period for which we have data, 1 in 7.9 whites stopped were arrested, compared with approximately 1 in 8.8 Hispanics and 1 in 9.5 blacks. These data are consistent with our general conclusion that the police are disproportionately stopping minorities; the stops of whites are more “efﬁcient” and are more likely to lead to arrests, whereas those for blacks and Hispanics are more indiscriminate, and fewer of the persons stopped in

Figure 3. Estimated rates eμ+αe at which people of different ethnic groups were stopped for violent crimes, as estimated from models dividing precincts into 5, 10, and 15 categories. For each graph, the top, middle, and lower lines correspond to blacks, Hispanics, and whites. These plots show the same general patterns as the model with three categories (the upper-left graph in Fig. 2) but with increasing levels of noise.

Table 2. Estimates and standard errors for the parameters of model (2) that includes proportion black and Hispanic as precinct-level predictors, ﬁt to all 75 precincts

Crime type Parameter Violent Weapons Property Drug Intercept −.66(.08) .08(.11) −.14(.24) −.98(.17)

- α1 [blacks] .41(.03) .24(.03) −.19(.04) −.02(.04)
- α2 [Hispanics] .10(.03) .12(.03) .23(.04) .15(.04)
- α3 [whites] −.51(.03) −.36(.03) −.05(.04) −.13(.04)


- ζ1 [coeff. for prop. black] −1.22(.18) .10(.19) −1.11(.45) −1.71(.31)
- ζ2 [coeff. for prop. Hispanic] −.33(.23) .71(.27) −1.50(.57) −1.89(.41)


σβ .40(.04) .43(.04) 1.04(.09) .68(.06) σ .25(.02) .27(.02) .37(.03) .37(.03)

NOTE: The results for the parameters of interest, αe, are similar to those obtained by ﬁtting the basic model separately to each of three categories of precincts, as displayed in Table 1 and Figure 2. As before, the model is ﬁt separately to the data from four different crime types.

these broader sweeps are actually arrested. It is perfectly reasonable for the police to make many stops that do not lead to arrests; the issue here is the comparison between ethnic groups.

This can also be understood in terms of simple economic theory (following the reasoning of Knowles, Persico, and Todd 2001 for police stops for suspected drugs). It is reasonable to suppose a diminishing return for stops in the sense that at some point, little beneﬁt will be gained by stopping additional people. If the gain is approximately summarized by arrests, then diminishing returns mean that the probability that a stop will lead to an arrest—in economic terms, the marginal gain from stopping one more person—will decrease as the number of persons stopped increases. The stops of blacks and Hispanics were less “efﬁcient” than those of whites, suggesting that the police have been using less rigorous standards when stopping members of minority groups. We found similar results when separately analyzing daytime and nighttime stops.

But this “hit rate” analysis can be criticized as unfair to the police, who are “damned if they do, damned if they don’t.” Relatively few of the stops of minorities led to arrests, and thus we conclude that police were more willing to stop minority group members with less reason. But we could also make the argument the other way around: Because a relatively high rate of whites stopped were arrested, we conclude that the police are biased against whites in the sense of arresting them too often. Analyses that examined the validity of arrests by race—that is,

the proportion of arrests that lead to convictions—would help clarify this question. Unfortunately, such data are not readily available. We do not believe this latter interpretation, but it is hard to rule it out based on these data alone.

That is why we consider this part of the study to provide only supporting evidence. Our main analysis found that blacks and Hispanics were stopped disproportionately often (compared with their population or their crime rate, as measured by their rate of valid arrests in the previous year), and the secondary analysis of the hit rates or “arrest efﬁciency” of these stops is consistent with that ﬁnding.

###### 6. DISCUSSION AND CONCLUSIONS

In the period for which we had data, the NYPD’s records indicate that they were stopping blacks and Hispanics more often than whites, in comparison to both the populations of these groups and the best estimates of the rate of crimes committed by each group. After controlling for precincts, this pattern still holds. More speciﬁcally, for violent crimes and weapons offenses, blacks and Hispanics are stopped about twice as often as whites. In contrast, for the less common stops for property and drug crimes, whites and Hispanics are stopped more often than blacks, in comparison to the arrest rate for each ethnic group.

A related piece of evidence is that stops of blacks and Hispanics were less likely than those of whites to lead to arrest,

Table 3. Estimates and standard errors for parameters under model (1) and three alternative speciﬁcations for the previous year’s arrests nep: treating log(nep) as a predictor in the Poisson regression model (3), and the two-stage models (4) and (5)

Model for previous year’s arrests Parameter Offset (1) Regression (3) Two-stage (5) Two-stage (4) Intercept −1.08(.06) −.94(.16) −1.07(.06) −1.13(.07)

- α1 [blacks] .40(.03) .41(.03) .40(.03) .42(.08)
- α2 [Hispanics] .10(.03) .10(.03) .10(.03) .14(.09)
- α3 [whites] −.50(.03) −.51(.03) −.50(.03) −.56(.09) γ [coeff. for lognep] .97(.03)


σβ .51(.05) .51(.05) .51(.05) .27(.12) σ .26(.02) .26(.02) .24(.02) .67(.04)

NOTE: For simplicity, results are displayed for violent crimes only, for the model ﬁt to all 75 precincts. The three αe parameters are nearly identical under all four models, with the speciﬁcation affecting only the intercept.

suggesting that the standards were more relaxed for stopping minority group members. Two different scenarios might explain the lower “hit rates” for nonwhites, one that suggests targeting of minorities and another that suggests dynamics of racial stereotyping and a more passive form of racial preference. In the ﬁrst scenario, police possibly used wider discretion and more relaxed constitutional standards in deciding to stop minority citizens. This explanation would conform to the scenario of “pretextual” stops discussed in several recent studies of motor vehicle stops (e.g., Lundman and Kaufman 2003) and suggests that the higher stop rates were intentional and purposive. Alternatively, police could simply form the perception of “suspicion” more often based on a broader interpretation of the social cues that capture police attention and evoke ofﬁcial reactions (Alpert et al. 2005). The latter explanation conforms more closely to a social-psychological process of racial stereotyping, where the attribution of suspicion is more readily attached to speciﬁc behaviors and contexts for minorities than it might be for whites (Thompson 1999; Richardson and Pittinsky 2005).

We did ﬁnd evidence of stops that are best explained as “racial incongruity” stops: high rates of minority stops in predominantly white precincts. Indeed, being “out of place” is often a trigger for suspicion (Alpert et al. 2005; Gould and Mastrofski 2004). Racial incongruity stops are most prominent in racially homogeneous areas. For example, we observed high stop rates of African-Americans in the predominantly white 19th Precinct, a sign of race-based selection of citizens for police interdiction. We also observed high stop rates for whites in several precincts in the Bronx, especially for drug crimes, most likely evidence that white drug buyers were entering predominantly minority neighborhoods where street drug markets are common. Overall, however, these were relatively infrequent events that produced misleading stop rates due to the population skew in such precincts.

To brieﬂy summarize our ﬁndings, blacks and Hispanics represented 51% and 33% of the stops while representing only 26% and 24% of the New York City population. Compared with the number of arrests of each group in the previous year (used as a proxy for the rate of criminal behavior), blacks were stopped 23% more often than whites and Hispanics were stopped 39% more often than whites. Controlling for precinct actually increased these discrepancies, with minorities between 1.5 and 2.5 times as often as whites (compared with the groups’ previous arrest rates in the precincts where they were stopped) for the most common categories of stops (violent crimes and drug crimes), with smaller differences for property and drug crimes. The differences in stop rates among ethnic groups are real, substantial, and not explained by previous arrest rates or precincts.

Our ﬁndings do not necessarily imply that the NYPD was acting in an unfair or racist manner, however. It is quite reasonable to suppose that effective policing requires stopping and questioning many people to gather information about any given crime.

In the context of some difﬁcult relations between the police and ethnic minority communities in New York City, it is useful to have some quantitative sense of the issues in dispute. Given that there have been complaints about the frequency with which the police have been stopping blacks and Hispanics, it is relevant to know that this is indeed a statistical pattern. The NYPD

then has the opportunity to explain their policies to the affected communities.

In the years since this study was conducted, an extensive monitoring system was put into place that would accomplish two goals. First, procedures were developed and implemented that permitted monitoring of ofﬁcers’ compliance with the mandates of the NYPD Patrol Guide for accurate and comprehensive recording of all police stops. Second, the new forms were entered into databases that would permit continuous monitoring of the racial proportionality of stops and their outcomes (e.g., frisks, arrests). When coupled with accurate reporting on race-speciﬁc measures of crime and arrest, the new procedures and monitoring requirements will ensure that inquiries similar to this study can be institutionalized as part of a framework of accountability mechanisms.

[Received March 2004. Revised December 2005.]

###### REFERENCES

Alpert, G., MacDonald, J. H., and Dunham, R. G. (2005), “Police Suspicion and Discretionary Decision Making During Citizen Stops,” Criminology, 43, 407–434.

Ayres, I. (2002a), “Outcome Tests of Racial Disparities in Police Practices,”

Justice Research and Policy, 4, 131–142.

(2002b), Pervasive Prejudice: Unconventional Evidence of Race and Gender Discrimination, Chicago: University of Chicago Press.

Bittner, E. (1970), Functions of the Police in Modern Society: A Reviev of Background Factors, Current Practices and Possible Role Models, Rockville, MD: National Institute of Mental Health.

Bratton, W., and Knobler, P. (1998), Turnaround, New York: Norton. Brown v. Texas (1979), 443 U.S. 43, U.S. Supreme Court. Brown v. Oneonta (2000), 221 F.3d 329, 2nd Ciruit Court. Cole, D. (1999), No Equal Justice: Race and Class in the Criminal Justice

System, New York: New Press.

Dharmapala, D., and Ross, S. L. (2004), “Racial Bias in Motor Vehicle Searches: Additional Theory and Evidence,” Contributions to Economic Policy and Analysis, 3, article 12; available at www.bepress.com/ bejeap/contributions/vol13/iss1/art12.

Dominitz, J., and Knowles, J. (2005), “Crime Minimization and Racial Bias: What Can We Learn From Police Search Data?” PIER Working Paper Archive 05-019, University of Pennsylvania, Penn Institute for Economic Research, Dept. of Economics.

Durose, M. R., Schmitt, E. L., and Langan, P. A. (2005), “Contacts Between Police and the Public: Findings From the 2002 National Survey,” NCJ 207845, Bureau of Justice Statistics, U.S. Department of Justice.

Eck, J., and Maguire, E. R. (2000), “Have Changes in Policing Reduced Violent Crime: An Assessment of the Evidence,” in The Crime Drop in America, eds. A. Blumstein and J. Wallman, New York: Cambridge University Press, pp. 207–265.

Fagan, J. (2002), “Law, Social Science and Racial Proﬁling,” Justice, Research

and Policy, 4, 104–129.

Fagan, J., and Davies, G. (2000), “Street Stops and Broken Windows: Terry, Race, and Disorder in New York City,” Fordham Urban Law Journal, 28, 457–504.

(2003), “Policing Guns: Order Maintenance and Crime Control in New York,” in Guns, Crime, and Punishment in America, ed. B. Harcourt, New York: New York University Press, pp. 191–221.

Fagan, J., Zimring, F. E., and Kim, J. (1998), “Declining Homicide in New York: A Tale of Two Trends,” Journal of Criminal Law and Criminology, 88, 1277–1324.

Fridell, L., Lunney, R., Diamond, D., Kubu, B., Scott, M., and Laing, C. (2001), “Racially Biased Policing: A Principled Response,” Police Executive Research Forum; available at www.policeforum.org/racial.html.

Garrett, B. (2001), “Remedying Racial Proﬁling Through Partnership, Statistics, and Reﬂective Policing,” Columbia Human Rights Law Review, 33, 41–148.

Gelman, A., Carlin, J. B., Stern, H. S., and Rubin, D. B. (2003), Bayesian Data

Analysis (2nd ed.), London: Chapman & Hall.

Gelman, A., and Rubin, D. B. (1992), “Inference From Iterative Simulation Using Multiple Sequences” (with discussion), Statistical Science, 7, 457–511. Goldberg, J. (1999), “The Color of Suspicion,” New York Times Magazine, June

20, 51.

Gould, J., and Mastrofski, S. (2004), “Suspect Searches: Assess Police Behavior Under the U.S. Constitution,” Criminology and Public Policy, 3, 315–361.

Greene, J. (1999), “Zero Tolerance: A Case Study of Police Policies and Practices in New York City,” Crime and Delinquency, 45, 171–199. Gross, S. R., and Barnes, K. Y. (2002), “Road Work: Racial Proﬁling and Drug Interdiction on the Highway,” Michigan Law Review, 101, 653–754. Gross, S. R., and Livingston, D. (2002), “Racial Proﬁling Under Attack,”

###### Columbia Law Review, 102, 1413–1438.

Harcourt, B. E. (1998), “Reﬂecting on the Subject: A Critique of the Social Inﬂuence Conception of Deterrence, the Broken Windows Theory, and OrderMaintenance Policing New York Style,” Michigan Law Review, 97, 291.

###### (2001), Illusion of Order: The False Promise of Broken Windows Policing, Cambridge, MA: Harvard University Press.

Harris, D. A. (1999), “The Stories, the Statistics, and the Law: Why ‘Driving While Black’ Matters,” Minnesota Law Review, 84, 265–326.

###### (2002), Proﬁles in Injustice: Why Racial Proﬁling Cannot Work, New York: New Press.

Hemenway, D. (1997), “The Myth of Millions of Annual Self-Defense Gun Uses: A Case Study of Survey Overestimates of Rare Events,” Chance, 10, 6–10.

Illinois v. Wardlow (2000), 528 U.S. 119, U.S. Supreme Court. Kelling, G., and Cole, C. (1996), Fixing Broken Windows, New York: Free

Press. Kelvin Daniels et al. v. City of New York (2004), Stipulation of Settlement, 99 Civ 1695 (SAS), ordered January 9, 2004; ﬁled January 13, 2004. Kennedy, R. (1997), Race, Crime and Law, Cambridge, MA: Harvard University Press.

Knowles, J., Persico, N., and Todd, P. (2001), “Racial Bias in MotorVehicle Searches: Theory and Evidence,” Journal of Political Economy, 109, 203–229.

Lamberth, J. (1997), “Report of John Lamberth, Ph.D.,” American Civil Liberties Union; available at www.aclu.org/court/lamberth.html

Langan, P., Greenfeld, L. A., Smith, S. K., Durose, M. R., and Levin, D. J. (2001), “Contacts Between Police and the Public: Findings From the 1999 National Survey,” NCJ 184957, Bureau of Justice Statistics, U.S. Department of Justice.

Loury, G. (2002), The Anatomy of Racial Inequality, Cambridge, MA: Harvard University Press.

Lundman, R. J., and Kaufman, R. L. (2003), “Driving While Black: Effects of Race, Ethnicity, and Gender on Citizen Self-Reports of Trafﬁc Stops and Police Actions,” Criminology, 41, 195–220.

MacDonald, H. (2001), “The Myth of Racial Proﬁling,” City Journal, 11, 2–5. Massey, D., and Denton, N. (1993), American Apartheid: Segregation and the

Making of the Underclass, Cambridge, MA: Harvard University Press.

McCullagh, P., and Nelder, J. A. (1989), Generalized Linear Models (2nd ed.), New York: Chapman & Hall.

Miller, J. (2000), “Proﬁling Populations Available for Stops and Searches,” Police Research Series Paper 121, Home Ofﬁce Research, Development and Statistics Directorate, United Kingdom.

Musto, D. (1973), The American Disease, New Haven, CT: Yale University Press. Pager, D. (2003), “The Mark of a Criminal Record,” American Journal of Soci-

ology, 108, 937–975.

People v. DeBour (1976), 40 N.Y.2d 210, 386 N.Y.S.2d 375. People v. Holmes (1996), 89 N.Y.2d 838, 652 N.Y.S.2d 725. R Project (2000), “The R Project for Statistical Computing,” available at www.r-

###### project.org.

Raudenbush, S. W., and Bryk, A. S. (2002), Hierarchical Linear Models (2nd ed.), Thousand Oaks, CA: Sage. Reiss, A. (1971), The Police and the Public, New Haven, CT: Yale University Press.

Richardson, M., and Pittinsky, T. L. (2005), “The Mistaken Assumption of Intentionality in Equal Protection Law: Psychological Science and the Interpretation of the Fourteenth Amendment,” KSG Working Paper RWP05-011; available at ssrn.com/abstract=722647

Rudovsky, D. (2001), “Law Enforcement by Stereotypes and Serendipity: Racial Proﬁling and Stops and Searches Without Cause,” University of Pennsylvania Journal of Constitutional Law, 3, 296–366.

Russell, K. K. (2002), “Racial Proﬁling: A Status Report of the Legal, Legislative, and Empirical Literature,” Rutgers Race and the Law Review, 3, 61–81. Saﬁr, H. (1999), “Statement Before the New York City Council Public Safety Commission,” April 19; cited in Spitzer (1999).

Sampson, R. J., and Raudenbush, S. W. (1999), “Systematic Social Observation of Public Spaces: A New Look at Disorder in Urban Neighborhoods,” American Journal of Sociology, 105, 622–630.

Sampson, R. J., Raudenbush, S. W., and Earls, F. (1997), “Neighborhoods and Violent Crime: A Multilevel Study of Collective Efﬁcacy,” Science, 277, 918–924.

###### Skogan, W. (1990), Disorder and Decline: Crime and the Spiral of Decay in

American Cities, Berkeley, CA: University of California Press.

Skogan, W., and Frydl, K. (eds.) (2004), The Evidence on Policing: Fairness and Efffectiveness in Law Enforcement, Washington, DC: National Academy Press.

Skolnick, J., and Capolovitz, A. (2001), “Guns, Drugs and Proﬁling: Ways to Target Guns and Minimize Racial Proﬁling,” Arizona Law Review, 43, 413–448.

Smith, D. A. (1986), “The Neighborhood Context of Police Behavior,” in Communities and Crime: Crime and Justice: An Annual Review of Research, eds. A. J. Reiss and M. Tonry, Chicago: University of Chicago Press, pp. 313–342.

Smith, M., and Alpert, G. (2002), “Searching for Direction: Courts, Social Science, and the Adjudication of Racial Proﬁling Claims,” Justice Quarterly, 19, 673–704.

Smith, M. R., Makarios, M., and Alpert, G. P. (2006), “Differential Suspicion: Theory Speciﬁcation and Gender Effects in the Trafﬁc Stop Context,” Justice Quarterly, 23, 271–295.

Spiegelhalter, D., Thomas, A., Best, N., Gilks, W., and Lunn, D. (1994, 2003), “BUGS: Bayesian Inference Using Gibbs Sampling,” MRC Biostatistics Unit, Cambridge, U.K.; available at www.mrc-bsu.cam.ac.uk/bugs/.

Spitzer, E. (1999), “The New York City Police Department’s “Stop and Frisk” Practices,” Ofﬁce of the New York State Attorney General; available at www.oag.state.ny.us/press/reports/stop_frisk/stop_frisk.html.

Sturtz, S., Ligges, U., and Gelman, A. (2005), “R2WinBUGS: A Package for Running WinBUGS From R,” Journal of Statistical Software, 12 (3), 1–16. Sykes, R. E., and Clark, J. P. (1976), “A Theory of Deference Exchange in Police-Civilian Encounters,” American Journal of Sociology, 81, 587–600. Taylor, R. B. (2000), Breaking Away From Broken Windows: Baltimore Neighborhoods and the Nationwide Fight Against Crime, Grime, Fear, and Decline, Boulder, CO: Westview Press.

Terry v. Ohio (1968), 392 U.S. 1, U.S. Supreme Court. Thompson, A. (1999), “Stopping the Usual Suspects: Race and the Fourth

Amendment,” New York University Law Review, 74, 956–1013. Tyler, T. R., and Huo, Y. J. (2003), Trust in the Law, New York: Russell Sage Foundation. U.S. Commission on Civil Rights (2000), “Police Practices and Civil Rights in

New York City,” available at www.uscrr.gov/pubs/nypolice/main.htm. U.S. v. Martinez-Fuerte (1976), 428 U.S. 543. U.S. Supreme Court. Veneiro, P., and Zoubeck, P. H. (1999), “Interim Report of the State Police

Review Team Regarding Allegations of Racial Proﬁling,” Ofﬁce of the New Jersey State Attorney General.

Walker, S. (2001), “Searching for the Denominator: Problems With Police Trafﬁc Stop Data and an Early Warning System Solution,” Justice Research and Policy, 3, 63–95.

Wang, A. (2001), “Illinois v. Wardlow and the Crisis of Legitimacy: An Argument for a “Real Cost” Balancing Test,” Law and Inequality, 19, 1–30.

Weidner, R. R., Frase, R., and Pardoe, I. (2004), “Explaining Sentence Severity in Large Urban Counties: A Multilevel Analysis of Contextual and CaseLevel Factors,” Prison Journal, 84, 184–207.

Weitzer, R. (2000), “Racialized Policing: Residents’ Perceptions in Three Neighborhoods,” Law and Society Review, 34, 129–155. Weitzer, R., and Tuch, S. A. (2002), “Perceptions of Racial Proﬁling: Race,

Class and Personal Experience,” Criminology, 50, 435–456. Whren et al. v. U.S. (1996), 517 U.S. 806, U.S. Supreme Court. Wilson, J. Q., and Kelling, G. L. (1982), “The Police and Neighborhood Safety:

Broken Windows,” Atlantic Monthly, March, 29–38. Zimring, F. E. (2006), The Great American Crime Decline, Oxford, U.K.: Oxford University Press.

Zingraff, M., Mason, H. M., Smith, W. R., Tomaskovic-Devey, D., Warren, P., McMurray, H. L., and Fenlon, C. R., et al. (2000), “Evaluating North Carolina State Highway Patrol Data: Citations, Warnings and Searches in 1998,” available at www.nccrimecontrol.org/shp/ncshpreport.htm

