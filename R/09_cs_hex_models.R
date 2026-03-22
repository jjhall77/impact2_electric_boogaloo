#!/usr/bin/env Rscript
# =============================================================================
# 09_cs_hex_models.R
# Callaway & Sant'Anna (2021) on hex panel
# Primary specification: heterogeneity-robust staggered DiD
# Uses never-treated hexes as controls (no forbidden comparisons)
# =============================================================================

library(fixest)
library(data.table)
library(did)

cat("Loading panel...\n")
panel <- fread("data/panel_hex_month.csv")

# ---------------------------------------------------------------
# Aggregate to quarterly panel for C&S tractability
# (monthly x 23 cohorts = too many group-time ATTs)
# ---------------------------------------------------------------
cat("Aggregating to quarterly panel...\n")
panel[, quarter := ceiling(month / 3)]
panel[, yq := year * 10 + quarter]  # numeric quarter ID: 20061, 20062, etc.

quarterly <- panel[, .(
  violent    = sum(violent),
  property   = sum(property),
  sqf_total  = sum(sqf_total),
  sqf_pc     = sum(sqf_pc),
  sqf_npc    = sum(sqf_npc),
  arrests_felony       = sum(arrests_felony),
  arrests_misdemeanor  = sum(arrests_misdemeanor)
), by = .(hex_id, year, quarter, yq, precinct, ever_treated)]

# Create numeric hex ID for did package (needs integer unit IDs)
quarterly[, hex_num := as.integer(factor(hex_id))]

cat(sprintf("Quarterly panel: %s rows, %s hexes, %s quarters\n",
            format(nrow(quarterly), big.mark = ","),
            uniqueN(quarterly$hex_id),
            uniqueN(quarterly$yq)))

# ---------------------------------------------------------------
# Define cohort: first quarter of treatment
# Convert first_treated dates to yq format
# Never-treated hexes get cohort = 0 (did package convention)
# ---------------------------------------------------------------
cat("Defining cohorts...\n")

# Read hex treatment map for first_treated dates
library(jsonlite)
hex_map <- fromJSON("data/hex_treatment_map.json")
treated_info <- hex_map$treated

# Build cohort lookup
cohort_lookup <- data.table(
  hex_id = names(treated_info),
  first_treated_date = sapply(treated_info, function(x) x$first_treated)
)

# Convert date string to yq
cohort_lookup[, ft_year := as.integer(substr(first_treated_date, 1, 4))]
cohort_lookup[, ft_month := as.integer(substr(first_treated_date, 6, 7))]
cohort_lookup[, ft_quarter := ceiling(ft_month / 3)]
cohort_lookup[, cohort_yq := ft_year * 10 + ft_quarter]

# Merge into quarterly panel
quarterly <- merge(quarterly, cohort_lookup[, .(hex_id, cohort_yq)],
                   by = "hex_id", all.x = TRUE)
quarterly[is.na(cohort_yq), cohort_yq := 0]  # never-treated

# Drop cohorts before our study period (2003-2005 cohorts have no pre-treatment data)
# Actually keep them — C&S will handle them, but we need pre-treatment periods
# Hexes treated before 2006 have no pre-treatment data in our panel
# C&S requires at least 1 pre-treatment period, so drop cohorts with
# first treatment before Q1 2006 (our panel starts Q1 2006)
n_early <- quarterly[cohort_yq > 0 & cohort_yq < 20061, uniqueN(hex_id)]
cat(sprintf("  Dropping %d hexes treated before 2006 (no pre-treatment data)\n", n_early))
quarterly_cs <- quarterly[cohort_yq == 0 | cohort_yq >= 20061]

cat(sprintf("  Remaining: %s hexes (%s treated, %s never-treated)\n",
            uniqueN(quarterly_cs$hex_id),
            uniqueN(quarterly_cs[cohort_yq > 0]$hex_id),
            uniqueN(quarterly_cs[cohort_yq == 0]$hex_id)))

# Consolidate small cohorts — group by year of first treatment
quarterly_cs[cohort_yq > 0, cohort_year := cohort_yq %/% 10]
quarterly_cs[cohort_yq == 0, cohort_year := 0]

cat("\nCohort distribution (by year):\n")
print(quarterly_cs[, .(n_hexes = uniqueN(hex_id)), by = cohort_year][order(cohort_year)])

# ---------------------------------------------------------------
# Callaway & Sant'Anna: Violent Crime
# ---------------------------------------------------------------
cat("\n", strrep("=", 60), "\n")
cat("CALLAWAY & SANT'ANNA: VIOLENT CRIME\n")
cat(strrep("=", 60), "\n\n")

cs_violent <- att_gt(
  yname  = "violent",
  tname  = "yq",
  idname = "hex_num",
  gname  = "cohort_yq",
  data   = as.data.frame(quarterly_cs),
  control_group = "nevertreated",
  anticipation  = 0,
  est_method    = "reg",
  print_details = FALSE
)

cat("Group-time ATTs computed.\n")
cat(sprintf("  Number of group-time ATTs: %d\n", length(cs_violent$att)))

# Aggregate to overall ATT
agg_violent <- aggte(cs_violent, type = "simple")
cat("\nOverall ATT (simple aggregation):\n")
summary(agg_violent)

# Aggregate to dynamic (event study)
es_violent <- aggte(cs_violent, type = "dynamic", min_e = -8, max_e = 12)
cat("\nEvent study aggregation:\n")
summary(es_violent)

