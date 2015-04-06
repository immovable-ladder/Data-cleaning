files <- paste0("./implite_rakai/data/",list.files(path = "./implite_rakai/data/"))
names <- gsub(".csv","",list.files(path = "./implite_rakai/data/"))

datadf <- data.frame()

for(i in 1:23){
  data <- read.csv(files[i],stringsAsFactors=FALSE,header=FALSE)
  attribute = matrix(data[1,],ncol=1)
  datadf <- rbind(datadf, cbind(colnames(data),Attribute=attribute,file=rep(names[i])))
  data <- data[-1,]
  assign(names[i],data)
  save(data,file=paste0(names[i],".RData"))
}
colnames(datadf) <- c("Order","Label","File")
datadf2 <- datadf %>%
  separate(Label,c("Label","Unit"), sep = "\\(", extra = "merge") %>%
  separate(Unit,c("Unit","Enumerate"), sep = "see ", extra = "merge") 
datadf2$Unit <- gsub("\\)","", datadf2$Unit)
datadf2$Enumerate <- gsub("\\)","", datadf2$Enumerate)

library(xlsx)
write.xlsx(datadf2,file="Metadata_file.xlsx",row.names=FALSE,showNA = FALSE)
