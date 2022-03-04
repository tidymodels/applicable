test_that("`score_apd_hat_values_numeric` fails when model has no pcs argument", {
  expect_snapshot(error = TRUE,
    score_apd_hat_values_numeric(mtcars, mtcars)
  )
})

test_that("`score` fails when predictors only contain factors", {
  model <- apd_hat_values(~., iris)
  expect_snapshot(error = TRUE,
    score(model, iris$Species)
  )
})

test_that("`score` fails when predictors are vectors", {
  object <- iris

  expect_snapshot(error = TRUE,
    score(object)
  )
})

test_that("`score` calculated hat_values are correct", {
  model <- apd_hat_values(mtcars %>% dplyr::slice(1:15))
  predictors <- as.matrix(mtcars %>% dplyr::slice(16:30))

  proj_matrix <- predictors %*% model$XtX_inv %*% t(predictors)
  expected <- diag(proj_matrix)

  actual_output <- score(model, predictors)
  actual_output <- actual_output$hat_values

  # Data frame method
  expect_equal(ignore_attr = TRUE,
    actual_output,
    expected
  )
})
