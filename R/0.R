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
#' @export
score <- function (object, ...) {
  UseMethod("score")
}

#' @export
#' @export score.default
#' @rdname score
score.default <- function(object, ...) {
  stop("`score()` is not implemented for an object of this class.", call. = FALSE)
}
