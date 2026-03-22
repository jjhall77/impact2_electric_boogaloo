#!/usr/bin/env Rscript
# =============================================================================
# 10_dcdh_hex_models.R
# de Chaisemartin & D'Haultfoeuille (2024) did_multiplegt_dyn
# Primary specification: handles switching/non-absorbing treatment
# Impact zones activate/deactivate every ~6 months across iterations
# =============================================================================

Sys.setenv(RGL_USE_NULL = "TRUE")  # rgl dependency workaround
library(polars)
library(DIDmultiplegtDYN)
library(data.table)
library(ggplot2)

cat("Loading panel v2 (switching treatment)...\n")
panel <- fread("data/panel_hex_month_v2.csv")

cat(sprintf("Panel: %s rows, %s hexes, %s months\n",
            format(nrow(panel), big.mark = ","),
            uniqueN(panel$hex_id),
            uniqueN(panel$time_id)))
cat(sprintf("  Treatment-ON hex-months: %s\n", format(sum(panel$treatment == 1), big.mark = ",")))
cat(sprintf("  Treatment-OFF hex-months: %s\n", format(sum(panel$treatment == 0), big.mark = ",")))

# ---------------------------------------------------------------
# Aggregate to quarterly for computational tractability
# Monthly x 6,559 hexes x 132 periods = very slow
# Quarterly: 44 periods, same hexes
# ---------------------------------------------------------------
cat("\nAggregating to quarterly panel...\n")
panel[, quarter := ceiling(month / 3)]
panel[, yq := year * 10 + quarter]

quarterly <- panel[, .(
  violent    = sum(violent),
  property   = sum(property),
  crime_total = sum(crime_total),
  sqf_total  = sum(sqf_total),
  sqf_pc     = sum(sqf_pc),
  sqf_npc    = sum(sqf_npc),
  arrests_total       = sum(arrests_total),
  arrests_felony       = sum(arrests_felony),
  arrests_misdemeanor  = sum(arrests_misdemeanor),
  # Treatment: 1 if treated in ANY month of the quarter
  treatment  = as.integer(any(treatment == 1))
), by = .(hex_id, hex_num, year, quarter, yq, precinct, ever_treated)]

# Create sequential quarter ID (1, 2, 3, ...)
quarter_map <- data.table(yq = sort(unique(quarterly$yq)))
quarter_map[, qid := .I]
quarterly <- merge(quarterly, quarter_map, by = "yq")

cat(sprintf("Quarterly panel: %s rows, %s hexes, %s quarters\n",
            format(nrow(quarterly), big.mark = ","),
            uniqueN(quarterly$hex_id),
            uniqueN(quarterly$qid)))
cat(sprintf("  Treatment-ON hex-quarters: %s\n", sum(quarterly$treatment == 1)))
cat(sprintf("  Treatment-OFF hex-quarters: %s\n", sum(quarterly$treatment == 0)))

# Check switching
switches <- quarterly[ever_treated == 1, .(
  n_on = sum(treatment == 1),
  n_off = sum(treatment == 0),
  n_switches = sum(abs(diff(treatment)))
), by = hex_num]
cat(sprintf("  Hexes with switching treatment: %d / %d ever-treated\n",
            sum(switches$n_switches > 0), nrow(switches)))
cat(sprintf("  Mean switches per treated hex: %.1f\n", mean(switches$n_switches)))

# =============================================================================
# dCDH: VIOLENT CRIME
# =============================================================================
cat("\n", strrep("=", 60), "\n")
cat("dCDH did_multiplegt_dyn: VIOLENT CRIME\n")
cat(strrep("=", 60), "\n\n")

# effects = 8 quarters (2 years post-treatment-switch)
# placebo = 4 quarters (1 year pre-trends)
# cluster at hex level (group level)
dcdh_violent <- did_multiplegt_dyn(
  df       = as.data.frame(quarterly),
  outcome  = "violent",
  group    = "hex_num",
  time     = "qid",
  treatment = "treatment",
  effects  = 8,
  placebo  = 4,
  cluster  = "hex_num",
  graph_off = TRUE,
  design   = NULL,
  save_sample = FALSE
)

