## Introduction to the analysis of spatial data using R
# Practical exercises, Chapter 3

## For the following quesitons, use the crime dataset available from the ggmap package. 

## 1) Create a new data set subsetting the crime database to keep only crimes with "location" equal to "apartment" and offense euqal to "robbery". How many observations does this dataset has?

## 2) Create a map with a background tile of Houston using the qmplot function to visualize where apartment bulgaries occur (Note: You need an internet connection to downlowd the png tile files). What do you observe?

## 3) Create a copy of your data object. Use the coordinates function to assign lat lon coordinates to this copy. Use the bbox function to find out the spatial extent of your data object.

## 4) Create a new data object by dropping the point with the maximum "lat" value from the data object (Note: this object should have the same number of observations MINUS ONE as the data object you created in question 1)). Plot the points again as in question 2). Do you observe any spatial pattern in the distribution of apartment bulgaries in Houston?

## Import the base polygons with Super Neighborhoods boundaries using the readOGR function.

## 5) Merge data object you created in 4) with these base polygons. Aggregate the number of robberies by Super Neighborhood. What is the name of the neighborhood with the most robberies?

## 6) Use the data object you created in question 4) to make an interactive map using leaflet of robberies in apartments happening on Saturdays between 10pm and 6am (use the variable "hour" to subset). Note: An internet connection is needed for this.

## BONUS QUESTION: Make an interactive map using shiny of robberies happening on Saturdays between 10pm and 6am with pop-ups displaying the hour of the robbery (Hint: you need to transform the hour variable from integer to character using the as.character() function).
