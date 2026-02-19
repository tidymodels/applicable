test_that("`score_apd_pca_numeric` fails when model has no pcs argument", {
  expect_snapshot(
    error = TRUE,
    score_apd_pca_numeric(mtcars, mtcars)
  )
})

test_that("`score` fails when predictors only contain factors", {
  model <- apd_pca(~., iris)
  expect_snapshot(
    error = TRUE,
    score(model, iris$Species)
  )
})

test_that("`score` fails when predictors are vectors", {
  object <- iris

  expect_snapshot(
    error = TRUE,
    score(object)
  )
})

test_that("`score_apd_pca_numeric` pcs output matches `stats::predict` output", {
  model <- apd_pca(mtcars %>% dplyr::slice(1:15))
  predictors <- as.matrix(mtcars %>% dplyr::slice(16:30))

  expected <- stats::predict(model$pcs, predictors)
  expected <- as.data.frame(expected[, 1:model$num_comp, drop = FALSE])

  # Select columns of the form PC{number}
  actual_output <- score_apd_pca_numeric(model, predictors) %>%
    dplyr::select(dplyr::matches("^PC\\d+$"))

  # Data frame method
  expect_equal(
    ignore_attr = TRUE,
    actual_output,
    expected
  )
})

test_that("`score` pcs output matches `stats::predict` output", {
  model <- apd_pca(mtcars %>% dplyr::slice(1:15))
  predictors <- as.matrix(mtcars %>% dplyr::slice(16:30))

  expected <- stats::predict(model$pcs, predictors)
  expected <- as.data.frame(expected[, 1:model$num_comp, drop = FALSE])

  # Select columns of the form PC{number}
  actual_output <- score(model, predictors) %>%
    dplyr::select(dplyr::matches("^PC\\d+$"))

  # Data frame method
  expect_equal(
    ignore_attr = TRUE,
    actual_output,
    expected
  )
})

test_that("`score_apd_pca_bridge` output is correct", {
  model <- apd_pca(mtcars %>% dplyr::slice(1:15))
  predictors <- as.matrix(mtcars %>% dplyr::slice(16:30))

  expected <- stats::predict(model$pcs, predictors)
  expected <- as.data.frame(expected[, 1:model$num_comp, drop = FALSE])

  # Select columns of the form PC{number}
  actual_output <- score_apd_pca_bridge("numeric", model, predictors) %>%
    dplyr::select(dplyr::matches("^PC\\d+$"))

  # Data frame method
  expect_equal(
    ignore_attr = TRUE,
    actual_output,
    expected
  )
})

test_that("`score_apd_pca_numeric` warns for missing predictor values", {
  model <- apd_pca(mtcars %>% dplyr::slice(1:15))
  predictors <- as.matrix(mtcars %>% dplyr::slice(16:30))
  predictors[1, 1] <- NA_real_

  expect_warning(
    score_apd_pca_numeric(model, predictors),
    "`new_data` contains missing predictor values"
  )
})
