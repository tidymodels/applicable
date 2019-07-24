#' @export
print.ad_pca <- function(x, ...) {
  #cat_line("something here")
  eigs <- x$pcs$sdev^2
  cum_sum <- cumsum(eigs)/sum(eigs)
  ninety_five_prop_var <- sum(cum_sum <= 95) + 1

  print(
    paste("The first",
           ninety_five_prop_var,
           "principal components account for 95%",
           "of the total variation in the predictors.")
        )
  print(x$pcs$rotation)

  invisible(x)
}
