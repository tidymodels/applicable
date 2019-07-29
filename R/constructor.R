new_apd_pca <- function(pcs, pca_means, blueprint) {
  hardhat::new_model(
    pcs = pcs,
    pca_means = pca_means,
    blueprint = blueprint,
    class = "apd_pca"
  )
}
