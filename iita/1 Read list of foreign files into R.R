setwd("C:/Users/Hannacamp/Documents/aWhere 2015/Data/IITA/HT baseline DRC")

install.packages("readstata13")
library <- c("reshape2", "foreign", "dplyr","readstata13")
lapply(library, library, character.only = T)

rm(library)

# find the data file in directory
files <- list.files(pattern = ".dta")
fnames <- gsub(".dta", "", files)
b = length(files)

# load the file in the environment
for (i in 1:b){
  a <- read.dta13(files[i])
  a <- tbl_df(a)
  assign(fnames[i], a)
  rm(a)
}