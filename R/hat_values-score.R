# -----------------------------------------------------------------------------
# ---------------------- Model function implementation ------------------------
# -----------------------------------------------------------------------------

score_apd_hat_values_numeric <- function(model, predictors) {
  if(!("XtX_inv" %in% names(model)))
    rlang::abort("The model must contain an XtX_inv argument.")

  proj_matrix <- predictors %*% model$XtX_inv %*% t(predictors)
  hat_values <- diag(proj_matrix)

  tibble::as_tibble(
    cbind(
      hat_values
    )
  )
}

# -----------------------------------------------------------------------------
# ------------------------ Model function bridge ------------------------------
# -----------------------------------------------------------------------------

score_apd_hat_values_bridge <- function(type, model, predictors) {
  predictors <- as.matrix(predictors)

  score_function <- get_hat_values_score_function(type)
  predictions <- score_function(model, predictors)

  hardhat::validate_prediction_size(predictions, predictors)

  predictions
}

get_hat_values_score_function <- function(type) {
  switch(
    type,
    numeric = score_apd_hat_values_numeric
  )
}

# -----------------------------------------------------------------------------
# ----------------------- Model function interface ----------------------------
# -----------------------------------------------------------------------------

#' Predict from a `apd_hat_values`
#'
#' @param object A `apd_hat_values` object.
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
#' mod <- apd_hat_values(mpg ~ cyl + log(drat), train)
#'
#' # Predict, with preprocessing
#' score(mod, test)
#'
#' @export
score.apd_hat_values <- function(object, new_data, type = "numeric", ...) {
  forged <- hardhat::forge(new_data, object$blueprint)
  rlang::arg_match(type, valid_predict_types())
  score_apd_hat_values_bridge(type, object, forged$predictors)
}

valid_predict_types <- function() {
  c("numeric")
}
