###############################################################################
## 26_gap_duration_test.R
##
## Gap-Duration Test for Residual Deterrence
##
## Logic: For each switch-ON event, we know (a) how long the hex was OFF
## before reactivation and (b) cumulative enforcement history. If residual
## deterrence from ENFORCEMENT sustains crime suppression:
##   - Short gaps → small marginal effect (echo still holding)
##   - Long gaps → large marginal effect (echo decayed, crime rebounded)
## If PRESENCE is the mechanism:
##   - Gap duration should NOT predict the switch-on effect size
##
## Part A: Switch-level regression of crime change on gap duration + cum SQF
## Part B: dCDH split by short-gap vs long-gap switches
## Part C: Long-gap reactivations during low-SQF era (strongest sub-test)
##
## Output: output/gap_duration_test.rds
##         output/fig_gap_duration.pdf / .png
###############################################################################

Sys.setenv(RGL_USE_NULL = "TRUE")

library(data.table)
library(fixest)
library(polars)
library(DIDmultiplegtDYN)
library(ggplot2)

cat("=== GAP-DURATION TEST FOR RESIDUAL DETERRENCE ===\n\n")

qdt <- readRDS("data/panel_quarterly_analysis.rds")
outcomes <- c("violent", "property", "robbery", "felony_assault", "burglary")

results <- list()

###############################################################################
## Identify all switch-ON events and compute gap duration
###############################################################################

setorder(qdt, hex_num, qid)

# Lag treatment to find switches
qdt[, treat_lag := shift(treatment, 1, fill = 0), by = hex_num]
qdt[, switch_on := (treatment == 1 & treat_lag == 0)]

# For each hex, identify episodes (contiguous runs of treatment)
# and compute gap between episodes
switch_events <- qdt[switch_on == TRUE, .(hex_num, qid)]
cat("Total switch-ON events:", nrow(switch_events), "\n")

# For each switch-ON, find when the hex was last treated (end of prior spell)
# Gap = qid_of_switch - qid_of_last_treated_quarter
# For first-ever activation, gap = Inf (no prior spell)

# Build episode table: for each hex, get start/end of each treatment spell
spell_list <- list()
for (h in unique(qdt[treatment == 1]$hex_num)) {
  hdt <- qdt[hex_num == h]
  # Find runs of treatment
  rle_t <- rle(hdt$treatment)
  ends <- cumsum(rle_t$lengths)
  starts <- c(1, ends[-length(ends)] + 1)

  for (i in seq_along(rle_t$values)) {
    if (rle_t$values[i] == 1) {
      spell_list[[length(spell_list) + 1]] <- data.table(
        hex_num = h,
        spell_start_qid = hdt$qid[starts[i]],
        spell_end_qid = hdt$qid[ends[i]],
        spell_length = rle_t$lengths[i]
      )
    }
  }
}
spells <- rbindlist(spell_list)
setorder(spells, hex_num, spell_start_qid)

cat("Total treatment spells:", nrow(spells), "\n")
cat("Hexes with spells:", uniqueN(spells$hex_num), "\n")

# For each spell (except the first per hex), compute gap from prior spell
spells[, spell_num := seq_len(.N), by = hex_num]
spells[, prior_end := shift(spell_end_qid, 1), by = hex_num]
spells[, gap_quarters := spell_start_qid - prior_end - 1]  # quarters with treatment=0

# First spell has no gap (set to NA)
spells[spell_num == 1, gap_quarters := NA_integer_]

cat("\nGap distribution (non-first spells):\n")
cat("  N with gap info:", sum(!is.na(spells$gap_quarters)), "\n")
print(summary(spells$gap_quarters[!is.na(spells$gap_quarters)]))

# Compute cumulative SQF received BEFORE each spell start
qdt[, cum_sqf := cumsum(sqf_total * treatment), by = hex_num]

# For each spell, get cumulative SQF just before spell_start
cum_sqf_at_switch <- qdt[, .(hex_num, qid, cum_sqf)]
spells <- merge(spells, cum_sqf_at_switch[, .(hex_num, qid, cum_sqf_before = cum_sqf)],
                by.x = c("hex_num", "spell_start_qid"),
                by.y = c("hex_num", "qid"), all.x = TRUE)

