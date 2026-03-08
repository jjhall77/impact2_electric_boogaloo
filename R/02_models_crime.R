# 02_models_crime.R
# Replicates Models 1-5 from MacDonald, Fagan & Geller (2016)
# Crime outcomes using conditional FE Poisson (fixest::fepois)
#
# IMPORTANT: Models are run on raw (uncollapsed) data, matching the
# paper's N of ~840,287. The collapsed panel gives wrong coefficients.

library(data.table)
library(fixest)
library(splines)

# ---- Load raw data and prepare variables -----------------------------------

crime <- fread("data-raw/blocks2004_2012_crime_fid_impactzones.csv",
               na.strings = c("", "NA", "."))
crime[, ym := year * 100L + month]
crime[, pct := as.integer(pct)]
crime[, year_pct_month := paste0(ym, "_", pct)]

cat("Crime panel loaded:", nrow(crime), "rows\n")

# Fix event study cumulation (Stata: eventneg2=1 if eventneg1==1)
crime[eventneg1 == 1, eventneg2 := 1L]
crime[eventpos1 == 1, eventpos2 := 1L]

# Build neighbor treatment indicator
# NOTE: Stata code uses year== (not year>=), so neighbor treatment is coded
# only in the activation year of each zone, not persistently.
crime[, treatmentn := 0L]
crime[year == 2004 & impact3neigh > 0,               treatmentn := 1L]
crime[year == 2005 & impact4neigh > 0,               treatmentn := 1L]
crime[year == 2005 & month >= 7 & impact5neigh > 0,  treatmentn := 1L]
crime[year == 2006 & impact6neigh > 0,               treatmentn := 1L]
crime[year == 2006 & month >= 6 & impact7neigh > 0,  treatmentn := 1L]
crime[year == 2007 & impact8neigh > 0,               treatmentn := 1L]
crime[year == 2007 & month >= 7 & impact9neigh > 0,  treatmentn := 1L]
crime[year == 2008 & impact10neigh > 0,              treatmentn := 1L]
crime[year == 2008 & month >= 7 & impact11neigh > 0, treatmentn := 1L]
crime[year == 2009 & impact12neigh > 0,              treatmentn := 1L]
crime[year == 2009 & month >= 7 & impact13neigh > 0, treatmentn := 1L]
crime[year == 2010 & impact14neigh > 0,              treatmentn := 1L]
crime[year == 2010 & month >= 8 & impact15neigh > 0, treatmentn := 1L]
crime[year == 2011 & impact16aneigh > 0,             treatmentn := 1L]
crime[year == 2011 & month >= 8 & impact16hneigh > 0, treatmentn := 1L]
crime[year == 2012 & impact17neigh > 0,              treatmentn := 1L]
crime[treatment == 1, treatmentn := 0L]

# Model 4 interaction variables
crime[, stops := fifelse(is.na(stops), 0L, as.integer(stops))]
crime[, cs_probcause := fifelse(is.na(cs_probcause), 0L, as.integer(cs_probcause))]
crime[, treatmentpc := treatment * cs_probcause]
crime[, cs_npc := stops - cs_probcause]
crime[, treatmentnpc := treatment * cs_npc]

# Model 5: cubic polynomial trend per precinct
crime[, monthly := (year - 2004L) * 12L + month]
crime[, c("bs1", "bs2", "bs3") := {
  p <- poly(monthly, degree = 3)
  list(p[, 1], p[, 2], p[, 3])
}, by = pct]

# ---- Outcome variable mapping ----------------------------------------------
# Mapping confirmed by matching Model 1 coefficients to Table 1:
#   crimes1    → Total              crimes10   → Weapons
#   offenses47 → Robbery            crimes7    → Misd.
#   offenses15 → Assault            crimes6    → Other Felony
#   offenses7  → Burglary           crimes5    → Drugs
#   crimes3    → Property Felony    offenses   → Violent Felony

outcomes <- c("crimes1", "offenses47", "offenses15", "offenses7", "crimes10",
              "crimes7", "crimes6", "crimes5", "crimes3", "offenses")
labels   <- c("Total", "Robbery", "Assault", "Burglary", "Weapons",
              "Misd.", "Other Felony", "Drugs", "Property Felony",
              "Violent Felony")
names(labels) <- outcomes

# Published target coefficients (Model 1, Impact) — Table 1
targets_m1 <- c(crimes1 = -0.124, offenses47 = -0.157, offenses15 = -0.131,
                offenses7 = -0.611, crimes10 = 0.314, crimes7 = -0.198,
                crimes6 = 0.614, crimes5 = -0.026, crimes3 = -0.296,
                offenses = -0.120)

# ---- Model 1: Basic treatment effect --------------------------------------
cat("\n========== MODEL 1: Impact Zone Effect ==========\n")

m1_results <- list()
for (yvar in outcomes) {
  fml <- as.formula(paste0(yvar, " ~ treatment | year_pct_month"))
  m1_results[[yvar]] <- fepois(fml, data = crime, vcov = ~year_pct_month)
}

cat(sprintf("\n%-18s %10s %10s %10s %8s\n",
            "Outcome", "Coef", "SE", "Target", "N"))
cat(strrep("-", 60), "\n")
for (yvar in outcomes) {
  m <- m1_results[[yvar]]
  cat(sprintf("%-18s %10.4f %10.4f %10.3f %8d\n",
              labels[yvar],
              coef(m)["treatment"],
              se(m)["treatment"],
              targets_m1[yvar],
              m$nobs))
}

