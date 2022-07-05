# -----------------------------------------------------------------------------
# ---------------------- Model function implementation ------------------------
# -----------------------------------------------------------------------------

score_apd_di_numeric <- function(model, predictors) {

  if (!("apd_di" %in% class(model))) {
    rlang::abort(
      "`model` must be an `apd_di` object",
      call = rlang::caller_env()
    )
  }

  predictors <- center_and_scale(predictors, model$sds, model$means)
  predictors <- sweep(predictors, 2, model$importance, "*")
  dk <- calculate_dk(model$training, predictors)
  di <- dk / model$d_bar
  aoa <- di <= model$aoa_threshold

  tibble::tibble(
    di = di,
    aoa = aoa
  )
}

# -----------------------------------------------------------------------------
# ------------------------ Model function bridge ------------------------------
# -----------------------------------------------------------------------------

score_apd_di_bridge <- function(type, model, predictors) {
  if (!all(names(model$training) %in% names(predictors))) {
    rlang::abort(
      "Some variables used to calculate the DI are missing from `new_data`",
      call = rlang::caller_env()
    )
  }
  predictors <- predictors[names(model$training)]
  predictors <- as.matrix(predictors)

  score_function <- get_aoa_score_function(type)
  predictions <- score_function(model, predictors)

  hardhat::validate_prediction_size(predictions, predictors)

  predictions
}

# -----------------------------------------------------------------------------
# ----------------------- Model function interface ----------------------------
# -----------------------------------------------------------------------------

#' Predict from a `apd_di`
#'
#' @param object A `apd_di` object.
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
#' @details The function computes the distance indices of the new data and
#' whether or not they are "inside" the area of applicability.
#'
#' @return
#'
#' A tibble of predictions. The number of rows in the tibble is guaranteed
#' to be the same as the number of rows in `new_data`.
#'
#' @examplesIf rlang::is_installed("vip")
#' library(vip)
#' train <- gen_friedman(1000, seed = 101)  # ?vip::gen_friedman
#' test <- train[701:1000, ]
#' train <- train[1:700, ]
#' pp <- stats::ppr(y ~ ., data = train, nterms = 11)
#' importance <- vi_permute(
#'   pp,
#'   target = "y",
#'   metric = "rsquared",
#'   pred_wrapper = predict
#' )
#'
#' aoa <- apd_di(y ~ ., train, test, importance = importance)
#' score(aoa, test)
#'
#' @export
score.apd_di <- function(object, new_data, type = "numeric", ...) {
  forged <- hardhat::forge(new_data, object$blueprint)
  rlang::arg_match(type, valid_predict_types())
  score_apd_di_bridge(type, object, forged$predictors)
}

# -----------------------------------------------------------------------------
# ----------------------- Helper functions ------------------------------------
# -----------------------------------------------------------------------------

get_aoa_score_function <- function(type) {
  switch(type,
         numeric = score_apd_di_numeric
  )
}

valid_predict_types <- function() {
  c("numeric")
}