# The cum_sqf_before at spell start includes this quarter's contribution if treated
# We want cum SQF BEFORE this spell, so use the prior quarter's value
# Actually, cum_sqf is cumsum of sqf*treatment, so at spell_start_qid, the current
# quarter IS included. We need the value at spell_start_qid - 1
prior_q_sqf <- qdt[, .(hex_num, qid, cum_sqf_prior = shift(cum_sqf, 1, fill = 0)), by = hex_num]
# This creates duplicates, fix by just getting one row per hex per qid
prior_q_sqf <- unique(prior_q_sqf[, .(hex_num, qid, cum_sqf_prior)])

spells[, cum_sqf_before := NULL]  # remove old
spells <- merge(spells, prior_q_sqf,
                by.x = c("hex_num", "spell_start_qid"),
                by.y = c("hex_num", "qid"), all.x = TRUE)

cat("\nCumulative SQF before spell start:\n")
print(summary(spells$cum_sqf_prior))

###############################################################################
## Part A: Switch-level crime change regression
###############################################################################

cat("\n--- Part A: Switch-level regression ---\n")

# For each spell (non-first), compute crime change:
# mean crime in first 2 quarters of spell vs mean crime in 2 quarters before spell
# This is the "switch-on effect" at the event level

# Only use spells with gap info (non-first spells) and enough pre/post data
usable_spells <- spells[!is.na(gap_quarters) & spell_start_qid >= 3]  # need 2 pre quarters
cat("Usable spells (non-first, have pre-data):", nrow(usable_spells), "\n")

# Compute pre and post crime for each spell
switch_crime <- list()
for (i in 1:nrow(usable_spells)) {
  sp <- usable_spells[i]
  h <- sp$hex_num
  sq <- sp$spell_start_qid

  # Pre: 2 quarters before switch (the gap period)
  pre_qs <- (sq - 2):(sq - 1)
  # Post: first 2 quarters of spell
  post_qs <- sq:(min(sq + 1, 44))

  pre_dt <- qdt[hex_num == h & qid %in% pre_qs]
  post_dt <- qdt[hex_num == h & qid %in% post_qs]

  if (nrow(pre_dt) >= 1 & nrow(post_dt) >= 1) {
    row <- data.table(
      hex_num = h,
      spell_start = sq,
      gap_quarters = sp$gap_quarters,
      cum_sqf = sp$cum_sqf_prior,
      spell_length = sp$spell_length
    )
    for (out in outcomes) {
      row[[paste0(out, "_pre")]] <- mean(pre_dt[[out]])
      row[[paste0(out, "_post")]] <- mean(post_dt[[out]])
      row[[paste0(out, "_delta")]] <- mean(post_dt[[out]]) - mean(pre_dt[[out]])
    }
    switch_crime[[length(switch_crime) + 1]] <- row
  }
}
switch_dt <- rbindlist(switch_crime)
cat("Switch events with crime data:", nrow(switch_dt), "\n")

# Standardize predictors
switch_dt[, gap_std := as.numeric(scale(gap_quarters))]
switch_dt[, cum_sqf_std := as.numeric(scale(cum_sqf))]
switch_dt[, log_gap := log(gap_quarters + 1)]

# Era indicator: was this switch during low-SQF era?
switch_dt[, low_sqf_era := as.integer(spell_start >= 31)]

cat("\nSwitch events by era:\n")
cat("  High-SQF era (qid < 31):", sum(switch_dt$spell_start < 31), "\n")
cat("  Low-SQF era (qid >= 31):", sum(switch_dt$spell_start >= 31), "\n")

cat("\nGap duration distribution:\n")
print(summary(switch_dt$gap_quarters))

# Main regression: does gap duration predict crime change at switch?
partA_results <- list()

cat("\n  === Part A Results ===\n")
cat(sprintf("  %-18s %10s %10s %10s %10s %10s\n",
            "Outcome", "b(gap)", "p(gap)", "b(sqf)", "p(sqf)", "N"))

