## Introduction to the analysis of spatial data using R
# Practical exercises, Chapter 2

# Use the Super Neighborhoods division polygon data and the additional Super Neighborhood Census data in csv format to answer the following questions.

# 1) Create a new SpatialPolygonsDataFrame called "neigh1" containing only the FOURTH WARD and SECOND WARD neighborhoods. Plot it. Are the two neighborhood contigous?

# 2) Convert "neigh1" to coordenates using the coordinates function. What is the distance between the centroids of the two neighborhoods, in kilometers? (Hint: use the distm function on the coordenates of the centroids.)

## For the following exercises, go back to the original Super Neighborhoods division polygon data.

# 3) Construct a new variable with the percentage of Hispanic Population (variable SUM_HispPop) in the total population, and add it to the data frame. What is the min, max and median of this variable?

# 4) Make a plot of the neighborhoods where the percentage of hispanics is larger than 70% appears in a different color. Save this plot as .jpeg. 

# 5) Make a cloropeth map of the total hispanic population using the spplot function. Change the default colors by choosing your own palette from the RColorBrewer options (use display.brewer.all() to see them). Save this plot as .jpeg. From this and the previous graph, what can you say about the spatial distribution of Hispanics in Houston?

## 6) Make a 2000 meter buffer around the center of "DOWNTOWN", and subset the neigh spatial object to select which of its centroids fall within the buffer. Hint: Use the gCentroid function with the option "byid=TRUE" to get the centroids of each area. 

## 7) Calculate the Moran's I statistic for the percentage of hispanics variable. What is your conclusion regarding spatial autocorrelation?

## BONUS Advanced question: Calculate the distance between every pair of centroids. Then calculate the mean distance of each area (Hint: use the colMeans base function). Make a new object with areas that have a mean distance smaller than 15 km. Plot the result.