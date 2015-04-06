setwd("C:/Users/Hannacamp/Documents/aWhere 2015/Data/Impact Lite Rakai")
library(plyr)
library(xlsx)

# list files containing codes and create enumerated value codebook
evfiles <- list.files(pattern='lkp','./')
evfnames <- gsub(".csv","",evfiles)
c=length(evfiles)
evcodes <- data.frame()

for(i in 1:c){
  a <- read.csv(evfiles[i])
  a[,3] <- rep(evfnames[i])
  names(a) <- c("Field_code","Field_desc","File_name")
  evcodes <- rbind.fill(evcodes,a[,1:3])
  rm(a)
}

write.xlsx(evcodes, "./evcodebook.xlsx", row.names = F, showNA=F)

# remove raw code files from environment
rm(list=evfnames)