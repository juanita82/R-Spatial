## Source code for Chapter 4
## Introduction to the analysis of spatial data using R
## By: Ana I. Moreno-Monroy
## This version:November 15, 2016
## **Note**: For this Chapter, packages ggmap and stringdist  need to be installed. If you get an error after running library("package_name"), run install.packages(""package_name") or install the package from Tools/Install Packages in R Studio

## Tile mapping with ggmap 
library(ggmap)
qmap("Facultad de Economia, Universidad de Antioquia, Medellin", zoom = 13, color = "bw", legend = "topleft")
## Geolocating using ggmap
info<-geocode("Universidad de Antioquia, Medellin", output = "more")
info
## Calculating distances using ggmap
from <- c("Universidad de Antioquia, Medellin, Antioquia")
to <- c("Carlos E. Restrepo, Medellin, Antioquia")
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
locations$original[1]
locations$address[1]
drop<-c(" ", "\\.", "-", ",", "#")
locations$address1<-gsub(paste(drop, collapse = "|") , "", locations$address)
locations$original1<-gsub(paste(drop, collapse = "|"), "", locations$original)
# And convert to all capitals 
locations$address1<-toupper(locations$address1)
locations$original1<-toupper(locations$original1)
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
mde_lines <- readOGR(dsn = "medellin_colombia.osm", layer = "medellin_colombia_osm_line")
levels(mde_lines@data$highway)
## OSM data: an example
mde_pri_sec<-mde_lines[mde_lines@data$highway=="primary"|mde_lines@data$highway=="secondary",]

