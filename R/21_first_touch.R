# 21_first_touch.R
# ROBUSTNESS: First-touch analysis
#
# Estimate the impact of treatment for hexes the FIRST TIME they enter
# an impact zone. This isolates the initial deployment effect from
# repeated on/off cycling and avoids residual deterrence contamination.
#
# Key: impact zones started in 2003, but our panel starts 2006-01.
# Hexes first treated in iterations 1-5 (2003-2005) entered treatment
# BEFORE our panel begins — their "first touch" is unobservable.
# We restrict to hexes first treated from 2006-01 onward.

library(data.table)
library(jsonlite)
Sys.setenv(RGL_USE_NULL = "TRUE")
library(polars)
suppressWarnings(suppressMessages(library(DIDmultiplegtDYN)))

get_att <- function(res) {
  if (!is.null(res$results$ATE)) {
    list(att = res$results$ATE[1, "Estimate"],
         se  = res$results$ATE[1, "SE"])
  } else {
    list(att = NA, se = NA)
  }
}

cat("Loading data...\n")
qdt <- readRDS("data/panel_quarterly_analysis.rds")
setkey(qdt, hex_num, qid)

tmap <- fromJSON("data/hex_treatment_map.json", simplifyVector = FALSE)

outcomes <- c("violent", "property", "robbery", "felony_assault", "burglary",
              "robbery_outside", "felony_assault_outside", "burglary_outside")
labels <- c("Violent Felony", "Property Felony", "Robbery", "Felony Assault",
            "Burglary", "Robbery (Outside)", "F. Assault (Outside)",
            "Burglary (Outside)")
names(labels) <- outcomes

# ---- Identify first-touch hexes ----
cat("\nIdentifying first-touch hexes...\n")

hex_first_treat <- data.table(
  hex_id = names(tmap$treated),
  first_date = sapply(tmap$treated, function(x) x$first_treated)
)
hex_first_treat[, first_date := as.Date(first_date)]
hex_first_treat[, first_year := year(first_date)]
hex_first_treat[, first_month := month(first_date)]
hex_first_treat[, first_ym := sprintf("%d-%02d", first_year, first_month)]
hex_first_treat[, first_quarter := ceiling(first_month / 3)]
hex_first_treat[, first_yq := first_year * 10L + first_quarter]

cat("First treatment distribution:\n")
print(hex_first_treat[, .N, by = first_year][order(first_year)])

# Hexes first treated within our panel (2006+)
first_in_panel <- hex_first_treat[first_date >= as.Date("2006-01-01")]
cat(sprintf("\nFirst treated in panel (2006+): %d hexes\n", nrow(first_in_panel)))
cat(sprintf("First treated before panel: %d hexes (excluded)\n",
            nrow(hex_first_treat) - nrow(first_in_panel)))

# Also get hex_num mapping
hex_id_num <- unique(qdt[, .(hex_id, hex_num)])
first_in_panel <- merge(first_in_panel, hex_id_num, by = "hex_id")

# ---- Build first-touch treatment variable ----
# For each first-touch hex, treatment = 1 ONLY in the quarter of first treatment
# and a few quarters after (to capture the initial effect).
# All subsequent treatment episodes are coded as 0.
# Controls: never-treated hexes.

cat("\nBuilding first-touch panel...\n")

# Map first_yq to qid
qmap <- unique(qdt[, .(yq = year * 10L + ceiling(quarter), qid)])[, .SD[1], by = yq]

# We need first_in_panel$first_yq mapped to qid
first_in_panel <- merge(first_in_panel, qmap, by.x = "first_yq", by.y = "yq", all.x = TRUE)
setnames(first_in_panel, "qid", "first_qid")

# Create panel with first-touch treatment only
# Keep: first-touch hexes + never-treated hexes
never_treated_nums <- qdt[, .(ever = any(treatment == 1)), by = hex_num][ever == FALSE, hex_num]
# Also include pre-2006 treated hexes as potential controls? No — they're contaminated.
# Exclude all hexes that were treated before 2006.
pre_panel_hex_nums <- hex_id_num[hex_id %in% hex_first_treat[first_date < as.Date("2006-01-01"), hex_id], hex_num]

# First-touch panel: first-in-panel hexes + never-treated (excluding pre-panel treated)
ft_hexes <- c(first_in_panel$hex_num, never_treated_nums)
ft_hexes <- setdiff(ft_hexes, pre_panel_hex_nums)  # shouldn't overlap, but be safe

qdt_ft <- qdt[hex_num %in% ft_hexes]

# Build first-touch treatment: 1 only from first_qid onward for first iteration only
# We need the end of the first iteration for each hex
cat("Computing first-touch treatment windows...\n")

