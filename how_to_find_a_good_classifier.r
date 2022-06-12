# Jared Kunz
# Objectives
# ---Find a good classifier for this data. 
# ---Show the equation of your classifier, 
# ---How well it classifies the data points in the full data set

library(kernlab)

# Clean up that Environment!! Plant them random seed generators!!
rm(list=ls())
set.seed(1)

# Load data
CreditData <- read.table("C:/college/week_one/credit_card_data.txt", header = FALSE)

# Set up the variables, vectors, etcetera
KernelsVector <- c("vanilladot", "polydot", "rbfdot", "anovadot", "splinedot", "tanhdot", "laplacedot")
KernelsLabelVector <- c("vanilladot                    ", "             polydot", "rbfdot", "anovadot", "    splinedot", "tanhdot", "laplacedot     ")
KernelsLabelVector2 <- c("                     vanilladot", "polydot          ", "rbfdot", "anovadot", "    splinedot", "tanhdot", "laplacedot     ")
KernelsVectorColor <- c("black", "lightpink1", "thistle1", "lightgreen", "darkolivegreen1", "wheat1", "lightblue")
ConstC <- c(); Accuracy <- c(); Spacer <- c()
SuppVects2 <- c();ObjFunctVals2 <- c(); TrainErrors2 <- c();Kernels2 <- c();
SuppVects3 <- c(); ObjFunctVals3 <- c();TrainErrors3 <- c();Accuracy3 <- c(); ConstC3 <- c()
SuppVects4 <- c();ObjFunctVals4 <- c();TrainErrors4 <- c();SuppVects4 <- c();Kernels4 <- c();
ObjFunctVals4 <- c();TrainErrors4 <- c();Accuracy4 <- c(); ConstantCVector4 <- seq(1, 70, by = 0.5)


percent <- function(x, digits = 2, format = "f", ...) {
  paste0(formatC(100 * x, format = format, digits = digits, ...), "%")
}

# ---create the models 
# Var eleven, V11 is the response the other variables are the predictors
ModelScaledUp <- ksvm(as.matrix(CreditData[, 1:10]), as.factor(CreditData[, 11]), type = "C-svc", kernel = "vanilladot", C = .002, scaled = TRUE)

# str() function - Compactly Display The Structure Of An Arbitrary R Object\
# str(ModelScaledUp) #remove the first # at line start for details about structure

# This provides summary info the from the -scaled- model data
ModelScaledUp

# Classification with vanilladot kernel (linear) and scaling, need to find coefficients
# ksvm does not directly return the coefficients a0 and am, you need to do the last step of the calculation yourself,
# To calculate, we use the model output to find a
aScaledUp <- colSums(ModelScaledUp@xmatrix[[1]] * ModelScaledUp@coef[[1]])


# calculate a0, a0 is -ModelScaledUp@b (intercept)
a0ScaledUp <- -ModelScaledUp@b

aScaledUp
a0ScaledUp

sum(aScaledUp) + a0ScaledUp

# see what the model predicts with ksvm predict() function
PredictFunctScaledUp <- predict(ModelScaledUp, CreditData[, 1:10])

# percent of testing observations that are correctly classified.
percent(sum(PredictFunctScaledUp == CreditData$V11) / nrow(CreditData))

# Loop to pause the code for a 10 seconds so you can read the results of my classifier equation
# Feel free to remove this for loop if you want to run the program without the 10 second pause
for (i in 1:10)
{  print(i) 
   date_time<-Sys.time()  
   while((as.numeric(Sys.time()) - as.numeric(date_time))<2.5){} #dummy while loop
}
### > aScaledUp
### V1            V2           V3           V4           V5           V6           V7           V8           V9           V10

### -0.004180985  0.004628256  0.014836154  0.093885681  0.569911183 -0.222436309  0.158114398 -0.001308316 -0.019636394  0.105437302

### > a0ScaledUp
### [1] -0.05105346
### > sum(aScaledUp) + a0ScaledUp
### [1] 0.6481975

# create the models-----
# Scaled=TRUE model ----
# Var eleven, V11 is the response the other variables are the predictors
ModelNoScaling <- ksvm(as.matrix(CreditData[, 1:10]), as.factor(CreditData[, 11]),type = "C-svc", kernel = "vanilladot",  C = .002, scaled = FALSE ) 

