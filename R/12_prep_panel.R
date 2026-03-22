# 12_prep_panel.R
# PHASE 0b: Load analysis panel, create regime indicators, quarterly aggregation
#
# Inputs:  data/panel_hex_analysis.csv
# Outputs: data/panel_analysis.rds          (monthly, with regimes)
#          data/panel_quarterly_analysis.rds (quarterly, for dCDH)

library(data.table)

cat("Loading analysis panel...\n")
dt <- fread("data/panel_hex_analysis.csv")
cat(sprintf("  %s rows, %d hexes, %d months\n", format(nrow(dt), big.mark = ","),
            uniqueN(dt$hex_id), uniqueN(dt$year_month)))

# ---- Regime indicators -------------------------------------------------------
# High SQF:  treatment ON and year_month <= 2012-03 (Q1 2012 was peak)
# Low SQF:   treatment ON and year_month >= 2013-07 (Impact XX onward, SQF collapsed)
#            and year_month <= 2015-06 (before dissolution)
# Post:      ever_treated == 1 and year_month >= 2015-07

dt[, regime_high_sqf := as.integer(treatment == 1 & year_month <= "2012-03")]
dt[, regime_low_sqf  := as.integer(treatment == 1 & year_month >= "2013-07" &
                                     year_month <= "2015-06")]
dt[, regime_post     := as.integer(ever_treated == 1 & year_month >= "2015-07")]

cat("\nRegime counts (hex-months):\n")
cat(sprintf("  High SQF:  %s\n", format(sum(dt$regime_high_sqf), big.mark = ",")))
cat(sprintf("  Low SQF:   %s\n", format(sum(dt$regime_low_sqf), big.mark = ",")))
cat(sprintf("  Post:      %s\n", format(sum(dt$regime_post), big.mark = ",")))
cat(sprintf("  Treatment ON total: %s\n", format(sum(dt$treatment), big.mark = ",")))

# Save monthly panel
saveRDS(dt, "data/panel_analysis.rds")
cat("\nSaved data/panel_analysis.rds\n")

# ---- Quarterly aggregation for dCDH ------------------------------------------
cat("\nBuilding quarterly panel...\n")

dt[, quarter := ceiling(month / 3)]
dt[, yq := year * 10L + quarter]

# Outcome columns to sum
outcome_cols <- c("violent", "property", "robbery", "felony_assault", "burglary",
                  "robbery_outside", "felony_assault_outside", "burglary_outside",
                  "assault_total", "assault_total_outside",
                  "sqf_total", "sqf_pc", "sqf_npc",
                  "arrests_total", "arrests_felony", "arrests_misdemeanor",
                  "arrests_violation")

# Treatment: 1 if treated in ANY month of the quarter
# Neighbor treatment: 1 if neighbor-treated in ANY month of the quarter
qdt <- dt[, c(
  lapply(.SD, sum),
  list(
    treatment = as.integer(any(treatment == 1)),
    treatmentn = as.integer(any(treatmentn == 1)),
    ever_treated = first(ever_treated),
    precinct = first(precinct)
  )
), by = .(hex_id, hex_num, year, quarter, yq),
  .SDcols = outcome_cols]

# Sequential quarter ID
qmap <- data.table(yq = sort(unique(qdt$yq)))
qmap[, qid := .I]
qdt <- merge(qdt, qmap, by = "yq")

# Precinct × year-quarter FE
qdt[, pct_yq := paste0(precinct, "_", yq)]

# Regime indicators (quarterly)
qdt[, regime_high_sqf := as.integer(treatment == 1 & yq <= 20121)]
qdt[, regime_low_sqf  := as.integer(treatment == 1 & yq >= 20133 & yq <= 20152)]
qdt[, regime_post     := as.integer(ever_treated == 1 & yq >= 20153)]

# Interaction terms (quarterly sums)
qdt[, treatmentpc  := treatment * sqf_pc]
qdt[, treatmentnpc := treatment * sqf_npc]

setkey(qdt, hex_num, qid)

cat(sprintf("  %s rows, %d hexes, %d quarters\n",
            format(nrow(qdt), big.mark = ","),
            uniqueN(qdt$hex_id), uniqueN(qdt$qid)))
cat(sprintf("  Treatment-ON hex-quarters: %s\n",
            format(sum(qdt$treatment), big.mark = ",")))
cat(sprintf("  Quarter map:\n"))
print(qmap)

saveRDS(qdt, "data/panel_quarterly_analysis.rds")
cat("\nSaved data/panel_quarterly_analysis.rds\n")
cat("Done.\n")