cat("\nViolent crime results:\n")
print(summary(dcdh_violent))

# =============================================================================
# dCDH: PROPERTY CRIME
# =============================================================================
cat("\n", strrep("=", 60), "\n")
cat("dCDH did_multiplegt_dyn: PROPERTY CRIME\n")
cat(strrep("=", 60), "\n\n")

dcdh_property <- did_multiplegt_dyn(
  df       = as.data.frame(quarterly),
  outcome  = "property",
  group    = "hex_num",
  time     = "qid",
  treatment = "treatment",
  effects  = 8,
  placebo  = 4,
  cluster  = "hex_num",
  graph_off = TRUE,
  design   = NULL,
  save_sample = FALSE
)

cat("\nProperty crime results:\n")
print(summary(dcdh_property))

# =============================================================================
# dCDH: FELONY ARRESTS
# =============================================================================
cat("\n", strrep("=", 60), "\n")
cat("dCDH did_multiplegt_dyn: FELONY ARRESTS\n")
cat(strrep("=", 60), "\n\n")

dcdh_arrests_f <- did_multiplegt_dyn(
  df       = as.data.frame(quarterly),
  outcome  = "arrests_felony",
  group    = "hex_num",
  time     = "qid",
  treatment = "treatment",
  effects  = 8,
  placebo  = 4,
  cluster  = "hex_num",
  graph_off = TRUE,
  design   = NULL,
  save_sample = FALSE
)

cat("\nFelony arrests results:\n")
print(summary(dcdh_arrests_f))

# =============================================================================
# dCDH: MISDEMEANOR ARRESTS
# =============================================================================
cat("\n", strrep("=", 60), "\n")
cat("dCDH did_multiplegt_dyn: MISDEMEANOR ARRESTS\n")
cat(strrep("=", 60), "\n\n")

dcdh_arrests_m <- did_multiplegt_dyn(
  df       = as.data.frame(quarterly),
  outcome  = "arrests_misdemeanor",
  group    = "hex_num",
  time     = "qid",
  treatment = "treatment",
  effects  = 8,
  placebo  = 4,
  cluster  = "hex_num",
  graph_off = TRUE,
  design   = NULL,
  save_sample = FALSE
)

cat("\nMisdemeanor arrests results:\n")
print(summary(dcdh_arrests_m))

# =============================================================================
# dCDH: SQF TOTAL (mechanism check)
# =============================================================================
cat("\n", strrep("=", 60), "\n")
cat("dCDH did_multiplegt_dyn: SQF TOTAL (first stage)\n")
cat(strrep("=", 60), "\n\n")

dcdh_sqf <- did_multiplegt_dyn(
  df       = as.data.frame(quarterly),
  outcome  = "sqf_total",
  group    = "hex_num",
  time     = "qid",
  treatment = "treatment",
  effects  = 8,
  placebo  = 4,
  cluster  = "hex_num",
  graph_off = TRUE,
  design   = NULL,
  save_sample = FALSE
)

cat("\nSQF total results:\n")
print(summary(dcdh_sqf))

# =============================================================================
# Save results
# =============================================================================
cat("\n", strrep("=", 60), "\n")
cat("SAVING RESULTS\n")
cat(strrep("=", 60), "\n")

results_dcdh <- list(
  violent    = dcdh_violent,
  property   = dcdh_property,
  arrests_f  = dcdh_arrests_f,
  arrests_m  = dcdh_arrests_m,
  sqf        = dcdh_sqf,
  quarterly_panel = quarterly,
  quarter_map = quarter_map
)
saveRDS(results_dcdh, "output/dcdh_hex_results.rds")
cat("Saved to output/dcdh_hex_results.rds\n")

# =============================================================================
# Event study plots
# =============================================================================
cat("\nGenerating event study plots...\n")

# Helper to extract dCDH event study data from coef$b and coef$vcov
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

