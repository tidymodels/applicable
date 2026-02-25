# Fit a `apd_hat_values`

`apd_hat_values()` fits a model.

## Usage

``` r
apd_hat_values(x, ...)

# Default S3 method
apd_hat_values(x, ...)

# S3 method for class 'data.frame'
apd_hat_values(x, ...)

# S3 method for class 'matrix'
apd_hat_values(x, ...)

# S3 method for class 'formula'
apd_hat_values(formula, data, ...)

# S3 method for class 'recipe'
apd_hat_values(x, data, ...)
```

## Arguments

- x:

  Depending on the context:

  - A **data frame** of predictors.

  - A **matrix** of predictors.

  - A **recipe** specifying a set of preprocessing steps created from
    [`recipes::recipe()`](https://recipes.tidymodels.org/reference/recipe.html).

- ...:

  Not currently used, but required for extensibility.

- formula:

  A formula specifying the predictor terms on the right-hand side. No
  outcome should be specified.

- data:

  When a **recipe** or **formula** is used, `data` is specified as:

  - A **data frame** containing the predictors.

## Value

A `apd_hat_values` object.

## Examples

``` r
predictors <- mtcars[, -1]

# Data frame interface
mod <- apd_hat_values(predictors)

# Formula interface
mod2 <- apd_hat_values(mpg ~ ., mtcars)

# Recipes interface
library(recipes)
#> Loading required package: dplyr
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union
#> 
#> Attaching package: ‘recipes’
#> The following object is masked from ‘package:stats’:
#> 
#>     step
rec <- recipe(mpg ~ ., mtcars)
rec <- step_log(rec, disp)
mod3 <- apd_hat_values(rec, mtcars)
```
