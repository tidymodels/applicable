# -----------------------------------------------------------------------------
# ---------------------- Model Constructor ------------------------------------
# -----------------------------------------------------------------------------

new_apd_pca <- function(pcs, pca_means, pctls, blueprint) {
  hardhat::new_model(
    pcs = pcs,
    pca_means = pca_means,
    pctls = pctls,
    blueprint = blueprint,
    class = "apd_pca"
  )
}

# -----------------------------------------------------------------------------
# ---------------------- Model function implementation ------------------------
# -----------------------------------------------------------------------------

apd_pca_impl <- function(predictors) {
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
  res$pctls <-
    map_dfc(as_tibble(res$pcs$rotation), get_ref_percentile) %>%
    mutate(percentile = seq(0, 100, length = 101))

  res
}

# -----------------------------------------------------------------------------
# ------------------------ Model function bridge ------------------------------
# -----------------------------------------------------------------------------

apd_pca_bridge <- function(processed, ...) {
  predictors <- processed$predictors

  fit <- apd_pca_impl(predictors)

  new_apd_pca(
    pcs = fit$pcs,
    pca_means = fit$pca_means,
    pctls = fit$pctls,
    blueprint = processed$blueprint
  )
}

# -----------------------------------------------------------------------------
# ----------------------- Model function interface ----------------------------
# -----------------------------------------------------------------------------

#' Fit a `apd_pca`
#'
#' `apd_pca()` fits a model.
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
#' A `apd_pca` object.
#'
#' @examples
#' predictors <- mtcars[, -1]
#'
#' # Data frame interface
#' mod <- apd_pca(predictors)
#'
#' # Formula interface
#' mod2 <- apd_pca(mpg ~ ., mtcars)
#'
#' # Recipes interface
#' library(recipes)
#' rec <- recipe(mpg ~ ., mtcars)
#' rec <- step_log(rec, disp)
#' mod3 <- apd_pca(rec, mtcars)
#'
#' @export
apd_pca <- function(x, ...) {
  UseMethod("apd_pca")
}

#' @export
#' @rdname apd_pca
apd_pca.default <- function(x, ...) {
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
#' @rdname apd_pca
apd_pca.data.frame <- function(x, ...) {
  processed <- hardhat::mold(x, NA_real_)
  apd_pca_bridge(processed, ...)
}

# Matrix method

#' @export
#' @rdname apd_pca
apd_pca.matrix <- function(x, ...) {
  processed <- hardhat::mold(x, NA_real_)
  apd_pca_bridge(processed, ...)
}

# Formula method

#' @export
#' @rdname apd_pca
apd_pca.formula <- function(formula, data, ...) {
  processed <- hardhat::mold(formula, data)
  apd_pca_bridge(processed, ...)
}

# Recipe method

#' @export
#' @rdname apd_pca
apd_pca.recipe <- function(x, data, ...) {
  processed <- hardhat::mold(x, data)
  apd_pca_bridge(processed, ...)
}

# -----------------------------------------------------------------------------
# ----------------------- Helper functions ------------------------------------
# -----------------------------------------------------------------------------

get_ref_percentile <- function(x) {
  res <- stats::ecdf(x)
  grid = seq(0, 1, length = 101)
  res <- stats::quantile(res, grid)
  unname(res)
}
