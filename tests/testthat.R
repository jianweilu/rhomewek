library(testthat)
library(FARS2)

expect_that(dim(accident_2013.csv.bz2)[1], equals(30202))
