library(xlsx)
load("~/aWhere 2015/Data/Impact Lite Rakai/mainsurveyinfo.RData")
metadata <- read.xlsx("Template - Metadata only.xlsx", sheetName = "MetaData", 
                      startRow =40, endRow = 53, colIndex = c(1:5), header = FALSE)
metadata <- data.frame(sapply( metadata, as.character ), stringsAsFactors = FALSE)

# generate datamap for metadata
library(dplyr)
library(gdata)
metadata2 <- metadata[,c(5,2,4,1)]
colnames(metadata2) <- c("Folder", "Attribute", "Unit","Name")
# metadata2 <- rbind(c("Folder", "Attribute", "Unit"), metadata2)
library(tidyr)
metadata3 <- metadata2 %>%
  separate(Folder,into = c("Folder1", "Folder2"),
           extra = "merge", sep = "/")
metadata3 <- arrange(metadata3, Folder1, Folder2)
metadata4 <- rbind(c("Folder1", "Folder2","Attribute", "Unit","Name"), metadata3)
write.fwf(metadata4[,c(1:4)], "metadata3.txt", colnames = FALSE)

library(psych)
data2 <- data[, c(2:19)]
output <- psych::describe(data2)
output <- cbind(metadata$X2, output)
output <- rbind(colnames(output), output)
write.fwf(output, "output.txt", rownames=FALSE, colnames = FALSE)


library(reshape)
library(ggplot2)

colnames(data2) <- metadata3$Attribute
data3 <- melt(data2)

barplot(data2[,2],data2[,3])

jpeg(filename = "plot1.jpg", width = 1000, height = 1000, bg = "transparent")
ggplot(data3, aes(x = variable, y = value)) + 
  geom_violin( ) +
  geom_jitter(height = 3, weidth = 2, aes(color=variable)) + xlab("Attribute") + ylab("Price") +
  theme(legend.position = "none", legend.direction = "vertical", legend.key = element_rect("transparent"), 
        axis.text.x = element_text(hjust = 0, angle = -30),
        panel.background = element_rect("transparent"))
dev.off()

library(Amelia)
missmap(data2)
