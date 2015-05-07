library(ibuttonr)
context("reading data")

test_that("ibuttonr reads data correctly", {
  data <- system.file("extdata","12a.csv", package = "ibuttonr")

  expect_equal(get_preamble_length(data), 14)

  expect_equal(header_names(data), c("Date/Time", "Unit", "Value"))

  ibut <- read_named_ibutton(data)
  expect_equal(class(ibut), "data.frame")

  foldername <- gsub(x = data, pattern = "12a.csv", replacement = "")

  ibutlist <- read_ibutton_folder(foldername)

  expect_equal(class(ibutlist), "list")

  expect_equal(length(ibutlist), 1)
  # name of list element
  expect_equal(names(ibutlist), "12a")
  # name of columns
  expect_equal(names(ibutlist[[1]]), c("ibutton", "Date.Time", "Unit", "Value"))

})