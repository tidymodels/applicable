test_that("print wording for `apd_pca` is correct", {
  x1 <- apd_pca(~Sepal.Length, iris)

  expect_snapshot(
    print(x1)
  )

  x2 <- apd_pca(~ Sepal.Length + Sepal.Width, iris)

  expect_snapshot(
    print(x2)
  )
})

test_that("print for `apd_pca` displays correct threshold", {
  threshold <- 0.72
  x <- apd_pca(~Sepal.Length, iris, threshold)
  percentage <- capture.output(x)
  percentage <- regmatches(
    percentage,
    regexpr("(\\d+)%", percentage)
  )

  expected_output <- threshold * 100
  expected_output <- paste0(expected_output, "%")

  expect_equal(
    percentage,
    expected_output
  )
})

test_that("print for apd_hat_values work as expected", {
  x <- apd_hat_values(mtcars)

  expect_snapshot(
    print(x)
  )
})