# ---- Model 2: Neighbor spillover ------------------------------------------
cat("\n========== MODEL 2: Neighbor Spillover ==========\n")

targets_m2_impact <- c(crimes1 = -0.149, offenses47 = -0.139, offenses15 = -0.148,
                       offenses7 = -0.663, crimes10 = 0.324, crimes7 = -0.234,
                       crimes6 = 0.629, crimes5 = -0.030, crimes3 = -0.332,
                       offenses = -0.129)
targets_m2_neigh <- c(crimes1 = -0.072, offenses47 = 0.050, offenses15 = -0.049,
                      offenses7 = -0.158, crimes10 = 0.026, crimes7 = -0.105,
                      crimes6 = 0.043, crimes5 = -0.011, crimes3 = -0.111,
                      offenses = -0.026)

m2_results <- list()
for (yvar in outcomes) {
  fml <- as.formula(paste0(yvar, " ~ treatment + treatmentn | year_pct_month"))
  m2_results[[yvar]] <- fepois(fml, data = crime, vcov = ~year_pct_month)
}

cat(sprintf("\n%-18s %10s %10s %10s %10s %10s\n",
            "Outcome", "Impact", "Target", "Neighbor", "Target", "N"))
cat(strrep("-", 72), "\n")
for (yvar in outcomes) {
  m <- m2_results[[yvar]]
  cat(sprintf("%-18s %10.4f %10.3f %10.4f %10.3f %8d\n",
              labels[yvar],
              coef(m)["treatment"], targets_m2_impact[yvar],
              coef(m)["treatmentn"], targets_m2_neigh[yvar],
              m$nobs))
}

# ---- Model 3: Event study -------------------------------------------------
cat("\n========== MODEL 3: Event Study (+/- 2 months) ==========\n")

m3_results <- list()
for (yvar in outcomes) {
  fml <- as.formula(paste0(yvar,
    " ~ eventneg2 + eventneg1 + eventpos1 + eventpos2 | year_pct_month"))
  m3_results[[yvar]] <- fepois(fml, data = crime, vcov = ~year_pct_month)
}

cat(sprintf("\n%-18s %10s %10s %10s %10s\n",
            "Outcome", "neg2", "neg1", "pos1", "pos2"))
cat(strrep("-", 62), "\n")
for (yvar in outcomes) {
  m <- m3_results[[yvar]]
  cc <- coef(m)
  cat(sprintf("%-18s %10.4f %10.4f %10.4f %10.4f\n",
              labels[yvar],
              cc["eventneg2"], cc["eventneg1"],
              cc["eventpos1"], cc["eventpos2"]))
}

# ---- Model 4: PC vs NPC stop interactions ----------------------------------
cat("\n========== MODEL 4: PC vs NPC Stops ==========\n")

targets_m4_pc  <- c(crimes1 = -0.011, offenses47 = -0.010, offenses15 = -0.009,
                    offenses7 = -0.015, crimes10 = -0.011, crimes7 = -0.012,
                    crimes6 = -0.017, crimes5 = -0.014, crimes3 = -0.011,
                    offenses = -0.010)
targets_m4_npc <- c(crimes1 = 0.002, offenses47 = -0.001, offenses15 = -0.003,
                    offenses7 = 0.005, crimes10 = -0.002, crimes7 = 0.004,
                    crimes6 = -0.002, crimes5 = -0.002, crimes3 = 0.002,
                    offenses = 0.000)

m4_results <- list()
for (yvar in outcomes) {
  fml <- as.formula(paste0(yvar,
    " ~ treatment + cs_probcause + cs_npc + treatmentpc + treatmentnpc",
    " | year_pct_month"))
  m4_results[[yvar]] <- fepois(fml, data = crime, vcov = ~year_pct_month)
}

cat(sprintf("\n%-18s %10s %10s %10s %10s %8s\n",
            "Outcome", "PC*Imp", "Target", "NPC*Imp", "Target", "N"))
cat(strrep("-", 72), "\n")
for (yvar in outcomes) {
  m <- m4_results[[yvar]]
  cat(sprintf("%-18s %10.4f %10.3f %10.4f %10.3f %8d\n",
              labels[yvar],
              coef(m)["treatmentpc"], targets_m4_pc[yvar],
              coef(m)["treatmentnpc"], targets_m4_npc[yvar],
              m$nobs))
}

# ---- Model 5: Cubic spline trend with fid FE ------------------------------
cat("\n========== MODEL 5: Cubic Trend + fid FE ==========\n")

m5_results <- list()
for (yvar in outcomes) {
  fml <- as.formula(paste0(yvar, " ~ treatment + bs1 + bs2 + bs3 | fid"))
  m5_results[[yvar]] <- fepois(fml, data = crime, vcov = ~fid)
}

cat(sprintf("\n%-18s %10s %10s\n", "Outcome", "Impact", "N"))
cat(strrep("-", 42), "\n")
for (yvar in outcomes) {
  m <- m5_results[[yvar]]
  cat(sprintf("%-18s %10.4f %8d\n",
              labels[yvar],
              coef(m)["treatment"],
              m$nobs))
}

# ---- Save all model objects ------------------------------------------------
dir.create("output", showWarnings = FALSE)
crime_models <- list(m1 = m1_results, m2 = m2_results, m3 = m3_results,
                     m4 = m4_results, m5 = m5_results)
saveRDS(crime_models, "output/crime_models.rds")
cat("\nAll crime models saved to output/crime_models.rds\n")
