# 24_figures.R
# Publication-quality figures
#
# Fig 1: dCDH event study panels (8 crime outcomes, 2×4 grid)
# Fig 2: Enforcement controls comparison (baseline vs +SQF vs +Arrests vs +All)
# Fig 3: Spillover event studies
# Fig 4: Dissolution event study
# Fig 5: Robustness forest plot
# Fig 6: First-touch vs baseline comparison
# Fig 7: Parallel trends summary (placebo tests)

library(data.table)
Sys.setenv(RGL_USE_NULL = "TRUE")
library(ggplot2)
library(patchwork)
library(fixest)

theme_set(theme_minimal(base_size = 11) +
  theme(
    panel.grid.minor = element_blank(),
    plot.title = element_text(size = 11, face = "bold"),
    strip.text = element_text(size = 10, face = "bold"),
    legend.position = "bottom"
  ))

# Helper: extract event study from dCDH result (v2.3+)
extract_es <- function(res, label = "") {
  eff <- res$results$Effects[, "Estimate"]
  se_eff <- res$results$Effects[, "SE"]
  plc <- res$results$Placebos[, "Estimate"]
  se_plc <- res$results$Placebos[, "SE"]
  n_eff <- length(eff)
  n_plc <- length(plc)
  data.table(
    period = c(-n_plc:-1, 0, 1:n_eff),
    estimate = c(rev(plc), 0, eff),
    se = c(rev(se_plc), 0, se_eff),
    label = label
  )[, `:=`(ci_lo = estimate - 1.96 * se, ci_hi = estimate + 1.96 * se)]
}

get_att <- function(res) {
  if (!is.null(res$results$ATE)) {
    list(att = res$results$ATE[1, "Estimate"],
         se  = res$results$ATE[1, "SE"])
  } else {
    list(att = NA, se = NA)
  }
}

outcomes <- c("violent", "property", "robbery", "felony_assault", "burglary",
              "robbery_outside", "felony_assault_outside", "burglary_outside")
labels <- c("Violent Felony", "Property Felony", "Robbery", "Felony Assault",
            "Burglary", "Robbery (Outside)", "F. Assault (Outside)",
            "Burglary (Outside)")
names(labels) <- outcomes

# Load results
dcdh_base <- readRDS("output/dcdh_full_results.rds")
dcdh_sqf  <- readRDS("output/dcdh_sqf_controlled_results.rds")
dcdh_arr  <- readRDS("output/dcdh_arrest_controlled_results.rds")
dcdh_all  <- readRDS("output/dcdh_all_enforcement_controlled_results.rds")
spillover <- readRDS("output/spillover_dcdh_results.rds")
ft_results <- readRDS("output/first_touch_results.rds")
rob_results <- readRDS("output/robustness_results.rds")

# ==============================================================================
# FIG 1: dCDH EVENT STUDY PANELS
# ==============================================================================
cat("Fig 1: dCDH event studies...\n")

es_list <- list()
for (yvar in outcomes) {
  res <- dcdh_base[[yvar]]
  if (!is.null(res$results)) {
    es_list[[yvar]] <- extract_es(res, labels[yvar])
  }
}
es_dt <- rbindlist(es_list)
es_dt[, label := factor(label, levels = labels)]

fig1 <- ggplot(es_dt, aes(x = period, y = estimate)) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray50") +
  geom_vline(xintercept = 0, linetype = "dotted", color = "gray70") +
  geom_ribbon(aes(ymin = ci_lo, ymax = ci_hi), alpha = 0.2, fill = "steelblue") +
  geom_line(color = "steelblue", linewidth = 0.7) +
  geom_point(color = "steelblue", size = 1.5) +
  facet_wrap(~label, scales = "free_y", ncol = 4) +
  labs(x = "Quarters Relative to Treatment Switch",
       y = "Effect Estimate",
       title = "dCDH Dynamic Treatment Effects by Outcome") +
  scale_x_continuous(breaks = seq(-4, 8, 2))

ggsave("output/fig1_dcdh_event_studies.png", fig1, width = 14, height = 7, dpi = 300)
ggsave("output/fig1_dcdh_event_studies.pdf", fig1, width = 14, height = 7)
cat("  Saved fig1\n")

# ==============================================================================
# FIG 2: ENFORCEMENT CONTROLS COMPARISON
# ==============================================================================
cat("Fig 2: Enforcement controls...\n")

qdt <- readRDS("data/panel_quarterly_analysis.rds")

