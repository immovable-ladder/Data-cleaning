library(readstata13)
a <- read.dta13("./data/HH_compostion_characteristic.dta")

library(stringr)
library(tidyr)
locations <- a[,c(4,15:16)]
locations_o <- a[,c(4,15:16)]
locations$Latitude <- gsub(" ","",locations$Latitude)
locations$Latitude <- gsub("\\.","",locations$Latitude,perl=TRUE)
locations$Latitude <- gsub("\\'","",locations$Latitude,perl=TRUE)
locations$Latitude[427] <- "02158700"
locations$Latitude[352] <- "2162677"
locations$Latitude <- gsub("^0","",locations$Latitude,perl=TRUE)
locations$Latitude <- str_pad(locations$Latitude, side = "right", width = 10, pad = "0")

locations$longtitude <- gsub(" ","",locations$longtitude)
locations$longtitude <- gsub("\\.","",locations$longtitude,perl=TRUE)
locations$longtitude <- gsub("\\'","",locations$longtitude,perl=TRUE)
locations$longtitude[352] <- "028529629"
locations$longtitude <- gsub("^0","",locations$longtitude,perl=TRUE)
locations$longtitude <- str_pad(locations$longtitude, side = "right", width = 10, pad = "0")
locations$longtitude

s_latitude <- t(sapply(locations$Latitude, function(x) substring(x, first=c(1,2,4), last=c(1,3,10))))
s_longtitude <- t(sapply(locations$longtitude, function(x) substring(x, first=c(1,3,4), last=c(2,4,10))))

s_latitude <- as.data.frame(s_latitude, stringsAsFactors = FALSE)
s_longtitude <- as.data.frame(s_longtitude, stringsAsFactors = FALSE)
colnames(s_latitude) <- c("lat_d","lat_m","lat_o")
colnames(s_longtitude) <- c("lon_d","lon_m","lon_o")

library(dplyr)
s_latitude <- data.frame(sapply( s_latitude, as.numeric ), stringsAsFactors = FALSE)
s_longtitude <- data.frame(sapply( s_longtitude, as.numeric ), stringsAsFactors = FALSE)

s_latitude <- s_latitude %>%
  mutate(lat_decimal = (-1)*(lat_d + lat_m / 60))
s_longtitude <- s_longtitude %>%
  mutate(lon_decimal = lon_d + lon_m / 60)

locations <- cbind(locations,s_latitude,s_longtitude)
locations <- merge(locations_o,locations , by = "Village_Sun_colline", all.y=TRUE)

write.csv(locations, "locations.csv", row.names=F)

