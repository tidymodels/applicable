# Predict from a `apd_pca`

Predict from a `apd_pca`

## Usage

``` r
# S3 method for class 'apd_pca'
score(object, new_data, type = "numeric", ...)
```

## Arguments

- object:

  A `apd_pca` object.

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
to be the same as the number of rows in `new_data`.

## Details

The function computes the principal components of the new data and their
percentiles as compared to the training data. The number of principal
components computed depends on the `threshold` given at fit time. It
also computes the multivariate distance between each principal component
and its mean.

## Examples

``` r
train <- mtcars[1:20, ]
test <- mtcars[21:32, -1]

# Fit
mod <- apd_pca(mpg ~ cyl + log(drat), train)

# Predict, with preprocessing
score(mod, test)
#> Warning: collapsing to unique 'x' values
#> Warning: collapsing to unique 'x' values
#> Warning: collapsing to unique 'x' values
#> # A tibble: 12 × 6
#>       PC1     PC2 distance PC1_pctl PC2_pctl distance_pctl
#>     <dbl>   <dbl>    <dbl>    <dbl>    <dbl>         <dbl>
#>  1 -1.16   0.664     1.34      42.9    87.6           43.0
#>  2  1.84   0.345     1.87      95.3    42.2           95.4
#>  3  1.23  -0.259     1.26      47.3    36.7           36.8
#>  4  0.461 -1.03      1.13       0      98.5           25.5
#>  5  1.34  -0.157     1.35      52.5    27.4           44.7
#>  6 -1.61   0.217     1.62      89.2    31.7           89.3
#>  7 -1.98  -0.159     1.99      96.4    27.5           96.2
#>  8 -1.25   0.579     1.37      48.0    82.0           59.1
#>  9 -0.103 -1.60      1.60       0       1             87.3
#> 10 -0.231 -0.0655    0.241      0       6.76           0  
#> 11  0.700 -0.793     1.06      22.4    96.0           24.4
#> 12 -1.64   0.184     1.65      90.6    29.2           90.6
```
