Project #002 Regression Trees and Random Forests
Using the crime data set uscrime.txt, http://www.statsci.org/data/general/uscrime.html find the best model you can using  (a) a regression tree model, and  (b) a random forest model.   In R, you can use the tree package or the rpart package, and the randomForest package.  For each model, describe one or two qualitative takeaways you get from analyzing the results (i.e., don’t just stop when you have a good model, but interpret it too). 

To begin, break down the above question  
Step 1:  Using the crime data set, find the best model you can using
1a) a regression tree model* -   
1b) a random forest model**
Step 2: For each model, describe one or two qualitative takeaways you get from analyzing the results (i.e., don’t just stop when you have a good model, but interpret it too).
2a) a regression tree model - one or two qualitative takeaways you get from analyzing the results
2b) a random forest model - one or two qualitative takeaways you get from analyzing the results

Step 1:  find the best model you can using
1a) a regression tree model -    You can use the tree package or the rpart package:
I decided to use the tree package because it seems more intuitive to me than the rpart package.  After some trial and error, I created the following unpruned tree using cross validation with a little more than a 50/50 split (.54 split) of the training and test data:
```r
crime_index = sample(1:nrow(crime_data), nrow(crime_data)*.54)
crime_train = crime_data[crime_index,]
crime_test = crime_data[-crime_index,]```
 
formula_C_2s = Crime ~ M + So + Ed +       Po2 + LF + M.F + Pop +NW + U1      + Wealth + Ineq + Prob + Time
The predictors - response formula I used is based upon reading the data source website and my approach to remove data with “high collinearity”, i.e. Per the user crime data source website: 
http://www.statsci.org/data/general/uscrime.html
“Only one of Po1 and Po2, and only one of U1 and U2, remain in the final regression, because of high collinearity.” 
This means to me, only Po1 or Po1 and U1 or U2 should remain in your regression.  Based upon my analysis, I preferred to keep Po2 and U1 because Po2 appeared to provide a better initial unpruned tree for pruning and U2 didn’t seem to have any visible effect on the tree structure. Here is some additional information about the unpruned tree:
```r
> rtree_model1 
node), split, n, deviance, yval
      * denotes terminal node

 1) root 47 6881000  905.1  
   2) Po2 < 7.2 23  779200  669.6  
     4) Pop < 22.5 12  243800  550.5  
       8) LF < 0.5675 7   48520  466.9 *
       9) LF > 0.5675 5   77760  667.6 *
     5) Pop > 22.5 11  179500  799.5 *
   3) Po2 > 7.2 24 3604000 1131.0  
     6) NW < 7.65 10  557600  886.9  
      12) Pop < 21.5 5  146400 1049.0 *
      13) Pop > 21.5 5  147800  724.6 *
     7) NW > 7.65 14 2027000 1305.0  
      14) Po2 < 8.9 6  170800 1041.0 *
      15) Po2 > 8.9 8 1125000 1503.0 *```

Number of “leave” shown in the “frame” value:
```r
> rtree_model1$frame
      var  n        dev      yval splits.cutleft splits.cutright
1     Po2 47 6880927.66  905.0851           <7.2            >7.2
2     Pop 23  779243.48  669.6087          <22.5           >22.5
4      LF 12  243811.00  550.5000        <0.5675         >0.5675
8  <leaf>  7   48518.86  466.8571                               
9  <leaf>  5   77757.20  667.6000                               
5  <leaf> 11  179470.73  799.5455                               
3      NW 24 3604162.50 1130.7500          <7.65           >7.65
6     Pop 10  557574.90  886.9000          <21.5           >21.5
12 <leaf>  5  146390.80 1049.2000                               
13 <leaf>  5  147771.20  724.6000                               
7     Po2 14 2027224.93 1304.9286           <8.9            >8.9
14 <leaf>  6  170828.00 1041.0000                               
15 <leaf>  8 1124984.88 1502.8750                
```
The summary (below) provides “Residual mean of deviance”.  I found models with lower values for this but they were overfitting.  This value was not too high and looked good based upon some trial and error of removing different predictors as well as adjusting the tree control values to get the right tree size, tree cuts etc.
t_ctrl = tree.control(nobs=nrow(crime_data), mincut = 5, minsize = 10, mindev = .009)
```r
> summary(rtree_model1)

Regression tree:
tree(formula = formula_C_2s, data = crime_data, na.action = na.pass, 
    control = t_ctrl)
Variables actually used in tree construction:
[1] "Po2" "Pop" "LF"  "NW" 
Number of terminal nodes:  7 
Residual mean deviance:  47390 = 1896000 / 40 
Distribution of residuals:
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
-573.900  -98.300   -1.545    0.000  110.600  490.100 ```

