## Introduction to the analysis of spatial data using R
# Practical exercises, Chapter 4

## 1) Experiment with tile mapping with ggmap by making a map of the location of your own home. 
## For the following excersises, use the crime dataset from the ggmap package.

## 2) Subset the crime dataset to keep only the first reported crime. Make a different object keeping only the lat and lon. Use the revgeocode geocode function to find the addresses corresponding to the X-Y coordinates. Do you see any differences between this addresses and the original one? Note: The input of the revgeocode functuin must be [1:2] numeric vector containing the lon lat coordinates

crime_1<-crime[1:1,]
crime_s <- crime[1:1, colnames(crime) %in% c("lat", "lon", "address")] 
location<-c(crime_s$lon, crime_s$lat)
geo_address <- revgeocode(location)

## 3) Subset the crime dataset to keep only the first 2 reported crimes. Find "as the crow flies" (Euclidian) distance matrix between these crimes. Use the ggmap mapdist function to find the distance between these 2 points using mode "walking". What is the difference between the two measures, in meters? Assume the first crime is the departing point. Hint: Use the paste function to create a string with the "lon , lat" neeeded as input in the mapdist function
library(geosphere)
dist_eu <- distm(crime_2) 
coord_g<-cbind(crime$lon[1:2], crime$lat[1:2])
distance_google<-mapdist(coord_g[1,], coord_g[2,], mode="walking")

dist_difference<- distance_google$m - dist_eu[1,2]
dist_difference

## 4) Import the _lines shapefile from the OSM data for Barcelona. Check which values the variable "highway" takes, and make a new shapefile containing only primary and secondary highways. Plot the result.
bcn_lines <- readOGR(dsn = "barcelona_spain.osm", layer = "barcelona_spain_osm_line")
levels(bcn_lines@data$highway)

bcn_pri_sec<-bcn_lines[bcn_lines@data$highway=="primary"|bcn_lines@data$highway=="secondary",]
# Plot the result
plot(bcn_pri_sec, axes=TRUE)

## 5) Import the _points shapefile from the OSM data for Barcelona. Identify the main health cluster in the city (Note: use any suitable category of the  "amenity" variable corresponding to health services) 
setwd("C:/Users/juanita82/Dropbox/R-Course/data/")
library(rgdal)
bcn_poi <- readOGR(dsn = "barcelona_spain.osm", layer = "barcelona_spain_osm_point_1")
levels(bcn_poi@data$amenity)
bcn_health<-bcn_poi[bcn_poi@data$amenity=="clinic"| bcn_poi@data$amenity=="doctors"| bcn_poi@data$amenity=="hospital",]
plot(bcn_health, axes=T)
# Project so that distances in meters make sense
bcn_health_p = spTransform(x = bcn_health, CRSobj = CRS("+init=epsg:2062"))
library(spatstat)
p <- as.ppp(bcn_health_p@coords, owin(bcn_health_p@bbox[1,], bcn_health_p@bbox[2,] )) # Create densities in raster
dp <- density.ppp(p, sigma=500, at="points")
bcn_health_p@data$den<- dp
# Identify point with highest density
max<-bcn_health_p[which.max(bcn_health_p@data$den),]
plot(bcn_health_p, axes=TRUE)
plot(max, axes=TRUE, add=TRUE, col="red")