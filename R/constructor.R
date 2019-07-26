new_ad_pca <- function(pcs, pca_means, XtX_inv, blueprint) {
  hardhat::new_model(
    pcs = pcs,
    pca_means = pca_means,
    XtX_inv = XtX_inv,
    blueprint = blueprint,
    class = "ad_pca"
  )
}
