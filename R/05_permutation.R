# 05_permutation.R
# Permutation test for Model 1 (total crime and total arrests).
# Randomly reassigns the TIMING of impact zone treatment 1,000 times,
# re-estimates Model 1, and compares the distribution of placebo
# coefficients to the true estimate.
#
# Paper reports: max placebo crime coef = -0.020 vs true = -0.124
#                max placebo arrest coef = +0.035 vs true = +0.426
#
# The permutation shuffles treatment timing across blocks, preserving
# the overall treatment rate per period. This tests whether the result
# could be driven by autocorrelation in timing and secular trends.

library(data.table)
library(fixest)
library(ggplot2)

set.seed(42)
N_PERM <- 1000

# ---- Load and prepare crime data -------------------------------------------
cat("Loading crime data...\n")
crime <- fread("data-raw/blocks2004_2012_crime_fid_impactzones.csv",
               na.strings = c("", "NA", "."))
crime[, ym := year * 100L + month]
crime[, pct := as.integer(pct)]
crime[, year_pct_month := paste0(ym, "_", pct)]

# True Model 1 coefficient
true_crime <- fepois(crimes1 ~ treatment | year_pct_month,
                     data = crime, vcov = ~year_pct_month)
true_crime_coef <- coef(true_crime)["treatment"]
cat(sprintf("True crime coefficient: %.4f\n", true_crime_coef))

# ---- Load and prepare arrest data ------------------------------------------
cat("Loading arrest data...\n")
arrest <- fread("data-raw/blocks2004_2012_arrest_fid_impactzones 2.csv",
                na.strings = c("", "NA", "."))
arrest[, ym := year * 100L + month]
arrest[, pct := as.integer(pct)]
arrest[, year_pct_month := paste0(ym, "_", pct)]

true_arrest <- fepois(offenses ~ treatment | year_pct_month,
                      data = arrest, vcov = ~year_pct_month)
true_arrest_coef <- coef(true_arrest)["treatment"]
cat(sprintf("True arrest coefficient: %.4f\n", true_arrest_coef))

# ---- Permutation: shuffle treatment timing ---------------------------------
# Strategy: for each permutation, randomly shuffle the `treatment` vector
# within each year_pct_month group. This preserves the treatment rate
# per precinct-month but breaks the link between treatment and specific
# blocks — equivalent to randomly reassigning which blocks are "treated"
# within each precinct at each time point.

cat(sprintf("\nRunning %d permutations...\n", N_PERM))

placebo_crime  <- numeric(N_PERM)
placebo_arrest <- numeric(N_PERM)

t0 <- proc.time()
for (i in seq_len(N_PERM)) {
  # Shuffle treatment within year_pct_month groups
  crime[, treatment_perm := sample(treatment), by = year_pct_month]
  arrest[, treatment_perm := sample(treatment), by = year_pct_month]

  # Re-estimate Model 1 with permuted treatment
  mc <- tryCatch(
    fepois(crimes1 ~ treatment_perm | year_pct_month,
           data = crime, vcov = ~year_pct_month),
    error = function(e) NULL
  )
  ma <- tryCatch(
    fepois(offenses ~ treatment_perm | year_pct_month,
           data = arrest, vcov = ~year_pct_month),
    error = function(e) NULL
  )

  placebo_crime[i]  <- if (!is.null(mc)) coef(mc)["treatment_perm"] else NA
  placebo_arrest[i] <- if (!is.null(ma)) coef(ma)["treatment_perm"] else NA

  if (i %% 100 == 0) {
    elapsed <- (proc.time() - t0)[3]
    cat(sprintf("  %d/%d done (%.0f sec elapsed, ~%.0f sec remaining)\n",
                i, N_PERM, elapsed, elapsed / i * (N_PERM - i)))
  }
}

# Clean up temp column
crime[, treatment_perm := NULL]
arrest[, treatment_perm := NULL]

