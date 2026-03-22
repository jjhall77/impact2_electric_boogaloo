# 23_robustness_spatial.R
# Spatial robustness:
#   (A) Area-overlap treatment (50% threshold instead of centroid-in-polygon)
#   (B) H3 resolution 8 (built by python/09_build_res8_panel.py)
#
# Run AFTER python/08_area_overlap_treatment.py and python/09_build_res8_panel.py

library(data.table)
Sys.setenv(RGL_USE_NULL = "TRUE")
library(polars)
suppressWarnings(suppressMessages(library(DIDmultiplegtDYN)))

get_att <- function(res) {
  if (!is.null(res$results$ATE)) {
    list(att = res$results$ATE[1, "Estimate"],
         se  = res$results$ATE[1, "SE"])
  } else {
    list(att = NA, se = NA)
  }
}

outcomes <- c("violent", "property", "robbery", "felony_assault", "burglary",
              "robbery_outside", "felony_assault_outside", "burglary_outside")
labels <- c("Violent Felony", "Property Felony", "Robbery", "Felony Assault",
            "Burglary", "Robbery (Outside)", "F. Assault (Outside)",
            "Burglary (Outside)")
names(labels) <- outcomes

dcdh_base <- readRDS("output/dcdh_full_results.rds")

# ==============================================================================
# A: AREA-OVERLAP TREATMENT
# ==============================================================================

if (file.exists("data/hex_overlap_treatment.csv")) {
  cat("========== AREA-OVERLAP TREATMENT (50% threshold) ==========\n")

  # Load monthly panel and overlap treatment
  dt <- readRDS("data/panel_analysis.rds")
  ov <- fread("data/hex_overlap_treatment.csv")

  # Merge
  dt_ov <- merge(dt, ov[, .(hex_id, year_month, treatment_overlap50)],
                 by = c("hex_id", "year_month"), all.x = TRUE)
  dt_ov[is.na(treatment_overlap50), treatment_overlap50 := 0L]

  cat(sprintf("  Centroid treatment ON: %s\n", format(sum(dt_ov$treatment), big.mark = ",")))
  cat(sprintf("  Overlap50 treatment ON: %s\n", format(sum(dt_ov$treatment_overlap50), big.mark = ",")))
  cat(sprintf("  Agreement: %.1f%%\n",
              100 * sum(dt_ov$treatment == dt_ov$treatment_overlap50) / nrow(dt_ov)))

  # Override treatment
  dt_ov[, treatment := treatment_overlap50]

  # Quarterly aggregation
  dt_ov[, quarter := ceiling(month / 3)]
  dt_ov[, yq := year * 10L + quarter]

  outcome_cols <- c("violent", "property", "robbery", "felony_assault", "burglary",
                    "robbery_outside", "felony_assault_outside", "burglary_outside",
                    "sqf_total", "sqf_pc", "sqf_npc",
                    "arrests_total", "arrests_felony", "arrests_misdemeanor",
                    "arrests_violation")

  qdt_ov <- dt_ov[, c(
    lapply(.SD, sum),
    list(
      treatment = as.integer(any(treatment == 1)),
      ever_treated = first(ever_treated),
      precinct = first(precinct)
    )
  ), by = .(hex_id, hex_num, year, quarter, yq),
    .SDcols = outcome_cols]

  qmap <- data.table(yq = sort(unique(qdt_ov$yq)))
  qmap[, qid := .I]
  qdt_ov <- merge(qdt_ov, qmap, by = "yq")
  setkey(qdt_ov, hex_num, qid)

  cat(sprintf("  Quarterly panel: %s rows, %d hex-q treated\n",
              format(nrow(qdt_ov), big.mark = ","), sum(qdt_ov$treatment)))

  # Run dCDH
  ov_results <- list()
  for (yvar in outcomes) {
    cat(sprintf("  %s: ", labels[yvar]))
    tryCatch({
      res <- did_multiplegt_dyn(
        df = as.data.frame(qdt_ov),
        outcome = yvar,
        group = "hex_num",
        time = "qid",
        treatment = "treatment",
        effects = 8,
        placebo = 4,
        graph_off = TRUE,
        cluster = "hex_num"
      )
      ov_results[[yvar]] <- res
      r <- get_att(res)
      if (!is.na(r$att)) cat(sprintf("ATT=%.4f (SE=%.4f)\n", r$att, r$se))
      else cat("no ATT\n")
    }, error = function(e) {
      cat(sprintf("ERROR: %s\n", e$message))
      ov_results[[yvar]] <<- list(error = e$message)
    })
  }
  saveRDS(ov_results, "output/dcdh_overlap_results.rds")
} else {
  cat("SKIP: data/hex_overlap_treatment.csv not found\n")
  cat("  Run python/08_area_overlap_treatment.py first\n")
  ov_results <- NULL
}

