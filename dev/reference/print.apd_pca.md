# Print number of predictors and principal components used.

Print number of predictors and principal components used.

## Usage

``` r
# S3 method for class 'apd_pca'
print(x, ...)
```

## Arguments

- x:

  A `apd_pca` object.

- ...:

  Not currently used, but required for extensibility.

## Value

None

## Examples

``` r
model <- apd_pca(~ Sepal.Length + Sepal.Width, iris)
print(model)
#> # Predictors:
#>    2
#> # Principal Components:
#>    2 components were needed
#>    to capture at least 95% of the
#>    total variation in the predictors.
```
