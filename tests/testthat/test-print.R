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