for (out in outcomes) {
  dv <- paste0(out, "_delta")

  # Model 1: gap only
  m1 <- lm(as.formula(paste(dv, "~ gap_std")), data = switch_dt)

  # Model 2: gap + cumulative SQF
  m2 <- lm(as.formula(paste(dv, "~ gap_std + cum_sqf_std")), data = switch_dt)

  # Model 3: gap + cum SQF + interaction
  m3 <- lm(as.formula(paste(dv, "~ gap_std * cum_sqf_std")), data = switch_dt)

  # Model 4: with era control
  m4 <- lm(as.formula(paste(dv, "~ gap_std + cum_sqf_std + low_sqf_era")), data = switch_dt)

  b_gap <- coef(m2)["gap_std"]
  p_gap <- summary(m2)$coefficients["gap_std", "Pr(>|t|)"]
  b_sqf <- coef(m2)["cum_sqf_std"]
  p_sqf <- summary(m2)$coefficients["cum_sqf_std", "Pr(>|t|)"]

  cat(sprintf("  %-18s %+8.4f   %8.3f %+8.4f   %8.3f   %4d\n",
              out, b_gap, p_gap, b_sqf, p_sqf, nrow(switch_dt)))

  # Model with interaction
  if ("gap_std:cum_sqf_std" %in% names(coef(m3))) {
    b_int <- coef(m3)["gap_std:cum_sqf_std"]
    p_int <- summary(m3)$coefficients["gap_std:cum_sqf_std", "Pr(>|t|)"]
    cat(sprintf("    interaction: %+.4f (p=%.3f)\n", b_int, p_int))
  }

  partA_results[[out]] <- list(
    m_gap_only = m1, m_gap_sqf = m2, m_interaction = m3, m_era = m4,
    b_gap = b_gap, p_gap = p_gap, b_sqf = b_sqf, p_sqf = p_sqf
  )
}

results$partA <- partA_results

###############################################################################
## Part B: dCDH split by short-gap vs long-gap switches
###############################################################################

cat("\n--- Part B: dCDH by gap duration ---\n")

# Split hexes by their MEDIAN gap duration across switches
hex_gap_stats <- switch_dt[, .(
  median_gap = median(gap_quarters),
  mean_gap = mean(gap_quarters),
  n_switches = .N
), by = hex_num]

gap_median_cut <- median(hex_gap_stats$median_gap)
cat("Median of hex-level median gap:", gap_median_cut, "quarters\n")

short_gap_hexes <- hex_gap_stats[median_gap <= gap_median_cut]$hex_num
long_gap_hexes <- hex_gap_stats[median_gap > gap_median_cut]$hex_num
never_treated <- qdt[, .(ever = any(treatment == 1)), by = hex_num][ever == FALSE]$hex_num

cat("Short-gap hexes:", length(short_gap_hexes), "\n")
cat("Long-gap hexes:", length(long_gap_hexes), "\n")

get_att <- function(res) {
  if (!is.null(res$results$ATE)) {
    list(att = res$results$ATE[1, "Estimate"],
         se  = res$results$ATE[1, "SE"],
         p_joint = res$results$p_jointeffects)
  } else {
    list(att = NA, se = NA, p_joint = NA)
  }
}

partB_results <- list()

for (group_name in c("short_gap", "long_gap")) {
  cat(sprintf("\n  --- dCDH: %s ---\n", group_name))

  group_hexes <- if (group_name == "short_gap") short_gap_hexes else long_gap_hexes
  sub <- copy(qdt[hex_num %in% c(group_hexes, never_treated)])
  sub[, hex_id2 := as.integer(factor(hex_num))]
  sub[, qid2 := as.integer(factor(qid))]

  group_res <- list()
  for (out in outcomes) {
    cat(sprintf("    %s... ", out))

    res <- tryCatch({
      did_multiplegt_dyn(
        df = as.data.frame(sub),
        outcome = out,
        group = "hex_id2",
        time = "qid2",
        treatment = "treatment",
        effects = 6,
        placebo = 3,
        cluster = "hex_id2",
        graph_off = TRUE
      )
    }, error = function(e) {
      cat(sprintf("ERROR: %s\n", substr(e$message, 1, 60)))
      list(error = e$message)
    })

    att_info <- get_att(res)
    cat(sprintf("ATT=%.4f SE=%.4f\n",
                ifelse(is.na(att_info$att), NA, att_info$att),
                ifelse(is.na(att_info$se), NA, att_info$se)))
    group_res[[out]] <- list(res = res, att = att_info)
  }
  partB_results[[group_name]] <- group_res
}

results$partB <- partB_results

cat("\n  === Part B Summary ===\n")
cat(sprintf("  %-18s %12s %12s %10s\n", "Outcome", "Short Gap", "Long Gap", "Diff"))
for (out in outcomes) {
  s <- partB_results$short_gap[[out]]$att$att
  l <- partB_results$long_gap[[out]]$att$att
  d <- if (!is.na(s) && !is.na(l)) s - l else NA
  cat(sprintf("  %-18s %+10.4f   %+10.4f   %+8.4f\n",
              out, ifelse(is.na(s), NA, s), ifelse(is.na(l), NA, l),
              ifelse(is.na(d), NA, d)))
}

