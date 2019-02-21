## Source code for Chapter 4
## Introduction to the analysis of spatial data using R
## By: Ana I. Moreno-Monroy
## This version: February 19, 2019
## **Note**: For this Chapter, several packages need to be installed. If you get an error after running library("package_name"), run install.packages(""package_name") or install the package from Tools/Install Packages in R Studio

library(tmaptools)
library(sp)
library(osrm)
library(raster)

## Geolocating using tmaptools (no API required)
plain = CRS("+proj=longlat +datum=WGS84 +no_defs")

from<-geocode_OSM("Universidad de Antioquia, Medellin", details=TRUE)
from = as.data.frame(t(from$coords))
coordinates(from) <- ~x+y
from =SpatialPointsDataFrame(from@coords, data=data.frame(id=1), proj4string = plain)
mapview(from)

to <- geocode_OSM("Carlos E. Restrepo, Medellin")
to <- as.data.frame(t(to$coords))
coordinates(to) <- ~x+y
to =SpatialPointsDataFrame(to@coords, data=data.frame(id=1), proj4string = plain)

mapview(from) + mapview(to, color="red")

## Calculating distances and travel time using osrm
route <- osrmRoute(src = from, dst= to, sp=TRUE)

route$duration # In minutes
route$distance  # In Km

mapview(from) + mapview(to, color="red") + mapview(route)

# Trip duration (in minutes and km)
library(raster)
start_end = bind(to, from)
trip <- osrmTrip(start_end)
trip[[1]]$summary$distance
trip[[1]]$summary$duration

mapview(trip[[1]]$trip[1])  + mapview(trip[[1]]$trip[2])

# Batch geolocation: an example -------------------------------------------
setwd("C:/Users/juanita82/Dropbox/R-Course/data/")
loc<-read.table("direcciones_MDE.TXT", header=TRUE, encoding = "utf-8")
loc[1:3,]
## Cleaning addresses
ind<-regexpr("(", loc$direccion, fixed=TRUE)
ind[!ind==-1]
loc$direccion[17]
## Cleaning addresses
ind[ind<0]<-length(loc$direccion)
loc$direccion1<-substr(loc$direccion, start=1, stop=ind-1)
loc$direccion1[17]
matches<-c("\\(", " IN", " AP", " BL", " PS", " TORRE", " TR", " CASA", " CA")
ind<-regexpr(paste(matches, collapse = "|"), loc$direccion)
ind[ind==-1]<-length(loc$direccion)
loc$direccion1<-substr(loc$direccion, start=1, stop=ind-1)
loc$direccion1 <-sub("CL", "CALLE", loc$direccion1)
loc$direccion1 <-sub("CR", "CARRERA", loc$direccion1)
loc$direccion1 <-sub("TV", "TRANSVERSAL", loc$direccion1)
loc$direccion1[1:10]
## Geolocating
#direccion <- paste("Medellin, Antioquia, Colombia,", loc$direccion1)
direccion <- paste(loc$direccion1, ",",  "Medellin, Colombia")
direccion[1]
#locations <- geocode(direccion[1:10], output="more")
locations <-tmaptools::geocode_OSM(direccion)
locations[1,1:5]
loc_points = locations
coordinates(loc_points) = ~lon+lat
proj4string(loc_points) = "+proj=longlat +datum=WGS84 +no_defs"
mapview(loc_points)
## Exporting as data frame
setwd("C:/Users/juanita82/Dropbox/R-Course/data/")
write.csv(locations, "coordenates.csv")


