# Predict from a `apd_isolation`

Predict from a `apd_isolation`

## Usage

``` r
# S3 method for class 'apd_isolation'
score(object, new_data, type = "numeric", ...)
```

## Arguments

- object:

  A `apd_isolation` object.

- new_data:

  A data frame or matrix of new samples.

- type:

  A single character. The type of predictions to generate. Valid options
  are:

  - `"numeric"` for numeric predictions.

- ...:

  Not used, but required for extensibility.

## Value

A tibble of predictions. The number of rows in the tibble is guaranteed
to be the same as the number of rows in `new_data`. The `score` column
is the raw prediction from
[`isotree::predict.isolation_forest()`](https://rdrr.io/pkg/isotree/man/predict.isolation_forest.html)
while `score_pctl` compares this value to the reference distribution of
the score created by predicting the training set. A value of *X* means
that *X* percent of the training data have scores less than the
predicted value.

## Details

About the score

## See also

[`apd_isolation()`](https://applicable.tidymodels.org/reference/apd_isolation.md)

## Examples

``` r
if (FALSE) { # interactive()
if (rlang::is_installed(c("isotree", "modeldata"))) {
  library(dplyr)

  data(cells, package = "modeldata")

  cells_tr <- cells |> filter(case == "Train") |> select(-case, -class)
  cells_te <- cells |> filter(case != "Train") |> select(-case, -class)

  if_mod <- apd_isolation(cells_tr, ntrees = 10, nthreads = 1)
  score(if_mod, cells_te)
}
}
```
