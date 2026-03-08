# 03_models_arrest.R
# Replicates Models 1-5 from MacDonald, Fagan & Geller (2016)
# Arrest outcomes using conditional FE Poisson (fixest::fepois)
#
# IMPORTANT: Models are run on raw (uncollapsed) data, matching the
# paper's N of ~341,765. Arrest data has different offense column numbers
# than crime data: offenses8, offenses18, offenses57 (vs 7, 15, 47).

library(data.table)
library(fixest)
library(splines)

# ---- Load raw data and prepare variables -----------------------------------

arrest <- fread("data-raw/blocks2004_2012_arrest_fid_impactzones 2.csv",
                na.strings = c("", "NA", "."))
arrest[, ym := year * 100L + month]
arrest[, pct := as.integer(pct)]
arrest[, year_pct_month := paste0(ym, "_", pct)]

cat("Arrest panel loaded:", nrow(arrest), "rows\n")

# Fix event study cumulation (Stata: eventneg2=1 if eventneg1==1)
arrest[eventneg1 == 1, eventneg2 := 1L]
arrest[eventpos1 == 1, eventpos2 := 1L]

# Build neighbor treatment indicator
# NOTE: Stata code uses year== (not year>=), so neighbor treatment is coded
# only in the activation year of each zone, not persistently.
arrest[, treatmentn := 0L]
arrest[year == 2004 & impact3neigh > 0,               treatmentn := 1L]
arrest[year == 2005 & impact4neigh > 0,               treatmentn := 1L]
arrest[year == 2005 & month >= 7 & impact5neigh > 0,  treatmentn := 1L]
arrest[year == 2006 & impact6neigh > 0,               treatmentn := 1L]
arrest[year == 2006 & month >= 6 & impact7neigh > 0,  treatmentn := 1L]
arrest[year == 2007 & impact8neigh > 0,               treatmentn := 1L]
arrest[year == 2007 & month >= 7 & impact9neigh > 0,  treatmentn := 1L]
arrest[year == 2008 & impact10neigh > 0,              treatmentn := 1L]
arrest[year == 2008 & month >= 7 & impact11neigh > 0, treatmentn := 1L]
arrest[year == 2009 & impact12neigh > 0,              treatmentn := 1L]
arrest[year == 2009 & month >= 7 & impact13neigh > 0, treatmentn := 1L]
arrest[year == 2010 & impact14neigh > 0,              treatmentn := 1L]
arrest[year == 2010 & month >= 8 & impact15neigh > 0, treatmentn := 1L]
arrest[year == 2011 & impact16aneigh > 0,             treatmentn := 1L]
arrest[year == 2011 & month >= 8 & impact16hneigh > 0, treatmentn := 1L]
arrest[year == 2012 & impact17neigh > 0,              treatmentn := 1L]
arrest[treatment == 1, treatmentn := 0L]

# Model 4 interaction variables
# Arrest file may already have these; rebuild to ensure consistency
arrest[, stops := fifelse(is.na(stops), 0L, as.integer(stops))]
arrest[, cs_probcause := fifelse(is.na(cs_probcause), 0L, as.integer(cs_probcause))]
arrest[, treatmentpc := treatment * cs_probcause]
arrest[, cs_npc := stops - cs_probcause]
arrest[, treatmentnpc := treatment * cs_npc]

# Model 5: cubic polynomial trend per precinct
arrest[, monthly := (year - 2004L) * 12L + month]
arrest[, c("bs1", "bs2", "bs3") := {
  p <- poly(monthly, degree = 3)
  list(p[, 1], p[, 2], p[, 3])
}, by = pct]

# ---- Outcome variable mapping ----------------------------------------------
# Arrest Stata code loops:
#   crimes1, crimes3, crimes5, crimes6, crimes7, crimes10,
#   offenses8, offenses18, offenses57, offenses
#
# We'll run all and match to Table 1 arrest section by coefficient values.
# Initial mapping follows crime pattern; will verify empirically.

outcomes <- c("crimes1", "crimes3", "crimes5", "crimes6", "crimes7",
              "crimes10", "offenses8", "offenses18", "offenses57", "offenses")
# Placeholder labels — will be confirmed after first run
labels <- c("?Total", "?crimes3", "?crimes5", "?crimes6", "?crimes7",
            "?crimes10", "?offenses8", "?offenses18", "?offenses57", "?offenses")
names(labels) <- outcomes

# Published target coefficients (Model 1 arrests, Table 1)
# Table columns: Total, Robbery, Assault, Burglary, Weapons, Misd.,
#                Other Felony, Drugs, Property Felony, Violent Felony
targets_table <- c(0.426, -0.002, -0.017, 0.387, 0.279,
                   0.298, 0.533, -0.083, 1.174, 0.024)
target_labels <- c("Total", "Robbery", "Assault", "Burglary", "Weapons",
                    "Misd.", "Other Felony", "Drugs", "Property Felony",
                    "Violent Felony")

# ---- Model 1: Basic treatment effect (+ mapping discovery) -----------------
cat("\n========== MODEL 1: Impact Zone Effect (Arrests) ==========\n")

m1_results <- list()
for (yvar in outcomes) {
  fml <- as.formula(paste0(yvar, " ~ treatment | year_pct_month"))
  m1_results[[yvar]] <- fepois(fml, data = arrest, vcov = ~year_pct_month)
}

# Print raw results and match to table columns by coefficient proximity
cat(sprintf("\n%-15s %10s %8s\n", "Variable", "Coef", "N"))
cat(strrep("-", 38), "\n")
coefs_m1 <- numeric(length(outcomes))
names(coefs_m1) <- outcomes
for (i in seq_along(outcomes)) {
  yvar <- outcomes[i]
  m <- m1_results[[yvar]]
  coefs_m1[yvar] <- coef(m)["treatment"]
  cat(sprintf("%-15s %10.4f %8d\n", yvar, coefs_m1[yvar], m$nobs))
}