# ---------------------------------------------------------------
# Callaway & Sant'Anna: Property Crime
# ---------------------------------------------------------------
cat("\n", strrep("=", 60), "\n")
cat("CALLAWAY & SANT'ANNA: PROPERTY CRIME\n")
cat(strrep("=", 60), "\n\n")

cs_property <- att_gt(
  yname  = "property",
  tname  = "yq",
  idname = "hex_num",
  gname  = "cohort_yq",
  data   = as.data.frame(quarterly_cs),
  control_group = "nevertreated",
  anticipation  = 0,
  est_method    = "reg",
  print_details = FALSE
)

agg_property <- aggte(cs_property, type = "simple")
cat("\nOverall ATT (simple aggregation):\n")
summary(agg_property)

es_property <- aggte(cs_property, type = "dynamic", min_e = -8, max_e = 12)
cat("\nEvent study aggregation:\n")
summary(es_property)

# ---------------------------------------------------------------
# Callaway & Sant'Anna: Felony Arrests
# ---------------------------------------------------------------
cat("\n", strrep("=", 60), "\n")
cat("CALLAWAY & SANT'ANNA: FELONY ARRESTS\n")
cat(strrep("=", 60), "\n\n")

cs_arrests_f <- att_gt(
  yname  = "arrests_felony",
  tname  = "yq",
  idname = "hex_num",
  gname  = "cohort_yq",
  data   = as.data.frame(quarterly_cs),
  control_group = "nevertreated",
  anticipation  = 0,
  est_method    = "reg",
  print_details = FALSE
)

agg_arrests_f <- aggte(cs_arrests_f, type = "simple")
cat("\nOverall ATT (simple aggregation):\n")
summary(agg_arrests_f)

es_arrests_f <- aggte(cs_arrests_f, type = "dynamic", min_e = -8, max_e = 12)

# ---------------------------------------------------------------
# Callaway & Sant'Anna: Misdemeanor Arrests
# ---------------------------------------------------------------
cat("\n", strrep("=", 60), "\n")
cat("CALLAWAY & SANT'ANNA: MISDEMEANOR ARRESTS\n")
cat(strrep("=", 60), "\n\n")

cs_arrests_m <- att_gt(
  yname  = "arrests_misdemeanor",
  tname  = "yq",
  idname = "hex_num",
  gname  = "cohort_yq",
  data   = as.data.frame(quarterly_cs),
  control_group = "nevertreated",
  anticipation  = 0,
  est_method    = "reg",
  print_details = FALSE
)

agg_arrests_m <- aggte(cs_arrests_m, type = "simple")
cat("\nOverall ATT (simple aggregation):\n")
summary(agg_arrests_m)

es_arrests_m <- aggte(cs_arrests_m, type = "dynamic", min_e = -8, max_e = 12)

# ---------------------------------------------------------------
# Aggregate by regime period (calendar time)
# This is the key test: how does the ATT change across regimes?
# ---------------------------------------------------------------
cat("\n", strrep("=", 60), "\n")
cat("ATT BY REGIME PERIOD (calendar-time aggregation)\n")
cat(strrep("=", 60), "\n\n")

# Calendar time aggregation
cal_violent <- aggte(cs_violent, type = "calendar")
cat("Violent crime - calendar time ATTs:\n")
summary(cal_violent)

cal_property <- aggte(cs_property, type = "calendar")
cat("\nProperty crime - calendar time ATTs:\n")
summary(cal_property)

# ---------------------------------------------------------------
# Event study plots
# ---------------------------------------------------------------
cat("\nSaving plots...\n")

png("output/cs_hex_es_violent.png", width = 1400, height = 700, res = 150)
ggdid(es_violent, title = "C&S Event Study: Violent Crime (Quarterly, Hex Grid)",
      xlab = "Quarters Relative to Treatment", ylab = "ATT")
dev.off()

png("output/cs_hex_es_property.png", width = 1400, height = 700, res = 150)
ggdid(es_property, title = "C&S Event Study: Property Crime (Quarterly, Hex Grid)",
      xlab = "Quarters Relative to Treatment", ylab = "ATT")
dev.off()

png("output/cs_hex_es_arrests_felony.png", width = 1400, height = 700, res = 150)
ggdid(es_arrests_f, title = "C&S Event Study: Felony Arrests (Quarterly, Hex Grid)",
      xlab = "Quarters Relative to Treatment", ylab = "ATT")
dev.off()

png("output/cs_hex_es_arrests_misd.png", width = 1400, height = 700, res = 150)
ggdid(es_arrests_m, title = "C&S Event Study: Misdemeanor Arrests (Quarterly, Hex Grid)",
      xlab = "Quarters Relative to Treatment", ylab = "ATT")
dev.off()

# ---------------------------------------------------------------
# Save all results
# ---------------------------------------------------------------
results_cs <- list(
  cs_violent    = cs_violent,
  cs_property   = cs_property,
  cs_arrests_f  = cs_arrests_f,
  cs_arrests_m  = cs_arrests_m,
  agg_violent   = agg_violent,
  agg_property  = agg_property,
  agg_arrests_f = agg_arrests_f,
  agg_arrests_m = agg_arrests_m,
  es_violent    = es_violent,
  es_property   = es_property,
  es_arrests_f  = es_arrests_f,
  es_arrests_m  = es_arrests_m,
  cal_violent   = cal_violent,
  cal_property  = cal_property
)
saveRDS(results_cs, "output/cs_hex_results.rds")
cat("Saved to output/cs_hex_results.rds\n")

cat("\nDone!\n")
