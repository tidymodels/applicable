# -----------------------------------------------------------------------------
# ---------------------- Model Constructor ------------------------------------
# -----------------------------------------------------------------------------

new_apd_di <- function(training, importance, sds, means, d_bar, aoa_threshold, blueprint) {
  hardhat::new_model(
    training = training,
    importance = importance,
    sds = sds,
    means = means,
    d_bar = d_bar,
    aoa_threshold = aoa_threshold,
    blueprint = blueprint,
    class = "apd_di"
  )
}

# -----------------------------------------------------------------------------
# ---------------------- Model function implementation ------------------------
# -----------------------------------------------------------------------------

apd_di_impl <- function(training, validation, importance, ...) {

  # Comments reference section numbers from Meyer and Pebesma 2021
  # (doi: 10.1111/2041-210X.13650)

  # 2.1 Standardization of predictor variables

  # Store standard deviations and means of all predictors from training
  # We'll save these to standardize `validation` and any data passed to `score`
  # Then scale & center `training`
  sds <- purrr::map_dbl(training, stats::sd, na.rm = TRUE)
  means <- purrr::map_dbl(training, mean, na.rm = TRUE)
  training <- center_and_scale(training, sds, means)

  # 2.2 Weighting of variables

  # Re-order `importance`'s rows
  # so they match the column order of `training` and `validation`
  importance_order <- purrr::map_dbl(
    names(training),
    ~ which(importance[["Variable"]] == .x)
  )
  importance <- importance[importance_order, ][["Importance"]]
  training <- sweep(training, 2, importance, "*")

  # Now apply all the above to the validation set, if provided
  if (!is.null(validation)) {
    # `validation` was re-ordered to match `training` back in the bridge function
    # so we can scale, center, and weight without needing to worry about
    # column order
    validation <- center_and_scale(validation, sds, means)
    validation <- sweep(validation, 2, importance, "*")
  }

  # 2.3 Multivariate distance calculation

  # Calculates the distance between each point in the `validation` set
  # (or `training`, if `validation` is `NULL`)
  # to the closest point in the training set
  dk <- calculate_dk(training, validation)

  # 2.4 Dissimilarity index

  # Find the mean nearest neighbor distance between training points:
  d_bar <- proxyC::dist(as.matrix(training))
  diag(d_bar) <- NA
  d_bar <- Matrix::mean(d_bar, na.rm = TRUE)

  # Use it to rescale dk from 2.3
  di <- dk / d_bar

  # 2.5 Deriving the area of applicability
  aoa_threshold <- as.vector(
    quantile(di, 0.75, na.rm = TRUE) + (1.5 * stats::IQR(di, na.rm = TRUE))
  )

  res <- list(
    training = training,
    importance = importance,
    sds = sds,
    means = means,
    d_bar = d_bar,
    aoa_threshold = aoa_threshold
  )
  res
}

center_and_scale <- function(x, sds, means) {
  sweep(x, 2, means, "-") / sweep(x, 2, sds, "/")
}

# Calculate minimum distances from each validation point to the training data
#
# If `validation` is `NULL`, then find the smallest distances between each
# point in `training` and the rest of the training data
calculate_dk <- function(training, validation = NULL) {

  if (is.null(validation)) {
    distances <- proxyC::dist(as.matrix(training))
    diag(distances) <- NA
  } else {
    distances <- proxyC::dist(as.matrix(validation), as.matrix(training))
  }

  apply(distances, 1, min, na.rm = TRUE)

}

# -----------------------------------------------------------------------------
# ------------------------ Model function bridge ------------------------------
# -----------------------------------------------------------------------------

apd_di_bridge <- function(training, validation, importance, ...) {

  blueprint <- training$blueprint
  training <- training$predictors

  validation <- check_di_validation(training, validation)

  check_di_importance(training, importance)
  check_di_columns_numeric(training, validation)

  fit <- apd_di_impl(training, validation, importance, ...)

  new_apd_di(
    training = fit$training,
    importance = fit$importance,
    sds = fit$sds,
    means = fit$means,
    d_bar = fit$d_bar,
    aoa_threshold = fit$aoa_threshold,
    blueprint = blueprint
  )
}

check_di_validation <- function(training, validation) {

  # If NULL, nothing to validate or re-order, so just return NULL
  if (is.null(validation)) return(NULL)

  # Make sure that the validation set has the same columns, in the same order,
  # as the original training data
  validation <- validation$predictors

  if (
    !all(names(training)   %in% names(validation)) ||
    !all(names(validation) %in% names(training))
  ) {
    rlang::abort(
      "`training` and `validation` must contain all the same columns"
    )
  }
  # Re-order validation so that its columns are guaranteed to be in the
  # same order as those in `training`
  validation[names(training)]

}

