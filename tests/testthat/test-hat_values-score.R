context("hat_values score tests")

test_that("`score_apd_hat_values_numeric` fails when model has no pcs argument", {
  expect_error(
    score_apd_hat_values_numeric(mtcars, mtcars),
    "The model must contain an XtX_inv argument."
  )
})

test_that("`score` fails when predictors only contain factors", {
  model <- apd_hat_values(~., iris)
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
