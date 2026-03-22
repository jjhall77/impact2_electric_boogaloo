# 16_spillover.R
# PHASE 4: Spillover / Adjacency Analysis
#
# 4A: TWFE spillover — already done in R/13_twfe.R Model C (reference only)
# 4B: dCDH on never-treated hexes using treatmentn as treatment
#     Estimates causal spillover ATT separately from direct treatment

library(data.table)
Sys.setenv(RGL_USE_NULL = "TRUE")
library(polars)
suppressWarnings(suppressMessages(library(DIDmultiplegtDYN)))

cat("Loading quarterly panel...\n")
qdt <- readRDS("data/panel_quarterly_analysis.rds")

# ---- 4B: dCDH spillover on never-treated hexes ----
cat("\n========== 4B: dCDH SPILLOVER (never-treated hexes) ==========\n")

# Restrict to hexes that are never directly treated
qdt_ctrl <- qdt[ever_treated == 0]
cat(sprintf("  Never-treated hexes: %d\n", uniqueN(qdt_ctrl$hex_num)))
cat(sprintf("  Neighbor-treated hex-quarters: %d\n", sum(qdt_ctrl$treatmentn)))

# Check for switching in treatmentn
n_switch <- qdt_ctrl[, .(switches = sum(abs(diff(treatmentn)))), by = hex_num][switches > 0, .N]
cat(sprintf("  Hexes with treatmentn switching: %d\n", n_switch))

outcomes <- c("violent", "property", "robbery", "felony_assault", "burglary",
              "robbery_outside", "felony_assault_outside", "burglary_outside")
labels <- c("Violent Felony", "Property Felony", "Robbery", "Felony Assault",
            "Burglary", "Robbery (Outside)", "F. Assault (Outside)",
            "Burglary (Outside)")
names(labels) <- outcomes

spill_results <- list()
for (yvar in outcomes) {
  cat(sprintf("\n--- Spillover dCDH: %s ---\n", labels[yvar]))

  tryCatch({
    res <- did_multiplegt_dyn(
      df = as.data.frame(qdt_ctrl),
      outcome = yvar,
      group = "hex_num",
      time = "qid",
      treatment = "treatmentn",
      effects = 6,
      placebo = 3,
      graph_off = TRUE,
      cluster = "hex_num"
    )
    spill_results[[yvar]] <- res

    if (!is.null(res$overall_att)) {
      cat(sprintf("  Spillover ATT: %.4f (SE: %.4f)\n",
                  res$overall_att, res$se_overall_att))
    }
  }, error = function(e) {
    cat(sprintf("  ERROR: %s\n", e$message))
    spill_results[[yvar]] <<- list(error = e$message)
  })
}

# Summary
cat("\n\n========== SPILLOVER SUMMARY ==========\n")
cat(sprintf("%-22s %10s %10s %10s\n", "Outcome", "Spill ATT", "SE", "Direction"))
cat(strrep("-", 55), "\n")
for (yvar in outcomes) {
  res <- spill_results[[yvar]]
  if (!is.null(res$overall_att)) {
    dir <- ifelse(res$overall_att < 0, "Diffusion", "Displacement")
    cat(sprintf("%-22s %10.4f %10.4f %10s\n",
                labels[yvar], res$overall_att, res$se_overall_att, dir))
  }
}

saveRDS(spill_results, "output/spillover_dcdh_results.rds")
cat("\nSaved output/spillover_dcdh_results.rds\n")
