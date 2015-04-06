setwd("C:/Users/Hannacamp/Documents/GitHub/iita/")
source("https://raw.githubusercontent.com/yizhexu/data-cleaning/master/survey-cleaning/function.R")

im <- read.csv("C:/Users/Hannacamp/Documents/GitHub/iita/PartAbook.csv",header=TRUE, stringsAsFactors=FALSE)
newname <- unique(im[,7])
PartA <- compile(newname, 1)

im <- read.csv("C:/Users/Hannacamp/Documents/GitHub/iita/PartBbook.csv",header=TRUE, stringsAsFactors=FALSE)
newname <- unique(im[,7])
PartB <- compile(newname, 1)

write.xlsx(PartA,"./PartA.xlsx",sheetName=PartA,row.names=FALSE,showNA=FALSE)
write.xlsx(PartB,"./PartB.xlsx",sheetName=PartA,row.names=FALSE,showNA=FALSE)