# in this case, ksvm scaling the data
# You are welcome, but not required, to try other (nonlinear) kernels as well;

# This provides summary info the from the -scaled- model data
ModelNoScaling

# ksvm does not directly return the coefficients a0 and a am, you need to do the last step of the calculation yourself,
# calculate a1 , we use the model output to find a
aNoScaling <- colSums(ModelNoScaling@xmatrix[[1]] * ModelNoScaling@coef[[1]])


# calculate a0, a0 is -ModelScaledUp@b (intercept)
a0NoScaling <- -ModelNoScaling@b


aNoScaling
a0NoScaling


# see what the model predicts with ksvm predict() function
PredictFunctNoScaling <- predict(ModelNoScaling, CreditData[, 1:10])

# percent of testing observations that are correctly classified.
percent(sum(PredictFunctNoScaling == CreditData$V11) / nrow(CreditData))

# Loop to pause the code for a 5 seconds so you can read the results of the non-scaled info
# Feel free to remove this for loop if you want to run the program without the 10 second pause
for (i in 1:5)
{  print(i) 
  date_time<-Sys.time()  
  while((as.numeric(Sys.time()) - as.numeric(date_time))<2.5){} #dummy while loop
}

for (i in KernelsVector)
{
  ModelScaledUp2 <- ksvm(as.matrix(CreditData[, 1:10]), as.factor(CreditData[, 11]), type = "C-svc", kernel = i, C = 67, scaled = TRUE)
  
 
  Kernels2 <- append(Kernels2, i)
  
  SuppVects2 <- append(SuppVects2, ModelScaledUp2@nSV)
  ObjFunctVals2 <- append(ObjFunctVals2, ModelScaledUp2@obj)
  
  TrainErrors2 <- append(TrainErrors2, ModelScaledUp2@error)
  
  
}
ObjFunctVals2 <- round(ObjFunctVals2, 2)
TrainErrors2 <- round(TrainErrors2, 6)

plot(SuppVects2, TrainErrors2,
     col = KernelsVectorColor,
     pch = 16,
     cex = 2,
     xlab = "Number of Support Vectors",
     ylab = "Training Error",
     main = "Kernels Plot by Training Error & Support Vector Count, C=67"
)

text(SuppVects2, TrainErrors2, labels = KernelsLabelVector2, adj = NULL,
     pos = NULL, offset = 1, vfont = NULL,
     cex = .70, col = NULL, font = NULL)

OutputTable2 <- as.data.frame(cbind(
  Kernel_List = Kernels2, "\t" = Spacer, Supprt_Vectrs = SuppVects2, "\t" = Spacer,
  Obj_Funct_Val = ObjFunctVals2, "\t" = Spacer, Training_Err = TrainErrors2, "\t" = Spacer, Color = KernelsVectorColor
))
FormattedTable <- OutputTable2
name.width <- max(sapply(names(FormattedTable), nchar))
format(FormattedTable, width = name.width, justify = "centre")


for (z in KernelsVector)
{
  
  ModelScaledUp4 <- ksvm(as.matrix(CreditData[, 1:10]), as.factor(CreditData[, 11]), type = "C-svc", kernel = z, C = 67, scaled = TRUE)
  Kernels4 <- append(Kernels4, z)
  SuppVects4 <- append(SuppVects4, ModelScaledUp4@nSV)
  ObjFunctVals4 <- append(ObjFunctVals4, ModelScaledUp4@obj)
  
  TrainErrors4 <- append(TrainErrors4, ModelScaledUp4@error)

  aScaledUp4 <- colSums(ModelScaledUp4@xmatrix[[1]] * ModelScaledUp4@coef[[1]])
  
  # calculate a0, a0 is -ModelScaledUp@b (intercept)
  a0ScaledUp4 <- -ModelScaledUp4@b
  
  
  
  # see what the model predicts with ksvm predict() function
  PredictFunctScaledUp4 <- predict(ModelScaledUp4, CreditData[, 1:10])
  
  # percent of testing observations that are correctly classified.
  AccuracySum4 <- sum(PredictFunctScaledUp4 == CreditData$V11) / nrow(CreditData)
  Accuracy4 <- append(Accuracy4, AccuracySum4)
}
ObjFunctVals4 <- round(ObjFunctVals4, 2)
Accuracy4 <- round(Accuracy4, 4)
TrainErrors4 <- round(TrainErrors4, 6)

