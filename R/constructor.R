new_ad_pca <- function(pcs, pca_means, XtXinv, blueprint) {
  hardhat::new_model(
    pcs = pcs,
    pca_means = pca_means,
    XtXinv = XtXinv,
    blueprint = blueprint,
    class = "ad_pca"
  )
}
