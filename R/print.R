#' @export
print.apd_pca <- function(x, ...) {
  predictors_count <- ncol(x$blueprint$ptypes$predictors)
  percentage <- x$threshold * 100
  num_comp <- x$num_comp

  print_output <- glue::glue(
  "# Predictors:
      {predictors_count}
   # Principal Components:
      The first {num_comp} principal components
      account for {percentage}% of the total variation
      in the predictors."
  )

 cat(print_output)

 invisible(x)
}
