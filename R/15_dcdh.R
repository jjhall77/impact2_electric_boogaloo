# 15_dcdh.R
# PHASE 3: de Chaisemartin & D'Haultfoeuille — primary specification
# Handles switching treatment. Quarterly panel.
#
# 3A: Full panel (2006-2016), all 8 outcomes + SQF + arrests
# 3B: Era-specific subpanels

library(data.table)
Sys.setenv(RGL_USE_NULL = "TRUE")
library(polars)
suppressWarnings(suppressMessages(library(DIDmultiplegtDYN)))

cat("Loading quarterly panel...\n")
qdt <- readRDS("data/panel_quarterly_analysis.rds")
setkey(qdt, hex_num, qid)

outcomes <- c("violent", "property", "robbery", "felony_assault", "burglary",
              "robbery_outside", "felony_assault_outside", "burglary_outside",
              "assault_total", "assault_total_outside")
labels <- c("Violent Felony", "Property Felony", "Robbery", "Felony Assault",
            "Burglary", "Robbery (Outside)", "F. Assault (Outside)",
            "Burglary (Outside)", "Assault (All Types)", "Assault (All, Outside)")
names(labels) <- outcomes

# Also run SQF and arrests
extra_outcomes <- c("sqf_total", "arrests_felony", "arrests_misdemeanor")
extra_labels   <- c("SQF Total", "Arrests (Felony)", "Arrests (Misd.)")
names(extra_labels) <- extra_outcomes

all_outcomes <- c(outcomes, extra_outcomes)
all_labels   <- c(labels, extra_labels)

# Helper: extract ATT, SE, p from dCDH result (v2.3+ API)
get_att <- function(res) {
  if (!is.null(res$results$ATE)) {
    list(att = res$results$ATE[1, "Estimate"],
         se  = res$results$ATE[1, "SE"],
         p_joint = res$results$p_jointeffects)
  } else {
    list(att = NA, se = NA, p_joint = NA)
  }
}

# Helper to extract event study data from dCDH result
extract_es <- function(res) {
  eff <- res$results$Effects[, "Estimate"]
  se_eff <- res$results$Effects[, "SE"]
  plc <- res$results$Placebos[, "Estimate"]
  se_plc <- res$results$Placebos[, "SE"]
  n_eff <- length(eff)
  n_plc <- length(plc)
  data.table(
    period = c(-n_plc:-1, 1:n_eff),
    estimate = c(rev(plc), eff),
    se = c(rev(se_plc), se_eff),
    ci_lo = c(rev(plc), eff) - 1.96 * c(rev(se_plc), se_eff),
    ci_hi = c(rev(plc), eff) + 1.96 * c(rev(se_plc), se_eff)
  )
}

# ==============================================================================
# 3A: FULL PANEL (2006-2016)
# ==============================================================================
cat("\n========== 3A: dCDH FULL PANEL ==========\n")

dcdh_full <- list()
for (yvar in all_outcomes) {
  cat(sprintf("\n--- dCDH: %s ---\n", all_labels[yvar]))

  tryCatch({
    res <- did_multiplegt_dyn(
      df = as.data.frame(qdt),
      outcome = yvar,
      group = "hex_num",
      time = "qid",
      treatment = "treatment",
      effects = 8,
      placebo = 4,
      graph_off = TRUE,
      cluster = "hex_num"
    )

    dcdh_full[[yvar]] <- res

    cat(sprintf("  Effects 1-8: %s\n",
                paste(sprintf("%.3f", res$results$Effects[, "Estimate"]), collapse = ", ")))
    cat(sprintf("  Placebos 1-4: %s\n",
                paste(sprintf("%.3f", res$results$Placebos[, "Estimate"]), collapse = ", ")))

    r <- get_att(res)
    if (!is.na(r$att)) {
      cat(sprintf("  Overall ATT: %.4f (SE: %.4f)\n", r$att, r$se))
    }

  }, error = function(e) {
    cat(sprintf("  ERROR: %s\n", e$message))
    dcdh_full[[yvar]] <<- list(error = e$message)
  })
}

# Summary table
cat("\n\n========== dCDH FULL PANEL SUMMARY ==========\n")
cat(sprintf("%-22s %10s %10s %10s\n", "Outcome", "ATT", "SE", "p (joint)"))
cat(strrep("-", 55), "\n")
for (yvar in all_outcomes) {
  res <- dcdh_full[[yvar]]
  r <- get_att(res)
  if (!is.na(r$att)) {
    cat(sprintf("%-22s %10.4f %10.4f %10.4f\n",
                all_labels[yvar], r$att, r$se,
                ifelse(is.na(r$p_joint), NA, r$p_joint)))
  }
}

