## Introduction to the analysis of spatial data using R
# Practical exercises, Chapter 4

## 1) Experiment with tile mapping with ggmap by making a map of the location of your own home. 
## For the following excersises, use the crime dataset from the ggmap package.

## 2) Subset the crime dataset to keep only the first reported crime. Make a different object keeping only the lat and lon. Use the revgeocode function to find the addresses corresponding to the X-Y coordinates. Do you see any differences between this addresses and the original one? Note: The input of the revgeocode function must be [1:2] numeric vector containing the lon lat coordinates

## 3) Subset the crime dataset to keep only the first 2 reported crimes. Find "as the crow flies" (Euclidian) distance matrix between these crimes. Use the ggmap mapdist function to find the distance between these 2 points using mode "walking". What is the difference between the two measures, in meters? Assume the first crime is the departing point. Hint: Use the paste function to create a string with the "lon , lat" neeeded as input in the mapdist function

## 4) Import the _lines shapefile from the OSM data for Barcelona. Check which values the variable "highway" takes, and make a new shapefile containing only primary and secondary highways. Plot the result.

## 5) Import the _points shapefile from the OSM data for Barcelona. Identify the main health cluster in the city (Note: use any suitable category of the  "amenity" variable corresponding to health services) 
