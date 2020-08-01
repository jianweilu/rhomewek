## code to prepare `accident_2013.csv.bz2` dataset goes here
accident_2013.csv.bz2<-read.csv("data-raw/accident_2013.csv.bz2")
usethis::use_data(accident_2013.csv.bz2, overwrite = TRUE)