ctrl_dt <- data.table()
for (yvar in outcomes) {
  trt_mean <- mean(qdt[treatment == 1, get(yvar)])

  for (spec_name in c("Baseline", "+ SQF", "+ Arrests", "+ All Enforcement")) {
    res <- switch(spec_name,
      "Baseline" = dcdh_base[[yvar]],
      "+ SQF" = dcdh_sqf[[yvar]],
      "+ Arrests" = dcdh_arr[[yvar]],
      "+ All Enforcement" = dcdh_all[[yvar]]
    )
    r <- get_att(res)
    if (!is.na(r$att)) {
      pct <- (r$att / trt_mean) * 100
      se_pct <- (r$se / trt_mean) * 100
      ctrl_dt <- rbind(ctrl_dt, data.table(
        outcome = labels[yvar],
        spec = spec_name,
        pct = pct,
        ci_lo = pct - 1.96 * se_pct,
        ci_hi = pct + 1.96 * se_pct
      ))
    }
  }
}

ctrl_dt[, spec := factor(spec, levels = c("Baseline", "+ SQF", "+ Arrests", "+ All Enforcement"))]
ctrl_dt[, outcome := factor(outcome, levels = rev(labels))]

fig2 <- ggplot(ctrl_dt, aes(x = pct, y = outcome, color = spec, shape = spec)) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "gray50") +
  geom_pointrange(aes(xmin = ci_lo, xmax = ci_hi),
                  position = position_dodge(width = 0.6), size = 0.4) +
  scale_color_manual(values = c("black", "#E69F00", "#56B4E9", "#CC79A7")) +
  scale_shape_manual(values = c(16, 17, 15, 18)) +
  labs(x = "Treatment Effect (% of treated mean)",
       y = NULL,
       color = "Specification", shape = "Specification",
       title = "Treatment Effects Conditional on Enforcement Activity") +
  theme(legend.position = "bottom")

ggsave("output/fig2_enforcement_controls.png", fig2, width = 10, height = 6, dpi = 300)
ggsave("output/fig2_enforcement_controls.pdf", fig2, width = 10, height = 6)
cat("  Saved fig2\n")

# ==============================================================================
# FIG 3: SPILLOVER
# ==============================================================================
cat("Fig 3: Spillover...\n")

spill_es <- list()
for (yvar in names(spillover)) {
  res <- spillover[[yvar]]
  if (!is.null(res$results)) {
    lbl <- if (yvar %in% names(labels)) labels[yvar] else yvar
    spill_es[[yvar]] <- extract_es(res, lbl)
  }
}

if (length(spill_es) > 0) {
  spill_dt <- rbindlist(spill_es)

  fig3 <- ggplot(spill_dt, aes(x = period, y = estimate)) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "gray50") +
    geom_vline(xintercept = 0, linetype = "dotted", color = "gray70") +
    geom_ribbon(aes(ymin = ci_lo, ymax = ci_hi), alpha = 0.2, fill = "darkgreen") +
    geom_line(color = "darkgreen", linewidth = 0.7) +
    geom_point(color = "darkgreen", size = 1.5) +
    facet_wrap(~label, scales = "free_y", ncol = 4) +
    labs(x = "Quarters Relative to Neighbor Treatment Switch",
         y = "Spillover Effect",
         title = "Spillover Effects: dCDH on Never-Treated Hexes (Neighbor Treatment)") +
    scale_x_continuous(breaks = seq(-4, 8, 2))

  ggsave("output/fig3_spillover_es.png", fig3, width = 14, height = 7, dpi = 300)
  ggsave("output/fig3_spillover_es.pdf", fig3, width = 14, height = 7)
  cat("  Saved fig3\n")
} else {
  cat("  SKIP: no spillover event study data\n")
}

# ==============================================================================
# FIG 4: DISSOLUTION EVENT STUDY
# ==============================================================================
cat("Fig 4: Dissolution event study...\n")

