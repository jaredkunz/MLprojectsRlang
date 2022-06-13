> ISYE 6501 - Homework Week 07 - Solutions - 10-07-2019 -- An OMSA Student

***Question 10.1***

***Using the same crime data set uscrime.txt as in Questions 8.2 and 9.1, find the best model you can using (a) a regression tree model, and (b) a random forest model. In R, you can use the tree package or the rpart package, and the randomForest package. For each model, describe one or two qualitative takeaways you get from analyzing the results (i.e., don't just stop when you have a good model, but interpret it too).***

***My Response to Q 10-1:***

To begin, I broke down the homework question

> **Step 1**: Using the crime data set, find the best model you can using
>
> **1a)** a regression tree model\* -
>
> **1b)** a random forest model\*\*
>
> You can use the tree package\* or the rpart package\* and the randomForest\*\* package.
>
> **Step 2:** For each model, describe one or two qualitative takeaways you get from analyzing the results (i.e., don't just stop when you have a good model, but interpret it too).
>
> **2a)** a regression tree model - one or two qualitative takeaways you get from analyzing the results
>
> **2b)** a random forest model - one or two qualitative takeaways you get from analyzing the results

**Step 1: find the best model you can using**

**1a) a regression tree model - You can use the tree package or the rpart package:**

I decided to use the tree package because it seems more intuitive to me than the rpart package. After some trial and error, I created the following unpruned tree using cross validation with a little more than a 50/50 split (.54 split) of the training and test data:

*crime_index = sample(1:nrow(crime_data), nrow(crime_data)\*.54)*

*crime_train = crime_data\[crime_index,\]*

*crime_test = crime_data\[-crime_index,\]*

![][1]

![][2]

*formula_C\_2s = Crime \~ M + So + Ed + Po2 + LF + M.F + Pop +NW + U1 + Wealth + Ineq + Prob + Time*

The predictors - response formula I used is based upon reading the data source website and my approach to remove data with "high collinearity", i.e. Per the user crime data source website:

> <http://www.statsci.org/data/general/uscrime.html>

"Only one of Po1 and Po2, and only one of U1 and U2, remain in the final regression, because of high collinearity."

This means to me, only Po1 or Po1 and U1 or U2 should remain in your regression. Based upon my analysis, I preferred to keep Po2 and U1 because Po2 appeared to provide a better initial unpruned tree for pruning and U2 didn't seem to have any visible effect on the tree structure. Here is some additional information about the unpruned tree:

\> rtree_model1

node), split, n, deviance, yval

\* denotes terminal node

1\) root 47 6881000 905.1

2\) Po2 \< 7.2 23 779200 669.6

4\) Pop \< 22.5 12 243800 550.5

8\) LF \< 0.5675 7 48520 466.9 \*

9\) LF \> 0.5675 5 77760 667.6 \*

5\) Pop \> 22.5 11 179500 799.5 \*

3\) Po2 \> 7.2 24 3604000 1131.0

6\) NW \< 7.65 10 557600 886.9

12\) Pop \< 21.5 5 146400 1049.0 \*

13\) Pop \> 21.5 5 147800 724.6 \*

7\) NW \> 7.65 14 2027000 1305.0

14\) Po2 \< 8.9 6 170800 1041.0 \*

15\) Po2 \> 8.9 8 1125000 1503.0 \*

Number of "leave" shown in the "frame" value:

\> rtree_model1\$frame

var n dev yval splits.cutleft splits.cutright

1 Po2 47 6880927.66 905.0851 \<7.2 \>7.2

2 Pop 23 779243.48 669.6087 \<22.5 \>22.5

4 LF 12 243811.00 550.5000 \<0.5675 \>0.5675

8 \<leaf\> 7 48518.86 466.8571

9 \<leaf\> 5 77757.20 667.6000

5 \<leaf\> 11 179470.73 799.5455

3 NW 24 3604162.50 1130.7500 \<7.65 \>7.65

6 Pop 10 557574.90 886.9000 \<21.5 \>21.5

12 \<leaf\> 5 146390.80 1049.2000

13 \<leaf\> 5 147771.20 724.6000

7 Po2 14 2027224.93 1304.9286 \<8.9 \>8.9

14 \<leaf\> 6 170828.00 1041.0000

15 \<leaf\> 8 1124984.88 1502.8750

The summary (below) provides "Residual mean of deviance". I found models with lower values for this but they were overfitting. This value was not too high and looked good based upon some trial and error of removing different predictors as well as adjusting the tree control values to get the right tree size, tree cuts etc.

> *t_ctrl = tree.control(nobs=nrow(crime_data), mincut = 5, minsize = 10, mindev = .009)*

\> summary(rtree_model1)

Regression tree:

tree(formula = formula_C\_2s, data = crime_data, na.action = na.pass,

control = t_ctrl)

