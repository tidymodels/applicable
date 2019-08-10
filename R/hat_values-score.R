# -----------------------------------------------------------------------------
# ---------------------- Model function implementation ------------------------
# -----------------------------------------------------------------------------

score_apd_hat_values_numeric <- function(model, predictors) {
  if(!("XtX_inv" %in% names(model)))
    rlang::abort("The model must contain an XtX_inv argument.")

  proj_matrix <- predictors %*% model$XtX_inv %*% t(predictors)
  hat_values <- diag(proj_matrix)

  hat_values_pctls <- get_new_percentile(
    model$pctls$hat_values_pctls,
    hat_values,
    model$pctls$percentile
  )

  tibble::as_tibble(
    cbind(
      hat_values,
      hat_values_pctls
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

#' Score new samples using hat values
#'
#' @param object A `apd_hat_values` object.
#'
#' @param new_data A data frame or matrix of new predictors.
#'
#' @param type A single character. The type of predictions to generate.
#' Valid options are:
#'
#' - `"numeric"` for a numeric value that summarizes the hat values for
#'   each sample across the training set.
#'
#' @param ... Not used, but required for extensibility.
#'
#' @return
#'
#' A tibble of predictions. The number of rows in the tibble is guaranteed
#' to be the same as the number of rows in `new_data`. For `type = "numeric"`,
#' the tibble contains two columns `hat_values` and `hat_values_pctls`. The
#' column `hat_values_pctls` is in percent units so that a value of 11.5
#' indicates that, in the training set, 11.5 percent of the training set
#' samples had smaller values than the sample being scored.
#'
#' @examples
#' train_data <- mtcars[1:20,]
#' test_data <- mtcars[21:32, -1]
#'
#' hat_values_model <- apd_hat_values(train_data)
#'
#' hat_values_scoring <- score(hat_values_model, new_data = test_data)
#' hat_values_scoring
#'
#' @export
score.apd_hat_values <- function(object, new_data, type = "numeric", ...) {
  forged <- hardhat::forge(new_data, object$blueprint)
  rlang::arg_match(type, valid_predict_types())
  score_apd_hat_values_bridge(type, object, forged$predictors)
}

# -----------------------------------------------------------------------------
# ----------------------- Helper functions ------------------------------------
# -----------------------------------------------------------------------------

valid_predict_types <- function() {
  c("numeric")
}
