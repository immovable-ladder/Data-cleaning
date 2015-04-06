df <- read.csv("Metadata - Match.csv", na.strings=c("NA",""),stringsAsFactors=FALSE)

library(dplyr); library(tidyr);library(plyr)
enumerate_q <- df %>%
  filter(is.na(Colname) == FALSE) %>%
  filter(is.na(ValueSet) == FALSE & is.na(Enumerate) == TRUE) %>%
  select(Colname,File,Enumerate,ValueSet,Label)
enumerate_e <- df %>%
  filter(is.na(Colname) == FALSE) %>%
  filter(is.na(Enumerate) != TRUE) %>%
  select(Colname,File,Enumerate,ValueSet,Label)

# replace enumerated value that only appear in enumerate_q (questionnaire)
names(enumerate_q)

for (i in 1:dim(enumerate_q)[1]){
  tryCatch({
    print(paste0("Preparing file ",i,". File name is ",enumerate_q[i,2]))
    file <- paste0(enumerate_q[i,2],".RData")
    load(file)
    col <- enumerate_q[i,1]
    level <- unlist(strsplit(gsub("\\'","", enumerate_q[i,4]),c("\\=|\\,")))
    level <- matrix(level,nrow=length(level)/2,byrow=T)
    data[,col] <- mapvalues(data[,col],from=level[,1],to=level[,2])
    save(data,file=file)
    }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
}
  
# replace enumerated value that only appear in enumerate_e (look up table)
for (i in 1:dim(enumerate_e)[1]){
  tryCatch({
    print(paste0("Preparing file ",i,". File name is ",enumerate_e[i,2], ". Look up file is ",enumerate_e[i,3]))
    file <- paste0(enumerate_e[i,2],".RData")
    load(file)
    col <- enumerate_e[i,1]
    level_doc <- paste0("./implite_rakai/lookup/",enumerate_e[i,3],".csv")
    level <- read.csv(level_doc,stringsAsFactors=F)
    data[,col] <- mapvalues(data[,col],from=as.character(level[,1]),to=as.character(level[,2]))
    save(data,file=file)
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
}
