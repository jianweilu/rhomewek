## code to prepare `accident_2014.csv.bz2` dataset goes here
accident_2014.csv.bz2<-read.csv("data-raw/accident_2014.csv.bz2")
usethis::use_data(accident_2014.csv.bz2, overwrite = TRUE)
