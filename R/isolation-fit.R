# -----------------------------------------------------------------------------
# ---------------------- Model Constructor ------------------------------------
# -----------------------------------------------------------------------------

new_apd_isolation <- function(model, pctls, blueprint) {
  hardhat::new_model(
    model = model,
    pctls = pctls,
    blueprint = blueprint,
    class = "apd_isolation"
  )
}

# -----------------------------------------------------------------------------
# ---------------------- Model function implementation ------------------------
# -----------------------------------------------------------------------------

apd_isolation_impl <- function(predictors, options) {
  check_isotree()
  cl <- rlang::call2("isolation.forest", .ns = "isotree", data = quote(predictors))
  cl <- rlang::call_modify(cl, !!!options)
  model_fit <- rlang::eval_tidy(cl)

  # Get reference distribution
  tr_pred <- predict(model_fit, predictors, type = "score")

  # Calculate percentile for scores
  pctls <-
    tibble::tibble(score = get_ref_percentile(tr_pred)) |>
    mutate(percentile = seq(0, 100, length = 101))

  res <- list(
    model = model_fit,
    pctls = pctls
  )
  res
}

# -----------------------------------------------------------------------------
# ------------------------ Model function bridge ------------------------------
# -----------------------------------------------------------------------------

apd_isolation_bridge <- function(processed, ...) {
  predictors <- processed$predictors
  options <- list(...)

  fit <- apd_isolation_impl(predictors, options)

  new_apd_isolation(
    model = fit$model,
    pctls = fit$pctls,
    blueprint = processed$blueprint
  )
}

# -----------------------------------------------------------------------------
# ----------------------- Model function interface ----------------------------
# -----------------------------------------------------------------------------

#' Fit an isolation forest to estimate an applicability domain.
#'
#' `apd_isolation()` fits an isolation forest model.
#'
#' @param x Depending on the context:
#'
#'   * A __data frame__ of predictors.
#'   * A __matrix__ of predictors (see the `categ_cols` argument of
#'     [isotree::isolation.forest()]).
#'   * A __recipe__ specifying a set of preprocessing steps
#'     created from [recipes::recipe()].
#'
#' @param data When a __recipe__ or __formula__ is used, `data` is specified as:
#'
#'   * A __data frame__ containing the predictors.
#'
#' @param formula A formula specifying the predictor terms on the right-hand
#' side. No outcome should be specified.
#'
#' @param ... Options to pass to [isotree::isolation.forest()]. Options should
#' not include `data`.
#'
#' @details
#' In an isolation forest, splits are designed to isolate individual data points.
#' The tree construction process takes random split locations on randomly
#' selected predictors. As splits are made in the tree, the algorithm tracks
#' when data points are isolated as more splits are made. The first points that
#' are isolated are thought to be outliers or anomalous. From these results, an
#' anomaly score can be constructed.
#'
#' This function creates an isolation forest on the training set and measures
#' the reference distribution of the scores when re-predicting the training set.
#' When scoring new data, the raw anomaly score is produced along with the
#' sample's corresponding percentile of the reference distribution.
#' @references
#' Liu, Fei Tony, Kai Ming Ting, and Zhi-Hua Zhou. "Isolation forest."
#' 2008 _Eighth IEEE International Conference on Data Mining. IEEE_, 2008.
#' Liu, Fei Tony, Kai Ming Ting, and Zhi-Hua Zhou. "Isolation-based anomaly
#' detection." _ACM Transactions on Knowledge Discovery from Data (TKDD)_ 6.1
#' (2012): 3.
#'
#' @return
#'
#' A `apd_isolation` object.
#'
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
#'   if_mod
#' }
#' @export
apd_isolation <- function(x, ...) {
  UseMethod("apd_isolation")
}

# Default method

#' @export
#' @rdname apd_isolation
apd_isolation.default <- function(x, ...) {
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
#' @rdname apd_isolation
apd_isolation.data.frame <- function(x, ...) {
  processed <- hardhat::mold(x, NA_real_)
  apd_isolation_bridge(processed, ...)
}

# Matrix method

#' @export
#' @rdname apd_isolation
apd_isolation.matrix <- function(x, ...) {
  processed <- hardhat::mold(x, NA_real_)
  apd_isolation_bridge(processed, ...)
}

# Formula method

#' @export
#' @rdname apd_isolation
apd_isolation.formula <- function(formula, data, ...) {
  processed <- hardhat::mold(formula, data)
  apd_isolation_bridge(processed, ...)
}

# Recipe method

#' @export
#' @rdname apd_isolation
apd_isolation.recipe <- function(x, data, ...) {
  processed <- hardhat::mold(x, data)
  apd_isolation_bridge(processed, ...)
}

#' @export
print.apd_isolation <- function(x, ...) {
  check_isotree()
  cat("Applicability domain via isolation forests\n\n")
  print(x$model)
  invisible(x)
}

check_isotree <- function() {
  if (!rlang::is_installed("isotree")) {
    rlang::abort("The 'isotree' package is required for apd_isolation().")
  }
  loadNamespace("isotree")
  invisible(NULL)
}
