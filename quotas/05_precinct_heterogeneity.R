# 05_precinct_heterogeneity.R
# Do some precincts show stronger month-end patterns?
# Proxy for command-level quota pressure variation
# Output: quotas/results_precinct.rds

library(data.table)

sqf <- readRDS("quotas/sqf_daily.rds")

cat("=== PRECINCT HETEROGENEITY TEST ===\n\n")

# Only use precincts with enough data (> 1000 stops)
pct_n <- sqf[, .N, by = pct][N > 1000]
cat(sprintf("Precincts with >1000 stops: %d (of %d)\n", nrow(pct_n), uniqueN(sqf$pct)))

sqf_sub <- sqf[pct %in% pct_n$pct]

# ---- Precinct-day aggregation ----
pct_day <- sqf_sub[, .(stops = .N,
                        arrests = sum(arstmade),
                        hit = sum(hit),
                        only_furtive = sum(only_furtive)),
                   by = .(date, year, month, day, dow, days_remaining, last_5, pct)]

# ---- Estimate precinct-specific last_5 coefficient ----
cat("Estimating precinct-level last_5 effects...\n")

pct_results <- list()
for (p in sort(unique(pct_day$pct))) {
  sub <- pct_day[pct == p]
  if (nrow(sub) < 100) next

  m <- tryCatch({
    lm(stops ~ last_5 + factor(dow) + factor(year), data = sub)
  }, error = function(e) NULL)

  if (is.null(m)) next

  coefs <- coef(summary(m))
  if (!"last_5" %in% rownames(coefs)) next

  pct_results[[as.character(p)]] <- data.table(
    pct = p,
    last5_coef = coefs["last_5", "Estimate"],
    last5_se = coefs["last_5", "Std. Error"],
    last5_p = coefs["last_5", "Pr(>|t|)"],
    mean_daily_stops = mean(sub$stops),
    total_stops = sum(sub$stops),
    last5_pct = coefs["last_5", "Estimate"] / mean(sub$stops) * 100
  )
}

pct_dt <- rbindlist(pct_results)
cat(sprintf("Estimated for %d precincts\n\n", nrow(pct_dt)))

# ---- Summary statistics ----
cat("--- Distribution of last_5 effects across precincts ---\n")
cat(sprintf("  Mean coefficient: %.2f (mean of pct-level last_5 coefs)\n", mean(pct_dt$last5_coef)))
cat(sprintf("  Median: %.2f\n", median(pct_dt$last5_coef)))
cat(sprintf("  Positive (more stops at month-end): %d / %d (%.0f%%)\n",
            sum(pct_dt$last5_coef > 0), nrow(pct_dt),
            sum(pct_dt$last5_coef > 0) / nrow(pct_dt) * 100))
cat(sprintf("  Significant at 5%%: %d / %d (%.0f%%)\n",
            sum(pct_dt$last5_p < 0.05 & pct_dt$last5_coef > 0), nrow(pct_dt),
            sum(pct_dt$last5_p < 0.05 & pct_dt$last5_coef > 0) / nrow(pct_dt) * 100))

# ---- Top / bottom precincts ----
cat("\n--- Top 10 precincts by last_5 effect (strongest month-end spike) ---\n")
top10 <- pct_dt[order(-last5_coef)][1:10]
cat("  pct | last5_coef | SE     | p      | mean_daily | last5_pct\n")
for (i in seq_len(nrow(top10))) {
  cat(sprintf("  %3d | %10.2f | %6.2f | %6.4f | %10.1f | %8.1f%%\n",
              top10$pct[i], top10$last5_coef[i], top10$last5_se[i],
              top10$last5_p[i], top10$mean_daily_stops[i], top10$last5_pct[i]))
}

cat("\n--- Bottom 10 precincts (no or negative month-end spike) ---\n")
bot10 <- pct_dt[order(last5_coef)][1:10]
cat("  pct | last5_coef | SE     | p      | mean_daily | last5_pct\n")
for (i in seq_len(nrow(bot10))) {
  cat(sprintf("  %3d | %10.2f | %6.2f | %6.4f | %10.1f | %8.1f%%\n",
              bot10$pct[i], bot10$last5_coef[i], bot10$last5_se[i],
              bot10$last5_p[i], bot10$mean_daily_stops[i], bot10$last5_pct[i]))
}

# ---- Year interaction at precinct level ----
cat("\n--- Precinct-level: does month-end effect intensify with SQF peak? ---\n")
# Split by volume tercile
pct_dt[, volume_tercile := cut(total_stops,
                                breaks = quantile(total_stops, c(0, 1/3, 2/3, 1)),
                                labels = c("low", "mid", "high"),
                                include.lowest = TRUE)]
terc_summary <- pct_dt[, .(mean_last5_coef = mean(last5_coef),
                            mean_last5_pct = mean(last5_pct),
                            n_pct = .N,
                            n_sig = sum(last5_p < 0.05 & last5_coef > 0)),
                        by = volume_tercile]
cat("  By stop-volume tercile:\n")
print(terc_summary)

# ---- Year-specific precinct-level estimates ----
cat("\n--- Year-specific last_5 effects (citywide, precinct FE) ---\n")
for (yr in 2006:2016) {
  sub <- pct_day[year == yr]
  m <- tryCatch(lm(stops ~ last_5 + factor(dow) + factor(pct), data = sub),
                error = function(e) NULL)
  if (!is.null(m)) {
    coefs <- coef(summary(m))
    if ("last_5" %in% rownames(coefs)) {
      cat(sprintf("  %d: last_5=%.2f (p=%.4f) | mean=%.1f | %%=%.1f%%\n",
                  yr, coefs["last_5", "Estimate"], coefs["last_5", "Pr(>|t|)"],
                  mean(sub$stops), coefs["last_5", "Estimate"] / mean(sub$stops) * 100))
    }
  }
}

# ---- Save ----
results <- list(
  pct_estimates = pct_dt,
  top10 = top10,
  bot10 = bot10,
  tercile_summary = terc_summary
)
saveRDS(results, "quotas/results_precinct.rds")
cat("\nSaved quotas/results_precinct.rds\n")
