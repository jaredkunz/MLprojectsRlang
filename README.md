# MLprojectsRlang

**Project #001: How to Find a Good Classifier using Support Vector Machines**

**Two Exercises Using R Language and a credit card data set**

**Step One**: Download the data from the link below. **Step Two**. Run the code called "how_to_find_a_good_classifier.r" found in this repo.
The files credit_card_data.txt (without headers) and credit_card_data-headers.txt (with headers) contains a dataset with 654 data points, 6 continuous and 4 binary predictor variables.

It has anonymized credit card applications with a binary response variable (last column) indicating if the application was positive or negative. The dataset is the "Credit Approval Data Set" from the UCI Machine Learning Repository (https://archive.ics.uci.edu/ml/datasets/Credit+Approval) without the categorical variables and without data points that have missing values.

**Exercise Part One -** Using the support vector machine function ksvm contained in the R package kernlab, find a good classifier for this data. Show the equation of your classifier, and how well it classifies the data points in the full data set.

Hint: You might want to view the predictions your model makes; if C is too large or too small, they'll almost all be the same (all zero or all one) and the predictive value of the model will be poor. Even finding the right order of magnitude for C might take a little trial-and-error.

**Exercise Part Two -** Try other (nonlinear) kernels as well; they can sometimes be useful and might provide better predictions than vanilladot.
![image](https://user-images.githubusercontent.com/27638043/173225211-a4750a4a-b8bc-4636-bb9c-40d5c62fc3ce.png)
