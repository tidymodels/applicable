ad_pca_bridge <- function(processed, ...) {
  predictors <- processed$predictors
  outcome <- processed$outcomes[[1]]

  fit <- ad_pca_impl(predictors, outcome)

  new_ad_pca(
    coefs = fit$coefs,
    blueprint = processed$blueprint
  )
}
