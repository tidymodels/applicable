#' @export
print.apd_pca <- function(x, ...) {
  predictors_count <- ncol(x$blueprint$ptypes$predictors)
  percentage <- x$threshold * 100
  num_comp <- x$num_comp
  wording <- "components were"

  if(num_comp == 1)
    wording <- "component was"

  print_output <- glue::glue(
  "# Predictors:
      {predictors_count}
   # Principal Components:
      {num_comp} {wording} needed
      to capture at least {percentage}% of the
      total variation in the predictors."
  )

 cat(print_output)

 invisible(x)
}

#' @export
print.apd_similarity <- function(x, ...) {
  cat("Applicability domain via similarity\n")
  cat("Reference data were", ncol(x$ref_data), "variables collected on",
      nrow(x$ref_data), "data points.\n")
  if (!is.na(x$quantile)) {
    cat("New data summarized using the ", round(x$quantile * 100, 1),
        "th percentile.\n", sep = "")
  } else {
    cat("New data summarized using the mean.\n", sep = "")
  }
  invisible(x)
}