check_di_importance <- function(training, importance) {
  # Make sure that all training variables have importance values
  #
  # Because we've already called check_di_validation, this also means all
  # predictors in `validation` have importance values

  all_importance <- all(names(training) %in% importance[["Variable"]])

  if (!all_importance) {
    rlang::abort(
      "All predictors must have an importance value in `importance`",
      call = rlang::caller_env()
    )
  }
}

check_di_columns_numeric <- function(training, validation) {
  col_is_numeric <- c(
    purrr::map_lgl(training, is.numeric),
    purrr::map_lgl(validation, is.numeric)
  )

  if (!all(col_is_numeric)) {
    rlang::abort(
      "All predictors must be numeric",
      call = rlang::caller_env()
    )
  }
}

# -----------------------------------------------------------------------------
# ----------------------- Model function interface ----------------------------
# -----------------------------------------------------------------------------

#' Fit a `apd_di`
#'
#' `apd_di()` fits a model.
#'
#' @param x Depending on the context:
#'
#'   * A __data frame__ of predictors used to fit your model.
#'   * A __matrix__ of predictors used to fit your model.
#'   * A __recipe__ specifying a set of preprocessing steps
#'     created from [recipes::recipe()].
#'
#' @param data When a __recipe__ or __formula__ is used, `data` is specified as:
#'
#'   * A __data frame__ containing the predictors used to fit your model.
#'
#' @param y,validation A data frame or matrix containing the data used to
#'  validate your model. This should be the same data as used to calculate all
#'  model accuracy metrics.
#'
#'  If this argument is `NULL`, then this function will use the training data
#'  (from `x` or `data`) to calculate within-sample distances.
#'  This may result in the area of applicability threshold being set too high,
#'  with the result that too many points are classed as "inside" the area of
#'  applicability.
#'
#' @param importance A data.frame with two columns: `Variable`, containing
#' the names of each variable in the training and validation data, and
#' `Importance`, containing the (raw or scaled) feature importance for each
#' variable.
#'
#' @param formula A formula specifying the predictor terms on the right-hand
#' side.
#'
#' @param ... Not currently used, but required for extensibility.
#'
#' @details This function calculates the "area of applicability" of a model, as
#' introduced by Meyer and Pebesma (2021). While the initial paper introducing
#' this method focused on spatial models, there is nothing inherently spatial
#' about the method; it can be used with any type of data.
#'
#' The `importance` argument is structured to work with objects returned by the
#' vip package, using functions such as [vip::vi_permute].
#'
#' @return
#'
#' A `apd_di` object.
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
#' apd_di(y ~ ., train, test, importance = importance)
#'
#' @references
#' H. Meyer and E. Pebesma. 2021. "Predicting into unknown space? Estimating
#' the area of applicability of spatial prediction models," Methods in Ecology
#' and Evolution 12(9), pp 1620 - 1633, doi: 10.1111/2041-210X.13650.
#'
#' @export
apd_di <- function(x, ...) {
  UseMethod("apd_di")
}

# Default method

#' @export
#' @rdname apd_di
apd_di.default <- function(x, ...) {
  cls <- class(x)[1]
  message <-
    "`x` is not of a recognized type.
     Only data.frame, matrix, recipe, and formula objects are allowed.
     A {cls} was specified."
  message <- glue::glue(message)
  rlang::abort(message = message)
}

# Data frame method

#' @export
#' @rdname apd_di
apd_di.data.frame <- function(x, y = NULL, importance, ...) {
  training <- hardhat::mold(x, NA_real_)
  validation <- NULL
  if (!is.null(y)) validation <- hardhat::mold(y, NA_real_)
  apd_di_bridge(training, validation, importance, ...)
}

# Matrix method

#' @export
#' @rdname apd_di
apd_di.matrix <- function(x, y = NULL, importance, ...) {
  training <- hardhat::mold(x, NA_real_)
  validation <- NULL
  if (!is.null(y)) validation <- hardhat::mold(y, NA_real_)
  apd_di_bridge(training, validation, importance, ...)
}

# Formula method

#' @export
#' @rdname apd_di
apd_di.formula <- function(formula, data, validation = NULL, importance, ...) {
  training <- hardhat::mold(formula, data)
  if (!is.null(validation)) validation <- hardhat::mold(formula, validation)
  apd_di_bridge(training, validation, importance, ...)
}

# Recipe method

#' @export
#' @rdname apd_di
apd_di.recipe <- function(x, data, validation = NULL, importance, ...) {
  training <- hardhat::mold(x, data)
  if (!is.null(validation)) validation <- hardhat::mold(x, validation)
  apd_di_bridge(training, validation, importance, ...)
}
