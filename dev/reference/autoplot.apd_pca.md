# Plot the distribution function for pcas

Plot the distribution function for pcas

## Usage

``` r
# S3 method for class 'apd_pca'
autoplot(object, ...)
```

## Arguments

- object:

  An object produced by `apd_pca`.

- ...:

  An optional set of `dplyr` selectors, such as
  [`dplyr::matches()`](https://tidyselect.r-lib.org/reference/starts_with.html)
  or
  [`dplyr::starts_with()`](https://tidyselect.r-lib.org/reference/starts_with.html)
  for selecting which variables should be shown in the plot.

## Value

A `ggplot` object that shows the distribution function for each
principal component.

## Examples

``` r
library(ggplot2)
library(dplyr)
library(modeldata)
#> 
#> Attaching package: ‘modeldata’
#> The following object is masked from ‘package:datasets’:
#> 
#>     penguins
data(biomass)

biomass_ad <- apd_pca(biomass[, 3:8])

autoplot(biomass_ad)

# Using selectors in `...`
autoplot(biomass_ad, distance) + scale_x_log10()

autoplot(biomass_ad, matches("PC[1-2]"))
```
