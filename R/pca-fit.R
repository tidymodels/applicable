# -----------------------------------------------------------------------------
# ---------------------- Model Constructor ------------------------------------
# -----------------------------------------------------------------------------

new_apd_pca <- function(pcs, pca_means, pctls, threshold, num_comp, blueprint) {
  hardhat::new_model(
    pcs = pcs,
    pca_means = pca_means,
    pctls = pctls,
    threshold = threshold,
    num_comp = num_comp,
    blueprint = blueprint,
    class = "apd_pca"
  )
}

# -----------------------------------------------------------------------------
# ---------------------- Model function implementation ------------------------
# -----------------------------------------------------------------------------

apd_pca_impl <- function(predictors, threshold) {
  pcs <- stats::prcomp(
    predictors,
    center = TRUE,
    scale. = TRUE,
    retx = TRUE
    )

  # TODO: verify threshold \in (0, 1]
  eigs <- pcs$sdev^2
  cum_sum <- cumsum(eigs)/sum(eigs)
  num_comp <- sum(cum_sum <= threshold) + 1

  # Update `pcs` count to `num_comp`
  pcs$x <- pcs$x[, 1:num_comp, drop=FALSE]

  # Find the mean of each principal component
  pca_means <- colMeans(pcs$x)

  # Compute distances between each principal component and its mean
  distance <- find_distance_to_pca_means(pcs$x, pca_means)
  pctls <- as_tibble(pcs$x) %>%
    setNames(names0(ncol(pcs$x), "PC")) %>%
    mutate(distance = distance)

  # Calculate percentile for all PCs and distances
  pctls <- map_dfc(pctls, get_ref_percentile) %>%
    mutate(percentile = seq(0, 100, length = 101))

  pcs$x <- NULL

  res <- list(
    pcs = pcs,
    pctls = pctls,
    pca_means = pca_means,
    threshold = threshold,
    num_comp = num_comp
  )
  res
}

# -----------------------------------------------------------------------------
# ------------------------ Model function bridge ------------------------------
# -----------------------------------------------------------------------------

apd_pca_bridge <- function(processed, threshold, ...) {
  predictors <- processed$predictors

  fit <- apd_pca_impl(predictors, threshold)

  new_apd_pca(
    pcs = fit$pcs,
    pca_means = fit$pca_means,
    pctls = fit$pctls,
    threshold = fit$threshold,
    num_comp = fit$num_comp,
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
#' @param threshold A number indicating the percentage of variance desired from
#' the principal components. It must be a number greater than 0 and less or
#' equal than 1.
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
apd_pca.data.frame <- function(x, threshold = 0.95, ...) {
  processed <- hardhat::mold(x, NA_real_)
  apd_pca_bridge(processed, threshold, ...)
}

# Matrix method

#' @export
#' @rdname apd_pca
apd_pca.matrix <- function(x, threshold = 0.95, ...) {
  processed <- hardhat::mold(x, NA_real_)
  apd_pca_bridge(processed, threshold, ...)
}

# Formula method

#' @export
#' @rdname apd_pca
apd_pca.formula <- function(formula, data, threshold = 0.95, ...) {
  processed <- hardhat::mold(formula, data)
  apd_pca_bridge(processed, threshold, ...)
}

# Recipe method

#' @export
#' @rdname apd_pca
apd_pca.recipe <- function(x, data, threshold = 0.95, ...) {
  processed <- hardhat::mold(x, data)
  apd_pca_bridge(processed, threshold, ...)
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
