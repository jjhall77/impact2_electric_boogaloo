###############################################################################
## 25_residual_deterrence_tests.R
##
## Three tests to distinguish police PRESENCE from residual deterrence
## of past ENFORCEMENT as the mechanism behind crime reductions.
##
## Test 1: Virgin low-SQF hexes -- event study for 33 hexes first treated
##         during low-SQF era (Q3 2013-Q2 2015) with no prior treatment.
##         These hexes had presence but zero enforcement history.
##
## Test 2: Cumulative SQF dosage moderator -- split dCDH by historical
##         enforcement exposure. If residual deterrence drives results,
##         high-history hexes should show larger effects.
##
## Test 3: Post-dissolution decay x enforcement history -- after July 2015,
##         does cumulative prior SQF predict crime rebound speed?
##
## Output: output/residual_deterrence_tests.rds
##         output/fig_virgin_lowsqf_es.pdf / .png
##         output/fig_dissolution_decay_by_history.pdf / .png
###############################################################################

Sys.setenv(RGL_USE_NULL = "TRUE")

library(data.table)
library(fixest)
library(polars)
library(DIDmultiplegtDYN)
library(ggplot2)

cat("=== RESIDUAL DETERRENCE TESTS ===\n\n")

qdt <- readRDS("data/panel_quarterly_analysis.rds")
outcomes <- c("violent", "property", "robbery", "felony_assault", "burglary")

results <- list()

###############################################################################
## Setup: identify hex groups
###############################################################################

hex_history <- qdt[, .(
  any_pre  = any(treatment == 1 & qid < 31),
  any_low  = any(treatment == 1 & qid >= 31 & qid <= 38),
  first_q  = ifelse(any(treatment == 1), min(qid[treatment == 1]), NA_integer_)
), by = hex_num]

virgin_low_hexes <- hex_history[any_pre == FALSE & any_low == TRUE]$hex_num
never_treated    <- hex_history[is.na(first_q)]$hex_num
ever_treated     <- hex_history[!is.na(first_q)]$hex_num
virgin_first_q   <- hex_history[hex_num %in% virgin_low_hexes, .(hex_num, first_q)]

get_att <- function(res) {
  if (!is.null(res$results$ATE)) {
    list(att = res$results$ATE[1, "Estimate"],
         se  = res$results$ATE[1, "SE"],
         p_joint = res$results$p_jointeffects)
  } else {
    list(att = NA, se = NA, p_joint = NA)
  }
}

###############################################################################
## TEST 1: Virgin Low-SQF Hexes Event Study
###############################################################################

cat("--- TEST 1: Virgin Low-SQF Hexes ---\n")
cat("  N =", length(virgin_low_hexes), "hexes, zero enforcement history\n")
cat("  Controls:", length(never_treated), "never-treated hexes\n\n")

# Build stacked event study dataset
es_data <- qdt[hex_num %in% c(virgin_low_hexes, never_treated)]
es_data[, virgin := as.integer(hex_num %in% virgin_low_hexes)]
es_data <- merge(es_data, virgin_first_q, by = "hex_num", all.x = TRUE)

cohort_qs <- unique(virgin_first_q$first_q)

es_pieces <- list()
for (cq in cohort_qs) {
  ctrl_piece <- es_data[virgin == 0]
  ctrl_piece[, first_q := cq]
  ctrl_piece[, rel_time := qid - cq]
  ctrl_piece <- ctrl_piece[rel_time >= -5 & rel_time <= 5]
  es_pieces[[paste0("ctrl_", cq)]] <- ctrl_piece
}
vir_piece <- es_data[virgin == 1][, rel_time := qid - first_q]
vir_piece <- vir_piece[rel_time >= -5 & rel_time <= 5]
es_pieces[["virgin"]] <- vir_piece

es_stacked <- rbindlist(es_pieces, fill = TRUE)
es_stacked[, cohort := first_q]
es_stacked[, rel_f := relevel(factor(rel_time), ref = "-1")]

