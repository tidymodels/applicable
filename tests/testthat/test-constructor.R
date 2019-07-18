context("test-constructor")

test_that("test pcs value is assigned correctly", {
  x <- new_ad_pca(
    1,
    blueprint = hardhat::default_xy_blueprint()
  )
  expect_equal(x$pcs, 1)
})

test_that("must provide pcs argument", {
  expect_error(
    new_ad_pca(blueprint = hardhat::default_xy_blueprint()),
    'argument "pcs" is missing, with no default'
  )
})

test_that("must use a valid blueprint", {
  expect_error(
    new_ad_pca(pcs = 1, blueprint = 1),
    'blueprint should be a blueprint, not a numeric.'
  )
})

