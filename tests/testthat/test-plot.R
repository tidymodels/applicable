test_that("output of autoplot.apd_pca is correct when no options are provided", {
  ad <- apd_pca(mtcars)
  ad_plot <- ggplot2::autoplot(ad)

  pctls <- ad$pctls %>%
    tidyr::gather(component, value, -percentile)

  expect_equal(ad_plot$data, pctls)
  expect_equal(ad_plot$labels$x, "abs(value)")
  expect_equal(ad_plot$labels$y, "percentile")
})

test_that("output of autoplot.apd_pca is correct when options=matches are provided", {
  ad <- apd_pca(mtcars)
  ad_plot <- ggplot2::autoplot(ad, matches("PC[1-5]"))

  pctls <- ad$pctls %>%
    select(matches("PC[1-5]"), percentile) %>%
    tidyr::gather(component, value, -percentile)

  expect_equal(ad_plot$data, pctls)
  expect_equal(ad_plot$labels$x, "abs(value)")
  expect_equal(ad_plot$labels$y, "percentile")
})

test_that("output of autoplot.apd_pca is correct when options=distance are provided", {
  ad <- apd_pca(mtcars)
  ad_plot <- ggplot2::autoplot(ad, "distance")

  pctls <- ad$pctls %>%
    select(matches("distance"), percentile) %>%
    tidyr::gather(component, value, -percentile)

  expect_equal(ad_plot$data, pctls)
  expect_equal(ad_plot$labels$x, "abs(value)")
  expect_equal(ad_plot$labels$y, "percentile")
})
