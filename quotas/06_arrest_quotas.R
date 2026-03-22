# 06_arrest_quotas.R
# Quota test using low-level arrests (misdemeanor + violation) vs felony arrests
# If quotas exist, discretionary low-level arrests should show month-end patterns
# Felony arrests (less discretionary) serve as a control
# Output: quotas/results_arrest_quotas.rds

library(data.table)

# ---- Load raw arrest data ----
cat("Loading raw arrest data...\n")
arr <- fread("data-raw/NYPD_Arrests_Data_(Historic)_20260315.csv",
             select = c("ARREST_DATE", "ARREST_PRECINCT", "LAW_CAT_CD"))

cat(sprintf("Raw rows: %s\n", format(nrow(arr), big.mark = ",")))

# Parse date
arr[, date := as.Date(ARREST_DATE, format = "%m/%d/%Y")]
arr <- arr[!is.na(date)]
arr[, year := year(date)]
arr <- arr[year >= 2006 & year <= 2016]

# Classify severity
arr[, severity := fcase(
  LAW_CAT_CD == "F", "felony",
  LAW_CAT_CD == "M", "misdemeanor",
  LAW_CAT_CD == "V", "violation",
  default = "other"
)]

cat("Severity distribution:\n")
print(arr[, .N, by = severity][order(-N)])

# Low-level = misdemeanor + violation
arr[, low_level := fifelse(severity %in% c("misdemeanor", "violation"), 1L, 0L)]
arr[, felony := fifelse(severity == "felony", 1L, 0L)]

# ---- Aggregate to citywide-day ----
city_day <- arr[, .(
  total = .N,
  felony = sum(felony),
  low_level = sum(low_level),
  misdemeanor = sum(severity == "misdemeanor"),
  violation = sum(severity == "violation")
), by = .(date, year)]

# Calendar fields
city_day[, `:=`(
  month = month(date),
  day = mday(date),
  dow = wday(date)
)]
city_day[, days_in_month := as.integer(format(
  as.Date(sprintf("%d-%02d-01", ifelse(month == 12, year + 1L, year),
                                ifelse(month == 12, 1L, month + 1L))) - 1, "%d"))]
city_day[, days_remaining := days_in_month - day]
city_day[, last_5 := fifelse(days_remaining < 5, 1L, 0L)]
city_day[, first_day := fifelse(day == 1, 1L, 0L)]

cat(sprintf("\nCitywide-day obs: %d\n", nrow(city_day)))
cat(sprintf("Mean daily: felony=%.0f, low-level=%.0f, total=%.0f\n",
            mean(city_day$felony), mean(city_day$low_level), mean(city_day$total)))

# ============================================================================
# TEST 1: HOCKEY STICK — last_5 effect on low-level vs felony
# ============================================================================
cat("\n=== TEST 1: HOCKEY STICK (last_5 days) ===\n\n")

for (outcome in c("low_level", "felony", "total")) {
  m <- lm(as.formula(paste(outcome, "~ last_5 + factor(dow) + factor(year)")),
          data = city_day)
  coefs <- coef(summary(m))
  cat(sprintf("  %11s ~ last_5: %7.1f (SE=%.1f, p=%.4f) | mean=%.0f | %%=%+.1f%%\n",
              outcome, coefs["last_5", "Estimate"], coefs["last_5", "Std. Error"],
              coefs["last_5", "Pr(>|t|)"], mean(city_day[[outcome]]),
              coefs["last_5", "Estimate"] / mean(city_day[[outcome]]) * 100))
}

# Linear days_remaining
cat("\n  Linear days_remaining:\n")
for (outcome in c("low_level", "felony")) {
  m <- lm(as.formula(paste(outcome, "~ days_remaining + factor(dow) + factor(year)")),
          data = city_day)
  coefs <- coef(summary(m))
  cat(sprintf("  %11s: %.2f per day (p=%.4f)\n",
              outcome, coefs["days_remaining", "Estimate"],
              coefs["days_remaining", "Pr(>|t|)"]))
}

# ============================================================================
# TEST 2: YEAR INTERACTIONS — does pattern intensify?
# ============================================================================
cat("\n=== TEST 2: LAST_5 × YEAR INTERACTIONS ===\n\n")

