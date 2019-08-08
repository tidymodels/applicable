context("hat_values score tests")

test_that("`score_apd_hat_values_numeric` fails when model has no pcs argument", {
  expect_error(
    score_apd_hat_values_numeric(mtcars, mtcars),
    "The model must contain an XtX_inv argument.",
    fixed = TRUE
  )
})

test_that("`score` fails when predictors only contain factors", {
  model <- apd_hat_values(~., iris)
  expect_error(
    score(model, iris$Species),
    "The class of `new_data`, 'factor', is not recognized.",
    fixed = TRUE
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
    message,
    fixed = TRUE
  )
})

test_that("`score_apd_hat_values_numeric` pcs output matches `stats::predict` output", {
  model <- apd_hat_values(mtcars %>% dplyr::slice(1:15))
  predictors <- as.matrix(mtcars %>% dplyr::slice(16:30))

  expected <- score(model, predictors)

  proj_matrix <- predictors %*% model$XtX_inv %*% t(predictors)
  hat_values <- diag(proj_matrix)
  actual_output <- score_apd_hat_values_numeric(model, predictors)

  # Data frame method
  expect_equivalent(
    actual_output,
    expected
  )
})
