

Random Forest Learning on Weight Lifting Exercise Dataset
========================================================

Data Description
---------------------------

The Weight Lifting Exercise Dataset was collected from the Human Activity Recognition Project in Groupware@LES. (http://groupware.les.inf.puc-rio.br/har) In this study, six young health participants, who were wearing accaccelerometers on the belt, forearm, arm, and dumbell, were asked to perform one set of 10 repetitions of the Unilateral Dumbbell Biceps Curl in five different fashions. We want to investigate "how (well)" an activity was performed by the wearer. The manner they did the exercise (the "classe" variable in the dataset) is the outcome of interest. 159 features are given to help building the prediction algorithm.

Data Cleaning
----------------------

Before performing any analysis, we did some data cleaning in the first place. The following types of feature variables are excluded:
(1) Variables with missing values
(2) Identity and timestamp features
(3) Variables similar to constants
(4) Some variables that are highly correlated with other variables (threshold = 0.9).
After the data cleaning step, 45 features are left for further analysis.

Model
------------------

We use the Random Forest learning algorithm to build the model. Generally the steps are as follows. We  resample the training data, then rebuild classification or regression trees on each of the resampled data. When we split the data each time in a classification tree, we also resample the variables. A large number of trees are then built. We vote or average those trees in order to get the prediction for a new outcome. Random Forest method is highly accurate in many cases. However, it may counter several problems such as low speed and overfitting.

Cross Validation
---------------------

With regard to the potential overfitting problem of Random Forest, we will perform a 10-fold cross validation to perform recursive feature selection. We use 10, 20, 30 and 40 as the cadidate subset sizes. The algorithm is as follows:

1. Split the dataset into 10 dataset.  
2. Each time, 9/10 datasets are training data, 1/10 is testing. Do:  
   *Train the model on the training set using all predictors then predict the testing set  
   *Calculate the variable importance or rankings.  
   *For each subset size S(i), keep the S(i) most important variables, train the model on the training set using S(i) predictors, predict the testing set.  
3. Calculate the performance profile over the S(i) using test samples, determine the proper number of predictors.  
4. Estimate the final list of predictors to keep in the final model.  
5. Fit the final model based on the optimal S(i) using the original training set.

Here are the codes

```r
ctrl <- rfeControl(functions = rfFuncs, method = "cv", verbose = FALSE)
rffit <- rfe(all_dat_cleaned[,-ncol(all_dat_cleaned)], all_dat_cleaned$classe,
                 sizes = c(10, 20, 30, 40), rfeControl = ctrl)
```
  
Result
---------------------------

The output and first figure below show that the best subset size was estimated to be 40 predictors. The density plot showed the prediction accuracy for these variables in 10 cross validation iterations. The top 5 variables (out of 40) are yaw_belt, magnet_dumbbell_z, pitch_belt, magnet_dumbbell_y, pitch_forearm. The prediction accuracy based on cross validation result on the 40 predictors selected is 0.9964326. The out-of-sample error is 0.0035674.




```r
rffit
```

```

Recursive feature selection

Outer resampling method: Cross-Validated (10 fold) 

Resampling performance over subset size:

 Variables Accuracy Kappa AccuracySD KappaSD Selected
        10    0.989 0.986    0.00222 0.00281         
        20    0.995 0.993    0.00147 0.00185         
        30    0.996 0.995    0.00161 0.00203         
        40    0.996 0.995    0.00140 0.00177        *
        45    0.996 0.995    0.00146 0.00185         

The top 5 variables (out of 40):
   yaw_belt, magnet_dumbbell_z, pitch_belt, magnet_dumbbell_y, pitch_forearm
```

```r
(error <- (1 - subset(rffit$results, Variables==40)$Accuracy))
```

```
[1] 0.003567
```

```r
plot(rffit, type = c("g", "o"))
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-31.png) 

```r
densityplot(rffit)
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-32.png) 

Prediction
---------------------------------

We will use the bulit algorithm to predict the 20 test samples. Here is the result.

```r
predict(rffit$fit,test_dat_cleaned)
```

```
 1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 
 B  A  B  A  A  E  D  B  A  A  B  C  B  A  E  E  A  B  B  B 
Levels: A B C D E
```
