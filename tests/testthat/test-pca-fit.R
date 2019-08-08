context("pca fit tests")

test_that("`new_apd_pca` arguments are assigned correctly", {
  x <- new_apd_pca(
    "pcs",
    "pca_means",
    "pctls",
    "threshold",
    "num_comp",
    blueprint = hardhat::default_xy_blueprint()
  )

  expect_equal(names(x), c("pcs", "pca_means", "pctls", "threshold", "num_comp", "blueprint"))
  expect_equal(x$pcs, "pcs")
  expect_equal(x$pca_means, "pca_means")
  expect_equal(x$pctls, "pctls")
  expect_equal(x$threshold, "threshold")
  expect_equal(x$num_comp, "num_comp")
  expect_equal(x$blueprint, hardhat::default_xy_blueprint())

})

test_that("pcs is provided", {
  expect_error(
    new_apd_pca(blueprint = hardhat::default_xy_blueprint()),
    'argument "pcs" is missing, with no default',
    fixed = TRUE
  )
})

test_that("`new_apd_pca` fails when blueprint is numeric", {
  expect_error(
    new_apd_pca(pcs = 1, blueprint = 1),
    'blueprint should be a blueprint, not a numeric.',
    fixed = TRUE
  )
})

test_that("`new_apd_pca` returned blueprint is of class hardhat_blueprint", {
  x <- new_apd_pca(
    "pcs",
    "pca_means",
    "pctls",
    "threshold",
    "num_comp",
    blueprint = hardhat::default_xy_blueprint()
  )

  expect_is(x$blueprint, "hardhat_blueprint")
})


test_that("`apd_pca` fails when model is not of class apd_pca", {
  model <- apd_pca(~ Sepal.Length + Species, iris)
  expect_is(model, "apd_pca")
})

test_that("`apd_pca` fails when model is not of class hardhat_model", {
  model <- apd_pca(~ Sepal.Length + Species, iris)
  expect_is(model, "hardhat_model")
})

test_that("pcs matches `prcomp` output for the data frame method", {
  expected <- stats::prcomp(mtcars, center = TRUE, scale. = TRUE)
  expected$x <- NULL

  # Data frame method
  expect_equivalent(
    apd_pca(mtcars)$pcs,
    expected
  )
})

test_that("pcs matches `prcomp` output for the formula method", {
  expected <- stats::prcomp(mtcars, center = TRUE, scale. = TRUE)
  expected$x <- NULL

  # Formula method
  expect_equivalent(
    apd_pca(~., mtcars)$pcs,
    expected
  )
})

test_that("pcs matches `prcomp` output for the recipe method", {
  expected <- stats::prcomp(mtcars, center = TRUE, scale. = TRUE)
  expected$x <- NULL

  # Recipe method
  rec <- recipes::recipe(~., mtcars)
  expect_equivalent(
    apd_pca(rec, data = mtcars)$pcs,
    expected
  )
})

test_that("pcs matches `prcomp` output for the matrix method", {
  expected <- stats::prcomp(mtcars, center = TRUE, scale. = TRUE)
  expected$x <- NULL

  # Matrix method
  expect_equivalent(
    apd_pca(as.matrix(mtcars))$pcs,
    expected
  )
})

test_that("`apd_pca` is not defined for vectors", {
  cls <- class(mtcars$mpg)[1]
  expected_message <- glue::glue("`x` is not of a recognized type.
     Only data.frame, matrix, recipe, and formula objects are allowed.
     A {cls} was specified.")

  expect_condition(
    apd_pca(mtcars$mpg),
    expected_message
  )
})
