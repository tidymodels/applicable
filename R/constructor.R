new_ad_pca <- function(pcs, pca_means, blueprint) {
  hardhat::new_model(
    pcs = pcs,
    pca_means = pca_means,
    blueprint = blueprint,
    class = "ad_pca"
  )
}
