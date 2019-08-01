context("pca score tests")

test_that("`score_apd_pca_numeric` fails when model has no pcs argument", {
  expect_error(
    score_apd_pca_numeric(mtcars, mtcars),
    "The model must contain a pcs argument."
  )
})

test_that("`score` fails when predictors only contain factors", {
  model <- apd_pca(~., iris)
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

test_that("`score_apd_pca_numeric` pcs output matches `stats::predict` output", {
  model <- apd_pca(mtcars %>% dplyr::slice(1:15))
  predictors <- as.matrix(mtcars %>% dplyr::slice(16:30))

  expected <- stats::predict(model$pcs, predictors)
  colnames(expected) <- applicable:::names0(ncol(expected), "PC")

  # Select columns of the form PC{number}
  actual_output <- score_apd_pca_numeric(model, predictors) %>%
    dplyr::select(dplyr::matches("^PC\\d+$"))

  # Data frame method
  expect_equivalent(
    actual_output,
    expected
  )
})
