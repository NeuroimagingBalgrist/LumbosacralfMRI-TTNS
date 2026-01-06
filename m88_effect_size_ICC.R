library(readr)
library(tidyverse)
library(irr)
library(tidyr)
library(emmeans)
rm(list = ls()); cat("\014")


effectsize <- read_csv("", col_names = FALSE, show_col_types = FALSE)



# ---- Session 1 and 2 ----
print('Kendalls W for both Sessions')
print(kendall(effectsize[, 1:8]))
print('Kendalls W for run 1 both Sessions')
print(kendall(effectsize[, c(1,5)]))

effectsize_long <- data.frame(rep(1:25, each=8), rep(1:2, each=4, 25), rep(1:4, 25), select(pivot_longer(effectsize, 1:8), value))
colnames(effectsize_long) <- c("subject", "session", "run", "effectsize")

effectsize_long$subject <- as.factor(effectsize_long$subject)
effectsize_long$session <- as.factor(effectsize_long$session)
effectsize_long$run <- as.factor(effectsize_long$run)

#Two-way ANOVA
res.aov <- aov(effectsize ~ session + run + Error(subject/(session + run)) , data=effectsize_long)
print(summary(res.aov))

emm <- emmeans(res.aov, ~ session)
print(pairs(emm))

emm <- emmeans(res.aov, ~ run)
print(pairs(emm))



# ---- Session 1 ----
print('Kendalls W for Sessions 01')
print(kendall(effectsize[, 1:4]))
effectsize_long_S1 <- effectsize_long[effectsize_long$session != "2", ]
effectsize_long_S1$session <- NULL
resS1.aov <- aov(effectsize ~ run + Error(subject/run), data=effectsize_long_S1)
print(summary(resS1.aov))



# ---- Session 2 ----
print('Kendalls W for Sessions 02')
print(kendall(effectsize[, 5:8]))
effectsize_long_S2 <- effectsize_long[effectsize_long$session != "1", ]
effectsize_long_S2$session <- NULL
resS2.aov <- aov(effectsize ~ run + Error(subject/run), data=effectsize_long_S2)
print(summary(resS2.aov))
