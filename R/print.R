#' @export
print.ad_pca <- function(x, ...) {
  eigs <- x$pcs$sdev^2
  cum_sum <- cumsum(eigs)/sum(eigs)
  ninety_five_prop_var <- sum(cum_sum <= 95) + 1
  predictors_count <- ncol(x$blueprint$ptypes$predictors)

  print_output <- glue::glue(
  "# Predictors: {predictors_count}
   # Principal Components: The first {ninety_five_prop_var} principal components
   account for 95% of the total variation in the predictors."
  )

  cat(print_output)

  invisible(x)
}
