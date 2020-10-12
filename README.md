
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
S3-ize the model objects, build tests and example data, and in general
make it a more properly-featured model package.

## Usage

The package is pretty easy to use\! Here’s a simple example:

``` r
library(tsforest)
data("LargeKitchenAppliances_TRAIN")
data("LargeKitchenAppliances_TEST")
model <- tsforest(LargeKitchenAppliances_TRAIN)
#> Training model with 26 intervals...
#> 1: Interval from 300 to 405
#> 2: Interval from 560 to 617
#> 3: Interval from 401 to 591
#> 4: Interval from 119 to 242
#> 5: Interval from 523 to 531
#> 6: Interval from 317 to 425
#> 7: Interval from 440 to 592
#> 8: Interval from 608 to 700
#> 9: Interval from 102 to 224
#> 10: Interval from 145 to 166
#> 11: Interval from 647 to 712
#> 12: Interval from 204 to 640
#> 13: Interval from 173 to 317
#> 14: Interval from 701 to 710
#> 15: Interval from 501 to 691
#> 16: Interval from 42 to 115
#> 17: Interval from 44 to 516
#> 18: Interval from 514 to 546
#> 19: Interval from 19 to 284
#> 20: Interval from 248 to 565
#> 21: Interval from 527 to 574
#> 22: Interval from 132 to 299
#> 23: Interval from 298 to 525
#> 24: Interval from 598 to 684
#> 25: Interval from 72 to 276
#> 26: Interval from 512 to 562
preds <- predict_tsforest(model, LargeKitchenAppliances_TEST)
#> 1: Interval from 300 to 405
#> 2: Interval from 560 to 617
#> 3: Interval from 401 to 591
#> 4: Interval from 119 to 242
#> 5: Interval from 523 to 531
#> 6: Interval from 317 to 425
#> 7: Interval from 440 to 592
#> 8: Interval from 608 to 700
#> 9: Interval from 102 to 224
#> 10: Interval from 145 to 166
#> 11: Interval from 647 to 712
#> 12: Interval from 204 to 640
#> 13: Interval from 173 to 317
#> 14: Interval from 701 to 710
#> 15: Interval from 501 to 691
#> 16: Interval from 42 to 115
#> 17: Interval from 44 to 516
#> 18: Interval from 514 to 546
#> 19: Interval from 19 to 284
#> 20: Interval from 248 to 565
#> 21: Interval from 527 to 574
#> 22: Interval from 132 to 299
#> 23: Interval from 298 to 525
#> 24: Interval from 598 to 684
#> 25: Interval from 72 to 276
#> 26: Interval from 512 to 562
table(preds$predictions, LargeKitchenAppliances_TEST$target)
#>    
#>      1  2  3
#>   1 71 30 30
#>   2 36 74 25
#>   3 18 21 70
```
