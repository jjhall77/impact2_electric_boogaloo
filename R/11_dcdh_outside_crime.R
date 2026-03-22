#!/usr/bin/env Rscript
# =============================================================================
# 11_dcdh_outside_crime.R
# dCDH did_multiplegt_dyn on OUTSIDE crime (visible to patrol officers)
# Same specification as 10_dcdh_hex_models.R but with outside crime outcomes
# =============================================================================

Sys.setenv(RGL_USE_NULL = "TRUE")
library(polars)
suppressWarnings(suppressMessages(library(DIDmultiplegtDYN)))
library(data.table)
library(ggplot2)

cat("Loading panel v3 (with outside crime)...\n")
panel <- fread("data/panel_hex_month_v3.csv")

cat(sprintf("Panel: %s rows, %s hexes\n",
            format(nrow(panel), big.mark = ","),
            uniqueN(panel$hex_id)))
cat(sprintf("  Violent outside total: %s\n", format(sum(panel$violent_outside), big.mark = ",")))
cat(sprintf("  Property outside total: %s\n", format(sum(panel$property_outside), big.mark = ",")))

# ---------------------------------------------------------------
# Aggregate to quarterly
# ---------------------------------------------------------------
cat("\nAggregating to quarterly...\n")
panel[, quarter := ceiling(month / 3)]
panel[, yq := year * 10 + quarter]

quarterly <- panel[, .(
  violent          = sum(violent),
  property         = sum(property),
  violent_outside  = sum(violent_outside),
  property_outside = sum(property_outside),
  treatment        = as.integer(any(treatment == 1))
), by = .(hex_id, hex_num, year, quarter, yq, precinct, ever_treated)]

quarter_map <- data.table(yq = sort(unique(quarterly$yq)))
quarter_map[, qid := .I]
quarterly <- merge(quarterly, quarter_map, by = "yq")

cat(sprintf("Quarterly: %s rows, %s quarters\n",
            format(nrow(quarterly), big.mark = ","),
            uniqueN(quarterly$qid)))

# =============================================================================
# FULL PANEL: VIOLENT OUTSIDE
# =============================================================================
cat("\n", strrep("=", 60), "\n")
cat("dCDH: VIOLENT CRIME (OUTSIDE ONLY) — Full Panel\n")
cat(strrep("=", 60), "\n\n")

dcdh_violent_out <- did_multiplegt_dyn(
  df        = as.data.frame(quarterly),
  outcome   = "violent_outside",
  group     = "hex_num",
  time      = "qid",
  treatment = "treatment",
  effects   = 8,
  placebo   = 4,
  cluster   = "hex_num",
  graph_off = TRUE,
  design    = NULL,
  save_sample = FALSE
)
cat("\nViolent outside results:\n")
print(summary(dcdh_violent_out))

# =============================================================================
# FULL PANEL: PROPERTY OUTSIDE
# =============================================================================
cat("\n", strrep("=", 60), "\n")
cat("dCDH: PROPERTY CRIME (OUTSIDE ONLY) — Full Panel\n")
cat(strrep("=", 60), "\n\n")

dcdh_property_out <- did_multiplegt_dyn(
  df        = as.data.frame(quarterly),
  outcome   = "property_outside",
  group     = "hex_num",
  time      = "qid",
  treatment = "treatment",
  effects   = 8,
  placebo   = 4,
  cluster   = "hex_num",
  graph_off = TRUE,
  design    = NULL,
  save_sample = FALSE
)
cat("\nProperty outside results:\n")
print(summary(dcdh_property_out))

# =============================================================================
# ERA 2 (2013+): VIOLENT OUTSIDE
# =============================================================================
cat("\n", strrep("=", 60), "\n")
cat("dCDH: VIOLENT OUTSIDE — Era 2 (2013-2016)\n")
cat(strrep("=", 60), "\n\n")

q_era2 <- quarterly[year >= 2013]
qmap2 <- data.table(qid_old = sort(unique(q_era2$qid)))
qmap2[, qid_new := .I]
q_era2 <- merge(q_era2, qmap2, by.x = "qid", by.y = "qid_old")
q_era2[, qid := qid_new]

