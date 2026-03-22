# 02_within_month_timing.R
# Hockey-stick test: do daily stop counts spike toward month-end?
# Controls for day-of-week, includes year interactions
# Output: quotas/results_hockey_stick.rds

library(data.table)

sqf <- readRDS("quotas/sqf_daily.rds")

# ---- Aggregate to precinct-day level ----
pct_day <- sqf[, .(stops = .N,
                    arrests = sum(arstmade),
                    hit = sum(hit),
                    frisked = sum(frisked),
                    frisked_no_result = sum(frisked_no_result),
                    only_furtive = sum(only_furtive)),
               by = .(date, year, month, day, dow, days_remaining, last_5, pct)]

# ---- Citywide-day level ----
city_day <- sqf[, .(stops = .N,
                     arrests = sum(arstmade),
                     hit = sum(hit),
                     frisked = sum(frisked),
                     frisked_no_result = sum(frisked_no_result),
                     only_furtive = sum(only_furtive)),
                by = .(date, year, month, day, dow, days_remaining, last_5)]

cat("=== HOCKEY-STICK TEST: Within-Month Timing ===\n\n")

# ---- Test 1: Linear days_remaining effect (more stops as month-end nears) ----
cat("--- Test 1: OLS — stops ~ days_remaining + dow FE + year FE ---\n")
m1 <- lm(stops ~ days_remaining + factor(dow) + factor(year), data = city_day)
cat(sprintf("  days_remaining coef: %.2f (SE=%.2f, p=%.4f)\n",
            coef(m1)["days_remaining"],
            summary(m1)$coefficients["days_remaining", "Std. Error"],
            summary(m1)$coefficients["days_remaining", "Pr(>|t|)"]))
cat(sprintf("  Interpretation: each day closer to month-end → %.1f more stops\n\n",
            -coef(m1)["days_remaining"]))

# ---- Test 2: Last-5-days indicator ----
cat("--- Test 2: OLS — stops ~ last_5 + dow FE + year FE ---\n")
m2 <- lm(stops ~ last_5 + factor(dow) + factor(year), data = city_day)
cat(sprintf("  last_5 coef: %.2f (SE=%.2f, p=%.4f)\n",
            coef(m2)["last_5"],
            summary(m2)$coefficients["last_5", "Std. Error"],
            summary(m2)$coefficients["last_5", "Pr(>|t|)"]))
cat(sprintf("  Mean daily stops: %.0f | Last-5 bump: %.1f%%\n\n",
            mean(city_day$stops),
            coef(m2)["last_5"] / mean(city_day$stops) * 100))

# ---- Test 3: Year interactions — does hockey stick get stronger? ----
cat("--- Test 3: OLS — stops ~ days_remaining × year + dow FE ---\n")
m3 <- lm(stops ~ days_remaining * factor(year) + factor(dow), data = city_day)
# Extract the interaction terms
coefs3 <- coef(summary(m3))
dr_rows <- grep("days_remaining", rownames(coefs3))
cat("  days_remaining effects by year:\n")
# Base year (2006) effect
base_eff <- coefs3["days_remaining", "Estimate"]
cat(sprintf("    2006 (base): %.2f (p=%.4f)\n", base_eff, coefs3["days_remaining", "Pr(>|t|)"]))
for (yr in 2007:2016) {
  int_name <- sprintf("days_remaining:factor(year)%d", yr)
  if (int_name %in% rownames(coefs3)) {
    total_eff <- base_eff + coefs3[int_name, "Estimate"]
    cat(sprintf("    %d: %.2f (interaction p=%.4f)\n", yr, total_eff,
                coefs3[int_name, "Pr(>|t|)"]))
  }
}

# ---- Test 4: last_5 × year interactions ----
cat("\n--- Test 4: OLS — stops ~ last_5 × year + dow FE ---\n")
m4 <- lm(stops ~ last_5 * factor(year) + factor(dow), data = city_day)
coefs4 <- coef(summary(m4))
base_l5 <- coefs4["last_5", "Estimate"]
mean_stops <- city_day[, mean(stops), by = year]
setnames(mean_stops, "V1", "mean_stops")
cat(sprintf("    2006 (base): %.1f stops (%.1f%% of mean)\n",
            base_l5, base_l5 / mean_stops[year == 2006, mean_stops] * 100))
for (yr in 2007:2016) {
  int_name <- sprintf("last_5:factor(year)%d", yr)
  if (int_name %in% rownames(coefs4)) {
    total_eff <- base_l5 + coefs4[int_name, "Estimate"]
    yr_mean <- mean_stops[year == yr, mean_stops]
    cat(sprintf("    %d: %.1f stops (%.1f%% of mean, interaction p=%.4f)\n",
                yr, total_eff, total_eff / yr_mean * 100,
                coefs4[int_name, "Pr(>|t|)"]))
  }
}

# ---- Test 5: Day-of-month bins (visual pattern) ----
cat("\n--- Test 5: Mean stops by day-of-month position (day-of-week adjusted) ---\n")
city_day[, dow_resid := residuals(lm(stops ~ factor(dow), data = city_day))]
bins <- city_day[, .(mean_stops = mean(stops),
                     adj_stops = mean(dow_resid) + mean(city_day$stops),
                     n_days = .N),
                 by = .(day_bin = cut(days_remaining,
                                      breaks = c(-1, 2, 5, 10, 15, 31),
                                      labels = c("0-2", "3-5", "6-10", "11-15", "16+")))]
setorder(bins, day_bin)
cat("  days_remaining | raw_mean | dow_adj | n_days\n")
for (i in seq_len(nrow(bins))) {
  cat(sprintf("  %14s | %7.0f  | %7.0f | %5d\n",
              bins$day_bin[i], bins$mean_stops[i], bins$adj_stops[i], bins$n_days[i]))
}

# ---- Save results ----
results <- list(
  m_linear = m1,
  m_last5 = m2,
  m_linear_year_int = m3,
  m_last5_year_int = m4,
  bins = bins,
  mean_stops_by_year = mean_stops
)
saveRDS(results, "quotas/results_hockey_stick.rds")
cat("\nSaved quotas/results_hockey_stick.rds\n")
