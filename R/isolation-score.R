# -----------------------------------------------------------------------------
# ---------------------- Model function implementation ------------------------
# -----------------------------------------------------------------------------

score_apd_isolation <- function(model, predictors) {
  check_isotree()
  predicted_output <- stats::predict(model$model, predictors)
  predicted_output <- tibble::tibble(score = unname(predicted_output))

  # Compute percentile of new isotree scores
  new_pctls <- get_new_percentile(
    model$pctls$score,
    predicted_output$score,
    grid = model$pctls$percentile
  )
  predicted_output$score_pctl <- new_pctls
  predicted_output
}

# -----------------------------------------------------------------------------
# ------------------------ Model function bridge ------------------------------
# -----------------------------------------------------------------------------

score_apd_isolation_bridge <- function(type, model, predictors) {

  predictions <- score_apd_isolation(model, predictors)

  hardhat::validate_prediction_size(predictions, predictors)

  predictions
}

# -----------------------------------------------------------------------------
# ----------------------- Model function interface ----------------------------
# -----------------------------------------------------------------------------

#' Predict from a `apd_isolation`
#'
#' @param object A `apd_isolation` object.
#'
#' @param new_data A data frame or matrix of new samples.
#'
#' @param type A single character. The type of predictions to generate.
#' Valid options are:
#'
#' - `"numeric"` for numeric predictions.
#'
#' @param ... Not used, but required for extensibility.
#'
#' @details About the score
#'
#' @return
#'
#' A tibble of predictions. The number of rows in the tibble is guaranteed
#' to be the same as the number of rows in `new_data`. The `score` column is the
#' raw prediction from [isotree::predict.isolation_forest()] while `score_pctl`
#' compares this value to the reference distribution of the score created by
#' predicting the training set. A value of _X_ means that _X_ percent of the
#' training data have scores less than the predicted value.
#'
#' @seealso [apd_isolation()]
#' @examplesIf interactive()
#' if (rlang::is_installed(c("isotree", "modeldata"))) {
#'   library(dplyr)
#'
#'   data(cells, package = "modeldata")
#'
#'   cells_tr <- cells |> filter(case == "Train") |> select(-case, -class)
#'   cells_te <- cells |> filter(case != "Train") |> select(-case, -class)
#'
#'   if_mod <- apd_isolation(cells_tr, ntrees = 10, nthreads = 1)
#'   score(if_mod, cells_te)
#' }
#' @export
score.apd_isolation <- function(object, new_data, type = "numeric", ...) {
  forged <- hardhat::forge(new_data, object$blueprint)
  rlang::arg_match(type, valid_isolation_predict_types())
  score_apd_isolation_bridge(type, object, forged$predictors)
}

# -----------------------------------------------------------------------------
# ----------------------- Helper functions ------------------------------------
# -----------------------------------------------------------------------------

valid_isolation_predict_types <- function() {
  c("numeric")
}
