context("test-pca-score")

test_that("`score` fails when predictors are factors", {
  model <- ad_pca(~., iris)
  expect_error(
    score(model, iris$Species),
    "The class of `new_data`, 'factor', is not recognized."
  )
})
