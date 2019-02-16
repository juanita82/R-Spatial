## Introduction to the analysis of spatial data using R
# Practical exercises, Chapter 3

## For the following quesitons, use the crime dataset available from the ggmap package. 

## 1) Create a new data set subsetting the crime database to keep only crimes with "location" equal to "apartment" and offense euqal to "robbery". How many observations does this dataset has?

library(ggmap)
bul_apt <- subset(crime, offense == "robbery" & location=="apartment") 

## One restriction at the time
bul_apt <- subset(crime, offense == "robbery") 
bul_apt <- subset(bul_apt, location=="apartment") 

## 2) Create a map with a background tile of Houston using the qmplot function to visualize where apartment bulgaries occur (Note: You need an internet connection to downlowd the png tile files). What do you observe?
bul_map<-qmplot(lon, lat, data = bul_apt, zoom=10)
bul_map

## 3) Create a copy of your data object. Use the coordinates function to assign lat lon coordinates to this copy. Use the bbox function to find out the spatial extent of your data object. 
bul_apt1<-bul_apt
library(sp)
coordinates(bul_apt1)=~lon+lat
bbox(bul_apt1)

## 4) Create a new data object by dropping the point with the maximum "lat" value from the data object (Note: this object should have the same number of observations MINUS ONE as the data object you created in 1)). Plot the points again as in question 2). Do you observe any spatial pattern in the distribution of apartment bulgaries in Houston?

# Subset on the SpatialPointsDataFrame
max_p<-max(bbox(bul_apt1))
#max_p<-bbox(bul_apt1)[2,2]
head(bul_apt1@coords)
sel<-bul_apt1@coords[,2]==max_p
table(sel)
bul_apt_p<-bul_apt1[!sel,]
data_p<-data.frame(bul_apt_p@coords)
bul_map_p<-qmplot(lon, lat, data = data_p, maptype="toner", extent = "normal")
bul_map_p

## Another way: Extract the coords data from Spatial Points first
bul_apt_e<-data.frame(bul_apt1@coords)
max_lat<-max(bul_apt_e$lat)
bul_apt2<-bul_apt_e[!bul_apt_e$lat==max_lat,]
bul_map1<-qmplot(lon, lat, data = bul_apt2, extent = "normal")
bul_map1

## Yet another way: drop the point located furthest away from the center
center<-gCentroid(bul_apt1)
max_dist<-which.max(distm(bul_apt1, center)) # The function which.max gives the index of the point satisfying the condition
bul_apt3<-bul_apt1[-max_dist,] # with the negative sign in front of the index I drop the observation 
bul_map3<-qmplot(lon, lat, data = data.frame(bul_apt3@coords), extent = "normal")
bul_map3

## Import the base polygons with Super Neighborhoods boundaries using the readOGR function
## 5) Merge data object you created in 4) with these base polygons. Aggregate the number of robberies by Super Neighborhood. What is the name of the neighborhood with the most robberies?
setwd("C:/Users/juanita82/Dropbox/R-Course/data/")
library(rgdal)
neigh <- readOGR(dsn = "Super_Neighborhoods", layer = "Super_Neighborhoods")
proj4string(bul_apt_p)<-proj4string(neigh)
## Basic plot to check overlay
plot(neigh, axes=TRUE)
points(bul_apt_p, cex=0.3, col="red")
## Merging Spatial Points and Polygons
# Subset murders happening within Super Neighborhoods boundaries
bul_apt_o <- bul_apt_p[neigh, ] 
## Aggregating points
neigh@data$bul_apt<-over(neigh, bul_apt_o["number"], fn=sum)
# Convert the data.fram into a variable
neigh@data$bul_apt<-neigh@data$bul_apt$number
neigh@data$bul_apt[is.na(neigh@data$bul_apt)]<-0
neigh@data$SNBNAME[which.max(neigh@data$bul_apt)]

## 6) Use the data object you created in question 4) to make an interactive map using leaflet of robberies happening on Saturdays between 10pm and 6am (use the variable "hour" to subset). 

library(leaflet)
keep<-c(22:23,0,1:6)
bul_apt_t<-bul_apt[bul_apt$hour %in% keep,]
unique(bul_apt_t$hour)
bul_apt_t<-bul_apt_t[bul_apt_t$day=="saturday",]
unique(bul_apt_t$day)

map<-leaflet(data = bul_apt_t) %>% addTiles() %>%
  addMarkers(~lon, ~lat)
map
