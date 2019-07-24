#' @export
print.ad_pca <- function(x, ...) {
  eigs <- x$pcs$sdev^2
  cum_sum <- cumsum(eigs)/sum(eigs)
  ninety_five_prop_var <- sum(cum_sum <= 95) + 1
  predictors_count <- ncol(x$blueprint$ptypes$predictors)

  cat(
    "# Predictors:",
    predictors_count
  )

  cat("\n")

  cat("# Principal Components:",
      "The first",
      ninety_five_prop_var,
      "principal components account for 95% \n",
      "of the total variation in the predictors."
    )

  invisible(x)
}