if (file.exists("output/dissolution_es_results.rds")) {
  diss_models <- readRDS("output/dissolution_es_results.rds")

  diss_dt <- data.table()
  for (yvar in outcomes) {
    m <- diss_models[[yvar]]
    if (is.null(m)) next
    cc <- coeftable(m)
    # Extract coefficients matching rel_f::X:ever_treated
    rows <- grep("^rel_f::", rownames(cc))
    if (length(rows) == 0) next
    for (r in rows) {
      rt_str <- sub("rel_f::([-0-9]+):ever_treated", "\\1", rownames(cc)[r])
      rt <- as.integer(rt_str)
      diss_dt <- rbind(diss_dt, data.table(
        outcome = labels[yvar],
        rel_time = rt,
        estimate = cc[r, "Estimate"],
        se = cc[r, "Std. Error"]
      ))
    }
    # Add reference period
    diss_dt <- rbind(diss_dt, data.table(
      outcome = labels[yvar], rel_time = -1, estimate = 0, se = 0))
  }

  diss_dt[, `:=`(ci_lo = estimate - 1.96 * se, ci_hi = estimate + 1.96 * se)]
  diss_dt[, outcome := factor(outcome, levels = labels)]

  fig4 <- ggplot(diss_dt, aes(x = rel_time, y = estimate)) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "gray50") +
    geom_vline(xintercept = -0.5, linetype = "solid", color = "red", alpha = 0.5) +
    geom_ribbon(aes(ymin = ci_lo, ymax = ci_hi), alpha = 0.15, fill = "firebrick") +
    geom_line(color = "firebrick", linewidth = 0.7) +
    geom_point(color = "firebrick", size = 1.5) +
    facet_wrap(~outcome, scales = "free_y", ncol = 4) +
    labs(x = "Quarters Relative to Dissolution (Q3 2015)",
         y = "Effect Estimate (Poisson FE)",
         title = "Event Study Around Program Dissolution (July 2015)") +
    scale_x_continuous(breaks = seq(-8, 8, 2)) +
    annotate("text", x = 0.5, y = Inf, label = "Post", hjust = 0, vjust = 1.5,
             size = 3, color = "red", fontface = "italic")

  ggsave("output/fig4_dissolution_es.png", fig4, width = 14, height = 7, dpi = 300)
  ggsave("output/fig4_dissolution_es.pdf", fig4, width = 14, height = 7)
  cat("  Saved fig4\n")
} else {
  cat("  SKIP: dissolution ES results not found\n")
}

# ==============================================================================
# FIG 5: ROBUSTNESS FOREST PLOT
# ==============================================================================
cat("Fig 5: Robustness forest plot...\n")

# Collect all specs
linger1 <- readRDS("output/dcdh_linger1_results.rds")
linger2 <- readRDS("output/dcdh_linger2_results.rds")

all_specs <- list(
  "Baseline (8/4)"      = dcdh_base,
  "No Pct 75"           = rob_results[["No Pct 75"]],
  "Near controls"       = rob_results[["Near controls"]],
  "6 eff / 3 plc"       = rob_results[["6 eff / 3 plc"]],
  "4 eff / 2 plc"       = rob_results[["4 eff / 2 plc"]],
  "Drop trans. Qs"      = rob_results[["Drop trans. Qs"]],
  "First-touch"         = ft_results,
  "Linger 1Q"           = linger1,
  "Linger 2Q"           = linger2,
  "+ SQF controls"      = dcdh_sqf,
  "+ Arrest controls"   = dcdh_arr,
  "+ All enforcement"   = dcdh_all
)

# Focus on 4 key outcomes for readability
key_outcomes <- c("violent", "robbery", "felony_assault", "burglary")
key_labels <- labels[key_outcomes]

rob_dt <- data.table()
for (spec_name in names(all_specs)) {
  spec <- all_specs[[spec_name]]
  for (yvar in key_outcomes) {
    r <- get_att(spec[[yvar]])
    if (!is.na(r$att)) {
      trt_mean <- mean(qdt[treatment == 1, get(yvar)])
      pct <- (r$att / trt_mean) * 100
      se_pct <- (r$se / trt_mean) * 100
      rob_dt <- rbind(rob_dt, data.table(
        spec = spec_name, outcome = key_labels[yvar],
        pct = pct, ci_lo = pct - 1.96 * se_pct, ci_hi = pct + 1.96 * se_pct
      ))
    }
  }
}

rob_dt[, spec := factor(spec, levels = rev(names(all_specs)))]
rob_dt[, outcome := factor(outcome, levels = key_labels)]

fig5 <- ggplot(rob_dt, aes(x = pct, y = spec)) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "gray50") +
  geom_pointrange(aes(xmin = ci_lo, xmax = ci_hi), size = 0.3, color = "steelblue") +
  facet_wrap(~outcome, scales = "free_x", ncol = 4) +
  labs(x = "Treatment Effect (% of treated mean)",
       y = NULL,
       title = "Robustness: Treatment Effects Across Specifications") +
  theme(axis.text.y = element_text(size = 8))

ggsave("output/fig5_robustness_forest.png", fig5, width = 14, height = 6, dpi = 300)
ggsave("output/fig5_robustness_forest.pdf", fig5, width = 14, height = 6)
cat("  Saved fig5\n")

# ==============================================================================
# FIG 6: FIRST-TOUCH VS BASELINE
# ==============================================================================
cat("Fig 6: First-touch comparison...\n")

