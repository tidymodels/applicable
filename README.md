
<!-- README.md is generated from README.Rmd. Please edit that file -->

# applicable

<!-- badges: start -->

<!-- badges: end -->

## Introduction

There are times when a model’s prediction should be taken with some
skepticism. For example, if a new data point is substantially different
from the training set, it’s predicted value may be suspect. In
chemistry, it is not uncommon to create an “applicability domain” model
that measures the amount of potential extrapolation new samples have
from the training set. The applicable package will be used to
demonstrate different method to measure how much a new data point is an
extrapolation from the original data (if at all).

## Installation

You can install applicable from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("tidymodels/applicable")
```