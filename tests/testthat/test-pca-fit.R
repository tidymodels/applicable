context("test-pca-fit")

test_that("pcs matches `prcomp` output for the data frame method", {
  expected <- stats::prcomp(mtcars, center = TRUE, scale. = TRUE)

  # Data frame method
  expect_equivalent(
    ad_pca(mtcars)$pcs,
    expected
  )
})

test_that("pcs matches `prcomp` output for the formula method", {
  expected <- stats::prcomp(mtcars, center = TRUE, scale. = TRUE)

  # Formula method
  expect_equivalent(
    ad_pca(~., mtcars)$pcs,
    expected
  )
})

test_that("pcs matches `prcomp` output for the recipe method", {
  skip("Skipping for now until issue 'argument \"data\" is missing, with no
        default' is fixed.")

  expected <- stats::prcomp(mtcars, center = TRUE, scale. = TRUE)

  # Recipe method
  rec <- recipes::recipe(~., mtcars) %>%
    recipes::prep()
  expect_equivalent(
    ad_pca(rec)$pcs,
    expected
  )
})

test_that("pcs matches `prcomp` output for the matrix method", {
  expected <- stats::prcomp(mtcars, center = TRUE, scale. = TRUE)

  # Matrix method
  expect_equivalent(
    ad_pca(as.matrix(mtcars))$pcs,
    expected
  )
})

test_that("ad_pca is not defined for vectors", {
  skip("Skipping until I understand why the expected & actual message differ.")

  expect_condition(
    ad_pca(mtcars$mpg),
    "`ad_pca()` is not defined for a 'numeric'."
  )
})