plot(SuppVects4, Accuracy4,
     col = KernelsVectorColor,
     pch = 16,
     cex = 2,
     xlab = "Number of Support Vectors",
     ylab = "Accuracy",
     main = "Kernels Plot by Accuracy & Support Vector Count, C=67"
)
text(SuppVects4, Accuracy4, labels = KernelsLabelVector2, adj = NULL,
     pos = NULL, offset = 1, vfont = NULL,
     cex = .70, col = NULL, font = NULL)

#OutputTable4 <- as.data.frame(cbind(
 # Kernel_List = Kernels4, Color = KernelsVectorColor, Constant_C = ModelScaledUp4@param$C, Supp_Vects = SuppVects4, "\t" = Spacer,
  #Obj_Funct_Val = ObjFunctVals4, "\t" = Spacer, Training_Errs = TrainErrors4, "\t" = Spacer, Accuracy = percent(Accuracy4)
#))
#FormattedTable <- OutputTable4
#name.width <- max(sapply(names(FormattedTable), nchar))
#format(FormattedTable, width = name.width, justify = "centre")

cat("Final Step: Please scroll all the way down to watch the build progress of the Support Vector Fluctuation Chart")

cat("\n")

for (j in ConstantCVector4) {
  # ModelScaledUp3 <- ksvm(as.matrix(CreditData[, 1:10]), as.factor(CreditData[, 11]),type = "C-svc", kernel = "vanilladot", C = j, scaled = TRUE)
  
  invisible(capture.output(ModelScaledUp3 <- ksvm(as.matrix(CreditData[, 1:10]), as.factor(CreditData[, 11]), type = "C-svc", kernel = "vanilladot", C = j, scaled = TRUE)))
  
  aScaledUp3 <- colSums(ModelScaledUp3@xmatrix[[1]] * ModelScaledUp3@coef[[1]])
  
  # calculate a0, a0 is -ModelScaledUp@b (intercept)
  a0ScaledUp3 <- -ModelScaledUp3@b
  
  
  
  # see what the model predicts with ksvm predict() function
  PredictFunctScaledUp3 <- suppressMessages(predict(ModelScaledUp3, CreditData[, 1:10]))
  
  # percent of testing observations that are correctly classified.
  AccuracySum3 <- sum(PredictFunctScaledUp3 == CreditData$V11) / nrow(CreditData)
  Accuracy3 <- append(Accuracy3, AccuracySum3)
  
  
  # Accuracy3 = sum(PredictFunctScaledUp1== CreditData$V11) / nrow(CreditData)
  SuppVects3 <- append(SuppVects3, ModelScaledUp3@nSV)
  ObjFunctVals3 <- append(ObjFunctVals3, ModelScaledUp3@obj)
  
  TrainErrors3 <- append(TrainErrors3, ModelScaledUp3@error)
  ConstC <- append(ConstC, j)

  cat("\n")
  cat("Final Step: Building SV Fluctuation Chart")
  cat("\n")
  cat("Accuracy:",percent(AccuracySum3))
  cat("\n")
  cat("Num of Support Vects:", ModelScaledUp3@nSV)
  cat("\n")
  cat("Const C:", j)
  cat("\n")
  cat("\n")
 
}
#plot(ConstC, SuppVects3)
plot(ConstC, SuppVects3,
     col = "midnightblue",
     pch = 1,
     cex = 1.5,
     xlab = "Constant C Value" ,
     ylab = "Number of Support Vectors",
     main = "SV Fluctuations, C=1-70 by 0.5,Vanilladot"
)
 
Accuracy3 <- round(Accuracy3, 4)
ObjFunctVals3 <- round(ObjFunctVals3, 2)
 

print("This super amazing R script has completed.  Thank you, please have a nice day and hey, be safe out there. ;)")