test1_results <- list()
test1_es_data <- list()

for (out in outcomes) {
  cat(sprintf("  %s: ", out))

  frm <- as.formula(paste0(out, " ~ rel_f:virgin | hex_num + cohort^qid"))
  m <- tryCatch(
    feols(frm, data = es_stacked, cluster = ~hex_num),
    error = function(e) { cat(sprintf("ERROR\n")); NULL }
  )

  if (!is.null(m)) {
    cf <- coef(m)
    se_vals <- se(m)

    # Parse coefficient names: format is "rel_f<N>:virgin"
    virgin_idx <- grep(":virgin$", names(cf))
    virgin_names <- names(cf)[virgin_idx]

    es_df <- data.frame(
      rel_time = as.integer(gsub("^rel_f|:virgin$", "", virgin_names)),
      estimate = cf[virgin_idx],
      se = se_vals[virgin_idx],
      row.names = NULL,
      stringsAsFactors = FALSE
    )
    # Remove any NAs from parsing
    es_df <- es_df[!is.na(es_df$rel_time), ]

    # Add reference period
    es_df <- rbind(es_df, data.frame(rel_time = -1, estimate = 0, se = 0))
    es_df <- es_df[order(es_df$rel_time), ]
    es_df$ci_lo <- es_df$estimate - 1.96 * es_df$se
    es_df$ci_hi <- es_df$estimate + 1.96 * es_df$se
    es_df$outcome <- out

    test1_es_data[[out]] <- es_df

    # Average post-treatment effect
    post <- es_df[es_df$rel_time >= 0, ]
    avg_post <- mean(post$estimate)
    avg_se <- sqrt(mean(post$se^2))  # approximate

    # Pre-treatment average (parallel trends check)
    pre <- es_df[es_df$rel_time < -1, ]
    avg_pre <- mean(pre$estimate)

    cat(sprintf("avg_post = %.3f (approx SE = %.3f), avg_pre = %.3f\n",
                avg_post, avg_se, avg_pre))

    test1_results[[out]] <- list(
      model = m, es_data = es_df,
      avg_post = avg_post, avg_pre = avg_pre, n_obs = nobs(m)
    )
  }
}

results$test1 <- test1_results

# Plot Test 1
if (length(test1_es_data) > 0) {
  es_all <- rbindlist(test1_es_data)
  es_all$outcome_label <- factor(es_all$outcome,
    levels = outcomes,
    labels = c("Violent Felony", "Property Felony", "Robbery",
               "Felony Assault", "Burglary"))

  p1 <- ggplot(es_all, aes(x = rel_time, y = estimate)) +
    geom_hline(yintercept = 0, color = "gray50", linetype = "dashed") +
    geom_vline(xintercept = -0.5, color = "firebrick", linetype = "dashed", alpha = 0.5) +
    geom_ribbon(aes(ymin = ci_lo, ymax = ci_hi), fill = "steelblue", alpha = 0.2) +
    geom_line(color = "steelblue", linewidth = 0.8) +
    geom_point(color = "steelblue", size = 2) +
    facet_wrap(~ outcome_label, scales = "free_y", ncol = 3) +
    labs(
      title = "Test 1: Crime in Virgin Low-SQF Hexes (No Enforcement History)",
      subtitle = paste0("N = ", length(virgin_low_hexes),
                        " hexes first treated post-Floyd with zero prior treatment or SQF"),
      x = "Quarters Relative to First Treatment",
      y = "Effect (crimes/hex/quarter)",
      caption = "Stacked event study, hex + cohort x time FE. 95% CI. Ref = q(-1)."
    ) +
    theme_minimal(base_size = 12) +
    theme(strip.text = element_text(face = "bold"), panel.grid.minor = element_blank())

  ggsave("output/fig_virgin_lowsqf_es.pdf", p1, width = 12, height = 7)
  ggsave("output/fig_virgin_lowsqf_es.png", p1, width = 12, height = 7, dpi = 300)
  cat("  Saved: output/fig_virgin_lowsqf_es.pdf/.png\n\n")
}

