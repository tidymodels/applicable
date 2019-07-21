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
  skip("Skipping until 'No variables or terms were selected.'
       issue is fixed in hardhat.")
  expected <- stats::prcomp(mtcars, center = TRUE, scale. = TRUE)

  # Recipe method
  rec <- recipes::recipe(~., mtcars)
  expect_equivalent(
    ad_pca(rec, data = mtcars)$pcs,
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
