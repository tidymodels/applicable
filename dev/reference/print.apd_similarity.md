# Print number of predictors and principal components used.

Print number of predictors and principal components used.

## Usage

``` r
# S3 method for class 'apd_similarity'
print(x, ...)
```

## Arguments

- x:

  A `apd_similarity` object.

- ...:

  Not currently used, but required for extensibility.

## Value

None

## Examples

``` r
set.seed(535)
tr_x <- matrix(
  sample(0:1, size = 20 * 50, prob = rep(.5, 2), replace = TRUE),
  ncol = 20
)
model <- apd_similarity(tr_x)
print(model)
#> Applicability domain via similarity
#> Reference data were 20 variables collected on 50 data points.
#> New data summarized using the mean.
```
