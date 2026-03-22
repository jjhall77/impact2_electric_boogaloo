# 14_cs.R
# PHASE 2: Callaway & Sant'Anna
# Known limitation: absorbing treatment assumption.
# Run on quarterly panel for computational tractability.
#
# Outcomes: violent, property, robbery, felony_assault, burglary,
#           robbery_outside, felony_assault_outside, burglary_outside

library(data.table)
library(did)
library(ggplot2)

cat("Loading quarterly panel...\n")
qdt <- readRDS("data/panel_quarterly_analysis.rds")

# ---- Build cohort variable (first treated quarter) ----
# C&S needs a cohort = first period treated, 0 for never-treated
first_treat <- qdt[treatment == 1, .(cohort_qid = min(qid)), by = hex_num]
qdt <- merge(qdt, first_treat, by = "hex_num", all.x = TRUE)
qdt[is.na(cohort_qid), cohort_qid := 0L]

cat(sprintf("  Never-treated: %d hexes\n", qdt[cohort_qid == 0, uniqueN(hex_num)]))
cat(sprintf("  Ever-treated:  %d hexes\n", qdt[cohort_qid > 0, uniqueN(hex_num)]))
cat(sprintf("  Cohorts: %s\n", paste(sort(unique(qdt[cohort_qid > 0]$cohort_qid)),
                                      collapse = ", ")))

outcomes <- c("violent", "property", "robbery", "felony_assault", "burglary",
              "robbery_outside", "felony_assault_outside", "burglary_outside")
labels <- c("Violent Felony", "Property Felony", "Robbery", "Felony Assault",
            "Burglary", "Robbery (Outside)", "F. Assault (Outside)",
            "Burglary (Outside)")
names(labels) <- outcomes

# ---- Run C&S for each outcome ----
cs_results <- list()

for (yvar in outcomes) {
  cat(sprintf("\n--- C&S: %s ---\n", labels[yvar]))

  tryCatch({
    att <- att_gt(
      yname = yvar,
      tname = "qid",
      idname = "hex_num",
      gname = "cohort_qid",
      data = as.data.frame(qdt),
      control_group = "nevertreated",
      est_method = "reg",
      base_period = "universal"
    )

    # Overall ATT
    agg_simple <- aggte(att, type = "simple")
    cat(sprintf("  Overall ATT: %.4f (SE: %.4f, p: %.4f)\n",
                agg_simple$overall.att, agg_simple$overall.se,
                2 * pnorm(-abs(agg_simple$overall.att / agg_simple$overall.se))))

    # Dynamic (event study)
    agg_dynamic <- aggte(att, type = "dynamic", min_e = -8, max_e = 12)

    # Calendar time (for regime comparison)
    agg_calendar <- tryCatch(aggte(att, type = "calendar"), error = function(e) NULL)

    cs_results[[yvar]] <- list(
      att_gt = att,
      simple = agg_simple,
      dynamic = agg_dynamic,
      calendar = agg_calendar
    )

    # Plot event study
    png(sprintf("output/cs_es_%s.png", yvar), width = 800, height = 500)
    p <- ggdid(agg_dynamic) +
      ggtitle(paste("C&S Event Study:", labels[yvar])) +
      geom_hline(yintercept = 0, linetype = "dashed", color = "red")
    print(p)
    dev.off()

  }, error = function(e) {
    cat(sprintf("  ERROR: %s\n", e$message))
    cs_results[[yvar]] <<- list(error = e$message)
  })
}

# ---- Summary table ----
cat("\n\n========== C&S OVERALL ATT SUMMARY ==========\n")
cat(sprintf("%-22s %10s %10s %10s\n", "Outcome", "ATT", "SE", "p-value"))
cat(strrep("-", 55), "\n")
for (yvar in outcomes) {
  res <- cs_results[[yvar]]
  if (!is.null(res$simple)) {
    att <- res$simple$overall.att
    se  <- res$simple$overall.se
    p   <- 2 * pnorm(-abs(att / se))
    cat(sprintf("%-22s %10.4f %10.4f %10.4f\n", labels[yvar], att, se, p))
  } else {
    cat(sprintf("%-22s %10s\n", labels[yvar], "FAILED"))
  }
}

# ---- Save ----
saveRDS(cs_results, "output/cs_results.rds")
cat("\nAll C&S results saved to output/cs_results.rds\n")
