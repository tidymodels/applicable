test_that("`new_apd_di` arguments are assigned correctly", {
  x <- new_apd_di(
    "training",
    "importance",
    "sds",
    "means",
    "d_bar",
    "aoa_threshold",
    blueprint = hardhat::default_xy_blueprint()
  )

  expect_equal(names(x), c("training", "importance", "sds", "means", "d_bar", "aoa_threshold", "blueprint"))
  expect_equal(x$training, "training")
  expect_equal(x$importance, "importance")
  expect_equal(x$sds, "sds")
  expect_equal(x$means, "means")
  expect_equal(x$d_bar, "d_bar")
  expect_equal(x$aoa_threshold, "aoa_threshold")
  expect_equal(x$blueprint, hardhat::default_xy_blueprint())
})

test_that("training is provided", {
  expect_snapshot(error = TRUE,
    new_apd_di(blueprint = hardhat::default_xy_blueprint())
  )
})

test_that("`new_apd_di` fails when blueprint is numeric", {
  expect_snapshot(error = TRUE,
    new_apd_di(oranges, blueprint = 1)
  )
})

test_that("`new_apd_di` returned blueprint is of class hardhat_blueprint", {
  x <- new_apd_di(
    "training",
    "importance",
    "sds",
    "means",
    "d_bar",
    "aoa_threshold",
    blueprint = hardhat::default_xy_blueprint()
  )

  expect_s3_class(x$blueprint, "hardhat_blueprint")
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

test_that("`apd_di` is properly classed", {
  model <- apd_di(y ~ ., train, test, importance)
  expect_s3_class(model, "apd_di")
  expect_s3_class(model, "hardhat_model")
})


test_that("`apd_di` is not defined for vectors", {
  cls <- class(mtcars$mpg)[1]
  expected_message <- glue::glue("`x` is not of a recognized type.
     Only data.frame, matrix, recipe, and formula objects are allowed.
     A {cls} was specified.")

  expect_condition(
    apd_di(mtcars$mpg),
    expected_message
  )
})

test_that("`apd_di` finds 0 distance between identical data", {

  expect_equal(
    apd_di(y ~ ., train, train, importance)$aoa_threshold,
    0
  )

})

test_that("`apd_di` works with or without a validation set", {

  expect_error(
    apd_di(y ~ ., train, test, importance),
    NA
  )

  expect_error(
    apd_di(y ~ ., train, importance = importance),
    NA
  )

})

test_that("`apd_di` methods are equivalent", {

  methods <- list(
    apd_di(y ~ ., train, test, importance),
    apd_di(train[2:11], test[2:11], importance),
    apd_di(as.matrix(train[2:11]), as.matrix(test[2:11]), importance)
  )

  expect_identical(
    methods[[1]]$aoa_threshold,
    methods[[2]]$aoa_threshold
  )

  expect_identical(
    methods[[2]]$aoa_threshold,
    methods[[3]]$aoa_threshold
  )

})

test_that("`apd_di` can handle different column orders", {

  expect_identical(
    apd_di(train[2:11], test[2:11], importance)$aoa_threshold,
    apd_di(train[2:11], test[11:2], importance)$aoa_threshold
  )

  expect_identical(
    apd_di(train[2:11], test[2:11], importance)$aoa_threshold,
    apd_di(train[11:2], test[2:11], importance)$aoa_threshold
  )

})
