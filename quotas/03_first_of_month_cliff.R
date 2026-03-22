# 03_first_of_month_cliff.R
# Discontinuity at month boundaries: does day 1 have fewer stops than day 28-31?
# RD-style test with running variable = days from month boundary
# Year interactions to capture intensification
# Output: quotas/results_cliff.rds

library(data.table)

sqf <- readRDS("quotas/sqf_daily.rds")

# ---- Citywide-day ----
city_day <- sqf[, .(stops = .N,
                     arrests = sum(arstmade),
                     hit = sum(hit),
                     frisked_no_result = sum(frisked_no_result)),
                by = .(date, year, month, day, dow, days_remaining, days_in_month,
                       first_day, last_day)]

cat("=== FIRST-OF-MONTH CLIFF TEST ===\n\n")

# ---- Approach 1: Simple t-test — last 3 days vs first 3 days ----
city_day[, period := fifelse(days_remaining <= 2, "last3",
                    fifelse(day <= 3, "first3", "middle"))]

means <- city_day[period != "middle", .(mean_stops = mean(stops), sd = sd(stops), n = .N),
                  by = period]
cat("--- Simple comparison: last 3 days vs first 3 days ---\n")
print(means)

tt <- t.test(stops ~ period, data = city_day[period != "middle"])
cat(sprintf("\n  t-test: diff=%.1f, t=%.2f, p=%.4f\n", diff(means$mean_stops),
            tt$statistic, tt$p.value))

# ---- Approach 2: RD around month boundary ----
# Create running variable: distance from month boundary
# Positive = days into new month, negative = days from end of old month
# Window: 7 days on each side
cat("\n--- RD around month boundary (±7 days) ---\n")

# Tag each day with distance from nearest month boundary
city_day[, dist_boundary := fifelse(day <= 7, day,  # first week: positive
                           fifelse(days_remaining < 7, -(days_remaining + 1),  # last week: negative
                                   NA_integer_))]
rd_data <- city_day[!is.na(dist_boundary)]
rd_data[, new_month := fifelse(dist_boundary > 0, 1L, 0L)]

# Simple RD: jump at boundary
m_rd <- lm(stops ~ new_month + dist_boundary + factor(dow) + factor(year), data = rd_data)
cat(sprintf("  RD jump (new_month): %.1f stops (SE=%.1f, p=%.4f)\n",
            coef(m_rd)["new_month"],
            summary(m_rd)$coefficients["new_month", "Std. Error"],
            summary(m_rd)$coefficients["new_month", "Pr(>|t|)"]))
cat(sprintf("  As %% of mean: %.1f%%\n",
            coef(m_rd)["new_month"] / mean(rd_data$stops) * 100))

# ---- Approach 3: RD × year interaction ----
cat("\n--- RD jump by year ---\n")
m_rd_yr <- lm(stops ~ new_month * factor(year) + dist_boundary + factor(dow), data = rd_data)
coefs <- coef(summary(m_rd_yr))
base_jump <- coefs["new_month", "Estimate"]

yr_means <- rd_data[, mean(stops), by = year]
setnames(yr_means, "V1", "mean_stops")

cat(sprintf("  2006 (base): %.1f stops (%.1f%%, p=%.4f)\n",
            base_jump, base_jump / yr_means[year == 2006, mean_stops] * 100,
            coefs["new_month", "Pr(>|t|)"]))

for (yr in 2007:2016) {
  int_name <- sprintf("new_month:factor(year)%d", yr)
  if (int_name %in% rownames(coefs)) {
    total <- base_jump + coefs[int_name, "Estimate"]
    yr_mean <- yr_means[year == yr, mean_stops]
    cat(sprintf("  %d: %.1f stops (%.1f%%, int. p=%.4f)\n",
                yr, total, total / yr_mean * 100, coefs[int_name, "Pr(>|t|)"]))
  }
}

# ---- Approach 4: Day-by-day means around boundary ----
cat("\n--- Day-by-day mean stops around month boundary (dow-adjusted) ---\n")
rd_data[, dow_resid := residuals(lm(stops ~ factor(dow) + factor(year), data = rd_data))]
day_means <- rd_data[, .(adj_stops = mean(dow_resid) + mean(rd_data$stops),
                          raw_mean = mean(stops),
                          n = .N),
                      by = dist_boundary][order(dist_boundary)]
cat("  dist_boundary | raw_mean | dow_adj | n_days\n")
for (i in seq_len(nrow(day_means))) {
  cat(sprintf("  %14d | %7.0f  | %7.0f | %5d\n",
              day_means$dist_boundary[i], day_means$raw_mean[i],
              day_means$adj_stops[i], day_means$n[i]))
}

# ---- Save ----
results <- list(
  means_comparison = means,
  t_test = tt,
  m_rd = m_rd,
  m_rd_year = m_rd_yr,
  day_means = day_means
)
saveRDS(results, "quotas/results_cliff.rds")
cat("\nSaved quotas/results_cliff.rds\n")
