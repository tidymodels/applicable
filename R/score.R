# -----------------------------------------------------------------------------
# ---------------------- Model fit generic interface --------------------------
# -----------------------------------------------------------------------------

#' A scoring function
#'
#' @param object Depending on the context:
#'
#'   * A __data frame__ of predictors.
#'   * A __matrix__ of predictors.
#'   * A __recipe__ specifying a set of preprocessing steps
#'     created from [recipes::recipe()].
#'
#' @param ... Not currently used, but required for extensibility.
#'
#' @return
#'
#' A tibble of predictions.
#'
#' @export
score <- function(object, ...) {
  UseMethod("score")
}

#' @export
#' @export score.default
#' @rdname score
score.default <- function(object, ...) {
  cli::cli_abort(c(
    "`object` is not of a recognized type.",
    "i", "Only data.frame, matrix, recipe, and formula objects are allowed.",
    "i", "A {class(object)[1]} was specified."
  ))
}
