library(proxyC)
library(Matrix)
library(recipes)
library(ggplot2)

# ------------------------------------------------------------------------------

# simulate a small data set
make_data <- function(p, n, rate = .5) {
  x <- matrix(sample(0:1, size = p * n, prob = rep(rate, 2), replace = TRUE), ncol = p)
  colnames(x) <- paste0("x", 1:p)
  x
}

set.seed(535)
tr_x <- make_data(20, 50)
un_x <- make_data(20, 10)

tr_x_sp <- Matrix(tr_x, sparse = TRUE)
un_x_sp <- Matrix(un_x, sparse = TRUE)

tr_scores <- simil(tr_x_sp, tr_x_sp, method = "jaccard")
un_scores <- simil(tr_x_sp, un_x_sp, method = "jaccard")

mean_tr <- apply(tr_scores, 1, mean)
mean_tab <- as.data.frame(table(mean_tr), stringsAsFactors = FALSE)
mean_tab$mean_tr <- as.numeric(mean_tab$mean_tr)
mean_tab$cumulative <- cumsum(mean_tab$Freq) / 50

# ------------------------------------------------------------------------------

test_that("matrix method - mean similarity", {
  tmp <- apd_similarity(tr_x)
  tmp_scores <- score(tmp, un_x)
  expect_equal(tmp_scores$similarity, apply(un_scores, 2, mean))
  expect_equal(tmp$options, list(method = "jaccard"))
  expect_equal(tmp$ref_data, tr_x_sp)
  expect_equal(mean_tab$mean_tr, tmp$ref_scores$sim)
  expect_equal(mean_tab$Freq, tmp$ref_scores$n)
  expect_equal(mean_tab$cumulative, tmp$ref_scores$cumulative)
})

test_that("data frame method - quantile similarity", {
  tmp <- apd_similarity(tr_x, quantile = .1)
  tmp_scores <- score(tmp, un_x)
  expect_equal(tmp_scores$similarity, apply(un_scores, 2, quantile, probs = .1))
})

test_that("formula method - mean similarity", {
  sim_form <- as.formula(" ~.")
  tmp <- apd_similarity(sim_form, tr_x)
  tmp_scores <- score(tmp, un_x)
  expect_equal(tmp_scores$similarity, apply(un_scores, 2, mean))
  expect_equal(tmp$options, list(method = "jaccard"))
  expect_equal(tmp$ref_data, tr_x_sp)
  expect_equal(mean_tab$mean_tr, tmp$ref_scores$sim)
  expect_equal(mean_tab$Freq, tmp$ref_scores$n)
  expect_equal(mean_tab$cumulative, tmp$ref_scores$cumulative)
})

# ------------------------------------------------------------------------------

test_that("data frame method - mean similarity", {
  tmp <- apd_similarity(as.data.frame(tr_x))
  tmp_scores <- score(tmp, as.data.frame(un_x))
  expect_equal(tmp_scores$similarity, apply(un_scores, 2, mean))
  expect_equal(tmp$options, list(method = "jaccard"))
  expect_equal(tmp$ref_data, tr_x_sp)
  expect_equal(mean_tab$mean_tr, tmp$ref_scores$sim)
  expect_equal(mean_tab$Freq, tmp$ref_scores$n)
  expect_equal(mean_tab$cumulative, tmp$ref_scores$cumulative)
})


test_that("matrix method - quantile similarity", {
  tmp <- apd_similarity(as.data.frame(tr_x), quantile = .1)
  tmp_scores <- score(tmp, as.data.frame(un_x))
  expect_equal(tmp_scores$similarity, apply(un_scores, 2, quantile, probs = .1))
})

test_that("formula method - quantile similarity", {
  sim_form <- as.formula(" ~.")
  tmp <- apd_similarity(sim_form, tr_x, quantile = .1)
  tmp_scores <- score(tmp, as.data.frame(un_x))
  expect_equal(tmp_scores$similarity, apply(un_scores, 2, quantile, probs = .1))
})