###############################################################################
## Part C: Long-gap reactivations in low-SQF era
##         (strongest sub-test: enforcement history decayed + no current enforcement)
###############################################################################

cat("\n--- Part C: Long-gap reactivations during low-SQF era ---\n")

# Find spells that start in qid >= 31 (low-SQF) with gap >= 4 quarters (1+ year off)
long_gap_low_sqf <- usable_spells[spell_start_qid >= 31 & gap_quarters >= 4]
cat("Spells with gap >= 4Q reactivated in low-SQF era:", nrow(long_gap_low_sqf), "\n")
cat("Unique hexes:", uniqueN(long_gap_low_sqf$hex_num), "\n")

# Relax to gap >= 2
long_gap_low_sqf2 <- usable_spells[spell_start_qid >= 31 & gap_quarters >= 2]
cat("Spells with gap >= 2Q reactivated in low-SQF era:", nrow(long_gap_low_sqf2), "\n")
cat("Unique hexes:", uniqueN(long_gap_low_sqf2$hex_num), "\n")

# For these switches, what's the average crime change?
partC_results <- list()

# Use switch_dt which has the pre/post crime
long_gap_switches <- switch_dt[spell_start >= 31 & gap_quarters >= 4]
cat("\nSwitch events (low-SQF era, gap >= 4Q):", nrow(long_gap_switches), "\n")

if (nrow(long_gap_switches) > 5) {
  cat("\n  Crime change at long-gap, low-SQF reactivation:\n")
  for (out in outcomes) {
    dv <- paste0(out, "_delta")
    vals <- long_gap_switches[[dv]]
    m <- mean(vals)
    se <- sd(vals) / sqrt(length(vals))
    t <- m / se
    cat(sprintf("    %-18s: mean delta = %+.3f (SE=%.3f, t=%.2f, n=%d)\n",
                out, m, se, t, length(vals)))
    partC_results[[out]] <- list(mean_delta = m, se = se, t = t, n = length(vals))
  }
} else {
  cat("  Too few events for gap >= 4Q. Trying gap >= 2Q...\n")
  long_gap_switches <- switch_dt[spell_start >= 31 & gap_quarters >= 2]
  cat("  Switch events (low-SQF era, gap >= 2Q):", nrow(long_gap_switches), "\n")

  if (nrow(long_gap_switches) > 5) {
    cat("\n  Crime change at long-gap, low-SQF reactivation:\n")
    for (out in outcomes) {
      dv <- paste0(out, "_delta")
      vals <- long_gap_switches[[dv]]
      m <- mean(vals)
      se <- sd(vals) / sqrt(length(vals))
      t <- m / se
      cat(sprintf("    %-18s: mean delta = %+.3f (SE=%.3f, t=%.2f, n=%d)\n",
                  out, m, se, t, length(vals)))
      partC_results[[out]] <- list(mean_delta = m, se = se, t = t, n = length(vals))
    }
  }
}

