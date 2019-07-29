# -----------------------------------------------------------------------------
# ---------------------- Model function implementation ------------------------
# -----------------------------------------------------------------------------

score_apd_pca_numeric <- function(model, predictors) {
  if(!("pcs" %in% names(model)))
    rlang::abort("The model must contain a pcs argument.")
  predicted_output <- stats::predict(model$pcs, predictors)

  diffs <- sweep(as.matrix(predicted_output), 2, model$pca_means)
  sq_diff <- diffs^2
  dists <- apply(sq_diff, 1, function(x) sqrt(sum(x)))

  tibble::as_tibble(
    cbind(
      predicted_output,
      dists
    )
  )
}

# -----------------------------------------------------------------------------
# ------------------------ Model function bridge ------------------------------
# -----------------------------------------------------------------------------

score_apd_pca_bridge <- function(type, model, predictors) {
  predictors <- as.matrix(predictors)

  score_function <- get_pca_score_function(type)
  predictions <- as.data.frame(score_function(model, predictors))

  hardhat::validate_prediction_size(predictions, predictors)

  predictions
}

get_pca_score_function <- function(type) {
  switch(
    type,
    numeric = score_apd_pca_numeric
  )
}

# -------------------------------------------------------------------
# ------------------ Model function interface -----------------------
# -------------------------------------------------------------------

#' Predict from a `apd_pca`
#'
#' @param object A `apd_pca` object.
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
#' mod <- apd_pca(mpg ~ cyl + log(drat), train)
#'
#' # Predict, with preprocessing
#' score(mod, test)
#'
#' @export
score.apd_pca <- function(object, new_data, type = "numeric", ...) {
  forged <- hardhat::forge(new_data, object$blueprint)
  rlang::arg_match(type, valid_predict_types())
  score_apd_pca_bridge(type, object, forged$predictors)
}

valid_predict_types <- function() {
  c("numeric")
}
