context('testing helper function `names0`')

test_that("`names0` fails if `num` is less than 1", {
  num <- 0
  expect_error(
    names0(num),
    message = "NA/NaN argument
    In addition: Warning message:
    In format(1:num) : NAs introduced by coercion")
})
