# 20_robustness.R
# Robustness checks using subset/parameter variations on existing panel
#
# 1. Exclude 75th Precinct
# 2. Restrict controls to hexes near ever-treated (within 3 rings)
# 3. Continuously-treated (hexes treated in ALL quarters Q3 2013+) vs never-treated
# 4. Vary effects/placebo windows (6/3 and 4/2)
# 5. Drop transition quarters (Q2 2012 – Q2 2013, qid 26-30)

library(data.table)
library(jsonlite)
Sys.setenv(RGL_USE_NULL = "TRUE")
library(polars)
suppressWarnings(suppressMessages(library(DIDmultiplegtDYN)))

# Helper: extract ATT, SE from dCDH result (v2.3+ API)
get_att <- function(res) {
  if (!is.null(res$results$ATE)) {
    list(att = res$results$ATE[1, "Estimate"],
         se  = res$results$ATE[1, "SE"])
  } else {
    list(att = NA, se = NA)
  }
}

fmt_att <- function(r) {
  if (is.na(r$att)) return(sprintf("%10s", "N/A"))
  sig <- ifelse(abs(r$att / r$se) > 1.96, "*",
         ifelse(abs(r$att / r$se) > 1.645, "+", " "))
  sprintf("%9.4f%s", r$att, sig)
}

cat("Loading quarterly panel...\n")
qdt <- readRDS("data/panel_quarterly_analysis.rds")
setkey(qdt, hex_num, qid)

outcomes <- c("violent", "property", "robbery", "felony_assault", "burglary",
              "robbery_outside", "felony_assault_outside", "burglary_outside")
labels <- c("Violent", "Property", "Robbery", "Fel.Asslt",
            "Burglary", "Rob(Out)", "FA(Out)", "Burg(Out)")
names(labels) <- outcomes

# Load baseline for comparison
dcdh_base <- readRDS("output/dcdh_full_results.rds")

# ==============================================================================
# Generic runner: run dCDH on a subset of qdt
# ==============================================================================
run_dcdh_subset <- function(label, qdt_sub, n_effects = 8, n_placebo = 4) {
  cat(sprintf("\n========== %s ==========\n", label))

  # Re-index qid sequentially if needed
  qids <- sort(unique(qdt_sub$qid))
  if (!identical(qids, seq_along(qids))) {
    qmap <- data.table(qid_orig = qids)
    qmap[, qid_new := .I]
    qdt_sub <- merge(qdt_sub, qmap, by.x = "qid", by.y = "qid_orig")
    qdt_sub[, qid := qid_new]
    qdt_sub[, qid_new := NULL]
  }
  setkey(qdt_sub, hex_num, qid)

  # Re-number hex_num sequentially
  hex_map <- data.table(hex_num_orig = sort(unique(qdt_sub$hex_num)))
  hex_map[, hex_num_new := .I]
  qdt_sub <- merge(qdt_sub, hex_map, by.x = "hex_num", by.y = "hex_num_orig")
  qdt_sub[, hex_num := hex_num_new]
  qdt_sub[, hex_num_new := NULL]
  setkey(qdt_sub, hex_num, qid)

  cat(sprintf("  %s rows, %d hexes, %d quarters, %d treated hex-q\n",
              format(nrow(qdt_sub), big.mark = ","),
              uniqueN(qdt_sub$hex_num), uniqueN(qdt_sub$qid),
              sum(qdt_sub$treatment)))

  n_switchers <- qdt_sub[, .(has_switch = any(diff(treatment) != 0)), by = hex_num][has_switch == TRUE, .N]
  cat(sprintf("  Switchers: %d\n", n_switchers))

  results <- list()
  for (yvar in outcomes) {
    cat(sprintf("  %s: ", labels[yvar]))
    tryCatch({
      res <- did_multiplegt_dyn(
        df = as.data.frame(qdt_sub),
        outcome = yvar,
        group = "hex_num",
        time = "qid",
        treatment = "treatment",
        effects = n_effects,
        placebo = n_placebo,
        graph_off = TRUE,
        cluster = "hex_num"
      )
      results[[yvar]] <- res
      r <- get_att(res)
      if (!is.na(r$att)) {
        cat(sprintf("ATT=%.4f (SE=%.4f)\n", r$att, r$se))
      } else {
        cat("no ATT\n")
      }
    }, error = function(e) {
      cat(sprintf("ERROR: %s\n", e$message))
      results[[yvar]] <<- list(error = e$message)
    })
  }
  return(results)
}

# ==============================================================================
# 1. EXCLUDE 75TH PRECINCT
# ==============================================================================
rob1 <- run_dcdh_subset("ROBUSTNESS 1: Exclude 75th Precinct",
                        qdt[precinct != 75])

# ==============================================================================
# 2. RESTRICT CONTROLS TO NEARBY HEXES
# ==============================================================================
cat("\nLoading proximity filter (hexes within 3 rings of ever-treated)...\n")

