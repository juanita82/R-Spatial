## Distances and duration using real-time data from Google maps

## Names space ##
library(rgdal) # For importing shapefile
library(rgeos) # For finding centroids
library(stplanr) # Complementary functions

setwd("C:/Users/juanita82/Dropbox/R-Course/data/")
neigh <- readOGR(dsn = "Super_Neighborhoods", layer = "Super_Neighborhoods")
cents = gCentroid(neigh, byid = T)

odf = points2odf(cents)
# defining departure time
brtime = as.POSIXct(strptime("2017-06-14 7:00:00", format = "%Y-%m-%d %H:%M:%S"))

data<-as.data.frame(1:88)
cents_d<-SpatialPointsDataFrame(cents, data=data)
# function to draw a line between starting and end points
l = od2line(flow = odf, zones = cents_d)

l@data[3:7] = NA
names(l@data)[names(l@data) == "V3"] <- "from_addresses"
class(l$from_addresses) = "character"
names(l@data)[names(l@data) == "V4"] <- "to_addresses"
class(l$to_addresses) = "character"
names(l@data)[names(l@data) == "V5"] <- "distances"
class(l$distances) = "numeric"
names(l@data)[names(l@data) == "V6"] <- "duration"
class(l$duration) = "numeric"
names(l@data)[names(l@data) == "V7"] <- "fare"
l$fare = NA

# loop to grab information from Google routing API (try for first 5)
for(i in 1:5){
  flag <- TRUE
  tryCatch({
    dists = dist_google(line2points(l[i,])[1,], line2points(l[i,])[2,],
                        mode = "driving", arrival_time = brtime)
    l$from_addresses[i] = as.character(dists$from_addresses)
    l$to_addresses[i] = as.character(dists$to_addresses)
    l$distances[i] = dists$distances
    l$duration[i] = dists$duration
    l$fare[i] = dists$fare
  },
  error=function(e) flag<<-FALSE
  )
  if (!flag) next
}

