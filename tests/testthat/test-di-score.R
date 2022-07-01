test_that("`score_apd_di_numeric` fails when model has no pcs argument", {
  expect_snapshot(error = TRUE,
                  score_apd_di_numeric(mtcars, mtcars)
  )
})

skip_if_not(rlang::is_installed("vip"))
train <- vip::gen_friedman(1000, seed = 101)
test <- train[701:1000, ]
train <- train[1:700, ]

pp <- ppr(y ~ ., data = train, nterms = 11)
importance <- vip::vi_permute(
  pp,
  target = "y",
  metric = "rsquared",
  pred_wrapper = predict
)
aoa <- apd_di(y ~ ., train, test, importance)

test_that("normal use", {

  expect_snapshot(
    score(aoa, test)
  )

  expect_snapshot(
    score(aoa, train)
  )

})
