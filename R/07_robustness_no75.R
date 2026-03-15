# 07_robustness_no75.R
# Robustness check: Re-estimate Model 1 excluding the 75th Precinct
#
# Tests whether the main treatment effects are sensitive to a single
# high-crime precinct (East New York, Brooklyn).
#
# Usage: Rscript R/07_robustness_no75.R

library(data.table)
library(fixest)

# ---- Load raw crime data and prepare ----------------------------------------

crime <- fread("data-raw/blocks2004_2012_crime_fid_impactzones.csv",
               na.strings = c("", "NA", "."))
crime[, ym := year * 100L + month]
crime[, pct := as.integer(pct)]
crime[, year_pct_month := paste0(ym, "_", pct)]

# Diagnostics for precinct 75
cat("=== CRIME DATA: Precinct 75 Diagnostics ===\n")
cat(sprintf("Total rows: %d\n", nrow(crime)))
cat(sprintf("Rows in pct 75: %d (%.1f%%)\n",
            nrow(crime[pct == 75]),
            100 * nrow(crime[pct == 75]) / nrow(crime)))
cat(sprintf("Treatment rate in pct 75: %.4f\n",
            mean(crime[pct == 75]$treatment, na.rm = TRUE)))
cat(sprintf("Treatment rate overall:   %.4f\n",
            mean(crime$treatment, na.rm = TRUE)))
cat(sprintf("Unique fids in pct 75: %d\n",
            uniqueN(crime[pct == 75]$fid)))
cat(sprintf("Unique fids overall: %d\n", uniqueN(crime$fid)))

# Filter out precinct 75
crime <- crime[pct != 75]
cat(sprintf("Rows after filtering: %d\n\n", nrow(crime)))

# ---- Crime Model 1 (no pct 75) ---------------------------------------------

crime_outcomes <- c("crimes1", "offenses47", "offenses15", "offenses7", "crimes10",
                    "crimes7", "crimes6", "crimes5", "crimes3", "offenses")
crime_labels <- c(crimes1 = "Total", offenses47 = "Robbery", offenses15 = "Assault",
                  offenses7 = "Burglary", crimes10 = "Weapons", crimes7 = "Misd.",
                  crimes6 = "Other Felony", crimes5 = "Drugs",
                  crimes3 = "Property Felony", offenses = "Violent Felony")

m1_crime_no75 <- list()
for (yvar in crime_outcomes) {
  fml <- as.formula(paste0(yvar, " ~ treatment | year_pct_month"))
  m1_crime_no75[[yvar]] <- fepois(fml, data = crime, vcov = ~year_pct_month)
}

rm(crime)

# ---- Load raw arrest data and prepare ---------------------------------------

arrest <- fread("data-raw/blocks2004_2012_arrest_fid_impactzones 2.csv",
                na.strings = c("", "NA", "."))
arrest[, ym := year * 100L + month]
arrest[, pct := as.integer(pct)]
arrest[, year_pct_month := paste0(ym, "_", pct)]

cat("=== ARREST DATA: Precinct 75 Diagnostics ===\n")
cat(sprintf("Total rows: %d\n", nrow(arrest)))
cat(sprintf("Rows in pct 75: %d (%.1f%%)\n",
            nrow(arrest[pct == 75]),
            100 * nrow(arrest[pct == 75]) / nrow(arrest)))
cat(sprintf("Treatment rate in pct 75: %.4f\n",
            mean(arrest[pct == 75]$treatment, na.rm = TRUE)))
cat(sprintf("Treatment rate overall:   %.4f\n",
            mean(arrest$treatment, na.rm = TRUE)))

arrest <- arrest[pct != 75]
cat(sprintf("Rows after filtering: %d\n\n", nrow(arrest)))

# ---- Arrest Model 1 (no pct 75) --------------------------------------------

arrest_outcomes <- c("crimes1", "crimes3", "crimes5", "crimes6", "crimes7",
                     "crimes10", "offenses8", "offenses18", "offenses57", "offenses")
arrest_labels <- c(offenses = "Total", offenses57 = "Robbery",
                   offenses18 = "Assault", offenses8 = "Burglary",
                   crimes10 = "Weapons", crimes7 = "Misd.",
                   crimes6 = "Other Felony", crimes5 = "Drugs",
                   crimes3 = "Property Felony", crimes1 = "Violent Felony")

m1_arrest_no75 <- list()
for (yvar in arrest_outcomes) {
  fml <- as.formula(paste0(yvar, " ~ treatment | year_pct_month"))
  m1_arrest_no75[[yvar]] <- fepois(fml, data = arrest, vcov = ~year_pct_month)
}

rm(arrest)

# ---- Load full-sample reference models --------------------------------------

full_crime <- readRDS("output/crime_models.rds")
full_arrest <- readRDS("output/arrest_models.rds")

# ---- Comparison table: Crime ------------------------------------------------

cat("\n", strrep("=", 90), "\n")
cat("  CRIME MODEL 1: Full Sample vs Excluding 75th Precinct\n")
cat(strrep("=", 90), "\n")
cat(sprintf("%-18s %10s %10s %10s %10s %10s %10s\n",
            "Outcome", "No75 Coef", "No75 SE", "Full Coef", "Full SE", "Diff", "No75 N"))
