## code to prepare `accident_2015.csv.bz2` dataset goes here
accident_2015.csv.bz2<-read.csv("data-raw/accident_2015.csv.bz2")
usethis::use_data(accident_2015.csv.bz2, overwrite = TRUE)
