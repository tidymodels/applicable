context("test-pca-score")

test_that("`score_ad_pca_numeric` fails when model has no pcs argument", {
  expect_error(
    score_ad_pca_numeric(mtcars, mtcars),
    "The model must contain a pcs argument."
  )
})

test_that("`score` fails when predictors only contain factors", {
  model <- ad_pca(~., iris)
  expect_error(
    score(model, iris$Species),
    "The class of `new_data`, 'factor', is not recognized."
  )
})

test_that("`score` fails when predictors are vectors", {
  object <- iris
  cls <- class(object)[1]
  message <-
    "`object` is not of a recognized type.
     Only data.frame, matrix, recipe, and formula objects are allowed.
     A {cls} was specified."
  message <- glue::glue(message)

  expect_error(
    score(object),
    message
  )
})

test_that("`score_ad_pca_numeric` output matches `stats::predict` output", {
  model <- ad_pca(mtcars)
  predictors <- as.matrix(mtcars)
  expected <- stats::predict(model$pcs, predictors)

  # Data frame method
  expect_equivalent(
    score_ad_pca_numeric(model, predictors),
    expected
  )
})
