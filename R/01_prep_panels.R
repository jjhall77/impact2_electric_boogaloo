# 01_prep_panels.R
# Loads raw crime and arrest CSVs (incident-level records), collapses to
# block × precinct × month panels, constructs analysis variables, and
# writes processed .rds files to data/

library(data.table)

# ---- Step 1: Load raw data ------------------------------------------------

crime_raw <- fread("data-raw/blocks2004_2012_crime_fid_impactzones.csv",
                   na.strings = c("", "NA", "."))
arrest_raw <- fread("data-raw/blocks2004_2012_arrest_fid_impactzones 2.csv",
                    na.strings = c("", "NA", "."))

cat("Crime raw:", nrow(crime_raw), "rows x", ncol(crime_raw), "cols\n")
cat("Arrest raw:", nrow(arrest_raw), "rows x", ncol(arrest_raw), "cols\n")

crime_raw[, ym := year * 100L + month]
arrest_raw[, ym := year * 100L + month]
crime_raw[, pct := as.integer(pct)]
arrest_raw[, pct := as.integer(pct)]

# ---- Step 2: Collapse to fid × pct × ym panel -----------------------------
# Raw data is at incident level (one row per offense record).
# Crime/offense counts must be SUMMED within each block-precinct-month.
# Block-level vars (treatment, impact dummies, stops, etc.) are constant
# within fid × pct × ym and taken as first value.

# -- Identify column roles --
crime_outcome_cols <- c(
  paste0("crimes", 1:12),
  paste0("offenses", 1:52),
  "offenses"
)
crime_outcome_cols <- intersect(crime_outcome_cols, names(crime_raw))

arrest_outcome_cols <- c(
  paste0("crimes", 1:12),
  paste0("offenses", 1:65),
  "offenses"
)
arrest_outcome_cols <- intersect(arrest_outcome_cols, names(arrest_raw))

# Columns that are constant within fid × pct × ym (take first)
crime_id_cols <- c("fid", "pct", "ym", "year", "month")
arrest_id_cols <- c("fid", "pct", "ym", "year", "month")

# Block-level / precinct-level vars to carry forward
block_vars_crime <- setdiff(
  names(crime_raw),
  c(crime_id_cols, crime_outcome_cols,
    grep("^lawcode|^totalcrimes|year_month|year_pct|ever_treat|^merge", names(crime_raw), value = TRUE))
)

block_vars_arrest <- setdiff(
  names(arrest_raw),
  c(arrest_id_cols, arrest_outcome_cols,
    grep("^chargecode", names(arrest_raw), value = TRUE))
)

# -- Aggregate --
collapse_panel <- function(dt, id_cols, outcome_cols, block_vars) {
  # Sum outcomes within each group
  sums <- dt[, lapply(.SD, sum, na.rm = TRUE),
             by = id_cols, .SDcols = outcome_cols]
  # First value of block-level vars within each group
  firsts <- dt[, lapply(.SD, function(x) x[1L]),
               by = id_cols, .SDcols = block_vars]
  # Merge
  merge(sums, firsts, by = id_cols)
}

crime <- collapse_panel(crime_raw, crime_id_cols, crime_outcome_cols, block_vars_crime)
arrest <- collapse_panel(arrest_raw, arrest_id_cols, arrest_outcome_cols, block_vars_arrest)

cat("\nAfter collapse:\n")
cat("  Crime panel:", nrow(crime), "rows\n")
cat("  Arrest panel:", nrow(arrest), "rows\n")

# Verify uniqueness
stopifnot(nrow(crime[, .N, by = .(fid, pct, ym)][N > 1]) == 0)
stopifnot(nrow(arrest[, .N, by = .(fid, pct, ym)][N > 1]) == 0)
cat("  Uniqueness check passed (fid × pct × ym)\n")

# ---- Step 2b: Panel balance diagnostics -----------------------------------

crime_periods <- crime[, .(n_periods = uniqueN(ym)), by = .(fid, pct)]
arrest_periods <- arrest[, .(n_periods = uniqueN(ym)), by = .(fid, pct)]

cat("\nCrime: fid×pct units =", nrow(crime_periods),
    ", periods =", uniqueN(crime$ym), "\n")
cat("  Periods per unit — min:", min(crime_periods$n_periods),
    "median:", median(crime_periods$n_periods),
    "max:", max(crime_periods$n_periods), "\n")

cat("Arrest: fid×pct units =", nrow(arrest_periods),
    ", periods =", uniqueN(arrest$ym), "\n")
cat("  Periods per unit — min:", min(arrest_periods$n_periods),
    "median:", median(arrest_periods$n_periods),
    "max:", max(arrest_periods$n_periods), "\n")

# ---- Step 3: Treatment & impact zone dates ---------------------------------
# Treatment variable `treatment` is already in the data.
cat("\nCrime treatment rate:", mean(crime$treatment, na.rm = TRUE), "\n")
cat("Arrest treatment rate:", mean(arrest$treatment, na.rm = TRUE), "\n")

