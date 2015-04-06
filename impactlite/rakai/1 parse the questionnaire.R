library(XML)
xmlPath <- "./Rakai/CCAFS_Survey.xml"
doc <- xmlTreeParse(xmlPath, useInternal = TRUE)
rootNode <- xmlRoot(doc)

# parse different models
module <- xpathSApply(rootNode, "//Record")
modf <- matrix(ncol=2,nrow=19)
colnames(modf) <- c("Name","Module")
for (i in 1:19){
  modf[i,1] <- xmlValue(module[[i]][["Items"]][["Item"]][["Name"]])
  modf[i,2] <- xmlValue(module[[i]][["Label"]])
}

# parse single questionnaire
question <- xpathSApply(rootNode, "//Item")

# the first element of a list is the question
df <- matrix(ncol=8,nrow=248)
colnames(df) <- c("Label","Name","Start","Len","ItemType","ZeroFill","ValueSet","Order")
for(i in 1:248){
  df[i,1] <- xmlValue(question[[i]][["Label"]])
  df[i,2] <- xmlValue(question[[i]][["Name"]])
  df[i,3] <- xmlValue(question[[i]][["Start"]])
  df[i,4] <- xmlValue(question[[i]][["Len"]])
  df[i,5] <- xmlValue(question[[i]][["ItemType"]])
  df[i,6] <- xmlValue(question[[i]][["ZeroFill"]])
  value <- question[[i]][["ValueSet"]][["ValueSetValues"]]
  size <- xmlSize(value)
  list <- list()
  df[i,7] <- ifelse(size == 0, 
                    "NA",
                    do.call("paste", c(lapply(1:size,function(j){xmlValue(value[[j]])}), sep = "&"))
                    )
  df[i,8] <- i
}

# merge the questionnaire
q.df <- merge(modf,df,by="Name",all=TRUE,sort=FALSE)

# extract enumerated values
library(dplyr)
en.df <- q.df %>%
  filter(ValueSet!="NA")
non.df <- q.df %>%
  filter(ValueSet=="NA")
en.df$ValueSet <- gsub(" ","",en.df$ValueSet)
en.df$ValueSet <- gsub("'","",en.df$ValueSet)
en.df$ValueSet <- gsub("^","'",en.df$ValueSet)
en.df$ValueSet <- gsub("$","'",en.df$ValueSet)
en.df$ValueSet <- gsub("\\|","'='",en.df$ValueSet)
en.df$ValueSet <- gsub("\\&","','",en.df$ValueSet)

df <- rbind(en.df,non.df)

library(tidyr)
df <- df %>%
  separate(Label,c("Label","Unit"), sep = "\\(", extra = "merge")
df$Unit[1:91] <- "Text"
df$Unit <- gsub("\\)","", df$Unit)

library(xlsx)
write.xlsx(df,file="Metadata.xlsx",row.names=FALSE,showNA = FALSE)
