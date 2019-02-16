## Source code for Chapter 3
## Introduction to the analysis of spatial data using R
## By: Ana I. Moreno-Monroy
## This version: June 12, 2017
## **Note**: For this Chapter, packages ggmap, sp, rgdal, rgeos, leaflet, shiny and geoshpere need to be installed. If you get an error after running library("package_name"), run install.packages(""package_name") or install the package from Tools/Install Packages in R Studio

# Load geolocalized crime data available from __ggmap__ package
library(ggmap)
str(crime)
# Subset by type of offense after checking all possible values
levels(crime$offense) 
# Subset to keep only murders
murder <- subset(crime, offense == "murder") 
# Drop unneeded columns
murder<-murder[,colnames(murder) %in% c("number", "lon", "lat")]
# Check the first pair of coordenates
c(murder$lat[1], murder$lon[1]) 
# use a background tile of location 
crime_map<-qmplot(lon, lat, data = murder, extent = "normal")
crime_map
## Kernel density overlay
crime_map + stat_density2d(aes(x = lon, y = lat, fill = ..level.., alpha = ..level..), data = murder, geom = "polygon")
## Conveting lat/lon into a Spatial Object
library(sp)
coordinates(murder)=~lon+lat
summary(murder)
## Spatial Points
# Check the slots
slotNames(murder)
# bbox refers to the Bouding Box, or (geographical) extent of the data 
bbox(murder)
# No coordenates system assigned
proj4string(murder)
## Merging points and base polygons 
# Import base polygons with Super Neighborhoods boundaries
setwd("C:/Users/juanita82/Dropbox/R-Course/data/")
library(rgdal)
neigh <- readOGR(dsn = "Super_Neighborhoods", layer = "Super_Neighborhoods")
# Same coordenate system
proj4string(murder)<-proj4string(neigh)
## Basic plot to check overlay
plot(neigh, axes=TRUE)
points(murder, cex=0.3, col="red")
## Merging Spatial Points and Polygons
# Subset murders happening within Super Neighborhoods boundaries
murder_o <- murder[neigh, ] 
# Two murders do not happen within SN Boundaires
length(murder)
length(murder_o)
## Aggregating points
neigh@data$murders<-over(neigh, murder_o["number"], fn=sum)
# Convert the data.fram into a variable
neigh@data$murders<-neigh@data$murders$number
# Alternatively, use aggregate
# neigh@data$murders <- aggregate(x = murder_o["number"], by = neigh, FUN = sum)
## Verification
# Check total sums of points and aggregates coincide
sum(neigh@data$murders, na.rm=TRUE)
sum(murder_o$number)
# Neighborhoods with no murders are assigned NA
table(is.na(neigh@data$murders))
# Assing zeros to NA values
neigh@data$murders[is.na(neigh@data$murders)]<-0
## Additional operations with Spatial points
# Distance of every murder to the center of Downtown 
library(rgeos)
library(geosphere)
center <- gCentroid(neigh[neigh$SNBNAME == "DOWNTOWN",]) 
dist_murder<-distm(murder_o, center)
# Mean distance of murders from downtown (in kilometers)
mean(dist_murder)/1000
## Interactive mapping with leaflet: an example
library(leaflet)
murder <- subset(crime, offense == "murder") 
murder_m<-murder[murder$day=="monday",]
murder_m<-murder_m[,colnames(murder_m) %in% c("time", "lon", "lat")]
map<-leaflet(data = murder_m) %>% addTiles() %>%
  addMarkers(~lon, ~lat)
## Interactive mapping with shiny: an example
library(shiny)
shinyApp(
  ui = fluidPage(leafletOutput('myMap')),
  server = function(input, output) {
    map<-leaflet(data = murder_m) %>% addTiles() %>%
      addMarkers(~lon, ~lat)  %>%
      addPopups(~lon, ~lat, popup = ~time) # popup
    output$myMap = renderLeaflet(map)
  }
)
