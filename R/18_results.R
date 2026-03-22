# 18_results.R
# PHASE 6: Results Compilation & MacDonald Comparability
#
# Builds comparison tables across all methods:
# - Table 1: MacDonald comparison (semi-elasticities)
# - Table 2: Regime comparison (dCDH era-specific ATTs)
# - Table 3: Spillover (direct vs spillover ATT)
# - Table 4: All crime vs outside crime

library(data.table)
library(fixest)

cat("Loading results...\n")
twfe     <- readRDS("output/twfe_results.rds")
cs       <- readRDS("output/cs_results.rds")
dcdh     <- readRDS("output/dcdh_full_results.rds")
dcdh_era <- readRDS("output/dcdh_era_results.rds")

outcomes <- c("violent", "property", "robbery", "felony_assault", "burglary",
              "robbery_outside", "felony_assault_outside", "burglary_outside")
labels <- c("Violent Felony", "Property Felony", "Robbery", "Felony Assault",
            "Burglary", "Robbery (Outside)", "F. Assault (Outside)",
            "Burglary (Outside)")
names(labels) <- outcomes

# Load quarterly panel for control group means (needed to convert dCDH to semi-elasticity)
qdt <- readRDS("data/panel_quarterly_analysis.rds")
ctrl_means <- qdt[ever_treated == 0, lapply(.SD, mean), .SDcols = outcomes]

semi_elast <- function(b) (exp(b) - 1) * 100

# ---- MacDonald published results (Table 1 Model 1) ----
# Only the outcomes we can compare:
# MacDonald: Violent Felony = -0.120, Property Felony = -0.296,
#            Robbery = -0.157, Assault = -0.131, Burglary = -0.611
macdonald_m1 <- c(violent = -0.120, property = -0.296,
                  robbery = -0.157, felony_assault = -0.131, burglary = -0.611)

# ==============================================================================
# TABLE 1: MacDonald Comparison
# ==============================================================================
cat("\n\n")
cat("================================================================\n")
cat("TABLE 1: TREATMENT EFFECT COMPARISON (semi-elasticities, %%)\n")
cat("================================================================\n")
cat(sprintf("%-22s %10s %10s %10s %10s\n",
            "Outcome", "MacDonald", "TWFE Hex", "C&S", "dCDH"))
cat(strrep("-", 65), "\n")

for (yvar in outcomes) {
  # MacDonald (only for crime outcomes that match)
  mac <- if (yvar %in% names(macdonald_m1)) {
    sprintf("%9.1f%%", semi_elast(macdonald_m1[yvar]))
  } else "      ---"

  # TWFE
  twfe_b <- coef(twfe$baseline[[yvar]])["treatment"]
  twfe_pct <- sprintf("%9.1f%%", semi_elast(twfe_b))

  # C&S (ATT in levels → semi-elasticity via control mean)
  cs_val <- if (!is.null(cs[[yvar]]$simple)) {
    cs_att <- cs[[yvar]]$simple$overall.att
    cs_pct <- (cs_att / as.numeric(ctrl_means[[yvar]])) * 100
    sprintf("%9.1f%%", cs_pct)
  } else "     FAIL"

  # dCDH (ATT in levels → semi-elasticity via control mean)
  dcdh_val <- if (!is.null(dcdh[[yvar]]) && !is.null(dcdh[[yvar]]$results)) {
    dcdh_pct <- (dcdh[[yvar]]$results$ATE[1] / as.numeric(ctrl_means[[yvar]])) * 100
    sprintf("%9.1f%%", dcdh_pct)
  } else "      N/A"

  cat(sprintf("%-22s %10s %10s %10s %10s\n",
              labels[yvar], mac, twfe_pct, cs_val, dcdh_val))
}

cat("\nNote: MacDonald used census blocks (2004-2012); ours use H3 hexes (2006-2016).\n")
cat("C&S assumes absorbing treatment. dCDH handles switching.\n")
cat("Semi-elasticities: MacDonald/TWFE = (exp(beta)-1)*100; C&S/dCDH = (ATT/mean_control)*100.\n")

# ==============================================================================
# TABLE 2: Regime Comparison (dCDH era-specific)
# ==============================================================================
cat("\n\n")
cat("================================================================\n")
cat("TABLE 2: REGIME COMPARISON (dCDH era-specific ATTs)\n")
cat("================================================================\n")
cat(sprintf("%-22s %12s %12s %12s\n",
            "Outcome", "High SQF", "Low SQF", "Post"))
cat(strrep("-", 60), "\n")

