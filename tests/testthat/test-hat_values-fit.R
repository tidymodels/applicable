test_that("`new_apd_hat_values` arguments are assigned correctly", {
  x <- new_apd_hat_values(
    "XtX_inv",
    "pctls",
    blueprint = hardhat::default_xy_blueprint()
  )

  expect_equal(names(x), c("XtX_inv", "pctls", "blueprint"))
  expect_equal(x$XtX_inv, "XtX_inv")
  expect_equal(x$pctls, "pctls")
  expect_equal(x$blueprint, hardhat::default_xy_blueprint())
})

test_that("XtX_inv is provided", {
  skip_if(packageVersion("base") < "4.3.3")
  expect_snapshot(error = TRUE,
    new_apd_hat_values(blueprint = hardhat::default_xy_blueprint())
  )
})

test_that("`new_apd_hat_values` fails when blueprint is numeric", {
  expect_snapshot(error = TRUE,
    new_apd_hat_values(XtX_inv = 1, blueprint = 1)
  )
})

test_that("`new_apd_hat_values` returned blueprint is of class hardhat_blueprint", {
  x <- new_apd_hat_values(
    "XtX_inv",
    "pctls",
    blueprint = hardhat::default_xy_blueprint()
  )

  expect_s3_class(x$blueprint, "hardhat_blueprint")
})

test_that("`apd_hat_values` fails when model is not of class apd_hat_values", {
  model <- apd_hat_values(~ Sepal.Length + Species, iris)
  expect_s3_class(model, "apd_hat_values")
})

test_that("`apd_hat_values` fails when model is not of class hardhat_model", {
  model <- apd_hat_values(~ Sepal.Length + Species, iris)
  expect_s3_class(model, "hardhat_model")
})

test_that("`apd_hat_values` is defined for data.frame objects", {
  x <- apd_hat_values(mtcars)
  X <- as.matrix(mtcars)
  XpX <- t(X) %*% X
  XtX_inv <- qr.solve(XpX)
  dimnames(XtX_inv) <- NULL

  expect_equal(class(x), c("apd_hat_values", "hardhat_model", "hardhat_scalar"))
  expect_equal(names(x), c("XtX_inv", "pctls", "blueprint"))
  expect_equal(x$XtX_inv, XtX_inv)
})

test_that("`apd_hat_values` is defined for formula objects", {
  x <- apd_hat_values(~ Sepal.Width + Sepal.Length, iris)
  X <- as.matrix(iris %>% select(Sepal.Width, Sepal.Length))
  XpX <- t(X) %*% X
  XtX_inv <- qr.solve(XpX)
  dimnames(XtX_inv) <- NULL

  expect_equal(class(x), c("apd_hat_values", "hardhat_model", "hardhat_scalar"))
  expect_equal(names(x), c("XtX_inv", "pctls", "blueprint"))
  expect_equal(x$XtX_inv, XtX_inv)
})

test_that("`apd_hat_values` is defined for recipe objects", {
  rec <- recipes::recipe(~ Sepal.Width + Sepal.Length, iris)
  x <- apd_hat_values(rec, data = iris)
  X <- as.matrix(iris %>% select(Sepal.Width, Sepal.Length))
  XpX <- t(X) %*% X
  XtX_inv <- qr.solve(XpX)
  dimnames(XtX_inv) <- NULL

  expect_equal(class(x), c("apd_hat_values", "hardhat_model", "hardhat_scalar"))
  expect_equal(names(x), c("XtX_inv", "pctls", "blueprint"))
  expect_equal(x$XtX_inv, XtX_inv)
})

test_that("`apd_hat_values` is defined for matrix objects", {
  X <- as.matrix(iris %>% select(-Species))
  x <- apd_hat_values(X)
  XpX <- t(X) %*% X
  XtX_inv <- qr.solve(XpX)
  dimnames(XtX_inv) <- NULL

  expect_equal(class(x), c("apd_hat_values", "hardhat_model", "hardhat_scalar"))
  expect_equal(names(x), c("XtX_inv", "pctls", "blueprint"))
  expect_equal(x$XtX_inv, XtX_inv)
})

test_that("`apd_hat_values` is not defined for vectors", {
  cls <- class(mtcars$mpg)[1]
  expected_message <- glue::glue("`x` is not of a recognized type.
     Only data.frame, matrix, recipe, and formula objects are allowed.
     A {cls} was specified.")

  expect_condition(
    apd_hat_values(mtcars$mpg),
    expected_message
  )
})

test_that("`apd_hat_values` fails when matrix has more predictors than samples", {
  bad_data <- mtcars %>%
    slice(1:5)

  expect_snapshot(error = TRUE,
    apd_hat_values(bad_data)
  )
})

test_that("`apd_hat_values` fails when the matrix X^tX is singular", {
  bad_data <- matrix(
    rep(0, 6),
    nrow = 3
  )
  colnames(bad_data) <- c("A", "B")

  expect_snapshot(error = TRUE,
    apd_hat_values(bad_data)
  )
})

test_that("`get_inv` behaves correctly when the input is not a matrix", {
  X <- c(1:5)
  expect_error(get_inv(X), NA)
})
