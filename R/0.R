score <- function (object, ...) {
  UseMethod("score")
}

#
score.default <- function(object, ...) {
  stop("`score()` is not implemented for an object of this class.", call. = FALSE)
}