Variables actually used in tree construction:

\[1\] \"Po2\" \"Pop\" \"LF\" \"NW\"

Number of terminal nodes: 7

Residual mean deviance: 47390 = 1896000 / 40

Distribution of residuals:

Min. 1st Qu. Median Mean 3rd Qu. Max.

-573.900 -98.300 -1.545 0.000 110.600 490.100

**Step 2: For each model, describe one or two qualitative takeaways you get from analyzing the results**

**2a) a regression tree model -**

I created some plots of the deviance at each note of the unpruned tree to see how it changed across the tree I saw that deviance is lowest around 4 or 5 nodes. I made a log(deviance) version of the plot as well to see how that looked (see next page).

![][3]![][4]

These deviance plots, along with this helpful site, <https://daviddalpiaz.github.io/r4sl/trees.html>, I followed the recommendation that "we can use cross-validation to select a good pruning of the tree":

> *plot(crime_treecv\$size, sqrt(crime_treecv\$dev / nrow(crime_train)), type = \"b\", xlab = \"Tree Size\", ylab = \"CV-RMSE\")*

![][5]

Based upon this above plot and my deviance plots, I picked 5 as the value for "best" when pruning the tree.

*rtree_model1_pruned = prune.tree(rtree_model1,best=5)*

The resulting tree looks pretty good and when I ran a prediction on it and created and "actual vs predicted" plot, the prediction and prediction line looked fairly good. Some "takeaways" are basically, more splits aren't better but neither are fewer. Finding "just the right" number of splits leads to a higher quality regression tree model.

![][6]![][7]

\> sqrt(summary(rtree_model1_pruned)\$dev / nrow(crime_train))

\[1\] 301.7727

\>

\> crime_test_prune_pred = predict(rtree_model1_pruned, newdata = crime_test)

\> rmse_prediction(crime_test_prune_pred, crime_test\$Crime)

\[1\] 247.2929

**Step 1: find the best model you can using**

**1b) a random forest model -- repeated basically the step 1 and step 2, but this time for random forest.**

After some trial and error, experimentation I found that number of trees at 168 would be a good number as it explains about 49% of variance and has a Mean of Squared Residuals of 75174

\> crime_rf

Call:

randomForest(formula = formula_A, data = crime_data, ntree = 168, mtry = num_pred_mtry, importance = TRUE)

Type of random forest: regression

Number of trees: 168

No. of variables tried at each split: 4

Mean of squared residuals: 75174.08

\% Var explained: 48.65

![][8]

**Step 2: For each model, describe one or two qualitative takeaways you get from analyzing the results**

**2b) a random forest model -**

Just looking at the number of trees and based upon my initial experiments with number of trees from 300 to 500, Mean of Squared Residuals and variance shows that a higher number of threes does not equate to a higher quality model. Also I tried removing some predictors and that impacted the quality of the model so I left them all in, although as the following "importance" of the predictors information shows, two of the predictors with the most collinearity are found to be very "important" or are found to have highest percent of Incoming MSE and Incoming Node Purity. So I'm not sure how much collinearity matters in Random Forest but I would think it should matter.

