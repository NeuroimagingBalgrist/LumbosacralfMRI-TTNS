library(readr)
library(tidyverse)
library(irr)
library(tidyr)
library(emmeans)
rm(list = ls()); cat("\014")  


effectsize <- read_csv("/media/neuroimaging/SSD_ChK/lumbar_fMRI/14_LTR/04_Results/88_effect_size/PAM50_cord_quad_DR_results_percent.csv", col_names = FALSE, show_col_types = FALSE)
effectsize_flobs <- read_csv("/media/neuroimaging/SSD_ChK/lumbar_fMRI/14_LTR/04_Results/88_effect_size/PAM50_cord_quad_DR_results_percent.csv", col_names = FALSE, show_col_types = FALSE)

# ---- Session 1 and 2 ----


# ---- Kendalls W ----
print('Kendalls W for both Sessions')
print(kendall(effectsize[, 1:8]))
print('Kendalls W for run 1 both Sessions')
print(kendall(effectsize[, c(1,5)]))

effectsize_long <- data.frame(rep(1:25, each=8), rep(1:2, each=4, 25), rep(1:4, 25), select(pivot_longer(effectsize, 1:8), value))
colnames(effectsize_long) <- c("subject", "session", "run", "effectsize")

effectsize_long$subject <- as.factor(effectsize_long$subject)
effectsize_long$session <- as.factor(effectsize_long$session)
effectsize_long$run <- as.factor(effectsize_long$run)

#-----Two-way ANOVA
res.aov <- aov(effectsize ~ session + run + Error(subject/(session + run)) , data=effectsize_long)
print(summary(res.aov))

emm <- emmeans(res.aov, ~ session)
print(pairs(emm))

emm <- emmeans(res.aov, ~ run)
print(pairs(emm))


# ----ICC-----

print("ICC for all runs and sessions")
icc_all <- icc(
  effectsize[, 1:8],
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


print("ICC for run 1 both Sessions")
icc_run1 <- icc(effectsize[, c(1, 5)],
    model = "twoway",
    type = "agreement",
    unit = "single")

print(icc_run1)

print(sprintf(
  "ICC = %.3f (95%% CI %.3f - %.3f)",
  icc_run1$value,
  icc_run1$lbound,
  icc_run1$ubound
))




# ---- Session 1 ----



# ---- Kendalls W ----
print('Kendalls W for Sessions 01')
print(kendall(effectsize[, 1:4]))
effectsize_long_S1 <- effectsize_long[effectsize_long$session != "2", ]
effectsize_long_S1$session <- NULL
resS1.aov <- aov(effectsize ~ run + Error(subject/run), data=effectsize_long_S1)
print(summary(resS1.aov))

# ----ICC-----
print("ICC for Session 1")

icc_S1 <- icc(
  effectsize[, 1:4],
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




# ---- Session 2 ----
print('Kendalls W for Sessions 02')
print(kendall(effectsize[, 5:8]))
effectsize_long_S2 <- effectsize_long[effectsize_long$session != "1", ]
effectsize_long_S2$session <- NULL
resS2.aov <- aov(effectsize ~ run + Error(subject/run), data=effectsize_long_S2)
print(summary(resS2.aov))

# ----ICC-----
print("ICC for Session 2")
icc_S2 <- icc(
  effectsize[, 5:8],
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


# ----------------------------------------------------------
# Session-to-session reliability using session means
# ----------------------------------------------------------

session_means <- data.frame(
  Session1 = rowMeans(effectsize[, 1:4]),
  Session2 = rowMeans(effectsize[, 5:8])
)

print("ICC between Session 1 and Session 2")

icc_session <- icc(
  session_means,
  model = "twoway",
  type  = "consistency",
  unit  = "single"
)
print(icc_session)

print(sprintf(
  "ICC = %.3f (95%% CI %.3f - %.3f)",
  icc_session$value,
  icc_session$lbound,
  icc_session$ubound
))





