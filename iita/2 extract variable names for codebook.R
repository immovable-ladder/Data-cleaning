setwd("C:/Users/Hannacamp/Documents/aWhere 2015/Data/IITA/HT baseline DRC")
library(readstata13)

files <- paste0('./HT baseline DRC/', list.files(pattern = '.dta','./HT baseline DRC/'))

names <- list.files(pattern = '.dta','./HT baseline DRC/')
names <- gsub(".dta", "", names)

codebook1 <- data.frame()

for(i in 1:length(files)){
  t <- read.dta13(files[i])
  a <- data.frame(rep(names[i]),names(t), rep(NA), rep(NA), rep(NA), rep(NA), rep(NA))
  colnames(a) <- c('datafile', 'variable_old', 'variable_new', 'question', 'unit', 'module','grouping')
  codebook1 <- rbind(codebook1, a)
  assign(names[i],t)
  filepath = paste0('./HT baseline DRC/', names[i], '.dta')
  save(list = (names[i]), file = filepath)
  rm(a,t)
}

write.xlsx(codebook1, "./codebook.xlsx", row.names = F, showNA=F)
