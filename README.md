
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
data("LargeKitchenAppliances_TRAIN")
data("LargeKitchenAppliances_TEST")
model <- tsforest(LargeKitchenAppliances_TRAIN)
#> Training model with 26 intervals...
#> 1: Interval from 85 to 116
#> 2: Interval from 169 to 621
#> 3: Interval from 14 to 490
#> 4: Interval from 522 to 555
#> 5: Interval from 501 to 651
#> 6: Interval from 375 to 640
#> 7: Interval from 629 to 695
#> 8: Interval from 651 to 655
#> 9: Interval from 712 to 715
#> 10: Interval from 310 to 539
#> 11: Interval from 124 to 193
#> 12: Interval from 95 to 665
#> 13: Interval from 568 to 579
#> 14: Interval from 352 to 635
#> 15: Interval from 383 to 716
#> 16: Interval from 76 to 431
#> 17: Interval from 138 to 662
#> 18: Interval from 689 to 708
#> 19: Interval from 597 to 654
#> 20: Interval from 314 to 408
#> 21: Interval from 286 to 324
#> 22: Interval from 146 to 338
#> 23: Interval from 496 to 599
#> 24: Interval from 137 to 514
#> 25: Interval from 404 to 676
#> 26: Interval from 474 to 579
preds <- predict_tsforest(model, LargeKitchenAppliances_TEST)
#> 1: Interval from 85 to 116
#> 2: Interval from 169 to 621
#> 3: Interval from 14 to 490
#> 4: Interval from 522 to 555
#> 5: Interval from 501 to 651
#> 6: Interval from 375 to 640
#> 7: Interval from 629 to 695
#> 8: Interval from 651 to 655
#> 9: Interval from 712 to 715
#> 10: Interval from 310 to 539
#> 11: Interval from 124 to 193
#> 12: Interval from 95 to 665
#> 13: Interval from 568 to 579
#> 14: Interval from 352 to 635
#> 15: Interval from 383 to 716
#> 16: Interval from 76 to 431
#> 17: Interval from 138 to 662
#> 18: Interval from 689 to 708
#> 19: Interval from 597 to 654
#> 20: Interval from 314 to 408
#> 21: Interval from 286 to 324
#> 22: Interval from 146 to 338
#> 23: Interval from 496 to 599
#> 24: Interval from 137 to 514
#> 25: Interval from 404 to 676
#> 26: Interval from 474 to 579
table(preds$predictions, LargeKitchenAppliances_TEST$target)
#>    
#>      1  2  3
#>   1 73 31 29
#>   2 33 80 31
#>   3 19 14 65
```

There’s also a more experimental (and not at all theoretically
grounded\!) function that takes advantage of the fact that variables are
(partially) defined as intervals to plot the variable importance across
the time series interval. You can use any summary function, although sum
seems to work the best:

``` r
model <- tsforest(LargeKitchenAppliances_TRAIN, importance = 'permutation', verbose = FALSE)
intervalwise_variable_importance(model, summary_function = sum)
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />

You can also plot an individual example using the function, where the
example will be scaled correctly to the importance values:

``` r
intervalwise_variable_importance(model, summary_function = sum, optional_example_rownumber = 1)
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />
