# -----------------------------------------------------------------------------
# ---------------------- Model Constructor ------------------------------------
# -----------------------------------------------------------------------------

new_apd_isolation <- function(model, pctls, blueprint) {
  # TODO add checks here
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
  if (!rlang::is_installed("isotree")) {
    rlang::abort("The 'isotree' package is required for apd_isolation().")
  }
  cl <- rlang::call2("isolation.forest", .ns = "isotree", df = quote(predictors))
  cl <- rlang::call_modify(cl, !!!options)
  model_fit <- rlang::eval_tidy(cl)

  # Get reference distribution
  tr_pred <- predict(model_fit, predictors, type = "score")

  # Calculate percentile for scores
  pctls <-
    tibble::tibble(score = get_ref_percentile(tr_pred)) %>%
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
#'   * A __matrix__ of predictors.
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
#' not include `df`.
#'
#' @details background on isolation forests
#'
#' @return
#'
#' A `apd_isolation` object.
#'
#' @examples
#' predictors <- mtcars[, -1]
#'
#' # Data frame interface
#' mod <- apd_isolation(predictors)
#'
#' # Formula interface
#' mod2 <- apd_isolation(mpg ~ ., mtcars)
#'
#' # Recipes interface
#' library(recipes)
#' rec <- recipe(mpg ~ ., mtcars)
#' rec <- step_log(rec, disp)
#' mod3 <- apd_isolation(rec, mtcars)
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