es_v <- extract_es(dcdh_violent, "Violent Crime")
es_p <- extract_es(dcdh_property, "Property Crime")
es_af <- extract_es(dcdh_arrests_f, "Felony Arrests")
es_am <- extract_es(dcdh_arrests_m, "Misdemeanor Arrests")
es_sqf <- extract_es(dcdh_sqf, "SQF Total")

# Combined crime plot
es_crime <- rbind(es_v, es_p)
p_crime <- ggplot(es_crime, aes(x = k, y = est, color = outcome)) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray50") +
  geom_vline(xintercept = 0, linetype = "dotted", color = "red") +
  geom_ribbon(aes(ymin = ci_lo, ymax = ci_hi, fill = outcome), alpha = 0.15, color = NA) +
  geom_line(linewidth = 0.8) +
  geom_point(size = 2) +
  labs(title = "dCDH Event Study: Crime (Quarterly, Hex Grid, Switching Treatment)",
       subtitle = "de Chaisemartin & D'Haultfoeuille (2024) did_multiplegt_dyn",
       x = "Quarters Relative to Treatment Switch",
       y = "ATT",
       color = "Outcome", fill = "Outcome") +
  theme_minimal(base_size = 13) +
  theme(legend.position = "bottom")
ggsave("output/dcdh_hex_es_crime.png", p_crime, width = 10, height = 6, dpi = 150)
cat("Saved output/dcdh_hex_es_crime.png\n")

# Arrests plot
es_arrests <- rbind(es_af, es_am)
p_arrests <- ggplot(es_arrests, aes(x = k, y = est, color = outcome)) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray50") +
  geom_vline(xintercept = 0, linetype = "dotted", color = "red") +
  geom_ribbon(aes(ymin = ci_lo, ymax = ci_hi, fill = outcome), alpha = 0.15, color = NA) +
  geom_line(linewidth = 0.8) +
  geom_point(size = 2) +
  labs(title = "dCDH Event Study: Arrests (Quarterly, Hex Grid, Switching Treatment)",
       subtitle = "de Chaisemartin & D'Haultfoeuille (2024) did_multiplegt_dyn",
       x = "Quarters Relative to Treatment Switch",
       y = "ATT",
       color = "Outcome", fill = "Outcome") +
  theme_minimal(base_size = 13) +
  theme(legend.position = "bottom")
ggsave("output/dcdh_hex_es_arrests.png", p_arrests, width = 10, height = 6, dpi = 150)
cat("Saved output/dcdh_hex_es_arrests.png\n")

# SQF plot
p_sqf <- ggplot(es_sqf, aes(x = k, y = est)) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray50") +
  geom_vline(xintercept = 0, linetype = "dotted", color = "red") +
  geom_ribbon(aes(ymin = ci_lo, ymax = ci_hi), alpha = 0.2, fill = "steelblue") +
  geom_line(color = "steelblue", linewidth = 0.8) +
  geom_point(color = "steelblue", size = 2) +
  labs(title = "dCDH Event Study: SQF Total (Quarterly, Hex Grid, Switching Treatment)",
       subtitle = "First stage: does treatment switch-on increase SQF?",
       x = "Quarters Relative to Treatment Switch",
       y = "ATT") +
  theme_minimal(base_size = 13)
ggsave("output/dcdh_hex_es_sqf.png", p_sqf, width = 10, height = 6, dpi = 150)
cat("Saved output/dcdh_hex_es_sqf.png\n")

# Also save the package's built-in plots
ggsave("output/dcdh_hex_builtin_violent.png", dcdh_violent$plot, width = 10, height = 6, dpi = 150)
ggsave("output/dcdh_hex_builtin_property.png", dcdh_property$plot, width = 10, height = 6, dpi = 150)
ggsave("output/dcdh_hex_builtin_sqf.png", dcdh_sqf$plot, width = 10, height = 6, dpi = 150)
cat("Saved built-in plots\n")

cat("\nDone!\n")