dcdh_violent_out_era2 <- did_multiplegt_dyn(
  df        = as.data.frame(q_era2),
  outcome   = "violent_outside",
  group     = "hex_num",
  time      = "qid",
  treatment = "treatment",
  effects   = 4,
  placebo   = 2,
  cluster   = "hex_num",
  graph_off = TRUE,
  design    = NULL,
  save_sample = FALSE
)
cat("\nViolent outside Era 2 results:\n")
print(summary(dcdh_violent_out_era2))

# =============================================================================
# ERA 2 (2013+): PROPERTY OUTSIDE
# =============================================================================
cat("\n", strrep("=", 60), "\n")
cat("dCDH: PROPERTY OUTSIDE — Era 2 (2013-2016)\n")
cat(strrep("=", 60), "\n\n")

dcdh_property_out_era2 <- did_multiplegt_dyn(
  df        = as.data.frame(q_era2),
  outcome   = "property_outside",
  group     = "hex_num",
  time      = "qid",
  treatment = "treatment",
  effects   = 4,
  placebo   = 2,
  cluster   = "hex_num",
  graph_off = TRUE,
  design    = NULL,
  save_sample = FALSE
)
cat("\nProperty outside Era 2 results:\n")
print(summary(dcdh_property_out_era2))

# =============================================================================
# Save
# =============================================================================
results <- list(
  violent_outside_full      = dcdh_violent_out,
  property_outside_full     = dcdh_property_out,
  violent_outside_era2      = dcdh_violent_out_era2,
  property_outside_era2     = dcdh_property_out_era2,
  quarterly_panel           = quarterly,
  quarter_map               = quarter_map
)
saveRDS(results, "output/dcdh_outside_crime_results.rds")
cat("\nSaved output/dcdh_outside_crime_results.rds\n")

# =============================================================================
# Comparison plots: All crime vs Outside crime
# =============================================================================
cat("\nGenerating comparison plots...\n")

extract_es <- function(obj, name) {
  b <- obj$coef$b
  se <- sqrt(diag(obj$coef$vcov))
  nms <- names(b)
  eff_idx <- grep("^Effect_", nms)
  plac_idx <- grep("^Placebo_", nms)
  n_eff <- length(eff_idx)
  n_plac <- length(plac_idx)
  es_data <- data.table(
    k = c(-(n_plac:1), 1:n_eff),
    est = c(rev(b[plac_idx]), b[eff_idx]),
    se = c(rev(se[plac_idx]), se[eff_idx])
  )
  es_data[, ci_lo := est - 1.96 * se]
  es_data[, ci_hi := est + 1.96 * se]
  es_data[, outcome := name]
  return(es_data)
}

# Load original results for comparison
orig <- readRDS("output/dcdh_hex_results.rds")

es_all <- rbind(
  extract_es(orig$violent, "Violent (All)"),
  extract_es(dcdh_violent_out, "Violent (Outside)"),
  extract_es(orig$property, "Property (All)"),
  extract_es(dcdh_property_out, "Property (Outside)")
)

p <- ggplot(es_all, aes(x = k, y = est, color = outcome, linetype = outcome)) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray50") +
  geom_vline(xintercept = 0, linetype = "dotted", color = "red") +
  geom_ribbon(aes(ymin = ci_lo, ymax = ci_hi, fill = outcome), alpha = 0.1, color = NA) +
  geom_line(linewidth = 0.8) +
  geom_point(size = 2) +
  scale_linetype_manual(values = c("solid", "dashed", "solid", "dashed")) +
  labs(title = "dCDH Event Study: All Crime vs Outside Crime (Full Panel)",
       subtitle = "Outside crime = visible to patrol officers (street, sidewalk, park, etc.)",
       x = "Quarters Relative to Treatment Switch",
       y = "ATT",
       color = "Outcome", fill = "Outcome", linetype = "Outcome") +
  theme_minimal(base_size = 13) +
  theme(legend.position = "bottom")
ggsave("output/dcdh_outside_vs_all_crime.png", p, width = 12, height = 7, dpi = 150)
cat("Saved output/dcdh_outside_vs_all_crime.png\n")

cat("\nDone!\n")