# ------------------------------------------------------------------------------

test_that("recipe method - mean similarity", {
  rec <-
    recipe(~., data = as.data.frame(tr_x)) %>%
    step_zv(all_predictors())
  tmp <- apd_similarity(rec, as.data.frame(tr_x))
  tmp_scores <- score(tmp, as.data.frame(un_x))
  expect_equal(tmp_scores$similarity, apply(un_scores, 2, mean))
  expect_equal(tmp$options, list(method = "jaccard"))
  expect_equal(tmp$ref_data, tr_x_sp)
  expect_equal(mean_tab$mean_tr, tmp$ref_scores$sim)
  expect_equal(mean_tab$Freq, tmp$ref_scores$n)
  expect_equal(mean_tab$cumulative, tmp$ref_scores$cumulative)
})


test_that("matrix method - quantile similarity", {
  rec <-
    recipe(~., data = as.data.frame(tr_x)) %>%
    step_zv(all_predictors())
  tmp <- apd_similarity(rec, as.data.frame(tr_x), quantile = .1)
  tmp_scores <- score(tmp, as.data.frame(un_x))
  expect_equal(tmp_scores$similarity, apply(un_scores, 2, quantile, probs = .1))
})

# ------------------------------------------------------------------------------

test_that("bad args", {
  expect_snapshot(error = TRUE,
    apd_similarity(tr_x, quantile = 2)
  )
  expect_snapshot(error = TRUE,
    apd_similarity(tr_x_sp)
  )
})

# ------------------------------------------------------------------------------

test_that("printed output", {
  expect_snapshot(print(apd_similarity(tr_x)))
  expect_snapshot(print(apd_similarity(tr_x)))
  expect_snapshot(print(apd_similarity(tr_x)))
  expect_snapshot(print(apd_similarity(tr_x, quantile = .13)))
})
# ------------------------------------------------------------------------------

test_that("plot output", {
  ad <- apd_similarity(tr_x)
  ad_plot <- autoplot(ad)
  expect_equal(ad_plot$data, ad$ref_scores)
  expect_equal(ad_plot$labels$x, "mean similarity (training set)")
  expect_equal(ad_plot$labels$y, "Cumulative Probability")
})

# ------------------------------------------------------------------------------

test_that("apd_similarity fails when quantile is neither NA nor a number in [0, 1]", {

  expect_snapshot(error = TRUE,
    apd_similarity(tr_x, quantile = -1)
  )

  expect_snapshot(error = TRUE,
    apd_similarity(tr_x, quantile = 3)
  )

  expect_snapshot(error = TRUE,
    apd_similarity(tr_x, quantile = "la")
  )
})

# ------------------------------------------------------------------------------

test_that("apd_similarity outputs warning with zero variance variables ", {
  bad_data <- list(
    "a" = c(0, 0),
    "b" = c(0, 0),
    "c" = c(1, 1),
    "d" = c(0, 0)
  )
  bad_data <- as.data.frame(bad_data)

  expect_snapshot(
    apd_similarity(bad_data)
  )
})

# ------------------------------------------------------------------------------

test_that("apd_similarity fails when all the variables have zero variance", {
  bad_data <- list(
    "a" = c(0, 0),
    "b" = c(0, 0),
    "d" = c(0, 0)
  )
  bad_data <- as.data.frame(bad_data)

  expect_snapshot(error = TRUE,
    apd_similarity(bad_data)
  )
})

# ------------------------------------------------------------------------------

test_that("apd_similarity fails data is not binary", {
  bad_data <- list(
    "a" = c(0, 0),
    "b" = c(1, 3),
    "c" = c(1, 1),
    "d" = c(2, 0)
  )
  bad_data <- as.data.frame(bad_data)

  expect_snapshot(error = TRUE,
    apd_similarity(bad_data)
  )
})
