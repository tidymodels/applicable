# -------------------------------------------------------------------
# ----------------- Model function implementation -------------------
# -------------------------------------------------------------------
ad_pca_impl <- function(predictors) {
  res <-
    list(
      pcs = stats::prcomp(
        predictors,
        center = TRUE,
        scale. = TRUE,
        retx = TRUE
      )
    )
  res$pca_means <- colMeans(res$pcs$x)
  res$pcs$x <- NULL
  res
}

# -------------------------------------------------------------------
# ------------------- Model function bridge -------------------------
# -------------------------------------------------------------------
ad_pca_bridge <- function(processed, ...) {
  predictors <- processed$predictors

  fit <- ad_pca_impl(predictors)

  new_ad_pca(
    pcs = fit$pcs,
    pca_means = fit$pca_means,
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
#' A `ad_pca` object.
#'
#' @examples
#' predictors <- mtcars[, -1]
#'
#' # Data frame interface
#' mod <- ad_pca(predictors)
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
#' @rdname ad_pca
ad_pca.data.frame <- function(x, ...) {
  processed <- hardhat::mold(x, NA_real_)
  ad_pca_bridge(processed, ...)
}

# Matrix method

#' @export
#' @rdname ad_pca
ad_pca.matrix <- function(x, ...) {
  processed <- hardhat::mold(x, NA_real_)
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