Step 2: For each model, describe one or two qualitative takeaways you get from analyzing the results 
2a) a regression tree model -  

I created some plots of the deviance at each note of the unpruned tree to see how it changed across the tree I saw that deviance is lowest around 4 or 5 nodes.  I made a log(deviance) version of the plot as well to see how that looked (see next page).


  

These deviance plots, along with this helpful site, https://daviddalpiaz.github.io/r4sl/trees.html, I followed the recommendation that “we can use cross-validation to select a good pruning of the tree”:
plot(crime_treecv$size, sqrt(crime_treecv$dev / nrow(crime_train)), type = "b",  xlab = "Tree Size", ylab = "CV-RMSE")
 

Based upon this above plot and my deviance plots, I picked 5 as the value for “best” when pruning the tree.  
rtree_model1_pruned = prune.tree(rtree_model1,best=5)
The resulting tree looks pretty good and when I ran a prediction on it and created and “actual vs predicted” plot, the prediction and prediction line looked fairly good.  Some “takeaways” are basically, more splits aren’t better but neither are fewer.  Finding “just the right” number of splits leads to a higher quality regression tree model.

  
> sqrt(summary(rtree_model1_pruned)$dev / nrow(crime_train))
[1] 301.7727
> 
> crime_test_prune_pred = predict(rtree_model1_pruned, newdata = crime_test)
> rmse_prediction(crime_test_prune_pred, crime_test$Crime)
[1] 247.2929

Step 1:  find the best model you can using
1b) a random forest model – repeated basically the step 1 and step 2, but this time for random forest.
After some trial and error, experimentation I found that number of trees at 168 would be a good number as it explains about 49% of variance and has a Mean of Squared Residuals of 75174
> crime_rf

Call:
 randomForest(formula = formula_A, data = crime_data, ntree = 168,      mtry = num_pred_mtry, importance = TRUE) 
               Type of random forest: regression
                     Number of trees: 168
No. of variables tried at each split: 4

          Mean of squared residuals: 75174.08
                    % Var explained: 48.65


 
Step 2: For each model, describe one or two qualitative takeaways you get from analyzing the results 
2b) a random forest model -  
Just looking at the number of trees and based upon my initial experiments with number of trees from 300 to 500, Mean of Squared Residuals and variance shows that a higher number of threes does not equate to a higher quality model.  Also I tried removing some predictors and that impacted the quality of the model so I left them all in, although as the following “importance” of the predictors information shows, two of the predictors with the most collinearity are found to be very “important” or are found to have highest percent of Incoming MSE and Incoming Node Purity.  So I’m not sure how much collinearity matters in Random Forest but I would think it should matter.

> importance_df[order(-importance_df$`%IncMSE`),] 
          %IncMSE IncNodePurity
Po1     7.2173552    1144282.65
Po2     6.1743593    1010652.09
Prob    4.5808406     915267.03
NW      4.0378630     525240.00
So      2.9637790      25499.18
M       2.7498859     171395.46
Ed      2.1987779     380436.34
Ineq    2.1602036     204632.87
Pop     2.1482340     407861.44
U2      1.6083328     234820.10
Time    0.8496660     245053.16
Wealth  0.7906889     705576.73
LF      0.7893884     365101.09
M.F    -0.8444108     286071.99
U1     -1.4671012     125072.03
  
Above are some charts showing the Out-of-bag results (left) and the prediction results.