# Also include TWFE three-regime for comparison
cat("--- dCDH ---\n")
for (yvar in outcomes) {
  vals <- character(3)
  for (i in 1:3) {
    era <- list(dcdh_era$era1, dcdh_era$era2, dcdh_era$era3)[[i]]
    res <- era[[yvar]]
    if (!is.null(res) && !is.null(res$results)) {
      att <- res$results$ATE[1]; se <- res$results$ATE[2]
      sig <- ifelse(abs(att / se) > 1.96, "*", " ")
      pct <- (att / as.numeric(ctrl_means[[yvar]])) * 100
      vals[i] <- sprintf("%6.1f%%%s", pct, sig)
    } else {
      vals[i] <- "      N/A"
    }
  }
  cat(sprintf("%-22s %12s %12s %12s\n", labels[yvar], vals[1], vals[2], vals[3]))
}

cat("\n--- TWFE (for reference) ---\n")
for (yvar in outcomes) {
  m <- twfe$three_regime[[yvar]]
  cc <- coef(m)
  cat(sprintf("%-22s %11.1f%% %11.1f%% %11.1f%%\n",
              labels[yvar],
              semi_elast(cc["regime_high_sqf"]),
              semi_elast(cc["regime_low_sqf"]),
              semi_elast(cc["regime_post"])))
}

# ==============================================================================
# TABLE 3: Spillover
# ==============================================================================
cat("\n\n")
cat("================================================================\n")
cat("TABLE 3: DIRECT vs SPILLOVER EFFECTS\n")
cat("================================================================\n")

# MacDonald M2 neighbor coefficients (published)
mac_neigh <- c(violent = -0.026, property = -0.111,
               robbery = 0.050, felony_assault = -0.049, burglary = -0.158)

cat(sprintf("%-22s %10s %10s %10s %10s\n",
            "Outcome", "TWFE Dir%", "TWFE Spill%", "Mac Spill", "dCDH Spill"))
cat(strrep("-", 65), "\n")

spill_dcdh <- tryCatch(readRDS("output/spillover_dcdh_results.rds"), error = function(e) NULL)

for (yvar in outcomes) {
  # TWFE spillover
  m <- twfe$spillover[[yvar]]
  cc <- coef(m)
  dir_pct  <- sprintf("%9.1f%%", semi_elast(cc["treatment"]))
  spill_pct <- sprintf("%9.1f%%", semi_elast(cc["treatmentn"]))

  # MacDonald
  mac_s <- if (yvar %in% names(mac_neigh)) {
    sprintf("%9.3f", mac_neigh[yvar])
  } else "      ---"

  # dCDH spillover
  dcdh_s <- if (!is.null(spill_dcdh) && !is.null(spill_dcdh[[yvar]]) &&
                !is.null(spill_dcdh[[yvar]]$results)) {
    sprintf("%9.4f", spill_dcdh[[yvar]]$results$ATE[1])
  } else "      N/A"

  cat(sprintf("%-22s %10s %10s %10s %10s\n",
              labels[yvar], dir_pct, spill_pct, mac_s, dcdh_s))
}

# ==============================================================================
# TABLE 4: All Crime vs Outside Crime
# ==============================================================================
cat("\n\n")
cat("================================================================\n")
cat("TABLE 4: ALL CRIME vs OUTSIDE CRIME\n")
cat("================================================================\n")

pairs <- list(
  c("robbery", "robbery_outside"),
  c("felony_assault", "felony_assault_outside"),
  c("burglary", "burglary_outside")
)

cat(sprintf("%-18s %10s %10s %10s %10s\n",
            "Crime Type", "TWFE All%", "TWFE Out%", "dCDH All", "dCDH Out"))
cat(strrep("-", 60), "\n")

for (pair in pairs) {
  all_var <- pair[1]
  out_var <- pair[2]

  twfe_all <- semi_elast(coef(twfe$baseline[[all_var]])["treatment"])
  twfe_out <- semi_elast(coef(twfe$baseline[[out_var]])["treatment"])

  dcdh_all <- if (!is.null(dcdh[[all_var]]) && !is.null(dcdh[[all_var]]$results)) {
    sprintf("%9.4f", dcdh[[all_var]]$results$ATE[1])
  } else "      N/A"
  dcdh_out <- if (!is.null(dcdh[[out_var]]) && !is.null(dcdh[[out_var]]$results)) {
    sprintf("%9.4f", dcdh[[out_var]]$results$ATE[1])
  } else "      N/A"

  cat(sprintf("%-18s %9.1f%% %9.1f%% %10s %10s\n",
              labels[all_var], twfe_all, twfe_out, dcdh_all, dcdh_out))
}

# Save everything
results_tables <- list(
  macdonald_m1 = macdonald_m1,
  ctrl_means = ctrl_means,
  labels = labels
)
saveRDS(results_tables, "output/results_tables.rds")
cat("\nSaved output/results_tables.rds\n")
cat("Phase 6 complete.\n")
