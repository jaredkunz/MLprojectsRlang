# MLprojectsRlang

**Project #001: How to Find a Good Classifier using Support Vector Machines**

**Two Exercises Using R Language and a credit card data set**

**Step One**: Download the data from the link below. **Step Two**. Run the code called "how_to_find_a_good_classifier.r" found in this repo.
The files credit_card_data.txt (without headers) and credit_card_data-headers.txt (with headers) contain a dataset with 654 data points, 6 continuous and 4 binary predictor variables.

It has anonymized credit card applications with a binary response variable (last column) indicating if the application was positive or negative. The dataset is the "Credit Approval Data Set" from the UCI Machine Learning Repository (https://archive.ics.uci.edu/ml/datasets/Credit+Approval) without the categorical variables and without data points that have missing values.

**Exercise Part One -** Using the support vector machine function ksvm contained in the R package kernlab, find a good classifier for this data. Show the equation of your classifier, and how well it classifies the data points in the full data set.

Hint: You might want to view the predictions your model makes; if C is too large or too small, they'll almost all be the same (all zero or all one) and the predictive value of the model will be poor. Even finding the right order of magnitude for C might take a little trial-and-error.

The term λ we use with SVM as the trade off the two components of correctness and the margin is called C in ksvm. One of the challenges of this is to find a 
value of C that works well; for many values of C, almost all predictions will be “yes” or almost all predictions will be “no”. • ksvm does not directly return the coefficients a0 and a1…am. Instead, you need to do  the last step of the calculation yourself. 

**Exercise Part Two -** Try other (nonlinear) kernels as well; they can sometimes be useful and might provide better predictions than vanilladot.

For example, the equation for your classifier, i.e. the answer to Exercise Part one might be:

```r
> aScaledUp
>The equation is as follows:
          V1           V2           V3           V4           V5           V6           V7           V8           V9 
-0.004180985  0.004628256  0.014836154  0.093885681  0.569911183 -0.222436309  0.158114398 -0.001308316 -0.019636394 
         V10 
 0.105437302 
> a0ScaledUp
[1] -0.05105346
> 
> # Finding C aka the Margin, with this equation is basically sum(aScaledUp V1 to V10) + a0ScaledUp(-0.0511) = 0.6481975
> # So using this scaling approach, the Margin or C, a good Constant C Classifier between 0 and 1 is:
[1] 0.6481975
> 
> # see what the model predicts with ksvm predict() function
> PredictFunctScaledUp <- predict(ModelScaledUp, CreditData[, 1:10])
> 
> # percent of testing observations that are correctly classified.
> percent(sum(PredictFunctScaledUp == CreditData$V11) / nrow(CreditData))
[1] "86.39%"

```

```r
Using this Final Step: Building SV Fluctuation Chart
Accuracy: 86.39%
Num of Support Vects: 193
Const C: 43.5

# In summary, using svm with vanilladot to find a good classifier, i.e. the Constant C or Margin is somewhere around 43.5 or 64.9
```


Answer to Exercise Part Two might look like this type of visual:
![image](https://user-images.githubusercontent.com/27638043/173225211-a4750a4a-b8bc-4636-bb9c-40d5c62fc3ce.png)