ft_dt <- data.table()
for (yvar in outcomes) {
  trt_mean <- mean(qdt[treatment == 1, get(yvar)])
  for (spec_name in c("Full Panel", "First-Touch")) {
    res <- if (spec_name == "Full Panel") dcdh_base[[yvar]] else ft_results[[yvar]]
    r <- get_att(res)
    if (!is.na(r$att)) {
      pct <- (r$att / trt_mean) * 100
      se_pct <- (r$se / trt_mean) * 100
      ft_dt <- rbind(ft_dt, data.table(
        outcome = labels[yvar], spec = spec_name,
        pct = pct, ci_lo = pct - 1.96 * se_pct, ci_hi = pct + 1.96 * se_pct
      ))
    }
  }
}

ft_dt[, outcome := factor(outcome, levels = rev(labels))]
ft_dt[, spec := factor(spec, levels = c("Full Panel", "First-Touch"))]

fig6 <- ggplot(ft_dt, aes(x = pct, y = outcome, color = spec, shape = spec)) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "gray50") +
  geom_pointrange(aes(xmin = ci_lo, xmax = ci_hi),
                  position = position_dodge(width = 0.5), size = 0.4) +
  scale_color_manual(values = c("gray40", "steelblue")) +
  scale_shape_manual(values = c(16, 17)) +
  labs(x = "Treatment Effect (% of treated mean)",
       y = NULL,
       color = "Specification", shape = "Specification",
       title = "First-Touch vs Full Panel Treatment Effects") +
  theme(legend.position = "bottom")

ggsave("output/fig6_first_touch.png", fig6, width = 9, height = 5, dpi = 300)
ggsave("output/fig6_first_touch.pdf", fig6, width = 9, height = 5)
cat("  Saved fig6\n")

# ==============================================================================
# FIG 7: PARALLEL TRENDS — PLACEBO TESTS
# ==============================================================================
cat("Fig 7: Parallel trends / placebo tests...\n")

# Extract placebo p-values from all full-panel results
placebo_dt <- data.table()
for (yvar in outcomes) {
  res <- dcdh_base[[yvar]]
  if (is.null(res$results)) next

  p_plc <- res$results$p_jointplacebo
  plc_est <- res$results$Placebos[, "Estimate"]
  plc_se  <- res$results$Placebos[, "SE"]
  n_plc <- length(plc_est)

  for (j in seq_len(n_plc)) {
    placebo_dt <- rbind(placebo_dt, data.table(
      outcome = labels[yvar],
      placebo = -j,
      estimate = plc_est[j],
      se = plc_se[j],
      p_joint = p_plc
    ))
  }
}

placebo_dt[, `:=`(ci_lo = estimate - 1.96 * se, ci_hi = estimate + 1.96 * se)]
placebo_dt[, outcome := factor(outcome, levels = labels)]

fig7a <- ggplot(placebo_dt, aes(x = placebo, y = estimate)) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray50") +
  geom_ribbon(aes(ymin = ci_lo, ymax = ci_hi), alpha = 0.2, fill = "darkorange") +
  geom_line(color = "darkorange", linewidth = 0.7) +
  geom_point(color = "darkorange", size = 1.5) +
  facet_wrap(~outcome, scales = "free_y", ncol = 4) +
  labs(x = "Placebo Period (quarters before treatment switch)",
       y = "Placebo Estimate",
       title = "Pre-Treatment Placebo Tests") +
  scale_x_continuous(breaks = -4:-1)

# Placebo joint p-value summary table as a plot
p_summary <- unique(placebo_dt[, .(outcome, p_joint)])
p_summary[, pass := fifelse(p_joint > 0.10, "Pass", "Fail")]
p_summary[, p_label := sprintf("p = %.3f", p_joint)]

fig7b <- ggplot(p_summary, aes(x = p_joint, y = outcome, fill = pass)) +
  geom_col(width = 0.6) +
  geom_vline(xintercept = 0.10, linetype = "dashed", color = "red") +
  geom_text(aes(label = p_label), hjust = -0.1, size = 3) +
  scale_fill_manual(values = c("Fail" = "#E41A1C", "Pass" = "#4DAF4A")) +
  scale_x_continuous(limits = c(0, 1)) +
  labs(x = "Joint Placebo p-value",
       y = NULL, fill = NULL,
       title = "Joint Placebo Tests (H0: all pre-treatment effects = 0)") +
  theme(legend.position = "none")

fig7 <- fig7a / fig7b + plot_layout(heights = c(3, 1))

ggsave("output/fig7_parallel_trends.png", fig7, width = 14, height = 9, dpi = 300)
ggsave("output/fig7_parallel_trends.pdf", fig7, width = 14, height = 9)
cat("  Saved fig7\n")

cat("\nAll figures complete.\n")
