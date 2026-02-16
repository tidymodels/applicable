# A scoring function

A scoring function

## Usage

``` r
score(object, ...)

# Default S3 method
score(object, ...)
```

## Arguments

- object:

  Depending on the context:

  - A **data frame** of predictors.

  - A **matrix** of predictors.

  - A **recipe** specifying a set of preprocessing steps created from
    [`recipes::recipe()`](https://recipes.tidymodels.org/reference/recipe.html).

- ...:

  Not currently used, but required for extensibility.

## Value

A tibble of predictions.
