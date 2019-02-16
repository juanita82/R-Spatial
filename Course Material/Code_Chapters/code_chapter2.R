## Source code for Chapter 2
## Introduction to the analysis of spatial data using R
## By: Ana I. Moreno-Monroy
## This version: June 12, 2017
## **Note**: For this Chapter, packages rgdal, sp, rgeos and spdep need to be installed. If you get an error after running library("package_name"), run install.packages("package_name") or install the package from Tools/Install Packages in R Studio

## Loading Super Neighborhoods shapefile
# Set working directory that contains the files
setwd("C:/Users/juanita82/Dropbox/R-Course/data/")
library(rgdal)
neigh <- readOGR(dsn = "Super_Neighborhoods", layer = "Super_Neighborhoods")
# Inspection
str(neigh@data)
# More details on NA values
table(is.na(neigh@data$COUNCIL_AC))
table(complete.cases(neigh@data))
# Projection?
proj4string(neigh)
## Plot map with axes values
plot(neigh, axes=TRUE)
# Convert projection
library(sp)
neigh <- spTransform(neigh, CRS("+init=epsg:3673"))
# Check map after projection
plot(neigh, axes=TRUE)
# Selecting a single area
sel <- neigh@data$SNBNAME=="DOWNTOWN"
downtown<-neigh[sel, ]
plot(neigh[sel, ], axes=TRUE) 
## Merge external dataset
SN_data<-read.csv("Census_2010_By_SuperNeighborhood.csv", header=TRUE)
## Alternative: download data (remove # to uncomment and run)
# SN_data<-read.csv2("http://arcg.is/2dZ7naE", sep=",")
# Merging dataset into Spatial Object
neigh<-merge(neigh, SN_data, by="POLYID")
# Subset to keep only some variables 
keep<-c("POLYID", "SNBNAME", "SUM_TotPop")
neigh1<-neigh[,colnames(neigh@data) %in% keep]
# Queries
sum(neigh@data$SUM_TotPop, na.rm=TRUE)
neigh@data$SUM_TotPop[neigh@data$SNBNAME=="DOWNTOWN"]
# Add more criteria 
neigh@data$SUM_TotPop[neigh@data$SNBNAME=="DOWNTOWN" | neigh@data$SNBNAME=="MEMORIAL"]
## Simple cloropeth map
spplot(neigh, "SUM_TotPop", main = "Population distribution", col = "transparent")
# Different color palette
library(RColorBrewer)
my.palette <- brewer.pal(n = 7, name = "OrRd")
spplot(neigh, "SUM_TotPop", col.regions = my.palette, main = "Population distribution", cuts = 6, col = "transparent")
## Identify specific areas in a plot
plot(neigh, axes=TRUE)
sel <- neigh@data$SUM_TotPop>mean(neigh@data$SUM_TotPop)
plot(neigh[sel, ], axes=TRUE, col="dark red", add=TRUE) 
## Find centroid of an area
library(rgeos)
plot(neigh, axes = TRUE)
center <- gCentroid(neigh[neigh$SNBNAME == "DOWNTOWN",]) 
plot(center, cex = 0.3, col="red", add=TRUE)
# Use the option "byid=TRUE" to obtain the centroids of each polygon
center_all <- gCentroid(neigh, byid=TRUE) 
## Select areas touching a buffer
plot(neigh, axes=T)
buffer_2k <- gBuffer(center, width = 2000)
plot(neigh[buffer_2k,], col = "lightblue", add = T) 
plot(buffer_2k, add = T, border = "red", lwd = 2)

## Calculating a distance matrix between centroids
library(geosphere)
neigh <- spTransform(neigh, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")) 
center_all <- gCentroid(neigh, byid=TRUE) 
dist_matrix <- distm(center_all) 
dist_matrix[1:5,1:5]

## Test of spatial dependency
# First check spatial pattern in variable of interest (Black population)
spplot(neigh, "SUM_NH_Black", col.regions = my.palette, main = "Number of Blacks", cuts = 6, col = "transparent")
# Construct a neighbor's list (default contiguity condition is "Queen")
library(spdep)
neigh_nb <- poly2nb(neigh)
# Plot neighbors
coords<-coordinates(neigh)
plot(neigh)
plot(neigh_nb, coords, add=T)
# Construct row-standardized weights between neighbors
neigh_lw_W <- nb2listw(neigh_nb, zero.policy = T)
# Calculating Moran's I 
moran_u <- moran.test(neigh@data$SUM_NH_Black, listw = neigh_lw_W, zero.policy = T)
moran_u

## sf package
setwd("C:/Users/juanita82/Dropbox/R-Course/data/")
library(sf)
neigh <- st_read("Super_Neighborhoods/Super_Neighborhoods.shp")
class(neigh)

# Merging with dplyr
setwd("C:/Users/juanita82/Dropbox/R-Course/data/")
library(dplyr)
SN_data<-read.csv("Census_2010_By_SuperNeighborhood.csv", header=TRUE)
neigh<-left_join(neigh, SN_data, by="POLYID")

# Plotting
plot(neigh[c("SUM_TotPop", "SUM_HispPop")])