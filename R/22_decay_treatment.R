# 22_decay_treatment.R
# ROBUSTNESS: Residual deterrence — treatment with decay
#
# If crime stays suppressed for a few quarters after a zone shuts off,
# the sharp 1→0 treatment switch overstates the counterfactual.
# We test this by:
#   (A) Coding treatment with exponential decay after switch-off
#   (B) Event study around zone dissolution (July 2015) to see timing of rebound
#
# For (A), we use dCDH with a modified treatment that decays:
#   t=0 (active): treatment = 1
#   t=1 after off: 0.5
#   t=2 after off: 0.25
#   t=3+ after off: 0
#
# Note: dCDH requires binary treatment, so we can't use continuous decay directly.
# Instead we test the SENSITIVITY of results to different "treatment lingers" definitions:
#   Linger 0: treatment = 1 only when active (baseline)
#   Linger 1: treatment = 1 for 1 quarter after zone deactivates
#   Linger 2: treatment = 1 for 2 quarters after
#
# If results are robust across linger definitions, residual deterrence
# doesn't meaningfully affect our estimates.

library(data.table)
library(jsonlite)
library(fixest)
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

cat("Loading data...\n")
dt <- readRDS("data/panel_analysis.rds")
qdt_orig <- readRDS("data/panel_quarterly_analysis.rds")

outcomes <- c("violent", "property", "robbery", "felony_assault", "burglary",
              "robbery_outside", "felony_assault_outside", "burglary_outside")
labels <- c("Violent Felony", "Property Felony", "Robbery", "Felony Assault",
            "Burglary", "Robbery (Outside)", "F. Assault (Outside)",
            "Burglary (Outside)")
names(labels) <- outcomes

# ==============================================================================
# PART A: Treatment linger sensitivity
# ==============================================================================

# Build lingered treatment at monthly level, then aggregate to quarterly
for (linger_q in c(1, 2)) {
  linger_m <- linger_q * 3  # months

  cat(sprintf("\n========== BUILDING LINGER-%d TREATMENT (%d months) ==========\n",
              linger_q, linger_m))

  # For each hex, find the off-switches and extend treatment
  dt_l <- copy(dt)
  setkey(dt_l, hex_id, time_id)

  # Group by hex, compute lingered treatment
  dt_l[, treat_linger := treatment]
  hex_ids <- unique(dt_l[ever_treated == 1, hex_id])

  for (hid in hex_ids) {
    idx <- which(dt_l$hex_id == hid)
    trt <- dt_l$treatment[idx]
    n <- length(trt)

    # Find off-switches: treatment goes from 1 to 0
    lingered <- trt
    for (i in 2:n) {
      if (trt[i] == 0 & any(trt[max(1, i - linger_m):(i-1)] == 1)) {
        # Check if within linger window of last ON
        last_on <- max(which(trt[1:(i-1)] == 1))
        if (i - last_on <= linger_m) {
          lingered[i] <- 1L
        }
      }
    }
    dt_l$treat_linger[idx] <- lingered
  }

  cat(sprintf("  Original treatment-ON: %s\n", format(sum(dt_l$treatment), big.mark = ",")))
  cat(sprintf("  Lingered treatment-ON: %s\n", format(sum(dt_l$treat_linger), big.mark = ",")))
  cat(sprintf("  Added hex-months: %s\n",
              format(sum(dt_l$treat_linger) - sum(dt_l$treatment), big.mark = ",")))

  # Aggregate to quarterly
  dt_l[, quarter := ceiling(month / 3)]
  dt_l[, yq := year * 10L + quarter]

  outcome_cols <- c("violent", "property", "robbery", "felony_assault", "burglary",
                    "robbery_outside", "felony_assault_outside", "burglary_outside",
                    "sqf_total", "sqf_pc", "sqf_npc",
                    "arrests_total", "arrests_felony", "arrests_misdemeanor",
                    "arrests_violation")

  qdt_l <- dt_l[, c(
    lapply(.SD, sum),
    list(
      treatment = as.integer(any(treat_linger == 1)),
      treatmentn = as.integer(any(treatmentn == 1)),
      ever_treated = first(ever_treated),
      precinct = first(precinct)
    )
  ), by = .(hex_id, hex_num, year, quarter, yq),
    .SDcols = outcome_cols]

  qmap <- data.table(yq = sort(unique(qdt_l$yq)))
  qmap[, qid := .I]
  qdt_l <- merge(qdt_l, qmap, by = "yq")
  setkey(qdt_l, hex_num, qid)

  cat(sprintf("  Quarterly treatment-ON: %d (was %d)\n",
              sum(qdt_l$treatment), sum(qdt_orig$treatment)))

  # Run dCDH
  cat(sprintf("\n--- dCDH with linger-%d treatment ---\n", linger_q))
  linger_results <- list()
  for (yvar in outcomes) {
    cat(sprintf("  %s: ", labels[yvar]))
    tryCatch({
      res <- did_multiplegt_dyn(
        df = as.data.frame(qdt_l),
        outcome = yvar,
        group = "hex_num",
        time = "qid",
        treatment = "treatment",
        effects = 8,
        placebo = 4,
        graph_off = TRUE,
        cluster = "hex_num"
      )
      linger_results[[yvar]] <- res
      r <- get_att(res)
      if (!is.na(r$att)) cat(sprintf("ATT=%.4f (SE=%.4f)\n", r$att, r$se))
      else cat("no ATT\n")
    }, error = function(e) {
      cat(sprintf("ERROR: %s\n", e$message))
      linger_results[[yvar]] <<- list(error = e$message)
    })
  }

  saveRDS(linger_results, sprintf("output/dcdh_linger%d_results.rds", linger_q))
}

