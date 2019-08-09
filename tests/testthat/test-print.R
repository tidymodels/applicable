context("testing print functions")

test_that("print wording for `apd_pca` is correct", {
  x1 <- apd_pca(~ Sepal.Length, iris)

  expect_known_output(
    print(x1),
    test_path("out/print-apd_pca-one-comp.txt")
  )

  x2 <- apd_pca(~ Sepal.Length + Sepal.Width, iris)

  expect_known_output(
    print(x2),
    test_path("out/print-apd_pca-more-comp.txt")
  )
})

test_that("print for `apd_pca` displays correct threshold", {
  threshold <- 0.72
  x <- apd_pca(~ Sepal.Length, iris, threshold)
  percentage <- capture.output(x)
  percentage <- regmatches(percentage,
                           regexpr("(\\d+)%", percentage))

  expected_output <- threshold * 100
  expected_output <- paste0(expected_output, '%')

  expect_equal(
    percentage,
    expected_output
  )
})

test_that("print for apd_hat_values work as expected", {
  x <- apd_hat_values(mtcars)

  expect_known_output(
    print(x),
    test_path("out/print-apd_hat_values.txt")
  )
})
