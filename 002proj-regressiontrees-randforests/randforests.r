# https://github.com/jaredkunz/MLprojectsRlang
# https://jaredkunz.com
# https://www.linkedin.com/in/jaredkunz/

library(randomForest)

# use the rm(list=()) command to clean the environment, but be careful it may remove your data you wanted to keep
# rm(list = ls())

# set seed
# suppressWarnings(RNGkind(sample.kind = "Rounding")) # This is used to ensure proper seed, RNG on R 3.6.1 vs older versions
set.seed(4)

# Import the data
crime_data <- read.table("C:/uscrime.txt", header = TRUE)


formula_A <- Crime ~ . # dEV 36290

 
num_pred_mtry <- 4
crime_rf <- randomForest(formula_A,data = crime_data, ntree = 168, mtry = num_pred_mtry,importance = TRUE)

crime_rf

#importance(crime_rf)
plot(crime_rf)

mse <- crime_rf$mse
pred <- crime_rf$predicted
rsq <- crime_rf$rsq
oob <- crime_rf$oob.times
plot(oob, type = "o")
plot(pred, type = "o")

crime_rf$call
crime_rf$type

rmse_prediction <- function(actual, predicted) {
  sqrt(mean((actual - predicted)^2))
}

importance_df <- as.data.frame(importance(crime_rf))
importance_df[order(-importance_df$`%IncMSE`),] 

 

print("Script Processes Complete")