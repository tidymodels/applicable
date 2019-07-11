# -------------------------------------------------------------------
# ----------------- Model function implementation -------------------
# -------------------------------------------------------------------
ad_pca_impl <- function(predictors, outcome) {
  list(coefs = 1)
}

# -------------------------------------------------------------------
# ------------------- Model function bridge -------------------------
# -------------------------------------------------------------------
ad_pca_bridge <- function(processed, ...) {
  predictors <- processed$predictors
  outcome <- processed$outcomes[[1]]

  fit <- ad_pca_impl(predictors, outcome)

  new_ad_pca(
    coefs = fit$coefs,
    blueprint = processed$blueprint
  )
}

# -------------------------------------------------------------------
# ------------------ Model function interface -----------------------
# -------------------------------------------------------------------
#' Fit a `ad_pca`
#'
#' `ad_pca()` fits a model.
#'
#' @param x Depending on the context:
#'
#'   * A __data frame__ of predictors.
#'   * A __matrix__ of predictors.
#'   * A __recipe__ specifying a set of preprocessing steps
#'     created from [recipes::recipe()].
#'
#' @param y When `x` is a __data frame__ or __matrix__, `y` is the outcome
#' specified as:
#'
#'   * A __data frame__ with 1 numeric column.
#'   * A __matrix__ with 1 numeric column.
#'   * A numeric __vector__.
#'
#' @param data When a __recipe__ or __formula__ is used, `data` is specified as:
#'
#'   * A __data frame__ containing both the predictors and the outcome.
#'
#' @param formula A formula specifying the outcome terms on the left-hand side,
#' and the predictor terms on the right-hand side.
#'
#' @param ... Not currently used, but required for extensibility.
#'
#' @return
#'
#' A `ad_pca` object.
#'
#' @examples
#' predictors <- mtcars[, -1]
#' outcome <- mtcars[, 1]
#'
#' # XY interface
#' mod <- ad_pca(predictors, outcome)
#'
#' # Formula interface
#' mod2 <- ad_pca(mpg ~ ., mtcars)
#'
#' # Recipes interface
#' library(recipes)
#' rec <- recipe(mpg ~ ., mtcars)
#' rec <- step_log(rec, disp)
#' mod3 <- ad_pca(rec, mtcars)
#'
#' @export
ad_pca <- function(x, ...) {
  UseMethod("ad_pca")
}

#' @export
#' @rdname ad_pca
ad_pca.default <- function(x, ...) {
  stop("`ad_pca()` is not defined for a '", class(x)[1], "'.", call. = FALSE)
}

# XY method - data frame

#' @export
#' @rdname ad_pca
ad_pca.data.frame <- function(x, y, ...) {
  processed <- hardhat::mold(x, y)
  ad_pca_bridge(processed, ...)
}

# XY method - matrix

#' @export
#' @rdname ad_pca
ad_pca.matrix <- function(x, y, ...) {
  processed <- hardhat::mold(x, y)
  ad_pca_bridge(processed, ...)
}

# Formula method

#' @export
#' @rdname ad_pca
ad_pca.formula <- function(formula, data, ...) {
  processed <- hardhat::mold(formula, data)
  ad_pca_bridge(processed, ...)
}

# Recipe method

#' @export
#' @rdname ad_pca
ad_pca.recipe <- function(x, data, ...) {
  processed <- hardhat::mold(x, data)
  ad_pca_bridge(processed, ...)
}
