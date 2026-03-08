# 06_staggered_dd.R
# Phase 3a: Staggered difference-in-differences extensions
#
# Tests whether the original TWFE Poisson results are robust to
# heterogeneous treatment effects across cohorts.
#
# Methods:
#   1. Sun & Abraham (2021) — interaction-weighted estimator via fixest::sunab()
#   2. Goodman-Bacon (2021) — TWFE decomposition via bacondecomp::bacon()
#   3. Callaway & Sant'Anna (2021) — group-time ATTs via did::att_gt()
#
# Panel construction:
#   - Aggregated from incident-level to fid × quarter (summing across precincts)
#   - Balanced panel with zeros for missing fid×quarter cells
#   - 36 quarterly periods: 2004Q1 through 2012Q4
#   - Cohorts defined by activation quarter (9 annual cohorts, Jan of each year)
#   - Linear models (standard in staggered-DD literature)

library(data.table)
library(fixest)
library(ggplot2)
library(did)
library(bacondecomp)

dir.create("output", showWarnings = FALSE)

# ==============================================================================
# 1. Build fid-level balanced quarterly panel
# ==============================================================================

cat("Loading raw crime data...\n")
crime_raw <- fread("data-raw/blocks2004_2012_crime_fid_impactzones.csv",
                   na.strings = c("", "NA", "."))
crime_raw[, ym := year * 100L + month]
crime_raw[, quarter := (month - 1L) %/% 3L + 1L]
crime_raw[, yq := year * 10L + quarter]  # e.g., 20041, 20042, ...

# Outcome columns
outcome_cols <- c("crimes1", "offenses47", "offenses15", "offenses7",
                  "crimes10", "crimes7", "crimes6", "crimes5",
                  "crimes3", "offenses")
olabels <- c("Total", "Robbery", "Assault", "Burglary", "Weapons",
             "Misd.", "Other Felony", "Drugs", "Property Felony",
             "Violent Felony")
names(olabels) <- outcome_cols

# --- Zone activation dates → annual cohorts ---
zone_cols <- c("impact3", "impact4", "impact5", "impact6", "impact7",
               "impact8", "impact9", "impact10", "impact11", "impact12",
               "impact13", "impact14", "impact15", "impact16_a",
               "impact16_h", "impact17")
act_yms <- c(200401L, 200501L, 200507L, 200601L, 200606L,
             200701L, 200707L, 200801L, 200807L, 200901L,
             200907L, 201001L, 201008L, 201101L, 201108L, 201201L)

# Assign cohort per fid (earliest zone activation, consolidated to Q1)
fid_zones <- crime_raw[, lapply(.SD, max, na.rm = TRUE),
                       by = fid, .SDcols = zone_cols]
fid_zones[, cohort_ym := 0L]
for (i in seq_along(zone_cols)) {
  z <- zone_cols[i]
  act <- act_yms[i]
  fid_zones[get(z) > 0 & (cohort_ym == 0L | act < cohort_ym), cohort_ym := act]
}
# Annual cohort → first quarter of activation year
fid_zones[, cohort_yr := fifelse(cohort_ym == 0L, 0L, cohort_ym %/% 100L)]
fid_zones[, cohort_yq := fifelse(cohort_yr == 0L, 0L, cohort_yr * 10L + 1L)]
fid_cohort <- fid_zones[, .(fid, cohort_yq)]

cat("\nAnnual cohort distribution (0 = never-treated):\n")
print(fid_cohort[, .N, by = cohort_yq][order(cohort_yq)])

# --- Aggregate outcomes to fid × quarter ---
agg <- crime_raw[, lapply(.SD, sum, na.rm = TRUE),
                 by = .(fid, yq), .SDcols = outcome_cols]

all_fids <- sort(unique(crime_raw$fid))
all_yqs  <- sort(unique(crime_raw$yq))

# Free raw data memory
rm(crime_raw, fid_zones)
gc(verbose = FALSE)

# --- Create balanced quarterly panel ---
n_fids   <- length(all_fids)
n_periods <- length(all_yqs)

