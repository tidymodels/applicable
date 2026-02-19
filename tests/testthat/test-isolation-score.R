library(recipes)

test_that("scoring isolation forests", {
  skip_if_not_installed("isotree")
  data(cells, package = "modeldata")

  cells_tr <- cells %>% filter(case == "Train") %>% select(-case, -class)
  cells_te <- cells %>% filter(case != "Train") %>% select(-case, -class)

  res_df <- apd_isolation(cells_tr, ntrees = 10, nthreads = 1)
  expect_error(
    score_te  <- score(res_df, cells_te),
    regexp = NA
  )

  expect_true(identical(names(score_te), c("score", "score_pctl")))
  expect_true(inherits(score_te, "tbl_df"))
  expect_equal(nrow(score_te), nrow(cells_te))
  raw_res <- unname(predict(res_df$model, cells_te))
  expect_equal(raw_res, score_te$score)
})