# ---- Step 4: Construct neighbor treatment indicator (treatmentn) -----------
# Follows the exact Stata logic from the replication code.
# Impact zone activation dates (encoded in the conditional logic):
#   impact3:  2004 (full year)    impact4:  2005 (full year)
#   impact5:  2005, month >= 7    impact6:  2006 (full year)
#   impact7:  2006, month >= 6    impact8:  2007 (full year)
#   impact9:  2007, month >= 7    impact10: 2008 (full year)
#   impact11: 2008, month >= 7    impact12: 2009 (full year)
#   impact13: 2009, month >= 7    impact14: 2010 (full year)
#   impact15: 2010, month >= 8    impact16_a: 2011 (full year)
#   impact16_h: 2011, month >= 8  impact17: 2012 (full year)

build_treatmentn <- function(dt) {
  dt[, treatmentn := 0L]
  dt[year == 2004 & impact3neigh > 0,              treatmentn := 1L]
  dt[year == 2005 & impact4neigh > 0,              treatmentn := 1L]
  dt[year == 2005 & month >= 7 & impact5neigh > 0, treatmentn := 1L]
  dt[year == 2006 & impact6neigh > 0,              treatmentn := 1L]
  dt[year == 2006 & month >= 6 & impact7neigh > 0, treatmentn := 1L]
  dt[year == 2007 & impact8neigh > 0,              treatmentn := 1L]
  dt[year == 2007 & month >= 7 & impact9neigh > 0, treatmentn := 1L]
  dt[year == 2008 & impact10neigh > 0,             treatmentn := 1L]
  dt[year == 2008 & month >= 7 & impact11neigh > 0, treatmentn := 1L]
  dt[year == 2009 & impact12neigh > 0,             treatmentn := 1L]
  dt[year == 2009 & month >= 7 & impact13neigh > 0, treatmentn := 1L]
  dt[year == 2010 & impact14neigh > 0,             treatmentn := 1L]
  dt[year == 2010 & month >= 8 & impact15neigh > 0, treatmentn := 1L]
  dt[year == 2011 & impact16aneigh > 0,            treatmentn := 1L]
  dt[year == 2011 & month >= 8 & impact16hneigh > 0, treatmentn := 1L]
  dt[year == 2012 & impact17neigh > 0,             treatmentn := 1L]
  # Neighbor treatment zeroed out for directly-treated units
  dt[treatment == 1, treatmentn := 0L]
  invisible(dt)
}

build_treatmentn(crime)
build_treatmentn(arrest)
cat("Crime treatmentn rate:", mean(crime$treatmentn), "\n")
cat("Arrest treatmentn rate:", mean(arrest$treatmentn), "\n")

# ---- Step 5: Fix event study cumulation ------------------------------------
# Stata: replace eventneg2=1 if eventneg1==1 / eventpos2=1 if eventpos1==1
# Makes the event dummies cumulative

crime[eventneg1 == 1, eventneg2 := 1L]
crime[eventpos1 == 1, eventpos2 := 1L]
arrest[eventneg1 == 1, eventneg2 := 1L]
arrest[eventpos1 == 1, eventpos2 := 1L]

# ---- Step 6: Create precinct × month-year FE key --------------------------
# Stata uses string concat: year_pct_month = year_month + pct
# For fixest we can use pct^ym in the formula; also store explicit key.

crime[, year_pct_month := paste0(ym, "_", pct)]
arrest[, year_pct_month := paste0(ym, "_", pct)]

# ---- Step 7: Create Model 4 interaction variables --------------------------
# Stata: treatmentpc  = treatment * cs_probcause
#        cs_npc       = stops - cs_probcause
#        treatmentnpc = treatment * cs_npc

for (dt in list(crime, arrest)) {
  if (!"treatmentpc" %in% names(dt) || all(is.na(dt$treatmentpc))) {
    dt[, stops := fifelse(is.na(stops), 0L, as.integer(stops))]
    dt[, cs_probcause := fifelse(is.na(cs_probcause), 0L, as.integer(cs_probcause))]
    dt[, treatmentpc := treatment * cs_probcause]
    dt[, cs_npc := stops - cs_probcause]
    dt[, treatmentnpc := treatment * cs_npc]
  }
}

# ---- Step 8: Save processed panels ----------------------------------------

dir.create("data", showWarnings = FALSE)
saveRDS(crime, "data/crime_panel.rds")
saveRDS(arrest, "data/arrest_panel.rds")

cat("\nSaved: data/crime_panel.rds (", format(object.size(crime), units = "MB"), ")\n")
cat("Saved: data/arrest_panel.rds (", format(object.size(arrest), units = "MB"), ")\n")
cat("Done.\n")
