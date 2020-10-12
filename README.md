
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
