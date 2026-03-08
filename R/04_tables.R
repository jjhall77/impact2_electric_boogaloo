# 04_tables.R
# Produces formatted replication tables matching the paper's Tables 1 and 2.
# Uses modelsummary for output.

library(fixest)
library(modelsummary)

# ---- Load saved model objects ----------------------------------------------
crime_models  <- readRDS("output/crime_models.rds")
arrest_models <- readRDS("output/arrest_models.rds")

# ---- Variable-to-label mappings (confirmed by coefficient matching) --------

crime_labels <- c(
  crimes1 = "Total", offenses47 = "Robbery", offenses15 = "Assault",
  offenses7 = "Burglary", crimes10 = "Weapons", crimes7 = "Misd.",
  crimes6 = "Other Felony", crimes5 = "Drugs", crimes3 = "Property Felony",
  offenses = "Violent Felony"
)

arrest_labels <- c(
  offenses = "Total", offenses57 = "Robbery", offenses18 = "Assault",
  offenses8 = "Burglary", crimes10 = "Weapons", crimes7 = "Misd.",
  crimes6 = "Other Felony", crimes5 = "Drugs", crimes3 = "Property Felony",
  crimes1 = "Violent Felony"
)

# Desired table column order
col_order <- c("Total", "Robbery", "Assault", "Burglary", "Weapons",
               "Misd.", "Other Felony", "Drugs", "Property Felony",
               "Violent Felony")

# ---- Helper: reorder model list by table column order ----------------------
reorder_models <- function(model_list, label_map) {
  ordered <- list()
  for (lbl in col_order) {
    var <- names(label_map)[label_map == lbl]
    if (length(var) == 1 && var %in% names(model_list)) {
      ordered[[lbl]] <- model_list[[var]]
    }
  }
  ordered
}

# ---- Table 1: Models 1 & 2 (Crime + Arrest) --------------------------------
cat("\n========== TABLE 1: Effect of Impact Zones on Crimes ==========\n\n")

# Crime Model 1
cm1 <- reorder_models(crime_models$m1, crime_labels)
msummary(cm1,
         coef_map = c("treatment" = "Impact"),
         stars = c("*" = 0.01, "**" = 0.05),
         gof_map = c("nobs"),
         title = "Table 1 — Crime Model 1",
         output = "markdown")

cat("\n")

# Crime Model 2
cm2 <- reorder_models(crime_models$m2, crime_labels)
msummary(cm2,
         coef_map = c("treatment" = "Impact", "treatmentn" = "Neighbors"),
         stars = c("*" = 0.01, "**" = 0.05),
         gof_map = c("nobs"),
         title = "Table 1 — Crime Model 2",
         output = "markdown")

cat("\n========== TABLE 1: Effect of Impact Zones on Arrests ==========\n\n")

# Arrest Model 1
am1 <- reorder_models(arrest_models$m1, arrest_labels)
msummary(am1,
         coef_map = c("treatment" = "Impact"),
         stars = c("*" = 0.01, "**" = 0.05),
         gof_map = c("nobs"),
         title = "Table 1 — Arrest Model 1",
         output = "markdown")

cat("\n")

# Arrest Model 2
am2 <- reorder_models(arrest_models$m2, arrest_labels)
msummary(am2,
         coef_map = c("treatment" = "Impact", "treatmentn" = "Neighbors"),
         stars = c("*" = 0.01, "**" = 0.05),
         gof_map = c("nobs"),
         title = "Table 1 — Arrest Model 2",
         output = "markdown")

# ---- Table 2: Model 4 PC vs NPC (Crime + Arrest) ---------------------------
cat("\n========== TABLE 2: Effect of Impact Zone Stops on Crimes ==========\n\n")

cm4 <- reorder_models(crime_models$m4, crime_labels)
msummary(cm4,
         coef_map = c("treatmentpc" = "PC*Impact", "treatmentnpc" = "NPC*Impact"),
         stars = c("*" = 0.01, "**" = 0.05),
         gof_map = c("nobs"),
         title = "Table 2 — Crime Model 4",
         output = "markdown")

cat("\n========== TABLE 2: Effect of Impact Zone Stops on Arrests ==========\n\n")

am4 <- reorder_models(arrest_models$m4, arrest_labels)
msummary(am4,
         coef_map = c("treatmentpc" = "PC*Impact", "treatmentnpc" = "NPC*Impact"),
         stars = c("*" = 0.01, "**" = 0.05),
         gof_map = c("nobs"),
         title = "Table 2 — Arrest Model 4",
         output = "markdown")

# ---- Save tables to files --------------------------------------------------
dir.create("output", showWarnings = FALSE)

# Combined Table 1 - Crime
msummary(cm1,
         coef_map = c("treatment" = "Impact"),
         stars = c("*" = 0.01, "**" = 0.05),
         gof_map = c("nobs"),
         title = "Table 1 — Crime Model 1: Effect of Impact Zones",
         output = "output/table1_crime_m1.md")

msummary(cm2,
         coef_map = c("treatment" = "Impact", "treatmentn" = "Neighbors"),
         stars = c("*" = 0.01, "**" = 0.05),
         gof_map = c("nobs"),
         title = "Table 1 — Crime Model 2: Neighbor Spillover",
         output = "output/table1_crime_m2.md")

# Combined Table 1 - Arrest
msummary(am1,
         coef_map = c("treatment" = "Impact"),
         stars = c("*" = 0.01, "**" = 0.05),
         gof_map = c("nobs"),
         title = "Table 1 — Arrest Model 1: Effect of Impact Zones",
         output = "output/table1_arrest_m1.md")

msummary(am2,
         coef_map = c("treatment" = "Impact", "treatmentn" = "Neighbors"),
         stars = c("*" = 0.01, "**" = 0.05),
         gof_map = c("nobs"),
         title = "Table 1 — Arrest Model 2: Neighbor Spillover",
         output = "output/table1_arrest_m2.md")

# Table 2
msummary(cm4,
         coef_map = c("treatmentpc" = "PC*Impact", "treatmentnpc" = "NPC*Impact"),
         stars = c("*" = 0.01, "**" = 0.05),
         gof_map = c("nobs"),
         title = "Table 2 — Crime Model 4: PC vs NPC Stops",
         output = "output/table2_crime_m4.md")

msummary(am4,
         coef_map = c("treatmentpc" = "PC*Impact", "treatmentnpc" = "NPC*Impact"),
         stars = c("*" = 0.01, "**" = 0.05),
         gof_map = c("nobs"),
         title = "Table 2 — Arrest Model 4: PC vs NPC Stops",
         output = "output/table2_arrest_m4.md")

cat("\nTables saved to output/\n")
