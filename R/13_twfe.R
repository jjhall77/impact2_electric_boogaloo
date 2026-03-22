# 13_twfe.R
# PHASE 1: TWFE sanity checks using fepois
#
# Models A-D on 8 outcomes:
#   violent, property, robbery, felony_assault, burglary,
#   robbery_outside, felony_assault_outside, burglary_outside
#
# All models: fepois(..., vcov = ~pct_ym) with | hex_id + pct_ym FE

library(data.table)
library(fixest)

cat("Loading monthly panel...\n")
dt <- readRDS("data/panel_analysis.rds")

# Ensure factor types for FE
dt[, hex_id := as.factor(hex_id)]
dt[, pct_ym := as.factor(pct_ym)]

outcomes <- c("violent", "property", "robbery", "felony_assault", "burglary",
              "robbery_outside", "felony_assault_outside", "burglary_outside")
labels  <- c("Violent Felony", "Property Felony", "Robbery", "Felony Assault",
             "Burglary", "Robbery (Outside)", "F. Assault (Outside)",
             "Burglary (Outside)")
names(labels) <- outcomes

# Helper: semi-elasticity from Poisson coef
semi_elast <- function(b) (exp(b) - 1) * 100

# ==============================================================================
# MODEL A: Baseline — Y ~ treatment | hex_id + pct_ym
# ==============================================================================
cat("\n========== MODEL A: BASELINE ==========\n")

mA <- list()
for (yvar in outcomes) {
  fml <- as.formula(paste0(yvar, " ~ treatment | hex_id + pct_ym"))
  mA[[yvar]] <- fepois(fml, data = dt, vcov = ~pct_ym)
}

cat(sprintf("\n%-22s %9s %9s %9s %10s\n",
            "Outcome", "Coef", "SE", "Semi-E%", "N"))
cat(strrep("-", 65), "\n")
for (yvar in outcomes) {
  m <- mA[[yvar]]
  b <- coef(m)["treatment"]
  s <- se(m)["treatment"]
  cat(sprintf("%-22s %9.4f %9.4f %9.1f%% %10s\n",
              labels[yvar], b, s, semi_elast(b),
              format(m$nobs, big.mark = ",")))
}

# ==============================================================================
# MODEL B: Three-Regime — Y ~ regime_high + regime_low + regime_post
# ==============================================================================
cat("\n========== MODEL B: THREE-REGIME ==========\n")

mB <- list()
for (yvar in outcomes) {
  fml <- as.formula(paste0(yvar,
    " ~ regime_high_sqf + regime_low_sqf + regime_post | hex_id + pct_ym"))
  mB[[yvar]] <- fepois(fml, data = dt, vcov = ~pct_ym)
}

cat(sprintf("\n%-22s %10s %10s %10s\n",
            "Outcome", "High SQF%", "Low SQF%", "Post%"))
cat(strrep("-", 55), "\n")
for (yvar in outcomes) {
  m <- mB[[yvar]]
  cc <- coef(m)
  cat(sprintf("%-22s %9.1f%% %9.1f%% %9.1f%%\n",
              labels[yvar],
              semi_elast(cc["regime_high_sqf"]),
              semi_elast(cc["regime_low_sqf"]),
              semi_elast(cc["regime_post"])))
}

# Print with SEs
cat("\nWith standard errors:\n")
cat(sprintf("%-22s %9s %9s %9s %9s %9s %9s\n",
            "Outcome", "High", "SE", "Low", "SE", "Post", "SE"))
cat(strrep("-", 80), "\n")
for (yvar in outcomes) {
  m <- mB[[yvar]]
  cc <- coef(m); ss <- se(m)
  cat(sprintf("%-22s %9.4f %9.4f %9.4f %9.4f %9.4f %9.4f\n",
              labels[yvar],
              cc["regime_high_sqf"], ss["regime_high_sqf"],
              cc["regime_low_sqf"],  ss["regime_low_sqf"],
              cc["regime_post"],     ss["regime_post"]))
}

# ==============================================================================
# MODEL C: Spillover — Y ~ treatment + treatmentn | hex_id + pct_ym
# ==============================================================================
cat("\n========== MODEL C: SPILLOVER ==========\n")

mC <- list()
for (yvar in outcomes) {
  fml <- as.formula(paste0(yvar, " ~ treatment + treatmentn | hex_id + pct_ym"))
  mC[[yvar]] <- fepois(fml, data = dt, vcov = ~pct_ym)
}

