library(ggplot2)

test_that("output of autoplot.apd_pca is correct when no options is provided", {
  ad <- apd_pca(mtcars)
  ad_plot <- autoplot(ad)

  pctls <- ad$pctls %>%
    tidyr::gather(component, value, -percentile)

  expect_equal(ad_plot$data, pctls)
  expect_equal(ad_plot$labels$x, "value")
  expect_equal(ad_plot$labels$y, "percentile")
})
