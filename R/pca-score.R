# -------------------------------------------------------------------
# ----------------- Model function implementation -------------------
# -------------------------------------------------------------------
score_ad_pca_numeric <- function(model, predictors) {
  if(!("pcs" %in% names(model)))
    rlang::abort("The model must contain a pcs argument.")
  stats::predict(model$pcs, predictors)
}

# -------------------------------------------------------------------
# ------------------- Model function bridge -------------------------
# -------------------------------------------------------------------
score_ad_pca_bridge <- function(type, model, predictors) {
  predictors <- as.matrix(predictors)

  score_function <- get_score_function(type)
  predictions <- as.data.frame(score_function(model, predictors))

  hardhat::validate_prediction_size(predictions, predictors)

  predictions
}

get_score_function <- function(type) {
  switch(
    type,
    numeric = score_ad_pca_numeric
  )
}

# -------------------------------------------------------------------
# ------------------ Model function interface -----------------------
# -------------------------------------------------------------------
#' Predict from a `ad_pca`
#'
#' @param object A `ad_pca` object.
#'
#' @param new_data A data frame or matrix of new predictors.
#'
#' @param type A single character. The type of predictions to generate.
#' Valid options are:
#'
#' - `"numeric"` for numeric predictions.
#'
#' @param ... Not used, but required for extensibility.
#'
#' @return
#'
#' A tibble of predictions. The number of rows in the tibble is guaranteed
#' to be the same as the number of rows in `new_data`.
#'
#' @examples
#' train <- mtcars[1:20,]
#' test <- mtcars[21:32, -1]
#'
#' # Fit
#' mod <- ad_pca(mpg ~ cyl + log(drat), train)
#'
#' # Predict, with preprocessing
#' score(mod, test)
#'
#' @export
score.ad_pca <- function(object, new_data, type = "numeric", ...) {
  forged <- hardhat::forge(new_data, object$blueprint)
  rlang::arg_match(type, valid_predict_types())
  score_ad_pca_bridge(type, object, forged$predictors)
}

valid_predict_types <- function() {
  c("numeric")
}

# -------------------------------------------------------------------
# -------------------- Generic score function -----------------------
# -------------------------------------------------------------------
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
  cls <- class(object)[1]
  message <-
    "`object` is not of a recognized type.
     Only data.frame, matrix, recipe, and formula objects are allowed.
     A {cls} was specified."
  message <- glue::glue(message)
  rlang::abort(message = message)
}
