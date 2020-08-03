
<!-- README.md is generated from README.Rmd. Please edit that file -->

# FARS2

<!-- badges: start -->

<!-- badges: end -->

This is an assignment for the Course 3 : Building R Packages. 
The goal of FARS\_functions is to analyze FARS data

## Installation

You can install the released version of FARS\_functions from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("FARS2")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(FARS2)
library(maps)
fars_2013_fn <- make_filename(2013)
fars_2013 <- fars_read(fars_2013_fn) 
dim(fars_2013)
```

