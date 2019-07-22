context("test-constructor")

test_that("pcs is assigned correctly", {
  x <- new_ad_pca(
    1,
    blueprint = hardhat::default_xy_blueprint()
  )
  expect_equal(x$pcs, 1)
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
    1,
    blueprint = hardhat::default_xy_blueprint()
  )
  expect_true(is(x$blueprint, "hardhat_blueprint"))
})
