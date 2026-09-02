library(readr)
library(tidyverse)
library(irr)
library(tidyr)
library(emmeans)
rm(list = ls()); cat("\014")  


tvalue <- read_csv("/media/neuroimaging/SSD_ChK/lumbar_fMRI/14_LTR/04_Results/89_tvalue/PAM50_cord_quad_DR_results_tvalue.csv", col_names = FALSE, show_col_types = FALSE)
tvalue_subject <- read_csv("/media/neuroimaging/SSD_ChK/lumbar_fMRI/14_LTR/04_Results/89_tvalue/PAM50_cord_quad_DR_results_tvalue_subject.csv", col_names = FALSE, show_col_types = FALSE)

tvalue_flobs <- read_csv("/media/neuroimaging/SSD_ChK/lumbar_fMRI/14_LTR/04_Results/89_tvalue/PAM50_cord_quad_DR_results_tvalue.csv", col_names = FALSE, show_col_types = FALSE)
tvalue_flobs_subject <- read_csv("/media/neuroimaging/SSD_ChK/lumbar_fMRI/14_LTR/04_Results/89_tvalue/PAM50_cord_quad_DR_results_tvalue_subject.csv", col_names = FALSE, show_col_types = FALSE)


# ---- Session 1 and 2 ----
print('Kendalls W for both Sessions')
print(kendall(tvalue[, 1:8]))
 

print("ICC for all runs and sessions")
icc_all <- icc(
  tvalue[, 1:8],
  model = "twoway",
  type  = "agreement",
  unit  = "single"
)
print(icc_all)

print(sprintf(
  "ICC = %.3f (95%% CI %.3f - %.3f)",
  icc_all$value,
  icc_all$lbound,
  icc_all$ubound
))

print('Kendalls W for run 1 both Sessions')
print(kendall(tvalue[, c(1,5)]))

print('ICC for run 1 both Sessions')
icc_run1 <- icc(
  tvalue[, c(1,5)],
  model = "twoway",
  type  = "agreement",
  unit  = "single"
)
print(icc_run1)


print(sprintf(
  "ICC = %.3f (95%% CI %.3f - %.3f)",
  icc_run1$value,
  icc_run1$lbound,
  icc_run1$ubound
))




print('Kendalls W for subject both Sessions')
print(kendall(tvalue_subject))

print('ICC for subject both Sessions')
icc_subject <- icc(
  tvalue_subject,
  model = "twoway",
  type  = "agreement",
  unit  = "single"
)
print(icc_subject)

tvalue_long <- data.frame(
  rep(1:25, each=8),
  rep(1:2, each=4, 25),
  rep(1:4, 25),
  select(pivot_longer(tvalue, 1:8), value)
)

colnames(tvalue_long) <- c("subject", "session", "run", "tvalue")

tvalue_long$subject <- as.factor(tvalue_long$subject)
tvalue_long$session <- as.factor(tvalue_long$session)
tvalue_long$run <- as.factor(tvalue_long$run)

# Two-way ANOVA
res.aov <- aov(
  tvalue ~ session + run + Error(subject/(session + run)),
  data=tvalue_long
)

print(summary(res.aov))

emm <- emmeans(res.aov, ~ session)
print(pairs(emm))

emm <- emmeans(res.aov, ~ run)
print(pairs(emm))

# ---- Session 1 ----
print('Kendalls W for Sessions 01')
print(kendall(tvalue[, 1:4]))

print('ICC for Session 01')
icc_S1 <- icc(
  tvalue[, 1:4],
  model = "twoway",
  type  = "agreement",
  unit  = "single"
)
print(icc_S1)

print(sprintf(
  "ICC = %.3f (95%% CI %.3f - %.3f)",
  icc_S1$value,
  icc_S1$lbound,
  icc_S1$ubound
))



tvalue_long_S1 <- tvalue_long[tvalue_long$session != "2", ]
tvalue_long_S1$session <- NULL

resS1.aov <- aov(
  tvalue ~ run + Error(subject/run),
  data=tvalue_long_S1
)

print(summary(resS1.aov))

# ---- Session 2 ----
print('Kendalls W for Sessions 02')
print(kendall(tvalue[, 5:8]))

print('ICC for Session 02')
icc_S2 <- icc(
  tvalue[, 5:8],
  model = "twoway",
  type  = "agreement",
  unit  = "single"
)
print(icc_S2)

print(sprintf(
  "ICC = %.3f (95%% CI %.3f - %.3f)",
  icc_S2$value,
  icc_S2$lbound,
  icc_S2$ubound
))

tvalue_long_S2 <- tvalue_long[tvalue_long$session != "1", ]
tvalue_long_S2$session <- NULL

resS2.aov <- aov(
  tvalue ~ run + Error(subject/run),
  data=tvalue_long_S2
)

print(summary(resS2.aov))

