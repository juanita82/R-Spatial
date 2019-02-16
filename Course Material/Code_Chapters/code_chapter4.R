## Source code for Chapter 4
## Introduction to the analysis of spatial data using R
## By: Ana I. Moreno-Monroy
## This version: June 12, 2017
## **Note**: For this Chapter, packages ggmap and stringdist  need to be installed. If you get an error after running library("package_name"), run install.packages("package_name") or install the package from Tools/Install Packages in R Studio

## Tile mapping with ggmap 
library(ggmap)
qmap("Campus Bellissens URV, Reus", zoom = 15, color = "bw", legend = "topleft")
## Geolocating using ggmap
info<-geocode("Campus Bellissens URV, Reus", output = "more")
info
## Calculating distances using ggmap
from <- c("Gaudi Centre, Reus")
to <- c("Campus Bellissens URV, Reus")
mapdist(from, to, mode="bicycling")
## Batch geolocation: an example
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
loc$direccion1[1:3]
## Geolocating
direccion <- paste("Medellin, Antioquia, Colombia,", loc$direccion1)
direccion[1]
locations <- geocode(direccion[1:10], output="more")
locations[1,1:5]
## Comparing original and return addreses
locations$original <- paste(loc$direccion1[1:10], "Medellin, Antioquia, Colombia")
locations$original
locations$address
drop<-c(" ", "\\.", "-", ",", "#", "n°", "\\:")
locations$address1<-gsub(paste(drop, collapse = "|") , "", locations$address)
locations$original1<-gsub(paste(drop, collapse = "|"), "", locations$original)
locations$address1<-gsub("carrera", "cr", locations$address1)
locations$address1
locations$original1
# And convert to all capitals 
locations$address1<-toupper(locations$address1)
locations$original1<-toupper(locations$original1)
locations$address1
locations$original1
# Final touch
locations$address1<-gsub("MEDELLÍN", "MEDELLIN", locations$address1)
## Check performance
library(stringdist)
ind_match<-amatch(locations$address1, locations$original1,  maxDist=1)
ind_match
ind_match<-amatch(locations$address1, locations$original1,  maxDist=2)
ind_match
## Visualizing and exporting the result
qmplot(lon, lat, data = locations, colour = I("red"), size = I(3))
# Save the map as a .jpg image 
setwd("C:/Users/juanita82/Dropbox/R-Course/data/")
jpeg("plot_mde.jpg")
qmplot(lon, lat, data = locations, colour = I("red"), size = I(3))
dev.off()
## Exporting as data frame
setwd("C:/Users/juanita82/Dropbox/R-Course/data/")
write.csv(locations, "coordenates.csv")
## OSM data: an example
setwd("C:/Users/juanita82/Dropbox/R-Course/data/")
library(rgdal)
bcn_poi <- readOGR(dsn = "barcelona_spain.osm", layer = "barcelona_spain_osm_point_1")
levels(bcn_poi@data$amenity)
bcn_party<-bcn_poi[bcn_poi@data$amenity %in% c("bar", "nightclub", "pub"),]
plot(bcn_party, axes=T)
# Project so that distances in meters make sense
bcn_party_p = spTransform(x = bcn_party, CRSobj = CRS("+init=epsg:2062"))
library(spatstat)
p <- as.ppp(bcn_party_p@coords, owin(bcn_party_p@bbox[1,], bcn_party_p@bbox[2,] )) # Create densities in raster
dp_all <- density.ppp(p, sigma=500)
# 3-D density graph
persp(dp_all, d=1, col="lightgrey",  box=FALSE, border=NA, shade=0.5, theta = 25, main="Party points")
# Density at each point
bcn_party_p@data$den<- density.ppp(p, sigma=500, at="points")
#Identify point with highest density
max<-bcn_party_p[which.max(bcn_party_p@data$den),]
plot(bcn_party_p, axes=TRUE)
plot(max, axes=TRUE, add=TRUE, col="red")

## In the actual map...
# Convert back to plain coordinates
max_p<-spTransform(max, CRS("+init=epsg:4326"))
# Create a data frame of coordinates
max_data<-data.frame(max_p@coords)
# Plot location and indicate point with red dot
qmap(max_p@coords[1,], max_p@coords[2,], zoom = 15, 
     base_layer = ggplot(aes(x=coords.x1, y=coords.x2), data = max_data)) +
        geom_point(col="red", size=3)
      
