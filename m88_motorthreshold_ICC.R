library(irr)
rm(list = ls()); cat("\014")  


x <- c(
  15.1, 17.2, 20.4, 10.5, 17.4, 22.6, 8.4, 6.5, 11.2, 19.7,
  11.3, 12.8, 20.4, 17.7, 18.9, 17.8, 12, 15.4, 12, 7.8,
  13.4, 15.3, 13.1, 18.2, 13.1, 17.9, 17, 17.8, 8.2, 15.1,
  22.4, 10, 7.1, 9.7, 23.4, 13.1, 14.7, 19.9, 18.3, 16.1,
  15.7, 10.5, 12.8, 10.2, 9.3, 14.4, 15.8, 14.2, 18.4, 13.3
)


# reshape: rows = subjects, cols = sessions
motorthresh <- cbind(
  Session1 = x[1:25],
  Session2 = x[26:50]
)

icc_result <- icc(
  motorthresh,
  model = "twoway",
  type  = "consistency",
  unit  = "single"
)

print(icc_result)
