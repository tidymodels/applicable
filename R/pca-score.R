# -----------------------------------------------------------------------------
# ---------------------- Model function implementation ------------------------
# -----------------------------------------------------------------------------

score_apd_pca_numeric <- function(model, predictors) {
  if (!("pcs" %in% names(model))) {
    rlang::abort("The model must contain a pcs argument.")
  }

  # Predict output and subset using `num_comp`
  predicted_output <- stats::predict(model$pcs, predictors)
  predicted_output <- predicted_output[, 1:model$num_comp, drop = FALSE]

  # Compute distances between new pca values and the pca means
  dists <- find_distance_to_pca_means(predicted_output, model$pca_means)

  predicted_output <-
    as_tibble(predicted_output) |>
    setNames(names0(ncol(predicted_output), "PC")) |>
    mutate(distance = dists)

  # Compute percentile of new pca values
  new_pctls <- purrr::map2_dfc(
    model$pctls |>
      dplyr::select(-percentile),
    predicted_output |> mutate(dplyr::across(dplyr::everything(), abs)),
    get_new_percentile,
    grid = model$pctls$percentile
  ) |>
    dplyr::rename_with(\(x) paste0(x, "_pctl"))

  tibble::as_tibble(
    cbind(
      predicted_output,
      new_pctls
    )
  )
}

# -----------------------------------------------------------------------------
# ------------------------ Model function bridge ------------------------------
# -----------------------------------------------------------------------------

score_apd_pca_bridge <- function(type, model, predictors) {
  predictors <- as.matrix(predictors)

  score_function <- get_pca_score_function(type)
  predictions <- score_function(model, predictors)

  hardhat::validate_prediction_size(predictions, predictors)

  predictions
}

# -----------------------------------------------------------------------------
# ----------------------- Model function interface ----------------------------
# -----------------------------------------------------------------------------

#' Predict from a `apd_pca`
#'
#' @param object A `apd_pca` object.
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
#' @details The function computes the principal components of the new data and
#' their percentiles as compared to the training data. The number of principal
#' components computed depends on the `threshold` given at fit time. It also
#' computes the multivariate distance between each principal component and its
#' mean.
#'
#' @return
#'
#' A tibble of predictions. The number of rows in the tibble is guaranteed
#' to be the same as the number of rows in `new_data`.
#'
#' @examples
#' train <- mtcars[1:20, ]
#' test <- mtcars[21:32, -1]
#'
#' # Fit
#' mod <- apd_pca(mpg ~ cyl + log(drat), train)
#'
#' # Predict, with preprocessing
#' score(mod, test)
#' @export
score.apd_pca <- function(object, new_data, type = "numeric", ...) {
  forged <- hardhat::forge(new_data, object$blueprint)
  rlang::arg_match(type, valid_predict_types())
  score_apd_pca_bridge(type, object, forged$predictors)
}

# -----------------------------------------------------------------------------
# ----------------------- Helper functions ------------------------------------
# -----------------------------------------------------------------------------

get_pca_score_function <- function(type) {
  switch(type,
    numeric = score_apd_pca_numeric
  )
}

valid_predict_types <- function() {
  c("numeric")
}
