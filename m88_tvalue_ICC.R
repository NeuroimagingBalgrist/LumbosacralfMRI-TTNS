library(readr)
library(tidyverse)
library(irr)
library(tidyr)
library(emmeans)
rm(list = ls()); cat("\014")


tvalue <- read_csv("", col_names = FALSE, show_col_types = FALSE)
tvalue_subject <- read_csv("", col_names = FALSE, show_col_types = FALSE)



# ---- Session 1 and 2 ----
print('Kendalls W for both Sessions')
print(kendall(tvalue[, 1:8]))
print('Kendalls W for run 1 both Sessions')
print(kendall(tvalue[, c(1,5)]))
print('Kendalls W for subject both Sessions')
print(kendall(tvalue_subject))

tvalue_long <- data.frame(rep(1:25, each=8), rep(1:2, each=4, 25), rep(1:4, 25), select(pivot_longer(tvalue, 1:8), value))
colnames(tvalue_long) <- c("subject", "session", "run", "tvalue")

tvalue_long$subject <- as.factor(tvalue_long$subject)
tvalue_long$session <- as.factor(tvalue_long$session)
tvalue_long$run <- as.factor(tvalue_long$run)

#Two-way ANOVA
res.aov <- aov(tvalue ~ session + run + Error(subject/(session + run)) , data=tvalue_long)
print(summary(res.aov))

emm <- emmeans(res.aov, ~ session)
print(pairs(emm))

emm <- emmeans(res.aov, ~ run)
print(pairs(emm))



# ---- Session 1 ----
print('Kendalls W for Sessions 01')
print(kendall(tvalue[, 1:4]))
tvalue_long_S1 <- tvalue_long[tvalue_long$session != "2", ]
tvalue_long_S1$session <- NULL
resS1.aov <- aov(tvalue ~ run + Error(subject/run), data=tvalue_long_S1)
print(summary(resS1.aov))



# ---- Session 2 ----
print('Kendalls W for Sessions 02')
print(kendall(tvalue[, 5:8]))
tvalue_long_S2 <- tvalue_long[tvalue_long$session != "1", ]
tvalue_long_S2$session <- NULL
resS2.aov <- aov(tvalue ~ run + Error(subject/run), data=tvalue_long_S2)
print(summary(resS2.aov))
