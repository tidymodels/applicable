# Plot the cumulative distribution function for similarity metrics

Plot the cumulative distribution function for similarity metrics

## Usage

``` r
# S3 method for class 'apd_similarity'
autoplot(object, ...)
```

## Arguments

- object:

  An object produced by `apd_similarity`.

- ...:

  Not currently used.

## Value

A `ggplot` object that shows the cumulative probability versus the
unique similarity values in the training set. Not that for large
samples, this is an approximation based on a random sample of 5,000
training set points.

## Examples

``` r
set.seed(535)
tr_x <- matrix(
  sample(0:1, size = 20 * 50, prob = rep(.5, 2), replace = TRUE),
  ncol = 20
)
model <- apd_similarity(tr_x)
```
