# Fit a `apd_pca`

`apd_pca()` fits a model.

## Usage

``` r
apd_pca(x, ...)

# Default S3 method
apd_pca(x, ...)

# S3 method for class 'data.frame'
apd_pca(x, threshold = 0.95, ...)

# S3 method for class 'matrix'
apd_pca(x, threshold = 0.95, ...)

# S3 method for class 'formula'
apd_pca(formula, data, threshold = 0.95, ...)

# S3 method for class 'recipe'
apd_pca(x, data, threshold = 0.95, ...)
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

- threshold:

  A number indicating the percentage of variance desired from the
  principal components. It must be a number greater than 0 and less or
  equal than 1.

- formula:

  A formula specifying the predictor terms on the right-hand side. No
  outcome should be specified.

- data:

  When a **recipe** or **formula** is used, `data` is specified as:

  - A **data frame** containing the predictors.

## Value

A `apd_pca` object.

## Details

The function computes the principal components that account for up to
either 95% or the provided `threshold` of variability. It also computes
the percentiles of the absolute value of the principal components.
Additionally, it calculates the mean of each principal component.

## Examples

``` r
predictors <- mtcars[, -1]

# Data frame interface
mod <- apd_pca(predictors)

# Formula interface
mod2 <- apd_pca(mpg ~ ., mtcars)

# Recipes interface
library(recipes)
rec <- recipe(mpg ~ ., mtcars)
rec <- step_log(rec, disp)
mod3 <- apd_pca(rec, mtcars)
```
