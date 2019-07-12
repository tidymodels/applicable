#' A scoring function
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