# For each first-touch hex, get the first iteration end date
ft_windows <- data.table(hex_id = character(), hex_num = integer(),
                         start_qid = integer(), end_qid = integer())
for (i in seq_len(nrow(first_in_panel))) {
  hid <- first_in_panel$hex_id[i]
  hnum <- first_in_panel$hex_num[i]
  iters <- tmap$treated[[hid]]$iterations
  first_iter <- iters[[1]]  # First iteration
  start_d <- as.Date(first_iter$start)
  end_d <- as.Date(first_iter$end)

  start_yq <- year(start_d) * 10L + ceiling(month(start_d) / 3)
  end_yq <- year(end_d) * 10L + ceiling(month(end_d) / 3)

  sq <- qmap[yq == start_yq, qid]
  eq <- qmap[yq == end_yq, qid]
  if (length(sq) == 0) sq <- NA_integer_
  if (length(eq) == 0) eq <- NA_integer_

  ft_windows <- rbind(ft_windows, data.table(hex_id = hid, hex_num = hnum,
                                              start_qid = sq, end_qid = eq))
}

# Set first-touch treatment
qdt_ft[, ft_treatment := 0L]
for (i in seq_len(nrow(ft_windows))) {
  w <- ft_windows[i]
  if (!is.na(w$start_qid) & !is.na(w$end_qid)) {
    qdt_ft[hex_num == w$hex_num & qid >= w$start_qid & qid <= w$end_qid,
           ft_treatment := 1L]
  }
}

cat(sprintf("  First-touch hexes: %d\n", nrow(first_in_panel)))
cat(sprintf("  Never-treated controls: %d\n", length(never_treated_nums)))
cat(sprintf("  Total panel hexes: %d\n", uniqueN(qdt_ft$hex_num)))
cat(sprintf("  FT treatment-ON hex-quarters: %d\n", sum(qdt_ft$ft_treatment)))

# ---- Re-index and run dCDH ----
# Re-number hex_num
hex_remap <- data.table(hex_num_orig = sort(unique(qdt_ft$hex_num)))
hex_remap[, hex_num_new := .I]
qdt_ft <- merge(qdt_ft, hex_remap, by.x = "hex_num", by.y = "hex_num_orig")
qdt_ft[, hex_num := hex_num_new]
qdt_ft[, hex_num_new := NULL]
setkey(qdt_ft, hex_num, qid)

# Override treatment with first-touch treatment
qdt_ft[, treatment := ft_treatment]

cat(sprintf("\n========== FIRST-TOUCH dCDH ==========\n"))
cat(sprintf("  %s rows, %d hexes, %d quarters\n",
            format(nrow(qdt_ft), big.mark = ","),
            uniqueN(qdt_ft$hex_num), uniqueN(qdt_ft$qid)))

ft_results <- list()
for (yvar in outcomes) {
  cat(sprintf("  %s: ", labels[yvar]))
  tryCatch({
    res <- did_multiplegt_dyn(
      df = as.data.frame(qdt_ft),
      outcome = yvar,
      group = "hex_num",
      time = "qid",
      treatment = "treatment",
      effects = 4,
      placebo = 2,
      graph_off = TRUE,
      cluster = "hex_num"
    )
    ft_results[[yvar]] <- res
    r <- get_att(res)
    if (!is.na(r$att)) {
      cat(sprintf("ATT=%.4f (SE=%.4f)\n", r$att, r$se))
    } else {
      cat("no ATT\n")
    }
  }, error = function(e) {
    cat(sprintf("ERROR: %s\n", e$message))
    ft_results[[yvar]] <<- list(error = e$message)
  })
}

# ---- Comparison ----
dcdh_base <- readRDS("output/dcdh_full_results.rds")

cat("\n\n========== FIRST-TOUCH vs BASELINE ==========\n")
cat(sprintf("%-22s %12s %12s\n", "Outcome", "Baseline", "First-Touch"))
cat(strrep("-", 48), "\n")
for (yvar in outcomes) {
  r0 <- get_att(dcdh_base[[yvar]])
  r1 <- get_att(ft_results[[yvar]])
  fmt <- function(r) {
    if (is.na(r$att)) return(sprintf("%12s", "N/A"))
    sig <- ifelse(abs(r$att / r$se) > 1.96, "*",
           ifelse(abs(r$att / r$se) > 1.645, "+", " "))
    sprintf("%10.4f%s", r$att, sig)
  }
  cat(sprintf("%-22s %12s %12s\n", labels[yvar], fmt(r0), fmt(r1)))
}

saveRDS(ft_results, "output/first_touch_results.rds")
cat("\nSaved output/first_touch_results.rds\n")
cat("First-touch analysis complete.\n")