cat("\nCreating balanced panel:", n_fids, "fids x",
    n_periods, "quarters =", n_fids * n_periods, "rows\n")

panel <- CJ(fid = all_fids, yq = all_yqs)
panel <- merge(panel, agg, by = c("fid", "yq"), all.x = TRUE)
for (col in outcome_cols) {
  panel[is.na(get(col)), (col) := 0L]
}

# Time index (1, ..., 36)
yq_map <- data.table(yq = all_yqs, time_idx = seq_along(all_yqs))
panel <- merge(panel, yq_map, by = "yq")

# Cohort
panel <- merge(panel, fid_cohort, by = "fid", all.x = TRUE)
panel[is.na(cohort_yq), cohort_yq := 0L]

# Cohort as time index
yq_to_idx <- setNames(yq_map$time_idx, as.character(yq_map$yq))
panel[, cohort_idx := fifelse(
  cohort_yq == 0L, 0L,
  as.integer(yq_to_idx[as.character(cohort_yq)])
)]

# Binary treatment (post × treated)
panel[, treat_post := fifelse(cohort_yq > 0L & yq >= cohort_yq, 1L, 0L)]

setorder(panel, fid, yq)

n_cohorts <- uniqueN(panel[cohort_yq > 0]$cohort_yq)
cat("Panel ready:", nrow(panel), "rows\n")
cat("  Never-treated:", uniqueN(panel[cohort_yq == 0]$fid), "fids\n")
cat("  Ever-treated:", uniqueN(panel[cohort_yq > 0]$fid), "fids\n")
cat("  Distinct cohorts:", n_cohorts, "\n")
cat("  Treat rate:", round(mean(panel$treat_post), 4), "\n\n")


# ==============================================================================
# 2. TWFE OLS baseline
# ==============================================================================

cat("========== TWFE OLS BASELINE ==========\n")
twfe_ols <- feols(crimes1 ~ treat_post | fid + time_idx,
                  data = panel, vcov = ~fid)
cat("TWFE OLS (crimes1):  coef =", round(coef(twfe_ols)["treat_post"], 4),
    " SE =", round(se(twfe_ols)["treat_post"], 4),
    " N =", twfe_ols$nobs, "\n")
cat("(Poisson TWFE from Phase 1: -0.122)\n\n")


# ==============================================================================
# 3. Sun & Abraham (2021) — fixest::sunab()
# ==============================================================================
# Interaction-weighted estimator using never-treated as controls.
# With 9 cohorts × 36 periods → ~315 interaction terms (tractable).

cat("========== SUN & ABRAHAM (2021) ==========\n")

# sunab convention: never-treated = large number
panel[, cohort_sa := fifelse(cohort_idx == 0L, 10000L, cohort_idx)]

sa_keys <- c("crimes1", "offenses47", "offenses")
sa_results <- list()

for (yvar in sa_keys) {
  cat("  Running:", olabels[yvar], "... ")
  fml <- as.formula(paste0(
    yvar, " ~ sunab(cohort_sa, time_idx, ref.p = c(.F, -1)) | fid + time_idx"
  ))
  sa_results[[yvar]] <- tryCatch(
    feols(fml, data = panel, vcov = ~fid),
    error = function(e) { cat("Error:", e$message, "\n"); NULL }
  )
  if (!is.null(sa_results[[yvar]])) cat("done\n")
}

# Print aggregate ATTs
cat("\nSun & Abraham aggregate ATTs:\n")
cat(sprintf("%-18s %10s %10s %15s\n", "Outcome", "SA_ATT", "SE", "Poisson_TWFE"))
cat(strrep("-", 57), "\n")
twfe_targets <- c(crimes1 = -0.122, offenses47 = -0.156, offenses = -0.120)
for (yvar in sa_keys) {
  if (!is.null(sa_results[[yvar]])) {
    sa_agg <- summary(sa_results[[yvar]], agg = "ATT")
    cat(sprintf("%-18s %10.4f %10.4f %15.3f\n",
                olabels[yvar], sa_agg$coeftable[1, 1], sa_agg$coeftable[1, 2],
                twfe_targets[yvar]))
  }
}

