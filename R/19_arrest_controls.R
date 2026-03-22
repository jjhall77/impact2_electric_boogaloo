# 19_arrest_controls.R
# PHASE 5D: dCDH with arrest controls — parallel to SQF controls test
#
# If crime ATT survives conditioning on arrest intensity,
# arrests aren't the mechanism either → presence effect confirmed
# via a second enforcement channel.
#
# Three specs:
#   (1) No controls (from saved results)
#   (2) Arrest controls only: arrests_felony + arrests_misd_viol
#   (3) Kitchen sink: sqf_pc + sqf_npc + arrests_felony + arrests_misd_viol

library(data.table)
Sys.setenv(RGL_USE_NULL = "TRUE")
library(polars)
suppressWarnings(suppressMessages(library(DIDmultiplegtDYN)))

# Helper: extract ATT, SE from dCDH result (v2.3+ API)
get_att <- function(res) {
  if (!is.null(res$results$ATE)) {
    list(att = res$results$ATE[1, "Estimate"],
         se  = res$results$ATE[1, "SE"],
         ci_lo = res$results$ATE[1, "LB CI"],
         ci_hi = res$results$ATE[1, "UB CI"],
         p_joint = res$results$p_jointeffects,
         p_placebo = res$results$p_jointplacebo)
  } else {
    list(att = NA, se = NA, ci_lo = NA, ci_hi = NA, p_joint = NA, p_placebo = NA)
  }
}

cat("Loading quarterly panel...\n")
qdt <- readRDS("data/panel_quarterly_analysis.rds")
setkey(qdt, hex_num, qid)

# Create combined misd + violation arrest variable
qdt[, arrests_misd_viol := arrests_misdemeanor + arrests_violation]

cat(sprintf("  arrests_misd_viol: mean=%.2f, max=%d\n",
            mean(qdt$arrests_misd_viol), max(qdt$arrests_misd_viol)))

# Crime outcomes
outcomes <- c("violent", "property", "robbery", "felony_assault", "burglary",
              "robbery_outside", "felony_assault_outside", "burglary_outside")
labels <- c("Violent Felony", "Property Felony", "Robbery", "Felony Assault",
            "Burglary", "Robbery (Outside)", "F. Assault (Outside)",
            "Burglary (Outside)")
names(labels) <- outcomes

# Load baseline (no controls) results
cat("Loading baseline dCDH results...\n")
dcdh_base <- readRDS("output/dcdh_full_results.rds")

# Load SQF-controlled results
dcdh_sqf <- readRDS("output/dcdh_sqf_controlled_results.rds")

# ==============================================================================
# SPEC 2: dCDH with arrest controls
# ==============================================================================
cat("\n========== dCDH WITH ARREST CONTROLS ==========\n")
cat("  Controls: arrests_felony, arrests_misd_viol\n\n")

dcdh_arr <- list()
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
      controls = c("arrests_felony", "arrests_misd_viol"),
      graph_off = TRUE,
      cluster = "hex_num"
    )
    dcdh_arr[[yvar]] <- res

    r <- get_att(res)
    if (!is.na(r$att)) {
      cat(sprintf("ATT=%.4f (SE=%.4f)\n", r$att, r$se))
    }
  }, error = function(e) {
    cat(sprintf("ERROR: %s\n", e$message))
    dcdh_arr[[yvar]] <<- list(error = e$message)
  })
}

saveRDS(dcdh_arr, "output/dcdh_arrest_controlled_results.rds")

# ==============================================================================
# SPEC 3: Kitchen sink — SQF + arrests
# ==============================================================================
cat("\n========== dCDH WITH ALL ENFORCEMENT CONTROLS ==========\n")
cat("  Controls: sqf_pc, sqf_npc, arrests_felony, arrests_misd_viol\n\n")

dcdh_all <- list()
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
      controls = c("sqf_pc", "sqf_npc", "arrests_felony", "arrests_misd_viol"),
      graph_off = TRUE,
      cluster = "hex_num"
    )
    dcdh_all[[yvar]] <- res

    r <- get_att(res)
    if (!is.na(r$att)) {
      cat(sprintf("ATT=%.4f (SE=%.4f)\n", r$att, r$se))
    }
  }, error = function(e) {
    cat(sprintf("ERROR: %s\n", e$message))
    dcdh_all[[yvar]] <<- list(error = e$message)
  })
}

