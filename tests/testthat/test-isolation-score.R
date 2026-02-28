library(recipes)

test_that("scoring isolation forests", {
  skip_if_not_installed("isotree")
  data(cells, package = "modeldata")

  cells_tr <- cells |> filter(case == "Train") |> select(-case, -class)
  cells_te <- cells |> filter(case != "Train") |> select(-case, -class)

  res_df <- apd_isolation(cells_tr, ntrees = 10, nthreads = 1)
  expect_no_error(score_te  <- score(res_df, cells_te))

  expect_true(identical(names(score_te), c("score", "score_pctl")))
  expect_true(inherits(score_te, "tbl_df"))
  expect_equal(nrow(score_te), nrow(cells_te))
  raw_res <- unname(predict(res_df$model, cells_te))
  expect_equal(raw_res, score_te$score)
})

test_that("isolation score percentiles clamp to 100 for extreme scores", {
  skip_if_not_installed("isotree")

  mod <- apd_isolation(iris[, 1:4], nthreads = 1)
  new_data <- tibble::tibble(
    Sepal.Length = 1e9,
    Sepal.Width = 1e9,
    Petal.Length = 1e9,
    Petal.Width = 1e9
  )

  res <- score(mod, new_data)
  expect_equal(res$score_pctl, 100)
})