###############################################################################
## TEST 2: Cumulative SQF Dosage Moderator
###############################################################################

cat("--- TEST 2: Cumulative SQF Dosage Moderator ---\n")

# Compute cumulative SQF at each switch-on point
setorder(qdt, hex_num, qid)
qdt[, cum_sqf_treated := cumsum(sqf_total * treatment), by = hex_num]
qdt[, cum_sqf_lag := shift(cum_sqf_treated, 1, fill = 0), by = hex_num]
qdt[, treat_lag := shift(treatment, 1, fill = 0), by = hex_num]
qdt[, switch_on := (treatment == 1 & treat_lag == 0)]

# Mean cumulative SQF at switch for each hex
switch_stats <- qdt[switch_on == TRUE, .(
  mean_cum_sqf = mean(cum_sqf_lag)
), by = hex_num]

med_cut <- median(switch_stats$mean_cum_sqf)
cat("  Median cum SQF at switch:", med_cut, "\n")

high_history <- switch_stats[mean_cum_sqf > med_cut]$hex_num
low_history  <- switch_stats[mean_cum_sqf <= med_cut]$hex_num
cat("  High-history:", length(high_history), "hexes\n")
cat("  Low-history:", length(low_history), "hexes (includes",
    sum(virgin_low_hexes %in% low_history), "virgin hexes)\n")

# dCDH on each subset (group + never-treated controls)
# Force base R backend to avoid polars issue
test2_results <- list()

for (group_name in c("high_history", "low_history")) {
  cat(sprintf("\n  --- dCDH: %s ---\n", group_name))

  group_hexes <- if (group_name == "high_history") high_history else low_history
  sub <- copy(qdt[hex_num %in% c(group_hexes, never_treated)])

  # Re-index
  sub[, hex_id2 := as.integer(factor(hex_num))]
  sub[, qid2 := as.integer(factor(qid))]

  group_results <- list()

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
      cat(sprintf("ERROR: %s\n", substr(e$message, 1, 80)))
      return(list(error = e$message))
    })

    att_info <- get_att(res)
    cat(sprintf("ATT=%.4f SE=%.4f\n",
                ifelse(is.na(att_info$att), NA, att_info$att),
                ifelse(is.na(att_info$se), NA, att_info$se)))
    group_results[[out]] <- list(res = res, att = att_info)
  }

  test2_results[[group_name]] <- group_results
}

results$test2 <- test2_results

# Summary
cat("\n  === Test 2 Summary ===\n")
cat(sprintf("  %-18s %14s %14s %10s\n", "Outcome", "High Hist.", "Low Hist.", "Diff"))
cat(sprintf("  %-18s %14s %14s %10s\n", "", "(ATT)", "(ATT)", ""))
for (out in outcomes) {
  h <- test2_results$high_history[[out]]$att$att
  l <- test2_results$low_history[[out]]$att$att
  if (!is.na(h) && !is.na(l)) {
    cat(sprintf("  %-18s %10.4f     %10.4f     %8.4f\n", out, h, l, h - l))
  } else {
    cat(sprintf("  %-18s %14s %14s\n", out,
                ifelse(is.na(h), "NA", sprintf("%.4f", h)),
                ifelse(is.na(l), "NA", sprintf("%.4f", l))))
  }
}

###############################################################################
## TEST 3: Post-Dissolution Decay x Enforcement History
## (Already ran successfully -- re-run for clean output)
###############################################################################

cat("\n--- TEST 3: Post-Dissolution Decay x Enforcement History ---\n")

# Reload fresh copy for Test 3 — convert to data.frame to avoid
# data.table auto-indexing issues from prior mutations
qdt3 <- as.data.frame(readRDS("data/panel_quarterly_analysis.rds"))

