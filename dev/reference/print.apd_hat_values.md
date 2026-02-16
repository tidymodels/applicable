# Print number of predictors and principal components used.

Print number of predictors and principal components used.

## Usage

``` r
# S3 method for class 'apd_hat_values'
print(x, ...)
```

## Arguments

- x:

  A `apd_hat_values` object.

- ...:

  Not currently used, but required for extensibility.

## Value

None

## Examples

``` r
model <- apd_hat_values(~ Sepal.Length + Sepal.Width, iris)
print(model)
#> # Predictors:
#> 2
```
