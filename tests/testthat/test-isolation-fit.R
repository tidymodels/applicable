library(recipes)

test_that("model fitting for isolation forests", {
  skip_if_not_installed("isotree")

  data(cells, package = "modeldata")

  cells_tr <- cells |> filter(case == "Train") |> select(-case, -class)
  cells_te <- cells |> filter(case != "Train") |> select(-case, -class)

  rec <-
    recipe(~ ., data = cells_tr) |>
    step_pca(all_predictors(), num_comp = 2)

  expect_no_error(
    res_df <- apd_isolation(cells_tr, ntrees = 10, nthreads = 1),
  )
  expect_no_error(
    res_1d <- apd_isolation(cells_tr |> dplyr::select(1),
                            ntrees = 10, nthreads = 1, ndim = 1)
  )
  expect_equal(res_1d$model$params$ndim, 1)
  expect_no_error(
    res_rec <- apd_isolation(rec, cells_tr, ntrees = 10, nthreads = 1, ndim = 2),
  )
  expect_equal(res_rec$model$params$ndim, 2)
  expect_no_error(
    res_formula <- apd_isolation(~ ., data = cells_tr, ntrees = 10, nthreads = 1)
  )
  expect_s3_class(res_formula, "apd_isolation")
  expect_no_error(apd_isolation(as.matrix(cells_tr), ntrees = 10, nthreads = 1))
  expect_error(
    apd_isolation(print),
    class = "rlang_error",
    regexp = "is not of a recognized type"
  )
  expect_no_error(applicable:::check_isotree())
  expect_snapshot(print(res_df))
})