# Event study plots
cat("\nGenerating Sun & Abraham event study plots...\n")
for (yvar in sa_keys) {
  if (!is.null(sa_results[[yvar]])) {
    png(paste0("output/sunab_", yvar, ".png"), width = 800, height = 500, res = 100)
    iplot(sa_results[[yvar]], ref.line = -1,
          main = paste("Sun & Abraham (2021):", olabels[yvar]),
          xlab = "Quarters relative to treatment",
          ylab = "Estimated effect")
    abline(h = 0, lty = 2, col = "gray50")
    dev.off()
    cat("  Saved: output/sunab_", yvar, ".png\n", sep = "")
  }
}


# ==============================================================================
# 4. Goodman-Bacon (2021) decomposition
# ==============================================================================
# Decomposes TWFE OLS into 2×2 DD sub-estimates. Shows whether forbidden
# comparisons (already-treated as controls) bias the overall estimate.

cat("\n========== GOODMAN-BACON (2021) ==========\n")
# Full panel (6274 fids) is too slow for bacon(). Use a 25% stratified
# subsample: all ever-treated fids + a random sample of never-treated.
# This preserves the treatment composition and gives a representative
# decomposition in a fraction of the time.
set.seed(123)
treated_fids   <- unique(panel[cohort_yq > 0]$fid)
untreated_fids <- unique(panel[cohort_yq == 0]$fid)
sample_ut      <- sample(untreated_fids, min(length(untreated_fids),
                          length(treated_fids)))  # match N
bacon_fids     <- c(treated_fids, sample_ut)
panel_bacon    <- panel[fid %in% bacon_fids]
cat("Bacon subsample:", uniqueN(panel_bacon$fid), "fids (",
    length(treated_fids), "treated +", length(sample_ut), "untreated)\n")

bacon_out <- tryCatch({
  df_bacon <- as.data.frame(panel_bacon[, .(fid, time_idx, crimes1, treat_post)])
  bacon(crimes1 ~ treat_post, data = df_bacon,
        id_var = "fid", time_var = "time_idx")
}, error = function(e) { cat("Error:", e$message, "\n"); NULL })
rm(panel_bacon)

if (!is.null(bacon_out)) {
  bacon_dt <- as.data.table(bacon_out)
  cat("\nBacon decomposition by comparison type:\n")
  type_summ <- bacon_dt[, .(
    n = .N,
    avg_est = round(weighted.mean(estimate, abs(weight)), 4),
    total_wt = round(sum(weight), 4)
  ), by = type]
  print(type_summ)
  cat("\nWeighted average (= TWFE OLS):",
      round(weighted.mean(bacon_out$estimate, bacon_out$weight), 4), "\n")

  png("output/bacon_decomp.png", width = 800, height = 500, res = 100)
  p <- ggplot(bacon_out, aes(x = weight, y = estimate,
                             shape = type, color = type)) +
    geom_point(alpha = 0.7, size = 2) +
    geom_hline(yintercept = coef(twfe_ols)["treat_post"],
               linetype = "dashed", linewidth = 0.5) +
    annotate("text", x = max(bacon_out$weight) * 0.8,
             y = coef(twfe_ols)["treat_post"],
             label = paste("TWFE =", round(coef(twfe_ols)["treat_post"], 3)),
             vjust = -0.5, size = 3) +
    labs(title = "Goodman-Bacon (2021) Decomposition: Total Crime",
         x = "Weight", y = "2x2 DD Estimate",
         shape = "Comparison", color = "Comparison") +
    theme_minimal(base_size = 11) +
    theme(legend.position = "bottom",
          legend.title = element_text(size = 9))
  print(p)
  dev.off()
  cat("Saved: output/bacon_decomp.png\n")
}


# ==============================================================================
# 5. Callaway & Sant'Anna (2021)
# ==============================================================================
# Group-time ATTs using never-treated as controls. Avoids forbidden
# comparisons. The earliest cohort (Q1 2004) is dropped by C&S because
# it lacks pre-treatment data.