# Save full results
saveRDS(dcdh_full, "output/dcdh_full_results.rds")
cat("\nSaved output/dcdh_full_results.rds\n")

# ==============================================================================
# 3B: ERA-SPECIFIC SUBPANELS
# ==============================================================================

run_era <- function(era_name, qdt_sub, n_effects, n_placebo) {
  cat(sprintf("\n========== dCDH ERA: %s ==========\n", era_name))

  # Re-index qid sequentially
  qmap_sub <- data.table(qid_orig = sort(unique(qdt_sub$qid)))
  qmap_sub[, qid_new := .I]
  qdt_sub <- merge(qdt_sub, qmap_sub, by.x = "qid", by.y = "qid_orig")
  qdt_sub[, qid := qid_new]
  qdt_sub[, qid_new := NULL]
  setkey(qdt_sub, hex_num, qid)

  cat(sprintf("  %s rows, %d hexes, %d quarters\n",
              format(nrow(qdt_sub), big.mark = ","),
              uniqueN(qdt_sub$hex_num), uniqueN(qdt_sub$qid)))
  cat(sprintf("  Treatment-ON: %d hex-quarters\n", sum(qdt_sub$treatment)))

  era_results <- list()
  for (yvar in outcomes) {  # just crime outcomes for eras
    cat(sprintf("  %s: ", labels[yvar]))

    tryCatch({
      res <- did_multiplegt_dyn(
        df = as.data.frame(qdt_sub),
        outcome = yvar,
        group = "hex_num",
        time = "qid",
        treatment = "treatment",
        effects = n_effects,
        placebo = n_placebo,
        graph_off = TRUE,
        cluster = "hex_num"
      )
      era_results[[yvar]] <- res

      r <- get_att(res)
      if (!is.na(r$att)) {
        cat(sprintf("ATT=%.4f (SE=%.4f)\n", r$att, r$se))
      } else {
        cat("no ATT\n")
      }
    }, error = function(e) {
      cat(sprintf("ERROR: %s\n", e$message))
      era_results[[yvar]] <<- list(error = e$message)
    })
  }
  return(era_results)
}

# Era 1: High SQF (2006 to Q1 2012) = qid 1 to 25
era1 <- run_era("HIGH SQF (2006-Q1 2012)",
                qdt[qid <= 25], n_effects = 4, n_placebo = 2)

# Era 2: Low SQF (Q3 2013 to Q2 2015) = qid 31 to 38
era2 <- run_era("LOW SQF (Q3 2013-Q2 2015)",
                qdt[qid >= 31 & qid <= 38], n_effects = 2, n_placebo = 2)

# Era 3: Post-dissolution (Q3 2015 to Q4 2016) = qid 39 to 44
# Use ever_treated as static treatment
qdt_era3 <- copy(qdt[qid >= 39])
qdt_era3[, treatment := ever_treated]  # static: were you ever an impact zone?
era3 <- run_era("POST-DISSOLUTION (Q3 2015-Q4 2016)",
                qdt_era3, n_effects = 2, n_placebo = 2)

# Save era results
dcdh_era <- list(era1 = era1, era2 = era2, era3 = era3)
saveRDS(dcdh_era, "output/dcdh_era_results.rds")
cat("\nSaved output/dcdh_era_results.rds\n")

# ---- Era comparison summary ----
cat("\n\n========== ERA COMPARISON SUMMARY ==========\n")
cat(sprintf("%-22s %12s %12s %12s\n",
            "Outcome", "High SQF", "Low SQF", "Post"))
cat(strrep("-", 60), "\n")
for (yvar in outcomes) {
  vals <- character(3)
  for (i in seq_along(list(era1, era2, era3))) {
    res <- list(era1, era2, era3)[[i]][[yvar]]
    r <- get_att(res)
    if (!is.na(r$att)) {
      sig <- ifelse(abs(r$att / r$se) > 1.96, "*", " ")
      vals[i] <- sprintf("%7.3f%s", r$att, sig)
    } else {
      vals[i] <- sprintf("%8s", "N/A")
    }
  }
  cat(sprintf("%-22s %12s %12s %12s\n", labels[yvar], vals[1], vals[2], vals[3]))
}
cat("* = p < 0.05\n")

cat("\nPhase 3 complete.\n")
