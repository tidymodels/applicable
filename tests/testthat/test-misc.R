test_that("`names0` fails if `num` is less than 1", {
  num <- 0
  expect_snapshot(
    error = TRUE,
    names0(num)
  )
})
