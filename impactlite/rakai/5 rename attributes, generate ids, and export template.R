library(xlsx)
df <- read.csv("Metadata - Match.csv", na.strings=c("NA",""),stringsAsFactors=FALSE)
file <- list.files(pattern=".RData")
name <- gsub(".RData","",file)
namexlsx <- gsub(".RData",".xlsx",file)
HHID <- data.frame()

for(i in 7:length(file)){
  print(paste0("Prepare file ",i))
  f <- file[i]
  load(f)
  newdf <- df %>%
    filter(File == name[i]) %>%
    filter(is.na(Name) == FALSE)
  cols <- newdf[,"Colname"]
  coln <- newdf[,"Name"]
  data <- data[,cols]
  colnames(data) <- coln
  HHID <- rbind(HHID,data["HH_ID"])
  save(data,file=f)
  write.xlsx2(data,file=namexlsx[i],sheetName=name[i],row.names=FALSE,showNA=FALSE)
}

# extract HH_ID
HHID <- distinct(HHID,HH_ID)

write.xlsx(HHID,file="HHID.xlsx",row.names=FALSE,showNA=FALSE)
