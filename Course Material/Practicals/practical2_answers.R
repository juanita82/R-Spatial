## Introduction to the analysis of spatial data using R
# Practical exercises, Chapter 2

# Use the Super Neighborhoods division polygon data and the additional Super Nieghborhood Census data in csv format to answer the following questions.

## Loading Super Neighborhoods shapefile
# Set working directory that contains the files
setwd("C:/Users/juanita82/Dropbox/R-Course/data/")
library(rgdal)
neigh <- readOGR(dsn = "Super_Neighborhoods", layer = "Super_Neighborhoods")

#library(sp)
#neigh <- spTransform(neigh, CRS("+init=epsg:3673"))

## Merge external dataset
SN_data<-read.csv("Census_2010_By_SuperNeighborhood.csv", header=TRUE)
neigh<-merge(neigh, SN_data, by="POLYID")
# Optional: Merge only some columns in external dataframe
rm(neigh)
neigh <- readOGR(dsn = "Super_Neighborhoods", layer = "Super_Neighborhoods")
neigh_1<-merge(neigh, SN_data[,colnames(SN_data) %in% c("POLYID", "SUM_TotPop")], by="POLYID")
rm(neigh_1)
# Direct merge (without creating dataframe)
neigh<-merge(neigh, read.csv("Census_2010_By_SuperNeighborhood.csv", header=TRUE), by="POLYID" )

## Additional: exporting the new shapefile with merged data
setwd("C:/Users/juanita82/Dropbox/R-Course/data/")
writeOGR(neigh, dsn= "Super_Neighborhoods_data", layer= "Super_Neighborhoods_data", driver="ESRI Shapefile")

# 1) Create a new SpatialPolygonsDataFrame called "neigh1" containing only the FOURTH WARD and SECOND WARD neighborhoods. Plot it. Are the two neighborhood contigous?

# Selecting a single area
sel <- neigh@data$SNBNAME=="FOURTH WARD" | neigh@data$SNBNAME=="SECOND WARD"
table(sel)
neigh1<-neigh[sel, ] 
plot(neigh1)

# Another way
areas<-c("FOURTH WARD", "SECOND WARD")
neigh1<-neigh[neigh@data$SNBNAME %in% areas, ] 
plot(neigh1)

# 2) Convert "neigh1" to coordenates using the coordinates function. What is the distance between the centroids of the two neighborhoods, in kilometers? (Hint: use the distm function on the coordinates of the centroids.)
coords<-coordinates(neigh1)
dist_c <-distm(coords)
dist_c / 1000 # distance in km

# Another way
center <- gCentroid(neigh1, byid=TRUE)
library(geosphere)
dist <- distm(center) 

## For the following exercises, go back to the original Super Neighborhoods division polygon data.

# 3) Construct a new variable with the percentage of Hispanic Population (variable SUM_HispPop) in the total population, and add it to the data frame. What is the min, max and median of this variable?

#neigh<-merge(neigh, SN_data, by="POLYID")
neigh@data$p_hisp <- neigh@data$SUM_HispPop/neigh@data$SUM_TotPop
summary(neigh@data$p_hisp)

# 4) Make a plot of the neighborhoods where the percentage of hispanics is larger than 70% appears in a different color. Save this plot as .jpeg. 

plot(neigh, axes=TRUE)
sel <- neigh@data$p_hisp>=0.7
table(sel)
plot(neigh[sel, ], axes=TRUE, col="dark red", add=TRUE) 
# Saving the plot
setwd("C:/Users/juanita82/Dropbox/R-Course/")
jpeg("p_hisp.jpeg")
plot(neigh, axes=TRUE)
sel <- neigh@data$p_hisp>0.7
plot(neigh[sel, ], axes=TRUE, col="dark red", add=TRUE) 
dev.off()

# 5) Make a cloropeth map of the total hispanic population using the spplot function. Change the default colors by choosing your own palette from the RColorBrewer options (use display.brewer.all() to see them). Save this plot as .jpeg. From this and the previous graph, what can you say about the spatial distribution of Hispanics in Houston?

library(RColorBrewer)
my.palette <- brewer.pal(n = 7, name = "OrRd")
spplot(neigh, "SUM_HispPop", col.regions = my.palette, main = "Hispanic Population distribution", cuts = 6, col = "transparent")

## 6) Make a 2000 meter buffer around the center of "DOWNTOWN", and subset the neigh spatial object to select which of its centroids fall within the buffer. Hint: Use the gCentroid function with the option "byid=TRUE" to get the centroids of each area. 

library(sp)
neigh <- spTransform(neigh, CRS("+init=epsg:3673"))

center <- gCentroid(neigh[neigh$SNBNAME == "DOWNTOWN",]) 
buffer_2k <- gBuffer(center, width = 2000)

center_all<- gCentroid(neigh, byid=TRUE) 

plot(neigh, axes=TRUE)
plot(center_all, axes=TRUE, add=TRUE)
plot(buffer_2k, add=TRUE, border = "red", lwd = 2)

inside_c <- center_all[buffer_2k,] # select points inside buffer
points(inside_c, col="red") # show where the points are located
neigh_w <- neigh[inside_c,] # select zones intersecting w. sel

plot(neigh)
plot(neigh_w, add = T, col = "lightslateblue", border = "grey")
plot(buffer_2k, add = T, border = "red", lwd = 2)

## BONUS Advanced question: Calculate the distance between every pair of centroids. Then calculate the mean distance of each area (Hint: use the colMeans base function). Make a new object with areas that have a mean distance smaller than 15 km. Plot the result.

library(geosphere)
neigh <- spTransform(neigh, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")) 

center_all <- gCentroid(neigh, byid=TRUE) 

dist_matrix <- distm(center_all) 

means<-colMeans(dist_matrix)

sel<-means<15000
neigh_15k<-neigh[sel,]

plot(neigh_15k)