# ---- Results ---------------------------------------------------------------
cat("\n========== PERMUTATION TEST RESULTS ==========\n")

# Crime
crime_valid <- placebo_crime[!is.na(placebo_crime)]
cat(sprintf("\nCrime (crimes1 = Total):\n"))
cat(sprintf("  True coefficient:       %.4f\n", true_crime_coef))
cat(sprintf("  Placebo range:          [%.4f, %.4f]\n",
            min(crime_valid), max(crime_valid)))
cat(sprintf("  Placebo mean (SD):      %.4f (%.4f)\n",
            mean(crime_valid), sd(crime_valid)))
cat(sprintf("  Max placebo (most neg): %.4f\n", min(crime_valid)))
cat(sprintf("  Paper max placebo:      -0.020\n"))
p_crime <- mean(crime_valid <= true_crime_coef)
cat(sprintf("  p-value (one-sided):    %.4f (%d/%d)\n",
            p_crime, sum(crime_valid <= true_crime_coef), length(crime_valid)))

# Arrest
arrest_valid <- placebo_arrest[!is.na(placebo_arrest)]
cat(sprintf("\nArrest (offenses = Total):\n"))
cat(sprintf("  True coefficient:       %.4f\n", true_arrest_coef))
cat(sprintf("  Placebo range:          [%.4f, %.4f]\n",
            min(arrest_valid), max(arrest_valid)))
cat(sprintf("  Placebo mean (SD):      %.4f (%.4f)\n",
            mean(arrest_valid), sd(arrest_valid)))
cat(sprintf("  Max placebo (most pos): %.4f\n", max(arrest_valid)))
cat(sprintf("  Paper max placebo:      +0.035\n"))
p_arrest <- mean(arrest_valid >= true_arrest_coef)
cat(sprintf("  p-value (one-sided):    %.4f (%d/%d)\n",
            p_arrest, sum(arrest_valid >= true_arrest_coef), length(arrest_valid)))

# ---- Save results ----------------------------------------------------------
perm_results <- list(
  crime = list(true_coef = true_crime_coef, placebo = crime_valid, p = p_crime),
  arrest = list(true_coef = true_arrest_coef, placebo = arrest_valid, p = p_arrest)
)
saveRDS(perm_results, "output/permutation_results.rds")

# ---- Plot ------------------------------------------------------------------
dir.create("output", showWarnings = FALSE)

p1 <- ggplot(data.frame(coef = crime_valid), aes(x = coef)) +
  geom_histogram(bins = 50, fill = "grey70", color = "grey40") +
  geom_vline(xintercept = true_crime_coef, color = "red", linewidth = 1) +
  labs(title = "Permutation Test: Total Crime (Model 1)",
       subtitle = sprintf("Red line = true estimate (%.3f); max placebo = %.4f; p < %.3f",
                           true_crime_coef, min(crime_valid), max(p_crime, 1/N_PERM)),
       x = "Placebo treatment coefficient", y = "Count") +
  theme_minimal()
ggsave("output/permutation_crime.png", p1, width = 7, height = 4, dpi = 150)

p2 <- ggplot(data.frame(coef = arrest_valid), aes(x = coef)) +
  geom_histogram(bins = 50, fill = "grey70", color = "grey40") +
  geom_vline(xintercept = true_arrest_coef, color = "red", linewidth = 1) +
  labs(title = "Permutation Test: Total Arrests (Model 1)",
       subtitle = sprintf("Red line = true estimate (%.3f); max placebo = %.4f; p < %.3f",
                           true_arrest_coef, max(arrest_valid), max(p_arrest, 1/N_PERM)),
       x = "Placebo treatment coefficient", y = "Count") +
  theme_minimal()
ggsave("output/permutation_arrest.png", p2, width = 7, height = 4, dpi = 150)

cat("\nPlots saved to output/permutation_crime.png and output/permutation_arrest.png\n")
cat("Done.\n")