for (outcome in c("low_level", "felony")) {
  cat(sprintf("--- %s ---\n", outcome))
  m <- lm(as.formula(paste(outcome, "~ last_5 * factor(year) + factor(dow)")),
          data = city_day)
  coefs <- coef(summary(m))
  base <- coefs["last_5", "Estimate"]
  yr_means <- city_day[, lapply(.SD, mean), by = year, .SDcols = outcome]

  cat(sprintf("  2006 (base): %+.1f (p=%.4f)\n", base, coefs["last_5", "Pr(>|t|)"]))
  for (yr in 2007:2016) {
    int_name <- sprintf("last_5:factor(year)%d", yr)
    if (int_name %in% rownames(coefs)) {
      total <- base + coefs[int_name, "Estimate"]
      yr_mean <- yr_means[year == yr][[outcome]]
      cat(sprintf("  %d: %+.1f (%+.1f%%, int.p=%.4f)\n",
                  yr, total, total / yr_mean * 100, coefs[int_name, "Pr(>|t|)"]))
    }
  }
  cat("\n")
}

# ============================================================================
# TEST 3: FIRST-OF-MONTH CLIFF (RD)
# ============================================================================
cat("=== TEST 3: FIRST-OF-MONTH CLIFF (RD ±7 days) ===\n\n")

city_day[, dist_boundary := fifelse(day <= 7, day,
                            fifelse(days_remaining < 7, -(days_remaining + 1),
                                    NA_integer_))]
rd_data <- city_day[!is.na(dist_boundary)]
rd_data[, new_month := fifelse(dist_boundary > 0, 1L, 0L)]

for (outcome in c("low_level", "felony")) {
  m <- lm(as.formula(paste(outcome, "~ new_month + dist_boundary + factor(dow) + factor(year)")),
          data = rd_data)
  coefs <- coef(summary(m))
  cat(sprintf("  %11s: RD jump = %+.1f (SE=%.1f, p=%.4f) | %+.1f%% of mean\n",
              outcome, coefs["new_month", "Estimate"], coefs["new_month", "Std. Error"],
              coefs["new_month", "Pr(>|t|)"],
              coefs["new_month", "Estimate"] / mean(rd_data[[outcome]]) * 100))
}

# ============================================================================
# TEST 4: QUALITY-STYLE — ratio of low-level to total
# ============================================================================
cat("\n=== TEST 4: LOW-LEVEL SHARE OF ARRESTS ~ days_remaining ===\n\n")

city_day[, low_share := low_level / total]
city_day[, violation_share := violation / total]

m_share <- lm(low_share ~ days_remaining + factor(dow) + factor(year), data = city_day)
coefs_s <- coef(summary(m_share))
cat(sprintf("  low_share ~ days_remaining: %.6f (p=%.4f)\n",
            coefs_s["days_remaining", "Estimate"],
            coefs_s["days_remaining", "Pr(>|t|)"]))
cat("  Negative = low-level share INCREASES at month-end → quota\n\n")

# Binned
city_day[, position := cut(days_remaining,
                           breaks = c(-1, 2, 5, 10, 15, 31),
                           labels = c("0-2", "3-5", "6-10", "11-15", "16+"))]
bins <- city_day[, .(felony = mean(felony),
                      low_level = mean(low_level),
                      total = mean(total),
                      low_share = mean(low_share),
                      n = .N), by = position][order(position)]
cat("  position | felony | low_level | total | low_share | n\n")
for (i in seq_len(nrow(bins))) {
  cat(sprintf("  %8s | %6.0f | %9.0f | %5.0f | %8.1f%% | %d\n",
              bins$position[i], bins$felony[i], bins$low_level[i],
              bins$total[i], bins$low_share[i] * 100, bins$n[i]))
}

# ============================================================================
# TEST 5: PRECINCT-LEVEL — low-level last_5 by precinct
# ============================================================================
cat("\n=== TEST 5: PRECINCT-LEVEL last_5 EFFECTS ===\n\n")

pct_day <- arr[, .(
  felony = sum(felony),
  low_level = sum(low_level)
), by = .(date, year, ARREST_PRECINCT)]

pct_day[, `:=`(
  month = month(date),
  day = mday(date),
  dow = wday(date)
)]
pct_day[, days_in_month := as.integer(format(
  as.Date(sprintf("%d-%02d-01", ifelse(month == 12, year + 1L, year),
                                ifelse(month == 12, 1L, month + 1L))) - 1, "%d"))]
pct_day[, days_remaining := days_in_month - day]
pct_day[, last_5 := fifelse(days_remaining < 5, 1L, 0L)]

