# Find distance between each principal component and the respective mean
# calculated on each principal components on the training set.
find_distance_to_pca_means <- function(pcs, pca_means) {
  diffs <- sweep(pcs, 2, pca_means)
  sq_diff <- diffs^2
  dists <- apply(sq_diff, 1, function(x) sqrt(sum(x)))
  dists
}