# ==============================================================================
# B: H3 RESOLUTION 8
# ==============================================================================

if (file.exists("data/panel_hex_res8_analysis.csv")) {
  cat("\n========== H3 RESOLUTION 8 ==========\n")

  dt8 <- fread("data/panel_hex_res8_analysis.csv")
  cat(sprintf("  %s rows, %d hexes\n", format(nrow(dt8), big.mark = ","),
              uniqueN(dt8$hex_id)))

  # Quarterly aggregation
  dt8[, quarter := ceiling(month / 3)]
  dt8[, yq := year * 10L + quarter]

  outcome_cols8 <- intersect(outcomes, names(dt8))

  qdt8 <- dt8[, c(
    lapply(.SD, sum),
    list(
      treatment = as.integer(any(treatment == 1)),
      ever_treated = first(ever_treated),
      precinct = first(precinct)
    )
  ), by = .(hex_id, hex_num, year, quarter, yq),
    .SDcols = outcome_cols8]

  qmap8 <- data.table(yq = sort(unique(qdt8$yq)))
  qmap8[, qid := .I]
  qdt8 <- merge(qdt8, qmap8, by = "yq")
  setkey(qdt8, hex_num, qid)

  cat(sprintf("  Quarterly: %s rows, %d treated hex-q\n",
              format(nrow(qdt8), big.mark = ","), sum(qdt8$treatment)))

  res8_results <- list()
  for (yvar in outcome_cols8) {
    cat(sprintf("  %s: ", labels[yvar]))
    tryCatch({
      res <- did_multiplegt_dyn(
        df = as.data.frame(qdt8),
        outcome = yvar,
        group = "hex_num",
        time = "qid",
        treatment = "treatment",
        effects = 8,
        placebo = 4,
        graph_off = TRUE,
        cluster = "hex_num"
      )
      res8_results[[yvar]] <- res
      r <- get_att(res)
      if (!is.na(r$att)) cat(sprintf("ATT=%.4f (SE=%.4f)\n", r$att, r$se))
      else cat("no ATT\n")
    }, error = function(e) {
      cat(sprintf("ERROR: %s\n", e$message))
      res8_results[[yvar]] <<- list(error = e$message)
    })
  }
  saveRDS(res8_results, "output/dcdh_res8_results.rds")
} else {
  cat("\nSKIP: data/panel_hex_res8_analysis.csv not found\n")
  cat("  Run python/09_build_res8_panel.py first\n")
  res8_results <- NULL
}

# ==============================================================================
# COMPARISON
# ==============================================================================
cat("\n\n========== SPATIAL ROBUSTNESS COMPARISON ==========\n")
cat(sprintf("%-22s %12s %12s %12s\n",
            "Outcome", "Baseline", "Overlap50", "Res-8"))
cat(strrep("-", 60), "\n")

for (yvar in outcomes) {
  fmt <- function(r) {
    if (is.null(r) || is.na(r$att)) return(sprintf("%12s", "N/A"))
    sig <- ifelse(abs(r$att / r$se) > 1.96, "*",
           ifelse(abs(r$att / r$se) > 1.645, "+", " "))
    sprintf("%10.4f%s", r$att, sig)
  }
  r0 <- get_att(dcdh_base[[yvar]])
  r1 <- if (!is.null(ov_results)) get_att(ov_results[[yvar]]) else list(att = NA, se = NA)
  r2 <- if (!is.null(res8_results)) get_att(res8_results[[yvar]]) else list(att = NA, se = NA)
  cat(sprintf("%-22s %12s %12s %12s\n", labels[yvar], fmt(r0), fmt(r1), fmt(r2)))
}

cat("\nSpatial robustness complete.\n")
