# Score new samples using hat values

Score new samples using hat values

## Usage

``` r
# S3 method for class 'apd_hat_values'
score(object, new_data, type = "numeric", ...)
```

## Arguments

- object:

  A `apd_hat_values` object.

- new_data:

  A data frame or matrix of new predictors.

- type:

  A single character. The type of predictions to generate. Valid options
  are:

  - `"numeric"` for a numeric value that summarizes the hat values for
    each sample across the training set.

- ...:

  Not used, but required for extensibility.

## Value

A tibble of predictions. The number of rows in the tibble is guaranteed
to be the same as the number of rows in `new_data`. For
`type = "numeric"`, the tibble contains two columns `hat_values` and
`hat_values_pctls`. The column `hat_values_pctls` is in percent units so
that a value of 11.5 indicates that, in the training set, 11.5 percent
of the training set samples had smaller values than the sample being
scored.

## Examples

``` r
train_data <- mtcars[1:20, ]
test_data <- mtcars[21:32, ]

hat_values_model <- apd_hat_values(train_data)

hat_values_scoring <- score(hat_values_model, new_data = test_data)
hat_values_scoring
#> # A tibble: 12 × 2
#>    hat_values hat_values_pctls
#>         <dbl>            <dbl>
#>  1      1.45              1   
#>  2      0.852            90.0 
#>  3      1.13              1   
#>  4      1.19              1   
#>  5      0.901            93.2 
#>  6      0.335             6.34
#>  7      5.41              1   
#>  8      5.91              1   
#>  9      8.19              1   
#> 10      5.11              1   
#> 11     12.4               1   
#> 12      0.960             1   
```