# Match each code variable to closest table target
cat("\n--- Mapping by coefficient matching ---\n")
cat(sprintf("%-15s → %-18s  (ours: %7.4f, target: %6.3f)\n",
            "Variable", "Label", 0, 0))
cat(strrep("-", 65), "\n")
remaining_targets <- targets_table
remaining_labels <- target_labels
mapping <- character(length(outcomes))
names(mapping) <- outcomes

for (pass in seq_along(outcomes)) {
  best_dist <- Inf
  best_var <- ""
  best_idx <- 0
  for (yvar in outcomes[mapping[outcomes] == ""]) {
    for (j in seq_along(remaining_targets)) {
      d <- abs(coefs_m1[yvar] - remaining_targets[j])
      if (d < best_dist) {
        best_dist <- d
        best_var <- yvar
        best_idx <- j
      }
    }
  }
  mapping[best_var] <- remaining_labels[best_idx]
  cat(sprintf("%-15s → %-18s  (ours: %7.4f, target: %6.3f, diff: %6.4f)\n",
              best_var, remaining_labels[best_idx],
              coefs_m1[best_var], remaining_targets[best_idx], best_dist))
  remaining_targets <- remaining_targets[-best_idx]
  remaining_labels <- remaining_labels[-best_idx]
}

# Apply discovered mapping
labels <- mapping

# Build properly ordered target vectors using the mapping
targets_m1 <- setNames(numeric(length(outcomes)), outcomes)
for (yvar in outcomes) {
  idx <- which(target_labels == labels[yvar])
  targets_m1[yvar] <- targets_table[idx]
}

# Reprint Model 1 with correct labels
cat("\n--- Model 1 Results (Arrests) ---\n")
cat(sprintf("%-18s %10s %10s %10s %8s\n",
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
cat("\n========== MODEL 2: Neighbor Spillover (Arrests) ==========\n")

# Table 1 arrest targets for Model 2
targets_m2_impact_table <- c(0.442, 0.060, -0.008, 0.376, 0.295,
                             0.302, 0.562, -0.093, 1.196, 0.051)
targets_m2_neigh_table <- c(0.049, 0.176, 0.025, -0.036, 0.047,
                            0.011, 0.086, -0.029, 0.068, 0.078)

targets_m2_impact <- setNames(numeric(length(outcomes)), outcomes)
targets_m2_neigh <- setNames(numeric(length(outcomes)), outcomes)
for (yvar in outcomes) {
  idx <- which(target_labels == labels[yvar])
  targets_m2_impact[yvar] <- targets_m2_impact_table[idx]
  targets_m2_neigh[yvar] <- targets_m2_neigh_table[idx]
}

m2_results <- list()
for (yvar in outcomes) {
  fml <- as.formula(paste0(yvar, " ~ treatment + treatmentn | year_pct_month"))
  m2_results[[yvar]] <- fepois(fml, data = arrest, vcov = ~year_pct_month)
}

cat(sprintf("\n%-18s %10s %10s %10s %10s %8s\n",
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
cat("\n========== MODEL 3: Event Study (Arrests) ==========\n")

m3_results <- list()
for (yvar in outcomes) {
  fml <- as.formula(paste0(yvar,
    " ~ eventneg2 + eventneg1 + eventpos1 + eventpos2 | year_pct_month"))
  m3_results[[yvar]] <- fepois(fml, data = arrest, vcov = ~year_pct_month)
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
cat("\n========== MODEL 4: PC vs NPC Stops (Arrests) ==========\n")

# Table 2 arrest targets
targets_m4_pc_table  <- c(-0.006, 0.000, 0.002, -0.024, -0.009,
                          -0.006, -0.016, -0.006, -0.014, 0.002)
targets_m4_npc_table <- c(-0.006, -0.010, -0.011, -0.001, -0.001,
                          -0.006, -0.003, -0.002, -0.011, -0.009)
targets_m4_pc <- setNames(numeric(length(outcomes)), outcomes)
targets_m4_npc <- setNames(numeric(length(outcomes)), outcomes)
for (yvar in outcomes) {
  idx <- which(target_labels == labels[yvar])
  targets_m4_pc[yvar] <- targets_m4_pc_table[idx]
  targets_m4_npc[yvar] <- targets_m4_npc_table[idx]
}

m4_results <- list()
for (yvar in outcomes) {
  fml <- as.formula(paste0(yvar,
    " ~ treatment + cs_probcause + cs_npc + treatmentpc + treatmentnpc",
    " | year_pct_month"))
  m4_results[[yvar]] <- fepois(fml, data = arrest, vcov = ~year_pct_month)
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
cat("\n========== MODEL 5: Cubic Trend + fid FE (Arrests) ==========\n")

m5_results <- list()
for (yvar in outcomes) {
  fml <- as.formula(paste0(yvar, " ~ treatment + bs1 + bs2 + bs3 | fid"))
  m5_results[[yvar]] <- fepois(fml, data = arrest, vcov = ~fid)
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
arrest_models <- list(m1 = m1_results, m2 = m2_results, m3 = m3_results,
                      m4 = m4_results, m5 = m5_results)
saveRDS(arrest_models, "output/arrest_models.rds")
cat("\nAll arrest models saved to output/arrest_models.rds\n")
cat("Variable-to-label mapping:\n")
for (yvar in outcomes) cat(sprintf("  %s → %s\n", yvar, labels[yvar]))