cat(strrep("-", 90), "\n")

crime_comparison <- data.frame(
  type = character(), variable = character(), label = character(),
  no75_coef = numeric(), no75_se = numeric(), no75_n = integer(),
  full_coef = numeric(), full_se = numeric(), full_n = integer(),
  diff = numeric(), pct_change = numeric(),
  stringsAsFactors = FALSE
)

for (yvar in crime_outcomes) {
  m_no75 <- m1_crime_no75[[yvar]]
  m_full <- full_crime$m1[[yvar]]

  no75_c <- coef(m_no75)["treatment"]
  no75_s <- se(m_no75)["treatment"]
  full_c <- coef(m_full)["treatment"]
  full_s <- se(m_full)["treatment"]
  d <- no75_c - full_c
  pct_chg <- if (abs(full_c) > 1e-6) 100 * d / abs(full_c) else NA

  cat(sprintf("%-18s %10.4f %10.4f %10.4f %10.4f %10.4f %10d\n",
              crime_labels[yvar], no75_c, no75_s, full_c, full_s, d, m_no75$nobs))

  crime_comparison <- rbind(crime_comparison, data.frame(
    type = "crime", variable = yvar, label = crime_labels[yvar],
    no75_coef = round(no75_c, 4), no75_se = round(no75_s, 4), no75_n = m_no75$nobs,
    full_coef = round(full_c, 4), full_se = round(full_s, 4), full_n = m_full$nobs,
    diff = round(d, 4), pct_change = round(pct_chg, 1),
    stringsAsFactors = FALSE
  ))
}

# ---- Comparison table: Arrest -----------------------------------------------

cat("\n", strrep("=", 90), "\n")
cat("  ARREST MODEL 1: Full Sample vs Excluding 75th Precinct\n")
cat(strrep("=", 90), "\n")
cat(sprintf("%-18s %10s %10s %10s %10s %10s %10s\n",
            "Outcome", "No75 Coef", "No75 SE", "Full Coef", "Full SE", "Diff", "No75 N"))
cat(strrep("-", 90), "\n")

arrest_comparison <- data.frame(
  type = character(), variable = character(), label = character(),
  no75_coef = numeric(), no75_se = numeric(), no75_n = integer(),
  full_coef = numeric(), full_se = numeric(), full_n = integer(),
  diff = numeric(), pct_change = numeric(),
  stringsAsFactors = FALSE
)

for (yvar in arrest_outcomes) {
  m_no75 <- m1_arrest_no75[[yvar]]
  m_full <- full_arrest$m1[[yvar]]

  no75_c <- coef(m_no75)["treatment"]
  no75_s <- se(m_no75)["treatment"]
  full_c <- coef(m_full)["treatment"]
  full_s <- se(m_full)["treatment"]
  d <- no75_c - full_c
  pct_chg <- if (abs(full_c) > 1e-6) 100 * d / abs(full_c) else NA

  cat(sprintf("%-18s %10.4f %10.4f %10.4f %10.4f %10.4f %10d\n",
              arrest_labels[yvar], no75_c, no75_s, full_c, full_s, d, m_no75$nobs))

  arrest_comparison <- rbind(arrest_comparison, data.frame(
    type = "arrest", variable = yvar, label = arrest_labels[yvar],
    no75_coef = round(no75_c, 4), no75_se = round(no75_s, 4), no75_n = m_no75$nobs,
    full_coef = round(full_c, 4), full_se = round(full_s, 4), full_n = m_full$nobs,
    diff = round(d, 4), pct_change = round(pct_chg, 1),
    stringsAsFactors = FALSE
  ))
}

# ---- Summary ----------------------------------------------------------------

all_comparison <- rbind(crime_comparison, arrest_comparison)

cat(sprintf("\n%s\n  SUMMARY\n%s\n", strrep("=", 60), strrep("=", 60)))
cat(sprintf("  Crime:  mean |diff| = %.4f, max |diff| = %.4f\n",
            mean(abs(crime_comparison$diff)), max(abs(crime_comparison$diff))))
cat(sprintf("  Arrest: mean |diff| = %.4f, max |diff| = %.4f\n",
            mean(abs(arrest_comparison$diff)), max(abs(arrest_comparison$diff))))

sign_flips <- sum(sign(all_comparison$no75_coef) != sign(all_comparison$full_coef) &
                  abs(all_comparison$full_coef) > 0.01)
cat(sprintf("  Sign flips (|full coef| > 0.01): %d / %d\n",
            sign_flips, nrow(all_comparison)))

# ---- Save results -----------------------------------------------------------

dir.create("output", showWarnings = FALSE)
saveRDS(list(crime = m1_crime_no75, arrest = m1_arrest_no75),
        "output/robustness_no75_models.rds")
write.csv(all_comparison, "output/robustness_no75_comparison.csv", row.names = FALSE)
cat("\nModels saved to output/robustness_no75_models.rds\n")
cat("Comparison saved to output/robustness_no75_comparison.csv\n")
