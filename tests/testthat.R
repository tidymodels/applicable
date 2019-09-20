library(testthat)
library(applicable)

if (requireNamespace("xml2")) {
  test_check("applicable", reporter = MultiReporter$new(reporters = list(JunitReporter$new(file = "test-results.xml"), CheckReporter$new())))
} else {
  test_check("applicable")
}