# Precinct-specific estimates
pct_n <- pct_day[, .N, by = ARREST_PRECINCT][N > 500]
pct_results <- list()
for (p in sort(pct_n$ARREST_PRECINCT)) {
  sub <- pct_day[ARREST_PRECINCT == p]
  m_ll <- tryCatch(lm(low_level ~ last_5 + factor(dow) + factor(year), data = sub),
                   error = function(e) NULL)
  m_f <- tryCatch(lm(felony ~ last_5 + factor(dow) + factor(year), data = sub),
                  error = function(e) NULL)
  if (is.null(m_ll) || is.null(m_f)) next

  cl <- coef(summary(m_ll))
  cf <- coef(summary(m_f))
  if (!("last_5" %in% rownames(cl) & "last_5" %in% rownames(cf))) next

  pct_results[[as.character(p)]] <- data.table(
    pct = p,
    ll_coef = cl["last_5", "Estimate"],
    ll_se = cl["last_5", "Std. Error"],
    ll_p = cl["last_5", "Pr(>|t|)"],
    ll_pct = cl["last_5", "Estimate"] / mean(sub$low_level) * 100,
    f_coef = cf["last_5", "Estimate"],
    f_se = cf["last_5", "Std. Error"],
    f_p = cf["last_5", "Pr(>|t|)"],
    f_pct = cf["last_5", "Estimate"] / mean(sub$felony) * 100,
    mean_ll = mean(sub$low_level),
    mean_f = mean(sub$felony)
  )
}
pct_dt <- rbindlist(pct_results)

cat(sprintf("Estimated for %d precincts\n", nrow(pct_dt)))
cat(sprintf("  Low-level: %d/%d positive (%.0f%%), %d sig at 5%%\n",
            sum(pct_dt$ll_coef > 0), nrow(pct_dt),
            sum(pct_dt$ll_coef > 0) / nrow(pct_dt) * 100,
            sum(pct_dt$ll_p < 0.05 & pct_dt$ll_coef > 0)))
cat(sprintf("  Felony:    %d/%d positive (%.0f%%), %d sig at 5%%\n",
            sum(pct_dt$f_coef > 0), nrow(pct_dt),
            sum(pct_dt$f_coef > 0) / nrow(pct_dt) * 100,
            sum(pct_dt$f_p < 0.05 & pct_dt$f_coef > 0)))

cat("\n--- Top 10 precincts: low-level last_5 spike ---\n")
top10 <- pct_dt[order(-ll_coef)][1:10]
cat("  pct | ll_coef | ll_p   | ll_%   | f_coef | f_p    | f_%\n")
for (i in seq_len(nrow(top10))) {
  cat(sprintf("  %3d | %+6.1f  | %.4f | %+5.1f%% | %+5.1f  | %.4f | %+5.1f%%\n",
              top10$pct[i], top10$ll_coef[i], top10$ll_p[i], top10$ll_pct[i],
              top10$f_coef[i], top10$f_p[i], top10$f_pct[i]))
}

# ============================================================================
# TEST 6: DIFFERENCE-IN-DIFFERENCES — low-level vs felony month-end gap
# ============================================================================
cat("\n=== TEST 6: DiD — low-level vs felony at month-end ===\n\n")

# Stack long
city_long <- rbind(
  city_day[, .(date, year, dow, days_remaining, last_5, count = low_level, type = "low_level")],
  city_day[, .(date, year, dow, days_remaining, last_5, count = felony, type = "felony")]
)
city_long[, is_low := fifelse(type == "low_level", 1L, 0L)]

m_did <- lm(count ~ last_5 * is_low + factor(dow) + factor(year) + is_low,
            data = city_long)
coefs_did <- coef(summary(m_did))
cat("  Interaction (last_5 × is_low_level):\n")
cat(sprintf("    coef=%.1f (SE=%.1f, p=%.4f)\n",
            coefs_did["last_5:is_low", "Estimate"],
            coefs_did["last_5:is_low", "Std. Error"],
            coefs_did["last_5:is_low", "Pr(>|t|)"]))
cat("  Positive = low-level arrests spike MORE at month-end than felonies → quota\n")
cat("  Negative = low-level arrests spike LESS → no differential quota pressure\n")

# Year-specific DiD
cat("\n  DiD by year (last_5 × is_low interaction):\n")
for (yr in c(2006, 2008, 2010, 2011, 2012, 2014, 2016)) {
  sub <- city_long[year == yr]
  m <- lm(count ~ last_5 * is_low + factor(dow) + is_low, data = sub)
  c <- coef(summary(m))
  if ("last_5:is_low" %in% rownames(c)) {
    cat(sprintf("    %d: DiD=%+.1f (p=%.4f)\n", yr, c["last_5:is_low", "Estimate"],
                c["last_5:is_low", "Pr(>|t|)"]))
  }
}

# ---- Save ----
results <- list(
  city_day = city_day[, .(date, year, month, day, dow, days_remaining, last_5,
                          felony, low_level, misdemeanor, violation, total, low_share)],
  bins = bins,
  pct_estimates = pct_dt,
  m_did = m_did
)
saveRDS(results, "quotas/results_arrest_quotas.rds")
cat("\n\nSaved quotas/results_arrest_quotas.rds\n")
