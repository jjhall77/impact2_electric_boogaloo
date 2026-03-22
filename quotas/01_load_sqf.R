# 01_load_sqf.R
# Load and harmonize all SQF files (2006-2016) into a single daily-level dataset
# Output: quotas/sqf_daily.rds

library(data.table)

sqf_dir <- "data-raw/sqf"

# ---- Load each year ----
cat("Loading SQF files...\n")

all_stops <- list()

for (yr in 2006:2016) {
  fname <- if (yr >= 2015) {
    file.path(sqf_dir, sprintf("sqf-%d.csv", yr))
  } else {
    file.path(sqf_dir, sprintf("%d.csv", yr))
  }

  if (!file.exists(fname)) {
    cat(sprintf("  %d: MISSING (%s)\n", yr, fname))
    next
  }

  dt <- fread(fname, select = c("datestop", "timestop", "pct",
                                  "arstmade", "sumissue",
                                  "frisked", "searched",
                                  "contrabn", "pistol", "riflshot", "asltweap",
                                  "knifcuti", "othrweap",
                                  "cs_objcs", "cs_descr", "cs_casng",
                                  "cs_lkout", "cs_cloth", "cs_drgtr",
                                  "cs_furtv", "cs_vcrim", "cs_bulge",
                                  "cs_other"),
              na.strings = c("", "NA", "(null)"))

  # Parse date — fread may auto-parse as IDate or leave as integer MMDDYYYY
  if (inherits(dt$datestop, "Date")) {
    dt[, date := as.IDate(datestop)]
  } else {
    dt[, datestop := as.character(datestop)]
    dt[, datestop := sprintf("%08s", datestop)]
    dt[, date := as.Date(datestop, format = "%m%d%Y")]
  }

  # Drop unparseable
  dt <- dt[!is.na(date)]
  dt <- dt[year(date) == yr]

  # Parse time
  dt[, timestop := as.character(timestop)]
  dt[, timestop := sprintf("%04s", timestop)]
  dt[, hour := as.integer(substr(timestop, 1, 2))]
  dt[hour > 23, hour := NA_integer_]

  # Standardize Y/N fields to 0/1
  yn_cols <- c("arstmade", "sumissue", "frisked", "searched", "contrabn",
               "pistol", "riflshot", "asltweap", "knifcuti", "othrweap",
               "cs_objcs", "cs_descr", "cs_casng", "cs_lkout", "cs_cloth",
               "cs_drgtr", "cs_furtv", "cs_vcrim", "cs_bulge", "cs_other")
  for (col in yn_cols) {
    if (col %in% names(dt)) {
      dt[, (col) := fifelse(toupper(get(col)) == "Y", 1L, 0L)]
    }
  }

  # Derived fields
  dt[, weapon_found := pmax(pistol, riflshot, asltweap, knifcuti, othrweap, na.rm = TRUE)]
  dt[, hit := pmax(arstmade, contrabn, weapon_found, na.rm = TRUE)]
  dt[, frisked_no_result := fifelse(frisked == 1 & hit == 0, 1L, 0L)]

  # Reason: count how many circumstance boxes checked
  cs_cols <- grep("^cs_", names(dt), value = TRUE)
  dt[, n_reasons := rowSums(.SD, na.rm = TRUE), .SDcols = cs_cols]
  dt[, only_furtive := fifelse(cs_furtv == 1 & n_reasons == 1, 1L, 0L)]

  # Calendar fields
  dt[, `:=`(
    year = year(date),
    month = month(date),
    day = mday(date),
    dow = wday(date),  # 1=Sun, 7=Sat
    days_in_month = mday(date + (32 - mday(date)) - mday(date + (32 - mday(date))) + 1),
    pct = as.integer(pct)
  )]
  # Correct days_in_month using lubridate-free approach
  dt[, days_in_month := as.integer(format(
    as.Date(sprintf("%d-%02d-01", ifelse(month == 12, year + 1L, year),
                                  ifelse(month == 12, 1L, month + 1L))) - 1,
    "%d"))]
  dt[, days_remaining := days_in_month - day]
  dt[, last_5 := fifelse(days_remaining < 5, 1L, 0L)]
  dt[, first_day := fifelse(day == 1, 1L, 0L)]
  dt[, last_day := fifelse(day == days_in_month, 1L, 0L)]
  dt[, ym := sprintf("%d-%02d", year, month)]

  # Keep relevant columns
  keep_cols <- c("date", "year", "month", "day", "dow", "hour", "pct", "ym",
                 "days_in_month", "days_remaining", "last_5", "first_day", "last_day",
                 "arstmade", "sumissue", "frisked", "searched",
                 "contrabn", "weapon_found", "hit", "frisked_no_result",
                 "only_furtive", "n_reasons",
                 "cs_furtv", "cs_bulge", "cs_objcs", "cs_descr")
  dt <- dt[, ..keep_cols]

  all_stops[[as.character(yr)]] <- dt
  cat(sprintf("  %d: %s stops\n", yr, format(nrow(dt), big.mark = ",")))
}

sqf <- rbindlist(all_stops)
cat(sprintf("\nTotal: %s stops\n", format(nrow(sqf), big.mark = ",")))

# Summary by year
cat("\nStops by year:\n")
print(sqf[, .(.N, arrest_rate = mean(arstmade), hit_rate = mean(hit),
              furtive_only = mean(only_furtive)), by = year][order(year)])

saveRDS(sqf, "quotas/sqf_daily.rds")
cat("\nSaved quotas/sqf_daily.rds\n")
