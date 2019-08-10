# -----------------------------------------------------------------------------
# ---------------------- Model Constructor ------------------------------------
# -----------------------------------------------------------------------------

new_apd_hat_values <- function(XtX_inv, pctls, blueprint) {
  hardhat::new_model(
    XtX_inv = XtX_inv,
    pctls = pctls,
    blueprint = blueprint,
    class = "apd_hat_values"
  )
}

# -----------------------------------------------------------------------------
# ---------------------- Model function implementation ------------------------
# -----------------------------------------------------------------------------

apd_hat_values_impl <- function(predictors) {
  XtX_inv <- get_inv(predictors)

  X <- as.matrix(predictors)
  dimnames(X) <- NULL

  P <- X %*% XtX_inv %*% t(X)
  hat_values <- diag(P)

  # Calculate percentile for all PCs and distances
  pctls <- as.data.frame(get_ref_percentile(hat_values)) %>%
    setNames("hat_values_pctls") %>%
    mutate(percentile = seq(0, 100, length = 101))

  res <-
    list(
      XtX_inv = XtX_inv,
      pctls = pctls
    )

  res
}

# -----------------------------------------------------------------------------
# ------------------------ Model function bridge ------------------------------
# -----------------------------------------------------------------------------

apd_hat_values_bridge <- function(processed, ...) {
  predictors <- processed$predictors

  fit <- apd_hat_values_impl(predictors)

  new_apd_hat_values(
    XtX_inv = fit$XtX_inv,
    pctls = fit$pctls,
    blueprint = processed$blueprint
  )
}

# -----------------------------------------------------------------------------
# ----------------------- Model function interface ----------------------------
# -----------------------------------------------------------------------------

#' Fit a `apd_hat_values`
#'
#' `apd_hat_values()` fits a model.
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
#' @param ... Not currently used, but required for extensibility.
#'
#' @return
#'
#' A `apd_hat_values` object.
#'
#' @examples
#' predictors <- mtcars[, -1]
#'
#' # Data frame interface
#' mod <- apd_hat_values(predictors)
#'
#' # Formula interface
#' mod2 <- apd_hat_values(mpg ~ ., mtcars)
#'
#' # Recipes interface
#' library(recipes)
#' rec <- recipe(mpg ~ ., mtcars)
#' rec <- step_log(rec, disp)
#' mod3 <- apd_hat_values(rec, mtcars)
#'
#' @export
apd_hat_values <- function(x, ...) {
  UseMethod("apd_hat_values")
}

#' @export
#' @rdname apd_hat_values
apd_hat_values.default <- function(x, ...) {
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
#' @rdname apd_hat_values
apd_hat_values.data.frame <- function(x, ...) {
  processed <- hardhat::mold(x, NA_real_)
  apd_hat_values_bridge(processed, ...)
}

# Matrix method

#' @export
#' @rdname apd_hat_values
apd_hat_values.matrix <- function(x, ...) {
  processed <- hardhat::mold(x, NA_real_)
  apd_hat_values_bridge(processed, ...)
}

# Formula method

#' @export
#' @rdname apd_hat_values
apd_hat_values.formula <- function(formula, data, ...) {
  processed <- hardhat::mold(formula, data)
  apd_hat_values_bridge(processed, ...)
}

# Recipe method

#' @export
#' @rdname apd_hat_values
apd_hat_values.recipe <- function(x, data, ...) {
  processed <- hardhat::mold(x, data)
  apd_hat_values_bridge(processed, ...)
}
