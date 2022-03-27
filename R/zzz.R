# nocov start
# takes after https://raw.githubusercontent.com/r-lib/vctrs/master/R/zzz.R
.onLoad <- function(libname, pkgname) {
  s3_register("ggplot2::autoplot", "apd_similarity")
  s3_register("ggplot2::autoplot", "apd_pca")
}

# nocov end