cat(sprintf("\n%-22s %9s %9s %9s %9s\n",
            "Outcome", "Direct%", "SE", "Spillover%", "SE"))
cat(strrep("-", 60), "\n")
for (yvar in outcomes) {
  m <- mC[[yvar]]
  cc <- coef(m); ss <- se(m)
  cat(sprintf("%-22s %9.1f%% %9.4f %9.1f%% %9.4f\n",
              labels[yvar],
              semi_elast(cc["treatment"]),  ss["treatment"],
              semi_elast(cc["treatmentn"]), ss["treatmentn"]))
}

# ==============================================================================
# MODEL D: Dose-Response (MacDonald M4 analog)
# Y ~ treatment + sqf_pc + sqf_npc + treatmentpc + treatmentnpc
# ==============================================================================
cat("\n========== MODEL D: DOSE-RESPONSE (PC vs NPC SQF) ==========\n")

mD <- list()
for (yvar in outcomes) {
  fml <- as.formula(paste0(yvar,
    " ~ treatment + sqf_pc + sqf_npc + treatmentpc + treatmentnpc | hex_id + pct_ym"))
  mD[[yvar]] <- fepois(fml, data = dt, vcov = ~pct_ym)
}

cat(sprintf("\n%-22s %10s %10s %10s %10s %10s\n",
            "Outcome", "Treat", "PC*Treat", "NPC*Treat", "PC", "NPC"))
cat(strrep("-", 78), "\n")
for (yvar in outcomes) {
  m <- mD[[yvar]]
  cc <- coef(m)
  cat(sprintf("%-22s %10.4f %10.4f %10.4f %10.4f %10.4f\n",
              labels[yvar],
              cc["treatment"], cc["treatmentpc"], cc["treatmentnpc"],
              cc["sqf_pc"], cc["sqf_npc"]))
}

cat("\nWith SEs:\n")
cat(sprintf("%-22s %9s %9s %9s %9s\n",
            "Outcome", "PC*Imp", "SE", "NPC*Imp", "SE"))
cat(strrep("-", 55), "\n")
for (yvar in outcomes) {
  m <- mD[[yvar]]
  cc <- coef(m); ss <- se(m)
  cat(sprintf("%-22s %9.4f %9.4f %9.4f %9.4f\n",
              labels[yvar],
              cc["treatmentpc"], ss["treatmentpc"],
              cc["treatmentnpc"], ss["treatmentnpc"]))
}

# ==============================================================================
# MODEL E: Event study around dissolution (2015-07)
# ==============================================================================
cat("\n========== MODEL E: EVENT STUDY (DISSOLUTION) ==========\n")

# Create relative month to 2015-07
dt[, rel_month := (year - 2015L) * 12L + (month - 7L)]

# Restrict to +/- 12 months and ever-treated hexes for clarity
es_dt <- dt[abs(rel_month) <= 12]

mE <- list()
es_outcomes <- c("violent", "property", "robbery", "felony_assault", "burglary")
for (yvar in es_outcomes) {
  fml <- as.formula(paste0(yvar,
    " ~ i(rel_month, ever_treated, ref = -1) | hex_id + pct_ym"))
  mE[[yvar]] <- fepois(fml, data = es_dt, vcov = ~pct_ym)
}

# Plot event studies
dir.create("output", showWarnings = FALSE)
for (yvar in es_outcomes) {
  png(sprintf("output/twfe_es_dissolution_%s.png", yvar),
      width = 800, height = 500)
  iplot(mE[[yvar]], main = paste("Event Study: Dissolution -", labels[yvar]),
        xlab = "Months relative to dissolution (July 2015)",
        ylab = "Coefficient")
  abline(h = 0, lty = 2, col = "red")
  dev.off()
}
cat("  Event study plots saved to output/twfe_es_dissolution_*.png\n")

# ==============================================================================
# Save all results
# ==============================================================================
twfe_results <- list(
  baseline = mA,
  three_regime = mB,
  spillover = mC,
  dose_response = mD,
  event_study = mE,
  labels = labels,
  outcomes = outcomes
)
saveRDS(twfe_results, "output/twfe_results.rds")
cat("\nAll TWFE results saved to output/twfe_results.rds\n")
