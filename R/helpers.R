# Find distance between each principal component and the respective mean
# calculated on each principal components on the training set.
find_distance_to_pca_means <- function(pcs, pca_means) {
  diffs <- sweep(pcs, 2, pca_means)
  sq_diff <- diffs^2
  dists <- apply(sq_diff, 1, function(x) sqrt(sum(x)))
  dists
}

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

# Find percentile
get_ref_percentile <- function(x) {
  res <- stats::ecdf(x)
  grid = seq(0, 1, length = 101)
  res <- stats::quantile(res, grid)
  unname(res)
}

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

# Find matrix XpX_inv
get_inv <- function(X) {
  if (!is.matrix(X)) {
    X <- as.matrix(X)
  }

  XpX <- t(X) %*% X
  XpX_inv <- try(qr.solve(XpX), silent = TRUE)

  if (inherits(XpX_inv, "try-error")) {
    rlang::abort(message = as.character(XpX_inv))
  }

  dimnames(XpX_inv) <- NULL
  XpX_inv
}
