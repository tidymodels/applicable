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
  cls <- class(object)[1]
  message <-
    "`object` is not of a recognized type.
     Only data.frame, matrix, recipe, and formula objects are allowed.
     A {cls} was specified."
  message <- glue::glue(message)
  rlang::abort(message = message)
}
