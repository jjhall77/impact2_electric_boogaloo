#!/usr/bin/env Rscript
# =============================================================================
# 08_hex_models.R
# Phase 1-3: Poisson FE models on hex x month panel
# Central question: Does police presence reduce crime independent of enforcement?
# =============================================================================

library(fixest)
library(data.table)

cat("Loading panel...\n")
panel <- fread("data/panel_hex_month.csv")
cat(sprintf("Panel: %s rows, %s hexes, %s months\n",
            format(nrow(panel), big.mark = ","),
            format(uniqueN(panel$hex_id), big.mark = ","),
            uniqueN(panel$year_month)))

cat(sprintf("  Ever-treated hexes: %s\n", uniqueN(panel[ever_treated == 1]$hex_id)))
cat(sprintf("  Never-treated hexes: %s\n", uniqueN(panel[ever_treated == 0]$hex_id)))

# =============================================================================
# PHASE 1: BASELINE REPLICATION (2006-2012)
# Conditional FE Poisson with hex + pct_ym fixed effects
# hex FE absorbs the permanent crime level of each hex
# pct_ym FE absorbs precinct-level time shocks
# =============================================================================
cat("\n", strrep("=", 60), "\n")
cat("PHASE 1: BASELINE REPLICATION (2006-2012)\n")
cat(strrep("=", 60), "\n")

df1 <- panel[year <= 2012]
cat(sprintf("Subset: %s rows\n", format(nrow(df1), big.mark = ",")))

cat("\n--- VIOLENT CRIME ---\n")
m1_violent <- fepois(violent ~ treatment | hex_id + pct_ym,
                     data = df1, vcov = ~pct_ym)
summary(m1_violent)

cat("\n--- PROPERTY CRIME ---\n")
m1_property <- fepois(property ~ treatment | hex_id + pct_ym,
                      data = df1, vcov = ~pct_ym)
summary(m1_property)

# =============================================================================
# PHASE 2: THREE-REGIME MODEL (2006-2016)
# Key test: presence vs enforcement
# =============================================================================
cat("\n", strrep("=", 60), "\n")
cat("PHASE 2: THREE-REGIME MODEL (2006-2016)\n")
cat(strrep("=", 60), "\n")

cat("\n--- VIOLENT CRIME ---\n")
m2_violent <- fepois(violent ~ treatment_presence_enforcement
                             + treatment_presence_only
                             + treatment_post_dissolution
                     | hex_id + pct_ym,
                     data = panel, vcov = ~pct_ym)
summary(m2_violent)

cat("\n--- PROPERTY CRIME ---\n")
m2_property <- fepois(property ~ treatment_presence_enforcement
                                + treatment_presence_only
                                + treatment_post_dissolution
                      | hex_id + pct_ym,
                      data = panel, vcov = ~pct_ym)
summary(m2_property)

# --- Arrests ---
cat("\n--- FELONY ARRESTS ---\n")
m2_arr_f <- fepois(arrests_felony ~ treatment_presence_enforcement
                                   + treatment_presence_only
                                   + treatment_post_dissolution
                   | hex_id + pct_ym,
                   data = panel, vcov = ~pct_ym)
summary(m2_arr_f)

cat("\n--- MISDEMEANOR ARRESTS ---\n")
m2_arr_m <- fepois(arrests_misdemeanor ~ treatment_presence_enforcement
                                        + treatment_presence_only
                                        + treatment_post_dissolution
                   | hex_id + pct_ym,
                   data = panel, vcov = ~pct_ym)
summary(m2_arr_m)

# =============================================================================
# DOSE-RESPONSE: PC and NPC stops with treatment indicator
# If treatment remains significant after controlling for stop intensity,
# that is direct evidence of a presence effect
# =============================================================================
cat("\n", strrep("=", 60), "\n")
cat("DOSE-RESPONSE: SQF INTENSITY\n")
cat(strrep("=", 60), "\n")

cat("\n--- VIOLENT CRIME ---\n")
m3_violent <- fepois(violent ~ sqf_pc + sqf_npc + treatment | hex_id + pct_ym,
                     data = panel, vcov = ~pct_ym)
summary(m3_violent)

cat("\n--- PROPERTY CRIME ---\n")
m3_property <- fepois(property ~ sqf_pc + sqf_npc + treatment | hex_id + pct_ym,
                      data = panel, vcov = ~pct_ym)
summary(m3_property)

# =============================================================================
# PHASE 3: EVENT STUDY AROUND DISSOLUTION (7/1/2015)
# Monthly leads/lags for ever-treated hexes, +/- 12 months
# =============================================================================
cat("\n", strrep("=", 60), "\n")
cat("PHASE 3: EVENT STUDY AROUND DISSOLUTION (7/1/2015)\n")
cat(strrep("=", 60), "\n")

# Create relative month variable
# Dissolution = July 2015 = "2015-07"
panel[, rel_month := (year - 2015) * 12 + (month - 7)]

# Event study: restrict to +/- 12 months and ever-treated hexes interacted
# with relative time dummies
es_data <- panel[rel_month >= -12 & rel_month <= 12]
es_data[, rel_month_factor := factor(rel_month)]
# Reference period: -1 (June 2015, last month before dissolution)
es_data[, rel_month_factor := relevel(rel_month_factor, ref = "-1")]

# Interaction of ever_treated x relative month
cat("\n--- VIOLENT CRIME EVENT STUDY ---\n")
es_violent <- fepois(violent ~ i(rel_month, ever_treated, ref = -1)
                     | hex_id + pct_ym,
                     data = es_data, vcov = ~pct_ym)
summary(es_violent)

cat("\n--- PROPERTY CRIME EVENT STUDY ---\n")
es_property <- fepois(property ~ i(rel_month, ever_treated, ref = -1)
                      | hex_id + pct_ym,
                      data = es_data, vcov = ~pct_ym)
summary(es_property)

# =============================================================================
# Save results
# =============================================================================
cat("\n", strrep("=", 60), "\n")
cat("SAVING RESULTS\n")
cat(strrep("=", 60), "\n")

results <- list(
  m1_violent = m1_violent,
  m1_property = m1_property,
  m2_violent = m2_violent,
  m2_property = m2_property,
  m2_arr_felony = m2_arr_f,
  m2_arr_misdemeanor = m2_arr_m,
  m3_violent = m3_violent,
  m3_property = m3_property,
  es_violent = es_violent,
  es_property = es_property
)
saveRDS(results, "output/hex_model_results.rds")
cat("Saved to output/hex_model_results.rds\n")

# Event study plots
png("output/es_dissolution_violent.png", width = 1200, height = 600, res = 150)
iplot(es_violent, main = "Event Study: Violent Crime Around Dissolution (7/2015)",
      xlab = "Months Relative to Dissolution", ylab = "Coefficient")
abline(v = 0, col = "red", lty = 2)
dev.off()

png("output/es_dissolution_property.png", width = 1200, height = 600, res = 150)
iplot(es_property, main = "Event Study: Property Crime Around Dissolution (7/2015)",
      xlab = "Months Relative to Dissolution", ylab = "Coefficient")
abline(v = 0, col = "red", lty = 2)
dev.off()

cat("Saved event study plots\n")
cat("\nDone!\n")
