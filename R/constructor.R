new_ad_pca <- function(coefs, blueprint) {
  hardhat::new_model(coefs = coefs, blueprint = blueprint, class = "ad_pca")
}