cat("\n========== CALLAWAY & SANT'ANNA (2021) ==========\n")
cat("Running group-time ATT estimation for crimes1...\n")
set.seed(42)

cs_out <- tryCatch({
  att_gt(
    yname = "crimes1",
    tname = "time_idx",
    idname = "fid",
    gname = "cohort_idx",
    data = as.data.frame(panel),
    control_group = "nevertreated",
    est_method = "reg",
    base_period = "universal"
  )
}, error = function(e) { cat("Error:", e$message, "\n"); NULL })

if (!is.null(cs_out)) {
  # Overall ATT
  cs_overall <- aggte(cs_out, type = "simple")
  cat("\nCallaway & Sant'Anna overall ATT (crimes1):\n")
  cat("  ATT =", round(cs_overall$overall.att, 4),
      " SE =", round(cs_overall$overall.se, 4), "\n")

  # Dynamic event study
  cs_dynamic <- aggte(cs_out, type = "dynamic", min_e = -8, max_e = 8)

  png("output/cs_event_study.png", width = 800, height = 500, res = 100)
  p <- ggdid(cs_dynamic,
             title = "Callaway & Sant'Anna (2021): Total Crime",
             xlab = "Quarters relative to treatment",
             ylab = "ATT")
  print(p)
  dev.off()
  cat("Saved: output/cs_event_study.png\n")

  # Group-specific ATTs
  cs_group <- aggte(cs_out, type = "group")
  cat("\nGroup-specific ATTs:\n")
  cat(sprintf("%-12s %10s %10s\n", "Cohort", "ATT", "SE"))
  cat(strrep("-", 34), "\n")
  for (j in seq_along(cs_group$egt)) {
    cidx <- cs_group$egt[j]
    cyr <- if (cidx >= 1 && cidx <= length(all_yqs)) {
      all_yqs[cidx] %/% 10
    } else cidx
    cat(sprintf("%-12s %10.4f %10.4f\n",
                cyr, cs_group$att.egt[j], cs_group$se.egt[j]))
  }
}


# ==============================================================================
# 6. Summary comparison
# ==============================================================================

cat("\n\n")
cat("================================================================\n")
cat("  SUMMARY: Total Crime (crimes1) — Estimator Comparison\n")
cat("================================================================\n\n")
cat(sprintf("%-35s %10s %10s\n", "Estimator", "ATT", "SE"))
cat(strrep("-", 57), "\n")

cat(sprintf("%-35s %10s %10s\n",
            "Poisson TWFE (Phase 1, raw data)", "-0.122", "0.052"))

cat(sprintf("%-35s %10.4f %10.4f\n", "Linear TWFE (OLS, quarterly)",
            coef(twfe_ols)["treat_post"], se(twfe_ols)["treat_post"]))

if (!is.null(sa_results[["crimes1"]])) {
  sa_agg <- summary(sa_results[["crimes1"]], agg = "ATT")
  cat(sprintf("%-35s %10.4f %10.4f\n", "Sun & Abraham (2021)",
              sa_agg$coeftable[1, 1], sa_agg$coeftable[1, 2]))
}

if (!is.null(cs_out)) {
  cat(sprintf("%-35s %10.4f %10.4f\n", "Callaway & Sant'Anna (2021)",
              cs_overall$overall.att, cs_overall$overall.se))
}

cat("\n")


# ==============================================================================
# 7. Save results
# ==============================================================================

staggered_results <- list(
  twfe_ols = twfe_ols,
  sun_abraham = sa_results,
  bacon = bacon_out,
  callaway_santanna = cs_out,
  panel_info = list(
    n_fids = n_fids,
    n_periods = n_periods,
    n_cohorts = n_cohorts,
    n_never_treated = uniqueN(panel[cohort_yq == 0]$fid),
    n_ever_treated = uniqueN(panel[cohort_yq > 0]$fid),
    cohort_table = fid_cohort[, .N, by = cohort_yq][order(cohort_yq)]
  )
)
saveRDS(staggered_results, "output/staggered_dd_results.rds")
cat("Results saved to output/staggered_dd_results.rds\n")
cat("Done.\n")
