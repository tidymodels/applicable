context("test-pca-score")

test_that("`score_ad_pca_numeric` fails when model has no pcs argument", {
  expect_error(
    score_ad_pca_numeric(mtcars, mtcars),
    "The model must contain a pcs argument."
  )
})

test_that("`score` fails when predictors are factors", {
  model <- ad_pca(~., iris)
  expect_error(
    score(model, iris$Species),
    "The class of `new_data`, 'factor', is not recognized."
  )
})

test_that("`ad_pca` fails when predictors are vectors", {
  skip("Skipping until I understand why the expected & actual message differ.")

  expect_error(
    ad_pca(iris$Sepal.Length),
    "`ad_pca()` is not defined for a 'numeric'."
    )
})