# Also do a stacked event study for these long-gap low-SQF reactivations
# using never-treated hexes as controls
if (nrow(long_gap_switches) >= 10) {
  cat("\n  Running stacked event study for long-gap low-SQF reactivations...\n")

  target_hexes <- unique(long_gap_switches$hex_num)
  # For each target hex, use the spell_start as the event date
  target_spells <- long_gap_switches[, .(hex_num, spell_start)]
  # If multiple spells per hex, use the first
  target_spells <- target_spells[, .(event_q = min(spell_start)), by = hex_num]

  # Build stacked dataset
  es_pieces <- list()
  cohort_qs <- unique(target_spells$event_q)

  for (cq in cohort_qs) {
    # Treated hexes in this cohort
    treat_hexes <- target_spells[event_q == cq]$hex_num
    treat_piece <- qdt[hex_num %in% treat_hexes]
    treat_piece[, event_q := cq]
    treat_piece[, rel_time := qid - cq]
    treat_piece[, treated_group := 1L]
    treat_piece <- treat_piece[rel_time >= -4 & rel_time <= 4]

    # Controls
    ctrl_piece <- qdt[hex_num %in% never_treated]
    ctrl_piece[, event_q := cq]
    ctrl_piece[, rel_time := qid - cq]
    ctrl_piece[, treated_group := 0L]
    ctrl_piece <- ctrl_piece[rel_time >= -4 & rel_time <= 4]

    es_pieces[[as.character(cq)]] <- rbind(treat_piece, ctrl_piece, fill = TRUE)
  }

  es_stacked <- rbindlist(es_pieces, fill = TRUE)
  es_stacked[, cohort := event_q]
  es_stacked[, rel_f := relevel(factor(rel_time), ref = "-1")]

  partC_es <- list()

  for (out in outcomes) {
    cat(sprintf("    ES: %s... ", out))

    frm <- as.formula(paste0(out, " ~ rel_f:treated_group | hex_num + cohort^qid"))
    m <- tryCatch(
      feols(frm, data = es_stacked, cluster = ~hex_num),
      error = function(e) { cat("ERROR\n"); NULL }
    )

    if (!is.null(m)) {
      cf <- coef(m)
      se_vals <- se(m)
      idx <- grep(":treated_group$", names(cf))

      es_df <- data.frame(
        rel_time = as.integer(gsub("^rel_f|:treated_group$", "", names(cf)[idx])),
        estimate = cf[idx],
        se = se_vals[idx],
        row.names = NULL
      )
      es_df <- es_df[!is.na(es_df$rel_time), ]
      es_df <- rbind(es_df, data.frame(rel_time = -1, estimate = 0, se = 0))
      es_df <- es_df[order(es_df$rel_time), ]
      es_df$ci_lo <- es_df$estimate - 1.96 * es_df$se
      es_df$ci_hi <- es_df$estimate + 1.96 * es_df$se
      es_df$outcome <- out

      post_avg <- mean(es_df$estimate[es_df$rel_time >= 0])
      pre_avg <- mean(es_df$estimate[es_df$rel_time < -1])
      cat(sprintf("post_avg=%.3f, pre_avg=%.3f\n", post_avg, pre_avg))

      partC_es[[out]] <- es_df
    }
  }

  results$partC_es <- partC_es

  # Plot
  if (length(partC_es) > 0) {
    es_all <- rbindlist(partC_es)
    es_all$outcome_label <- factor(es_all$outcome, levels = outcomes,
      labels = c("Violent Felony", "Property Felony", "Robbery",
                 "Felony Assault", "Burglary"))

    gap_threshold <- ifelse(nrow(switch_dt[spell_start >= 31 & gap_quarters >= 4]) >= 10,
                            4, 2)

    p_es <- ggplot(es_all, aes(x = rel_time, y = estimate)) +
      geom_hline(yintercept = 0, color = "gray50", linetype = "dashed") +
      geom_vline(xintercept = -0.5, color = "firebrick", linetype = "dashed", alpha = 0.5) +
      geom_ribbon(aes(ymin = ci_lo, ymax = ci_hi), fill = "darkgreen", alpha = 0.2) +
      geom_line(color = "darkgreen", linewidth = 0.8) +
      geom_point(color = "darkgreen", size = 2) +
      facet_wrap(~ outcome_label, scales = "free_y", ncol = 3) +
      labs(
        title = paste0("Long-Gap Reactivations in Low-SQF Era (gap >= ",
                        gap_threshold, "Q)"),
        subtitle = paste0("N = ", nrow(long_gap_switches),
                          " switch-ON events. Enforcement history decayed + no current enforcement."),
        x = "Quarters Relative to Reactivation",
        y = "Effect (crimes/hex/quarter)",
        caption = "Stacked ES, hex + cohort x time FE. 95% CI. Ref = q(-1)."
      ) +
      theme_minimal(base_size = 12) +
      theme(strip.text = element_text(face = "bold"), panel.grid.minor = element_blank())

    ggsave("output/fig_gap_reactivation_es.pdf", p_es, width = 12, height = 7)
    ggsave("output/fig_gap_reactivation_es.png", p_es, width = 12, height = 7, dpi = 300)
    cat("  Saved: output/fig_gap_reactivation_es.pdf/.png\n")
  }
}

results$partC <- partC_results

###############################################################################
## FIGURES
###############################################################################

cat("\n--- Building Part A figure ---\n")

