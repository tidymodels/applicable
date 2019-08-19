
<!-- README.md is generated from README.Rmd. Please edit that file -->

# applicable

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/applicable)](https://cran.r-project.org/package=applicable)

[![Travis build status](https://travis-ci.org/tidymodels/applicable.svg?branch=master)](https://travis-ci.org/tidymodels/applicable)
<!-- badges: end -->

## Introduction

There are times when a model’s prediction should be taken with some
skepticism. For example, if a new data point is substantially different
from the training set, it’s predicted value may be suspect. In
chemistry, it is not uncommon to create an “applicability domain” model
that measures the amount of potential extrapolation new samples have
from the training set. applicable contains different methods to measure
how much a new data point is an extrapolation from the original data (if
at all).

## Installation

You can install the development version of applicable from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("tidymodels/applicable")
```

## Vignettes

To learn about how to use applicable, check out the vignettes:

  - `vignette("binary-data", "applicable")`: Learn different methods to
    analyze binary data.

  - `vignette("continuous-data", "applicable")`: Learn different methods
    to analyze continuous data.