# Recompute hex groups from fresh data
et_mask <- tapply(qdt3$treatment, qdt3$hex_num, function(x) any(x == 1))
ever_treated <- as.integer(names(et_mask)[et_mask])
cat("  Ever-treated hexes:", length(ever_treated), "\n")

# SQF stock for each ever-treated hex (cumulative SQF received while treated, through Q2 2015)
stock_mask <- qdt3$qid <= 38 & qdt3$treatment == 1
sqf_stock <- aggregate(sqf_total ~ hex_num, data = qdt3[stock_mask, ], FUN = sum)
names(sqf_stock)[2] <- "total_sqf"

sqf_stock_full <- data.frame(hex_num = ever_treated)
sqf_stock_full <- merge(sqf_stock_full, sqf_stock, by = "hex_num", all.x = TRUE)
sqf_stock_full$total_sqf[is.na(sqf_stock_full$total_sqf)] <- 0

sqf_stock_full$sqf_tercile <- cut(sqf_stock_full$total_sqf,
  breaks = quantile(sqf_stock_full$total_sqf, c(0, 1/3, 2/3, 1)),
  labels = c("Low", "Medium", "High"),
  include.lowest = TRUE)

cat("  Tercile sizes:", paste(table(sqf_stock_full$sqf_tercile), collapse = " / "), "\n")

test3_results <- list()

for (out in outcomes) {
  cat(sprintf("  %s: ", out))

  # Crime change: post (qid 39-44) minus pre (qid 35-38)
  pre_mask <- qdt3$hex_num %in% ever_treated & qdt3$qid >= 35 & qdt3$qid <= 38
  post_mask <- qdt3$hex_num %in% ever_treated & qdt3$qid >= 39 & qdt3$qid <= 44

  pre_mean <- aggregate(qdt3[pre_mask, out, drop = FALSE],
                         by = list(hex_num = qdt3$hex_num[pre_mask]), FUN = mean)
  names(pre_mean)[2] <- "y_pre"
  post_mean <- aggregate(qdt3[post_mask, out, drop = FALSE],
                          by = list(hex_num = qdt3$hex_num[post_mask]), FUN = mean)
  names(post_mean)[2] <- "y_post"

  change_dt <- merge(pre_mean, post_mean, by = "hex_num")
  change_dt$delta_y <- change_dt$y_post - change_dt$y_pre
  change_dt <- merge(change_dt, sqf_stock_full[, c("hex_num", "total_sqf", "sqf_tercile")],
                     by = "hex_num")
  change_dt$total_sqf_std <- as.numeric(scale(change_dt$total_sqf))

  # Does enforcement history predict rebound?
  reg <- lm(delta_y ~ total_sqf_std, data = change_dt)
  b <- coef(reg)["total_sqf_std"]
  s <- summary(reg)$coefficients["total_sqf_std", "Std. Error"]
  p <- summary(reg)$coefficients["total_sqf_std", "Pr(>|t|)"]

  cat(sprintf("beta(sqf_std) = %.4f (SE=%.4f, p=%.3f)\n", b, s, p))

  # By tercile
  terc <- do.call(rbind, lapply(split(change_dt, change_dt$sqf_tercile), function(d) {
    data.frame(sqf_tercile = d$sqf_tercile[1],
               mean_delta = mean(d$delta_y),
               se_delta = sd(d$delta_y) / sqrt(nrow(d)),
               n = nrow(d))
  }))
  for (i in 1:nrow(terc)) {
    cat(sprintf("    %s: delta = %.3f (SE=%.3f, n=%d)\n",
                terc$sqf_tercile[i], terc$mean_delta[i], terc$se_delta[i], terc$n[i]))
  }

  test3_results[[out]] <- list(beta = b, se = s, p = p, tercile_means = terc)
}

results$test3 <- test3_results

