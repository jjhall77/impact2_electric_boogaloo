# 17_sqf_dose.R
# PHASE 5: Probable Cause SQF Interactions
#
# 5A: TWFE dose-response — already in R/13_twfe.R Model D (reference only)
# 5B: dCDH with SQF controls
# 5C: Era-specific TWFE dose-response

library(data.table)
library(fixest)
Sys.setenv(RGL_USE_NULL = "TRUE")
library(polars)
suppressWarnings(suppressMessages(library(DIDmultiplegtDYN)))

cat("Loading panels...\n")
dt  <- readRDS("data/panel_analysis.rds")
qdt <- readRDS("data/panel_quarterly_analysis.rds")

# Helper: extract ATT, SE from dCDH result (v2.3+ API)
get_att <- function(res) {
  if (!is.null(res$results$ATE)) {
    list(att = res$results$ATE[1, "Estimate"],
         se  = res$results$ATE[1, "SE"])
  } else {
    list(att = NA, se = NA)
  }
}

dt[, hex_id := as.factor(hex_id)]
dt[, pct_ym := as.factor(pct_ym)]

outcomes <- c("violent", "property", "robbery", "felony_assault", "burglary",
              "robbery_outside", "felony_assault_outside", "burglary_outside",
              "assault_total", "assault_total_outside")
labels <- c("Violent Felony", "Property Felony", "Robbery", "Felony Assault",
            "Burglary", "Robbery (Outside)", "F. Assault (Outside)",
            "Burglary (Outside)", "Assault (All Types)", "Assault (All, Outside)")
names(labels) <- outcomes

# ==============================================================================
# 5B: dCDH with SQF controls
# ==============================================================================
cat("\n========== 5B: dCDH WITH SQF CONTROLS ==========\n")

dcdh_ctrl <- list()
for (yvar in outcomes) {
  cat(sprintf("--- %s: ", labels[yvar]))

  tryCatch({
    res <- did_multiplegt_dyn(
      df = as.data.frame(qdt),
      outcome = yvar,
      group = "hex_num",
      time = "qid",
      treatment = "treatment",
      effects = 8,
      placebo = 4,
      controls = c("sqf_pc", "sqf_npc"),
      graph_off = TRUE,
      cluster = "hex_num"
    )
    dcdh_ctrl[[yvar]] <- res

    r <- get_att(res)
    if (!is.na(r$att)) {
      cat(sprintf("ATT=%.4f (SE=%.4f)\n", r$att, r$se))
    }
  }, error = function(e) {
    cat(sprintf("ERROR: %s\n", e$message))
    dcdh_ctrl[[yvar]] <<- list(error = e$message)
  })
}

# Compare with and without controls
cat("\n--- Comparing dCDH ATT: without vs with SQF controls ---\n")
dcdh_full <- readRDS("output/dcdh_full_results.rds")

cat(sprintf("%-22s %12s %12s %12s\n",
            "Outcome", "No Controls", "With SQF", "Diff"))
cat(strrep("-", 60), "\n")
for (yvar in outcomes) {
  r_no  <- get_att(dcdh_full[[yvar]])
  r_yes <- get_att(dcdh_ctrl[[yvar]])
  diff_val <- if (!is.na(r_no$att) & !is.na(r_yes$att)) r_yes$att - r_no$att else NA
  cat(sprintf("%-22s %12.4f %12.4f %12.4f\n",
              labels[yvar],
              ifelse(is.na(r_no$att), NA, r_no$att),
              ifelse(is.na(r_yes$att), NA, r_yes$att),
              ifelse(is.na(diff_val), NA, diff_val)))
}
cat("If 'With SQF' ATT remains similar → presence effect beyond enforcement\n")

saveRDS(dcdh_ctrl, "output/dcdh_sqf_controlled_results.rds")

# ==============================================================================
# 5C: Era-specific TWFE dose-response
# ==============================================================================
cat("\n========== 5C: ERA-SPECIFIC TWFE DOSE-RESPONSE ==========\n")

# Era 1: High SQF (through 2012-03)
dt_era1 <- dt[year_month <= "2012-03"]
# Era 2: Low SQF (2013-07 through 2015-06)
dt_era2 <- dt[year_month >= "2013-07" & year_month <= "2015-06"]

for (era_name in c("Era 1: High SQF", "Era 2: Low SQF")) {
  cat(sprintf("\n--- %s ---\n", era_name))
  era_dt <- if (era_name == "Era 1: High SQF") dt_era1 else dt_era2

  cat(sprintf("%-22s %10s %10s %10s %10s\n",
              "Outcome", "Treat", "PC*Treat", "NPC*Treat", "N"))
  cat(strrep("-", 60), "\n")

  for (yvar in outcomes) {
    fml <- as.formula(paste0(yvar,
      " ~ treatment + sqf_pc + sqf_npc + treatmentpc + treatmentnpc | hex_id + pct_ym"))
    tryCatch({
      m <- fepois(fml, data = era_dt, vcov = ~pct_ym)
      cc <- coef(m)
      cat(sprintf("%-22s %10.4f %10.4f %10.4f %10s\n",
                  labels[yvar],
                  cc["treatment"],
                  cc["treatmentpc"],
                  cc["treatmentnpc"],
                  format(m$nobs, big.mark = ",")))
    }, error = function(e) {
      cat(sprintf("%-22s %10s\n", labels[yvar], "FAILED"))
    })
  }
}

cat("\nPhase 5 complete.\n")
