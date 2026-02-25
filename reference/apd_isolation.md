# Fit an isolation forest to estimate an applicability domain.

`apd_isolation()` fits an isolation forest model.

## Usage

``` r
apd_isolation(x, ...)

# Default S3 method
apd_isolation(x, ...)

# S3 method for class 'data.frame'
apd_isolation(x, ...)

# S3 method for class 'matrix'
apd_isolation(x, ...)

# S3 method for class 'formula'
apd_isolation(formula, data, ...)

# S3 method for class 'recipe'
apd_isolation(x, data, ...)
```

## Arguments

- x:

  Depending on the context:

  - A **data frame** of predictors.

  - A **matrix** of predictors (see the `categ_cols` argument of
    [`isotree::isolation.forest()`](https://rdrr.io/pkg/isotree/man/isolation.forest.html)).

  - A **recipe** specifying a set of preprocessing steps created from
    [`recipes::recipe()`](https://recipes.tidymodels.org/reference/recipe.html).

- ...:

  Options to pass to
  [`isotree::isolation.forest()`](https://rdrr.io/pkg/isotree/man/isolation.forest.html).
  Options should not include `data`.

- formula:

  A formula specifying the predictor terms on the right-hand side. No
  outcome should be specified.

- data:

  When a **recipe** or **formula** is used, `data` is specified as:

  - A **data frame** containing the predictors.

## Value

A `apd_isolation` object.

## Details

In an isolation forest, splits are designed to isolate individual data
points. The tree construction process takes random split locations on
randomly selected predictors. As splits are made in the tree, the
algorithm tracks when data points are isolated as more splits are made.
The first points that are isolated are thought to be outliers or
anomalous. From these results, an anomaly score can be constructed.

This function creates an isolation forest on the training set and
measures the reference distribution of the scores when re-predicting the
training set. When scoring new data, the raw anomaly score is produced
along with the sample's corresponding percentile of the reference
distribution.

## References

Liu, Fei Tony, Kai Ming Ting, and Zhi-Hua Zhou. "Isolation forest." 2008
*Eighth IEEE International Conference on Data Mining. IEEE*, 2008. Liu,
Fei Tony, Kai Ming Ting, and Zhi-Hua Zhou. "Isolation-based anomaly
detection." *ACM Transactions on Knowledge Discovery from Data (TKDD)*
6.1 (2012): 3.

## Examples

``` r
if (FALSE) { # interactive()
if (rlang::is_installed(c("isotree", "modeldata"))) {
  library(dplyr)

  data(cells, package = "modeldata")

  cells_tr <- cells |> filter(case == "Train") |> select(-case, -class)
  cells_te <- cells |> filter(case != "Train") |> select(-case, -class)

  if_mod <- apd_isolation(cells_tr, ntrees = 10, nthreads = 1)
  if_mod
}
}
```