# Binned scatter: gap duration vs crime change
# Bin gap into quintiles
# Use unique breaks to handle ties in gap distribution
gap_breaks <- unique(quantile(switch_dt$gap_quarters, seq(0, 1, 0.2), na.rm = TRUE))
if (length(gap_breaks) < 3) gap_breaks <- unique(quantile(switch_dt$gap_quarters, c(0, 0.33, 0.67, 1), na.rm = TRUE))
switch_dt[, gap_bin := cut(gap_quarters,
  breaks = gap_breaks,
  labels = FALSE, include.lowest = TRUE)]

# Compute mean crime change by gap bin
fig_data_list <- list()
for (out in outcomes) {
  dv <- paste0(out, "_delta")
  bin_means <- switch_dt[!is.na(gap_bin), .(
    mean_gap = mean(gap_quarters),
    mean_delta = mean(get(dv)),
    se_delta = sd(get(dv)) / sqrt(.N),
    n = .N
  ), by = gap_bin]
  bin_means$outcome <- out
  fig_data_list[[out]] <- bin_means
}
fig_data <- rbindlist(fig_data_list)
fig_data$outcome_label <- factor(fig_data$outcome, levels = outcomes,
  labels = c("Violent Felony", "Property Felony", "Robbery",
             "Felony Assault", "Burglary"))

p_gap <- ggplot(fig_data, aes(x = mean_gap, y = mean_delta)) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray50") +
  geom_point(color = "steelblue", size = 3) +
  geom_errorbar(aes(ymin = mean_delta - 1.96 * se_delta,
                     ymax = mean_delta + 1.96 * se_delta),
                color = "steelblue", width = 0.3) +
  geom_smooth(method = "lm", se = TRUE, color = "firebrick",
              linewidth = 0.7, alpha = 0.15) +
  facet_wrap(~ outcome_label, scales = "free_y", ncol = 3) +
  labs(
    title = "Part A: Crime Change at Switch-ON by Gap Duration",
    subtitle = paste0("If residual deterrence matters, longer gaps should show LARGER crime drops.\n",
                      "Binned scatter (quintiles of gap duration). N = ",
                      nrow(switch_dt), " switch events."),
    x = "Mean Gap Duration (quarters off before reactivation)",
    y = "Crime change at switch (post - pre)",
    caption = "Red line = OLS fit. 95% CI on bin means."
  ) +
  theme_minimal(base_size = 12) +
  theme(strip.text = element_text(face = "bold"), panel.grid.minor = element_blank())

ggsave("output/fig_gap_duration.pdf", p_gap, width = 12, height = 7)
ggsave("output/fig_gap_duration.png", p_gap, width = 12, height = 7, dpi = 300)
cat("Saved: output/fig_gap_duration.pdf/.png\n")

###############################################################################
## SAVE
###############################################################################

saveRDS(results, "output/gap_duration_test.rds")
cat("\nSaved: output/gap_duration_test.rds\n")

###############################################################################
## FINAL SUMMARY
###############################################################################

cat("\n")
cat(paste(rep("=", 72), collapse = ""), "\n")
cat("GAP-DURATION TEST SUMMARY\n")
cat(paste(rep("=", 72), collapse = ""), "\n")

cat("\nPART A: Does gap duration predict crime change at switch-ON?\n")
cat("  (Residual deterrence predicts: longer gap → bigger crime drop)\n")
for (out in outcomes) {
  r <- partA_results[[out]]
  cat(sprintf("  %-18s: b(gap)=%+.4f (p=%.3f), b(sqf)=%+.4f (p=%.3f)\n",
              out, r$b_gap, r$p_gap, r$b_sqf, r$p_sqf))
}

cat("\nPART B: dCDH by gap type\n")
cat("  (Residual deterrence predicts: long-gap hexes show larger ATT)\n")
for (out in outcomes) {
  s <- partB_results$short_gap[[out]]$att$att
  l <- partB_results$long_gap[[out]]$att$att
  cat(sprintf("  %-18s: short=%+.4f, long=%+.4f\n",
              out, ifelse(is.na(s), NA, s), ifelse(is.na(l), NA, l)))
}

cat("\nPART C: Long-gap reactivations in low-SQF era\n")
cat("  (Pure presence test: enforcement decayed + no current enforcement)\n")
for (out in outcomes) {
  if (!is.null(partC_results[[out]])) {
    r <- partC_results[[out]]
    cat(sprintf("  %-18s: delta=%+.3f (SE=%.3f, t=%.2f, n=%d)\n",
                out, r$mean_delta, r$se, r$t, r$n))
  }
}

cat("\nDone.\n")
