context("test-constructor")

test_that("`new_ad_pca` arguments are assigned correctly", {
  x <- new_ad_pca(
    "pcs",
    "pca_means",
    "XtX_inv",
    blueprint = hardhat::default_xy_blueprint()
  )

  expect_equal(names(x), c("pcs", "pca_means", "XtX_inv", "blueprint"))
  expect_equal(x$pcs, "pcs")
  expect_equal(x$pca_means, "pca_means")
  expect_equal(x$XtX_inv, "XtX_inv")
  expect_equal(x$blueprint, hardhat::default_xy_blueprint())

})

test_that("pcs is provided", {
  expect_error(
    new_ad_pca(blueprint = hardhat::default_xy_blueprint()),
    'argument "pcs" is missing, with no default'
  )
})

test_that("`new_ad_pca` fails when blueprint is numeric", {
  expect_error(
    new_ad_pca(pcs = 1, blueprint = 1),
    'blueprint should be a blueprint, not a numeric.'
  )
})

test_that("`new_ad_pca` returned blueprint is of class hardhat_blueprint", {
  x <- new_ad_pca(
    "pcs",
    "pca_means",
    "XtX_inv",
    blueprint = hardhat::default_xy_blueprint()
  )

  expect_is(x$blueprint, "hardhat_blueprint")
})