# Plot Test 3
plot_data <- do.call(rbind, lapply(outcomes, function(out) {
  tm <- test3_results[[out]]$tercile_means
  tm$outcome <- out
  tm
}))
plot_data$outcome_label <- factor(plot_data$outcome, levels = outcomes,
  labels = c("Violent Felony", "Property Felony", "Robbery", "Felony Assault", "Burglary"))
plot_data$sqf_tercile <- factor(plot_data$sqf_tercile, levels = c("Low", "Medium", "High"))

p3 <- ggplot(plot_data, aes(x = sqf_tercile, y = mean_delta, fill = sqf_tercile)) +
  geom_col(alpha = 0.8, width = 0.6) +
  geom_errorbar(aes(ymin = mean_delta - 1.96 * se_delta,
                     ymax = mean_delta + 1.96 * se_delta), width = 0.2) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray50") +
  facet_wrap(~ outcome_label, scales = "free_y", ncol = 3) +
  scale_fill_manual(values = c("Low" = "#4DAF4A", "Medium" = "#FF7F00", "High" = "#E41A1C")) +
  labs(
    title = "Test 3: Post-Dissolution Crime Change by Enforcement History",
    subtitle = "If residual deterrence from enforcement matters, High-history zones should rebound LESS",
    x = "Cumulative SQF Tercile (enforcement history)",
    y = "Crime change (post - pre dissolution)",
    fill = "Enforcement\nHistory",
    caption = "Pre = Q3 2014-Q2 2015; Post = Q3 2015-Q4 2016. 95% CI."
  ) +
  theme_minimal(base_size = 12) +
  theme(strip.text = element_text(face = "bold"), panel.grid.minor = element_blank(),
        legend.position = "bottom")

ggsave("output/fig_dissolution_decay_by_history.pdf", p3, width = 12, height = 7)
ggsave("output/fig_dissolution_decay_by_history.png", p3, width = 12, height = 7, dpi = 300)
cat("\n  Saved: output/fig_dissolution_decay_by_history.pdf/.png\n")

###############################################################################
## SAVE
###############################################################################

saveRDS(results, "output/residual_deterrence_tests.rds")
cat("\nSaved: output/residual_deterrence_tests.rds\n")

###############################################################################
## FINAL SUMMARY
###############################################################################

cat("\n")
cat(paste(rep("=", 72), collapse = ""), "\n")
cat("RESIDUAL DETERRENCE TEST SUMMARY\n")
cat(paste(rep("=", 72), collapse = ""), "\n")

cat("\nTEST 1: Virgin Low-SQF Hexes (N=33, zero enforcement history)\n")
cat("  Logic: If crime drops at activation despite zero enforcement history,\n")
cat("         then presence works and residual deterrence is ruled out.\n")
for (out in outcomes) {
  r <- test1_results[[out]]
  if (!is.null(r)) {
    cat(sprintf("  %-18s: avg post = %+.3f, avg pre = %+.3f\n",
                out, r$avg_post, r$avg_pre))
  }
}

cat("\nTEST 2: Cumulative Dosage Moderator\n")
cat("  Logic: If high-history ~ low-history effects, enforcement stock\n")
cat("         doesn't drive ATT -- presence is the mechanism.\n")
for (out in outcomes) {
  h <- test2_results$high_history[[out]]$att$att
  l <- test2_results$low_history[[out]]$att$att
  cat(sprintf("  %-18s: high=%.4f, low=%.4f\n",
              out, ifelse(is.na(h), NA, h), ifelse(is.na(l), NA, l)))
}

cat("\nTEST 3: Post-Dissolution Decay x Enforcement History\n")
cat("  Logic: If beta(cum_sqf) ~ 0, enforcement history doesn't predict\n")
cat("         crime rebound -- residual deterrence is not the mechanism.\n")
for (out in outcomes) {
  r <- test3_results[[out]]
  cat(sprintf("  %-18s: beta = %+.4f (p = %.3f)\n", out, r$beta, r$p))
}

cat("\nDone.\n")