# ==============================================================================
# PART B: Dissolution event study (TWFE)
# ==============================================================================
cat("\n========== DISSOLUTION EVENT STUDY ==========\n")
cat("  Event: July 2015 (program dissolved)\n")
cat("  Window: ±8 quarters around Q3 2015 (qid 39)\n")

# Use ever_treated × relative time
dissolution_qid <- 39  # Q3 2015

qdt_es <- copy(qdt_orig)
qdt_es[, rel_time := qid - dissolution_qid]
qdt_es[, ever_treated_f := factor(ever_treated)]

# Restrict to ±8 quarters
qdt_es <- qdt_es[abs(rel_time) <= 8]

# Create relative time dummies interacted with ever_treated
# Reference period: rel_time = -1
qdt_es[, rel_f := factor(rel_time)]
qdt_es[, hex_id_f := factor(hex_id)]
qdt_es[, pct_yq := factor(paste0(precinct, "_", yq))]

cat("  Running event studies...\n")
es_results <- list()
for (yvar in outcomes) {
  cat(sprintf("  %s: ", labels[yvar]))
  fml <- as.formula(paste0(yvar, " ~ i(rel_f, ever_treated, ref = -1) | hex_id_f + pct_yq"))
  tryCatch({
    m <- fepois(fml, data = qdt_es, vcov = ~pct_yq)
    es_results[[yvar]] <- m

    # Extract post-dissolution coefficients (rel_time >= 0)
    cc <- coeftable(m)
    post_coefs <- cc[grepl("rel_f::[0-9]", rownames(cc)), ]
    if (nrow(post_coefs) > 0) {
      avg_post <- mean(post_coefs[, "Estimate"])
      cat(sprintf("avg post-dissolution = %.4f\n", avg_post))
    }
  }, error = function(e) {
    cat(sprintf("ERROR: %s\n", e$message))
  })
}

saveRDS(es_results, "output/dissolution_es_results.rds")

# Print event study coefficients
cat("\n--- Dissolution Event Study Coefficients ---\n")
cat(sprintf("%-5s", "RelQ"))
for (yvar in outcomes) cat(sprintf(" %10s", labels[yvar]))
cat("\n")
cat(strrep("-", 5 + 11 * length(outcomes)), "\n")

for (rt in -8:8) {
  if (rt == -1) {
    cat(sprintf("%-5d", rt))
    for (yvar in outcomes) cat(sprintf(" %10s", "[ref]"))
    cat("\n")
    next
  }
  cat(sprintf("%-5d", rt))
  for (yvar in outcomes) {
    m <- es_results[[yvar]]
    if (is.null(m)) { cat(sprintf(" %10s", "N/A")); next }
    cc <- coeftable(m)
    rname <- sprintf("rel_f::%d:ever_treated", rt)
    if (rname %in% rownames(cc)) {
      est <- cc[rname, "Estimate"]
      se  <- cc[rname, "Std. Error"]
      sig <- ifelse(abs(est/se) > 1.96, "*", ifelse(abs(est/se) > 1.645, "+", " "))
      cat(sprintf(" %9.3f%s", est, sig))
    } else {
      cat(sprintf(" %10s", "---"))
    }
  }
  cat("\n")
}

# ==============================================================================
# COMPARISON: Linger sensitivity
# ==============================================================================
cat("\n\n========== LINGER SENSITIVITY COMPARISON ==========\n")
dcdh_base <- readRDS("output/dcdh_full_results.rds")
linger1 <- readRDS("output/dcdh_linger1_results.rds")
linger2 <- readRDS("output/dcdh_linger2_results.rds")

cat(sprintf("%-22s %12s %12s %12s\n",
            "Outcome", "Baseline", "Linger-1Q", "Linger-2Q"))
cat(strrep("-", 60), "\n")

for (yvar in outcomes) {
  fmt <- function(r) {
    if (is.na(r$att)) return(sprintf("%12s", "N/A"))
    sig <- ifelse(abs(r$att / r$se) > 1.96, "*",
           ifelse(abs(r$att / r$se) > 1.645, "+", " "))
    sprintf("%10.4f%s", r$att, sig)
  }
  r0 <- get_att(dcdh_base[[yvar]])
  r1 <- get_att(linger1[[yvar]])
  r2 <- get_att(linger2[[yvar]])
  cat(sprintf("%-22s %12s %12s %12s\n", labels[yvar], fmt(r0), fmt(r1), fmt(r2)))
}

cat("\nResidual deterrence analysis complete.\n")
