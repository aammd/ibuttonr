library(ibuttonr)
context("reading data")

test_that("ibuttonr reads data correctly", {
  data <- system.file("extdata","12a.csv", package = "ibuttonr")

  expect_equal(get_preamble_length(data), 14)

  expect_equal(header_names(data), c("Date/Time", "Unit", "Value"))
})