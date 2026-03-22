# 04_quality_degradation.R
# Does stop quality (arrest rate, hit rate, furtive-only rate) degrade at month-end?
# If quotas exist, officers rushing to hit targets produce lower-quality stops.
# Era interactions: high-SQF (2006-2011), post-reform (2012-2016)
# Output: quotas/results_quality.rds

library(data.table)

sqf <- readRDS("quotas/sqf_daily.rds")

# Define eras
sqf[, era := fifelse(year <= 2011, "high_sqf",
             fifelse(year <= 2013, "transition", "post_reform"))]

cat("=== QUALITY DEGRADATION TEST ===\n\n")

# ---- Stop-level regressions ----
# Each stop is an observation; outcome = quality indicator
# Key predictor: days_remaining (or last_5)

# Use LPM (linear probability model) for speed and robustness with many FEs
# Precinct FE included

# ---- Test 1: Arrest rate by day-of-month ----
cat("--- Test 1: Arrest rate (LPM) ~ days_remaining + dow + year + pct FE ---\n")
m1 <- lm(arstmade ~ days_remaining + factor(dow) + factor(year) + factor(pct), data = sqf)
coefs1 <- coef(summary(m1))
cat(sprintf("  days_remaining coef: %.6f (SE=%.6f, p=%.4f)\n",
            coefs1["days_remaining", "Estimate"],
            coefs1["days_remaining", "Std. Error"],
            coefs1["days_remaining", "Pr(>|t|)"]))
cat("  Positive = arrest rate HIGHER at month start (lower near end → quota)\n\n")

# ---- Test 2: Hit rate ----
cat("--- Test 2: Hit rate (LPM) ~ days_remaining ---\n")
m2 <- lm(hit ~ days_remaining + factor(dow) + factor(year) + factor(pct), data = sqf)
coefs2 <- coef(summary(m2))
cat(sprintf("  days_remaining coef: %.6f (SE=%.6f, p=%.4f)\n",
            coefs2["days_remaining", "Estimate"],
            coefs2["days_remaining", "Std. Error"],
            coefs2["days_remaining", "Pr(>|t|)"]))

# ---- Test 3: Frisked-no-result ----
cat("\n--- Test 3: Frisked-no-result (LPM) ~ days_remaining ---\n")
m3 <- lm(frisked_no_result ~ days_remaining + factor(dow) + factor(year) + factor(pct),
          data = sqf[frisked == 1])
coefs3 <- coef(summary(m3))
cat(sprintf("  days_remaining coef: %.6f (SE=%.6f, p=%.4f)\n",
            coefs3["days_remaining", "Estimate"],
            coefs3["days_remaining", "Std. Error"],
            coefs3["days_remaining", "Pr(>|t|)"]))
cat("  Negative = fruitless frisks MORE COMMON at month-end → quota\n")

# ---- Test 4: Only-furtive ----
cat("\n--- Test 4: Only-furtive (LPM) ~ days_remaining ---\n")
m4 <- lm(only_furtive ~ days_remaining + factor(dow) + factor(year) + factor(pct), data = sqf)
coefs4 <- coef(summary(m4))
cat(sprintf("  days_remaining coef: %.6f (SE=%.6f, p=%.4f)\n",
            coefs4["days_remaining", "Estimate"],
            coefs4["days_remaining", "Std. Error"],
            coefs4["days_remaining", "Pr(>|t|)"]))
cat("  Negative = furtive-only MORE COMMON at month-end → quota\n")

# ---- Test 5: Era interactions ----
cat("\n--- Test 5: Quality by era × days_remaining (LPM with pct FE) ---\n\n")

for (era_val in c("high_sqf", "post_reform")) {
  sub <- sqf[era == era_val]
  cat(sprintf("  Era: %s (n=%s stops)\n", era_val, format(nrow(sub), big.mark = ",")))

  m_arr <- lm(arstmade ~ days_remaining + factor(dow) + factor(year) + factor(pct), data = sub)
  m_hit <- lm(hit ~ days_remaining + factor(dow) + factor(year) + factor(pct), data = sub)
  m_furt <- lm(only_furtive ~ days_remaining + factor(dow) + factor(year) + factor(pct), data = sub)

  cat(sprintf("    arrest ~ days_remaining: %.6f (p=%.4f)\n",
              coef(summary(m_arr))["days_remaining", "Estimate"],
              coef(summary(m_arr))["days_remaining", "Pr(>|t|)"]))
  cat(sprintf("    hit ~ days_remaining:    %.6f (p=%.4f)\n",
              coef(summary(m_hit))["days_remaining", "Estimate"],
              coef(summary(m_hit))["days_remaining", "Pr(>|t|)"]))
  cat(sprintf("    furtive ~ days_remaining: %.6f (p=%.4f)\n\n",
              coef(summary(m_furt))["days_remaining", "Estimate"],
              coef(summary(m_furt))["days_remaining", "Pr(>|t|)"]))
}

# ---- Test 6: Binned quality by position in month ----
cat("--- Test 6: Mean quality indicators by position in month ---\n")
sqf[, position := cut(days_remaining,
                      breaks = c(-1, 2, 5, 10, 15, 31),
                      labels = c("0-2", "3-5", "6-10", "11-15", "16+"))]
qual_bins <- sqf[, .(n_stops = .N,
                      arrest_rate = mean(arstmade),
                      hit_rate = mean(hit),
                      furtive_only_rate = mean(only_furtive),
                      frisk_no_result_rate = mean(frisked_no_result)),
                  by = position][order(position)]
cat("  position | n_stops | arrest% | hit% | furtive_only% | frisk_no_result%\n")
for (i in seq_len(nrow(qual_bins))) {
  cat(sprintf("  %8s | %7s | %6.2f%% | %5.2f%% | %12.2f%% | %15.2f%%\n",
              qual_bins$position[i],
              format(qual_bins$n_stops[i], big.mark = ","),
              qual_bins$arrest_rate[i] * 100,
              qual_bins$hit_rate[i] * 100,
              qual_bins$furtive_only_rate[i] * 100,
              qual_bins$frisk_no_result_rate[i] * 100))
}

# ---- Save ----
results <- list(
  m_arrest = m1,
  m_hit = m2,
  m_frisk_no_result = m3,
  m_furtive = m4,
  qual_bins = qual_bins
)
saveRDS(results, "quotas/results_quality.rds")
cat("\nSaved quotas/results_quality.rds\n")