\> importance_df\[order(-importance_df\$\`%IncMSE\`),\]

%IncMSE IncNodePurity

Po1 7.2173552 1144282.65

Po2 6.1743593 1010652.09

Prob 4.5808406 915267.03

NW 4.0378630 525240.00

So 2.9637790 25499.18

M 2.7498859 171395.46

Ed 2.1987779 380436.34

Ineq 2.1602036 204632.87

Pop 2.1482340 407861.44

U2 1.6083328 234820.10

Time 0.8496660 245053.16

Wealth 0.7906889 705576.73

LF 0.7893884 365101.09

M.F -0.8444108 286071.99

U1 -1.4671012 125072.03

![][9]![][10]

Above are some charts showing the Out-of-bag results (left) and the prediction results.

***Question 10.2***

***Describe a situation or problem from your job, everyday life, current events, etc., for which a logistic regression model would be appropriate. List some (up to 5) predictors that you might use.***

Sports such as american football is good for logistic regression because it is good for problems when trying to find the probability of something happening, especially when there are only two possible outcomes such as win or loss in a game. Some predictors we might use are:

-   Points Scored

-   Pass Completions

-   Touchdowns

-   Home versus away

-   Penalties

> References (for Question 10.2)

<https://scholars.unh.edu/cgi/viewcontent.cgi?article=1472&context=honors>

***Question 10.3***

***1. Using the GermanCredit data set germancredit.txt from***

***[http://archive.ics.uci.edu/ml/machine-learning-databases/statlog/german /]***

***(description at <http://archive.ics.uci.edu/ml/datasets/Statlog+%28German+Credit+Data%29>), use logistic regression to find a good predictive model for whether credit applicants are good credit risks or not. Show your model (factors used and their coefficients), the software output, and the quality of fit. You can use the glm function in R. To get a logistic regression (logit) model on data where the response is either zero or one, use family=binomial(link="logit") in your glm function call.***

***2. Because the model gives a result between 0 and 1, it requires setting a threshold probability to separate between "good" and "bad" answers. In this data set, they estimate that incorrectly identifying a bad customer as good, is 5 times worse than incorrectly classifying a good customer as bad. Determine a good threshold probability based on your model.***

***My response to 10.3:***

1.  ***Show your model (factors used and their coefficients), the software output, and the quality of fit** (the info in the remainder of this document)*

2.  ***Determine a good threshold probability based on your model --** I believe 0.4 is a good threshold probability. It gives a confusion matrix result of 276 TN(True Negative), 96 TP(True Positive), and lower values for the false results, i.e. 71 FN, 57, FP. (False Negative, False Positive respectively)*

Call:

glm(formula = V21 \~ ., family = binomial(link = \"logit\"), data = gcredit_train)

Deviance Residuals:

Min 1Q Median 3Q Max

-2.2508 -0.6729 -0.3550 0.5668 2.8136

Coefficients:

Estimate Std. Error z value Pr(\>\|z\|)

(Intercept) 8.021e-01 1.701e+00 0.472 0.637206

V1A12 -1.800e-01 3.379e-01 -0.533 0.594170

V1A13 -6.185e-01 5.365e-01 -1.153 0.248953

V1A14 -1.634e+00 3.461e-01 -4.720 2.36e-06 \*\*\*

V2 5.885e-02 1.624e-02 3.623 0.000291 \*\*\*

V3A31 1.868e-01 8.143e-01 0.229 0.818564

V3A32 -9.914e-01 6.222e-01 -1.594 0.111031

V3A33 -2.463e+00 7.239e-01 -3.402 0.000669 \*\*\*

V3A34 -1.751e+00 6.325e-01 -2.769 0.005621 \*\*

V4A41 -1.625e+00 5.296e-01 -3.069 0.002150 \*\*

V4A410 -1.121e+00 1.301e+00 -0.861 0.389166

V4A42 -6.133e-01 3.783e-01 -1.621 0.104969

V4A43 -7.760e-01 3.710e-01 -2.092 0.036471 \*

V4A44 2.489e-01 1.231e+00 0.202 0.839702

V4A45 -4.735e-01 7.578e-01 -0.625 0.532070

V4A46 2.399e-01 7.187e-01 0.334 0.738485

V4A48 -1.576e+01 5.491e+02 -0.029 0.977111

V4A49 -1.258e+00 5.351e-01 -2.351 0.018746 \*

V5 -3.798e-05 7.887e-05 -0.481 0.630190

V6A62 -5.063e-01 4.498e-01 -1.126 0.260366

V6A63 -1.638e-01 5.598e-01 -0.293 0.769776

V6A64 -1.394e+00 7.047e-01 -1.978 0.047959 \*

V6A65 -8.356e-01 3.886e-01 -2.150 0.031554 \*

V7A72 -1.693e-01 5.754e-01 -0.294 0.768640

V7A73 -6.862e-02 5.550e-01 -0.124 0.901604

V7A74 -8.282e-01 6.183e-01 -1.340 0.180407

V7A75 -4.887e-01 5.806e-01 -0.842 0.399972

V8 3.486e-01 1.366e-01 2.552 0.010711 \*

V9A92 -8.326e-02 5.892e-01 -0.141 0.887634

V9A93 -6.667e-01 5.817e-01 -1.146 0.251722

V9A94 5.302e-02 7.049e-01 0.075 0.940039

V10A102 3.645e-01 5.923e-01 0.615 0.538285

V10A103 -8.303e-01 5.894e-01 -1.409 0.158911

V11 8.824e-02 1.302e-01 0.678 0.498048

V12A122 2.587e-01 3.655e-01 0.708 0.479044

V12A123 -1.434e-01 3.582e-01 -0.400 0.688913

V12A124 1.527e+00 7.286e-01 2.095 0.036140 \*

V13 -3.063e-02 1.408e-02 -2.175 0.029637 \*

V14A142 3.599e-01 6.268e-01 0.574 0.565823

V14A143 -7.026e-01 3.832e-01 -1.833 0.066732 .

V15A152 -4.493e-01 3.593e-01 -1.251 0.211081

V15A153 -1.694e+00 7.840e-01 -2.161 0.030718 \*

V16 5.347e-01 3.151e-01 1.697 0.089718 .

V17A172 1.920e-01 9.216e-01 0.208 0.834929

V17A173 1.421e-01 8.769e-01 0.162 0.871268

V17A174 -1.231e-01 8.943e-01 -0.138 0.890534

V18 3.031e-01 3.855e-01 0.786 0.431693

V19A192 -1.659e-01 2.880e-01 -0.576 0.564470

V20A202 -2.356e+00 1.135e+00 -2.075 0.037966 \*

\-\--

Signif. codes: 0 '\*\*\*' 0.001 '\*\*' 0.01 '\*' 0.05 '.' 0.1 ' ' 1

(Dispersion parameter for binomial family taken to be 1)

Null deviance: 605.69 on 499 degrees of freedom

Residual deviance: 425.26 on 451 degrees of freedom

AIC: 523.26

Number of Fisher Scoring iterations: 14

![][11]

AUC is provides a "quick and dirty" estimate of model quality. Confusion matrix provides a better assessment.

Call:

roc.default(response = gcredit_test\$V21, predictor = round(probability))

Data: round(probability) in 347 controls (gcredit_test\$V21 0) \< 153 cases (gcredit_test\$V21 1).

Area under the curve: 0.6724

![][12]![][13]

***Determine a good threshold probability based on your model.***

1.  \[1\] 0.4

2.  prob_threshold Var2 Freq

3.  1 0 0 276

4.  2 1 0 71

5.  3 0 1 57

6.  4 1 1 96

I used a for loop to iterate through the sequence of thresholds to see which produced the best confusion matrices. Here are the results

\> probability \<- predict(gcredit_model1, newdata = gcredit_test, type = \"response\")

\> roc_1 \<- roc(gcredit_test\$V21, round(probability))

\> roc_1

\> threshold \<- seq(from = .1, to = 1, by = .1)

\>

\> for (i in threshold) {

\+ prob_threshold \<- as.integer(probability \> i)

\+

\+ conf_matrix \<- as.data.frame(table(prob_threshold, gcredit_test\$V21))

\+ conf_matrix

\+ print(i)

\+ print(conf_matrix)

\+ }

\[1\] 0.1

prob_threshold Var2 Freq

1 0 0 145

2 1 0 202

3 0 1 23

4 1 1 130

\[1\] 0.2

prob_threshold Var2 Freq

1 0 0 203

2 1 0 144

3 0 1 29

4 1 1 124

\[1\] 0.3

prob_threshold Var2 Freq

1 0 0 242

2 1 0 105

3 0 1 36

4 1 1 117

\[1\] 0.4

prob_threshold Var2 Freq

1 0 0 276

2 1 0 71

3 0 1 57

4 1 1 96

\[1\] 0.5

prob_threshold Var2 Freq

1 0 0 292

2 1 0 55

3 0 1 76

4 1 1 77

\[1\] 0.6

prob_threshold Var2 Freq

1 0 0 308

2 1 0 39

3 0 1 97

4 1 1 56

\[1\] 0.7

prob_threshold Var2 Freq

1 0 0 323

2 1 0 24

3 0 1 104

4 1 1 49

\[1\] 0.8

prob_threshold Var2 Freq

1 0 0 338

2 1 0 9

3 0 1 123

4 1 1 30

\[1\] 0.9

prob_threshold Var2 Freq

1 0 0 343

2 1 0 4

3 0 1 141

4 1 1 12

> **[References:]{.underline}**

I used this textbook to help me understand the structure of the tree: <http://faculty.marshall.usc.edu/gareth-james/ISL/ISLR%20Seventh%20Printing.pdf>

<https://daviddalpiaz.github.io/r4sl/trees.html>

  [1]: media/image1.png {width="4.21307195975503in" height="0.4723184601924759in"}
  [2]: media/image2.png {width="3.75298665791776in" height="2.8852230971128607in"}
  [3]: media/image3.png {width="2.9199332895888013in" height="2.214132764654418in"}
  [4]: media/image4.png {width="2.9301498250218723in" height="2.237496719160105in"}
  [5]: media/image5.png {width="3.5453849518810148in" height="2.3077154418197727in"}
  [6]: media/image6.png {width="3.3121773840769904in" height="2.4370702099737533in"}
  [7]: media/image7.png {width="3.3967279090113736in" height="2.2946609798775155in"}
  [8]: media/image8.png {width="3.448284120734908in" height="2.6821161417322834in"}
  [9]: media/image9.png {width="2.8495833333333334in" height="2.0349168853893262in"}
  [10]: media/image10.png {width="2.8692311898512686in" height="2.070071084864392in"}
  [http://archive.ics.uci.edu/ml/machine-learning-databases/statlog/german /]: http://archive.ics.uci.edu/ml/machine-learning-databases/statlog/german%20/
  [11]: media/image11.png {width="4.084359142607174in" height="3.089997812773403in"}
  [12]: media/image12.png {width="3.218672353455818in" height="2.4245756780402448in"}
  [13]: media/image13.png {width="3.1869389763779528in" height="2.304400699912511in"}