saveRDS(dcdh_all, "output/dcdh_all_enforcement_controlled_results.rds")

# ==============================================================================
# COMPARISON TABLE
# ==============================================================================
cat("\n\n========== TREATMENT EFFECTS CONDITIONAL ON ENFORCEMENT ==========\n")
cat(sprintf("%-22s %10s %10s %10s %10s\n",
            "Outcome", "Baseline", "+SQF", "+Arrests", "+All"))
cat(strrep("-", 65), "\n")

for (yvar in outcomes) {
  r0 <- get_att(dcdh_base[[yvar]])
  r1 <- get_att(dcdh_sqf[[yvar]])
  r2 <- get_att(dcdh_arr[[yvar]])
  r3 <- get_att(dcdh_all[[yvar]])

  fmt <- function(r) {
    if (is.na(r$att)) return(sprintf("%10s", "N/A"))
    sig <- ifelse(abs(r$att / r$se) > 1.96, "*",
           ifelse(abs(r$att / r$se) > 1.645, "+", " "))
    sprintf("%9.3f%s", r$att, sig)
  }

  cat(sprintf("%-22s %10s %10s %10s %10s\n",
              labels[yvar], fmt(r0), fmt(r1), fmt(r2), fmt(r3)))
}
cat("* p < 0.05; + p < 0.10\n")

# Semi-elasticity version (ATT / treated mean)
cat("\n\n========== SEMI-ELASTICITIES (% of treated mean) ==========\n")
cat(sprintf("%-22s %10s %10s %10s %10s %10s\n",
            "Outcome", "Trt Mean", "Baseline", "+SQF", "+Arrests", "+All"))
cat(strrep("-", 75), "\n")

for (yvar in outcomes) {
  trt_mean <- mean(qdt[treatment == 1, get(yvar)])

  r0 <- get_att(dcdh_base[[yvar]])
  r1 <- get_att(dcdh_sqf[[yvar]])
  r2 <- get_att(dcdh_arr[[yvar]])
  r3 <- get_att(dcdh_all[[yvar]])

  pct <- function(r) {
    if (is.na(r$att)) return(sprintf("%10s", "N/A"))
    val <- (r$att / trt_mean) * 100
    sig <- ifelse(abs(r$att / r$se) > 1.96, "*",
           ifelse(abs(r$att / r$se) > 1.645, "+", " "))
    sprintf("%8.1f%%%s", val, sig)
  }

  cat(sprintf("%-22s %10.2f %10s %10s %10s %10s\n",
              labels[yvar], trt_mean, pct(r0), pct(r1), pct(r2), pct(r3)))
}
cat("* p < 0.05; + p < 0.10\n")

# ==============================================================================
# DESCRIPTIVE: Arrest patterns by regime × treatment
# ==============================================================================
cat("\n\n========== ARREST PATTERNS BY REGIME × TREATMENT ==========\n")

dt <- readRDS("data/panel_analysis.rds")

# Define regimes
dt[, regime := fifelse(year_month <= "2012-03", "1_HighSQF",
               fifelse(year_month >= "2013-07" & year_month <= "2015-06", "2_LowSQF",
               fifelse(year_month >= "2015-07", "3_Post", "Transition")))]

desc <- dt[regime != "Transition",
           .(felony_arr = mean(arrests_felony),
             misd_arr   = mean(arrests_misdemeanor),
             viol_arr   = mean(arrests_violation),
             misd_viol  = mean(arrests_misdemeanor + arrests_violation),
             sqf        = mean(sqf_total),
             n_hexmonths = .N),
           by = .(regime, treated = fifelse(treatment == 1, "Treated", "Control"))]

setorder(desc, regime, -treated)

cat(sprintf("\n%-12s %-10s %8s %8s %8s %8s %8s %10s\n",
            "Regime", "Group", "Fel.Arr", "Misd.Arr", "Viol.Arr", "M+V Arr", "SQF", "N"))
cat(strrep("-", 80), "\n")
for (i in seq_len(nrow(desc))) {
  r <- desc[i]
  cat(sprintf("%-12s %-10s %8.3f %8.3f %8.3f %8.3f %8.2f %10s\n",
              r$regime, r$treated,
              r$felony_arr, r$misd_arr, r$viol_arr, r$misd_viol,
              r$sqf, format(r$n_hexmonths, big.mark = ",")))
}

cat("\nPhase 5D complete.\n")
