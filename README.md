
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tsforest

<!-- badges: start -->

<!-- badges: end -->

The goal of tsforest is to provide an R implementation of the Time
Series Forest classification algorithm described by Deng et al (2013)
and documented on timeseriesclassification.com. There’s another R
package that implements many of these, but its backend is in Java which
can cause some installation and running problems.

## Installation

You can install the the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("mattsq/tsforest")
```

This is still very much a work in progress\! Eventually I’d like to
S3-ize the model objects, build tests and more example data, and in
general make it a more properly-featured model package.

## Usage

The package is pretty easy to use\! Here’s a simple example:

``` r
library(tsforest)
data("FreezerRegularTrain_TRAIN")
data("FreezerRegularTrain_TEST")
model <- tsforest(FreezerRegularTrain_TRAIN, target = "target")
#> Training model with 17 intervals...
#> 1: Interval from 272 to 290
#> 2: Interval from 176 to 186
#> 3: Interval from 3 to 22
#> 4: Interval from 39 to 268
#> 5: Interval from 228 to 237
#> 6: Interval from 217 to 285
#> 7: Interval from 222 to 273
#> 8: Interval from 22 to 60
#> 9: Interval from 122 to 273
#> 10: Interval from 285 to 295
#> 11: Interval from 201 to 216
#> 12: Interval from 74 to 88
#> 13: Interval from 98 to 130
#> 14: Interval from 38 to 291
#> 15: Interval from 73 to 133
#> 16: Interval from 212 to 282
#> 17: Interval from 224 to 232
print(model)
#> Time series forest model converting time series of length: 301 
#> To length: 51 
#> Predicting on target class: target 
#> Includes underlying random forest model:
#> Ranger result
#> 
#> Call:
#>  ranger::ranger(form_for_pred, data = returned_object$featurized_df,      ...) 
#> 
#> Type:                             Classification 
#> Number of trees:                  500 
#> Sample size:                      150 
#> Number of independent variables:  51 
#> Mtry:                             7 
#> Target node size:                 1 
#> Variable importance mode:         none 
#> Splitrule:                        gini 
#> OOB prediction error:             0.00 %
```

Predictions use the standard S3 predict method, and return a vector of
predictions:

``` r
preds <- predict(model, FreezerRegularTrain_TEST)
#> Fitting new data to trained intervals:
#> 1: Interval from 272 to 290
#> 2: Interval from 176 to 186
#> 3: Interval from 3 to 22
#> 4: Interval from 39 to 268
#> 5: Interval from 228 to 237
#> 6: Interval from 217 to 285
#> 7: Interval from 222 to 273
#> 8: Interval from 22 to 60
#> 9: Interval from 122 to 273
#> 10: Interval from 285 to 295
#> 11: Interval from 201 to 216
#> 12: Interval from 74 to 88
#> 13: Interval from 98 to 130
#> 14: Interval from 38 to 291
#> 15: Interval from 73 to 133
#> 16: Interval from 212 to 282
#> 17: Interval from 224 to 232
table(preds$predictions, FreezerRegularTrain_TEST$target)
#>    
#>        1    2
#>   1 1417    3
#>   2    8 1422
```

There’s also a more experimental (and not at all theoretically
grounded\!) function that takes advantage of the fact that variables are
(partially) defined as intervals to plot the variable importance across
the time series interval. You can use any summary function, although sum
seems to work the best:

``` r
model <- tsforest(FreezerRegularTrain_TRAIN, 
                  importance = 'permutation', 
                  verbose = FALSE)
intervalwise_variable_importance(model, summary_function = sum)
```

<img src="man/figures/README-intervalwise_model_1-1.png" width="100%" />

You can also plot an individual example using the function, where the
example will be scaled correctly to the importance values:

``` r
intervalwise_variable_importance(model, 
                                 summary_function = sum, 
                                 optional_example_rownumber = 1)
```

<img src="man/figures/README-intervalwise_with_example-1.png" width="100%" />
