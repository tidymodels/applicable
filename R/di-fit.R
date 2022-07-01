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

  # 2.1 Standardization of predictor variables
  sds <- purrr::map_dbl(training, stats::sd)
  means <- purrr::map_dbl(training, mean)

  training <- sweep(training, 2, means) / sweep(training, 2, sds, "/")

  if (!is.null(validation)) {
    validation <- sweep(validation, 2, means) / sweep(validation, 2, sds, "/")
  }

  # 2.2 Weighting of variables
  importance_order <- purrr::map_dbl(
    names(training),
    ~ which(importance[["Variable"]] == .x)
  )
  importance <- importance[importance_order, ][["Importance"]]
  training <- sweep(training, 2, importance, "*")

  if (!is.null(validation)) {
    validation <- validation[names(training)]
    validation <- sweep(validation, 2, importance, "*")
  }

  # 2.3 Multivariate distance calculation
  dk <- calculate_dk(training, validation)

  # 2.4 Dissimilarity index
  d_bar <- mean(stats::dist(training))
  di <- dk / d_bar

  # 2.5 Deriving the area of applicability
  aoa_threshold <- as.vector(quantile(di, 0.75) + (1.5 * stats::IQR(di)))

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

calculate_dk <- function(training, validation) {
  nrow_training <- nrow(training)
  distances <- rbind(training, validation)
  distances <- stats::dist(distances)
  if (is.null(validation)) {
    purrr::map_dbl(
      seq_len(nrow_training),
      function(row_n) {
        lower_distances <- Inf
        higher_distances <- Inf
        if (row_n != 1) {
          i <- seq_len(row_n)
          j <- row_n
          lower_distances <- distances[nrow_training*(i-1) - i*(i-1)/2 + j-i]
        }
        if (row_n != nrow_training) {
          i <- row_n
          j <- seq.int(row_n + 1, nrow_training, 1)
          higher_distances <- distances[nrow_training*(i-1) - i*(i-1)/2 + j-i]
        }
        min(c(lower_distances, higher_distances))
      }
    )
  } else {
    nrow_validation <- nrow(validation)
    nrow_total <- nrow_validation + nrow_training
    purrr::map_dbl(
      seq_len(nrow_validation) + nrow_training,
      function(row_n) {
        i <- seq_len(nrow_training)
        j <- row_n
        min(distances[nrow_total*(i-1) - i*(i-1)/2 + j-i])
      }
    )
  }
}

# -----------------------------------------------------------------------------
# ------------------------ Model function bridge ------------------------------
# -----------------------------------------------------------------------------

apd_di_bridge <- function(training, validation, importance, ...) {
  blueprint <- training$blueprint
  training <- training$predictors
  all_numeric <- purrr::map_lgl(training, is.numeric)

  if (!is.null(validation)) {
    validation <- validation$predictors
    all_numeric <- c(all_numeric, purrr::map_lgl(validation, is.numeric))
  }

  all_numeric <- all(all_numeric)

  if (!all_numeric) {
    rlang::abort(
      "All predictors must be numeric",
      call = rlang::caller_env()
    )
  }

  all_importance <- all(names(training) %in% importance[["Variable"]])

  if (!all_importance) {
    rlang::abort(
      "All predictors must have an importance value in `importance`",
      call = rlang::caller_env()
    )
  }

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

# -----------------------------------------------------------------------------
# ----------------------- Model function interface ----------------------------
# -----------------------------------------------------------------------------

#' Fit a `apd_di`
#'
#' `apd_di()` fits a model.
#'
#' @param x,y Depending on the context:
#'
#'   * A __data frame__ of predictors.
#'   * A __matrix__ of predictors.
#'   * A __recipe__ specifying a set of preprocessing steps
#'     created from [recipes::recipe()].
#'
#'  If `y` is `NULL`, then this function will use within-sample distances.
#'  This may result in too large an area of applicability being calculated.
#'
#' @param data,validation When a __recipe__ or __formula__ is used, `data` is specified as:
#'
#'   * A __data frame__ containing the predictors.
#'
#'  If `validation` is `NULL`, then this function will use within-sample distances.
#'  This may result in too large an area of applicability being calculated.
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
