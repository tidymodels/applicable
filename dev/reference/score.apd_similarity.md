# Score new samples using similarity methods

Score new samples using similarity methods

## Usage

``` r
# S3 method for class 'apd_similarity'
score(object, new_data, type = "numeric", add_percentile = TRUE, ...)
```

## Arguments

- object:

  A `apd_similarity` object.

- new_data:

  A data frame or matrix of new predictors.

- type:

  A single character. The type of predictions to generate. Valid options
  are:

  - `"numeric"` for a numeric value that summarizes the similarity
    values for each sample across the training set.

- add_percentile:

  A single logical; should the percentile of the similarity score
  *relative to the training set values* by computed?

- ...:

  Not used, but required for extensibility.

## Value

A tibble of predictions. The number of rows in the tibble is guaranteed
to be the same as the number of rows in `new_data`. For
`type = "numeric"`, the tibble contains a column called "similarity". If
`add_percentile = TRUE`, an additional column called `similarity_pctl`
will be added. These values are in percent units so that a value of 11.5
indicates that, in the training set, 11.5 percent of the training set
samples had smaller values than the sample being scored.

## Examples

``` r
# \donttest{
data(qsar_binary)

jacc_sim <- apd_similarity(binary_tr)

mean_sim <- score(jacc_sim, new_data = binary_unk)
mean_sim
#> # A tibble: 5 × 2
#>   similarity similarity_pctl
#>        <dbl>           <dbl>
#> 1     0.376            49.8 
#> 2     0.284            13.5 
#> 3     0.218             6.46
#> 4     0.452           100   
#> 5     0.0971            5.59
# }
```