# Precomputed by Python: data/nearby_hex_ids.json
nearby <- fromJSON("data/nearby_hex_ids.json")
cat(sprintf("  Hexes within 3 rings: %d\n", length(nearby)))

# Map hex_id to hex_num
hex_id_map <- unique(qdt[, .(hex_id, hex_num)])
nearby_nums <- hex_id_map[hex_id %in% nearby, hex_num]
cat(sprintf("  Hexes in panel within 3 rings: %d (of %d total)\n",
            length(nearby_nums), uniqueN(qdt$hex_num)))

rob2 <- run_dcdh_subset("ROBUSTNESS 2: Controls within 3 rings",
                        qdt[hex_num %in% nearby_nums])

# ==============================================================================
# 3. CONTINUOUSLY-TREATED VS NEVER-TREATED
# ==============================================================================
# Hexes treated in EVERY quarter from Q3 2013 (qid 31) through Q2 2015 (qid 38)
cat("\nIdentifying continuously-treated hexes...\n")
cont_treated <- qdt[qid >= 31 & qid <= 38,
                    .(all_on = all(treatment == 1)), by = hex_num][all_on == TRUE, hex_num]
never_treated <- qdt[, .(ever = any(treatment == 1)), by = hex_num][ever == FALSE, hex_num]
cat(sprintf("  Continuously treated (Q3 2013-Q2 2015): %d hexes\n", length(cont_treated)))
cat(sprintf("  Never treated: %d hexes\n", length(never_treated)))

rob3 <- run_dcdh_subset("ROBUSTNESS 3: Continuously-treated vs never-treated",
                        qdt[hex_num %in% c(cont_treated, never_treated)])

# ==============================================================================
# 4. VARY EFFECTS/PLACEBO WINDOWS
# ==============================================================================
rob4a <- run_dcdh_subset("ROBUSTNESS 4A: 6 effects / 3 placebos",
                         copy(qdt), n_effects = 6, n_placebo = 3)

rob4b <- run_dcdh_subset("ROBUSTNESS 4B: 4 effects / 2 placebos",
                         copy(qdt), n_effects = 4, n_placebo = 2)

# ==============================================================================
# 5. DROP TRANSITION QUARTERS (Q2 2012 – Q2 2013 = qid 26-30)
# ==============================================================================
rob5 <- run_dcdh_subset("ROBUSTNESS 5: Drop transition Qs (Q2 2012-Q2 2013)",
                        qdt[!(qid %in% 26:30)])

# ==============================================================================
# COMPARISON TABLE
# ==============================================================================
all_specs <- list(
  "Baseline (8/4)" = dcdh_base,
  "No Pct 75"      = rob1,
  "Near controls"  = rob2,
  "Cont. treated"  = rob3,
  "6 eff / 3 plc"  = rob4a,
  "4 eff / 2 plc"  = rob4b,
  "Drop trans. Qs" = rob5
)

cat("\n\n========== ROBUSTNESS COMPARISON: ATT (levels) ==========\n")
header <- sprintf("%-12s", "Outcome")
for (nm in names(all_specs)) header <- paste0(header, sprintf(" %12s", nm))
cat(header, "\n")
cat(strrep("-", nchar(header)), "\n")

for (yvar in outcomes) {
  line <- sprintf("%-12s", labels[yvar])
  for (spec in all_specs) {
    r <- get_att(spec[[yvar]])
    line <- paste0(line, sprintf(" %12s", fmt_att(r)))
  }
  cat(line, "\n")
}
cat("* p < 0.05; + p < 0.10\n")

# Semi-elasticity version
cat("\n\n========== ROBUSTNESS COMPARISON: Semi-elasticities (%) ==========\n")
header <- sprintf("%-12s", "Outcome")
for (nm in names(all_specs)) header <- paste0(header, sprintf(" %12s", nm))
cat(header, "\n")
cat(strrep("-", nchar(header)), "\n")

for (yvar in outcomes) {
  trt_mean <- mean(qdt[treatment == 1, get(yvar)])
  line <- sprintf("%-12s", labels[yvar])
  for (spec in all_specs) {
    r <- get_att(spec[[yvar]])
    if (is.na(r$att)) {
      line <- paste0(line, sprintf(" %12s", "N/A"))
    } else {
      pct <- (r$att / trt_mean) * 100
      sig <- ifelse(abs(r$att / r$se) > 1.96, "*",
             ifelse(abs(r$att / r$se) > 1.645, "+", " "))
      line <- paste0(line, sprintf(" %10.1f%%%s", pct, sig))
    }
  }
  cat(line, "\n")
}
cat("* p < 0.05; + p < 0.10\n")

# Save all results
saveRDS(all_specs, "output/robustness_results.rds")
cat("\nSaved output/robustness_results.rds\n")
cat("Robustness checks complete.\n")
