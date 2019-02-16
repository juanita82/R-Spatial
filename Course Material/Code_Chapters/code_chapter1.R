## Source code for Chapter 1
## Introduction to the analysis of spatial data using R
## By: Ana I. Moreno-Monroy
## This version: June 12, 2017
## **Note**: For this Chapter, packages dplyr and utils need to be installed. If you get an error after running library(dplyr), run install.packages("dplyr") or install the package from Tools/Install Packages in R Studio (same for utils)

## Assigning and plotting
x <- 1:400
y <- sin(x/10)
plot (x,y, main = "X versus Y")

## Load example data
data <- USArrests # Click on Play button next to data on the Environment panel 
# Get more information about the database
?USArrests
## Basic inspection
head(data)
summary(data)
## Simple plots 
plot(data$UrbanPop, data$Murder)
## Subset data 
# By rows 
data1<-data[1:20,]
# By columns
data2<-data[,3:4]
# By observation
data2<-data[1,1]
# Overwritting element
data2<-data1
# Removing elements from workspace
rm(x, y, data1, data2)
## Creating variable from data frame
var<-data$Murder
# Create a character vector
answer<-c("FALSE", "FALSE", "TRUE")
names<-c("UrbanPop", "Murder")
# Sum strings satisfying a condition
sum(answer=="FALSE")
rm(answer)

## Subset data satisfying a condition 
# Above/below value of variable: two alternartives
sel<-data$UrbanPop>mean(data$UrbanPop)
table(sel)
data1<-data[sel,]
#Another way: using the __subset__ base function (all in one line) 
data2<-subset(data, UrbanPop>mean(UrbanPop))
# Are they the same?
data1 == data2

# Subset data satisfying a condition 
# Above/below value of variable:
sel<-data$UrbanPop>mean(data$UrbanPop)
table(sel)
data1<-data[sel,]
# Another way: using the __subset__ base function (all in one line) 
data2<-subset(data, UrbanPop>mean(UrbanPop))
dim(data2)
## Subset data satisfying a condition 
# Subset by column names
keep<-c("UrbanPop", "Murder")
data3<-data[,colnames(data) %in% keep]
# Equivalently, drop unwanted columns using ! (IS NOT)
drop<-c("Rape", "Assault")
data4<-data[,!colnames(data) %in% drop]
## Handling data using the dplyr package
library(dplyr)
data<-USArrests
data_1<-mutate(data, all_crimes=(Murder + Assault + Rape))
# Create a new variable "all_crimes" equal to the sum of Murder, Assault and Rape
data$all_crimes <- data$Murder + data$Assault 
  
data_2 <- filter(data, UrbanPop>mean(UrbanPop))
dim(data_2)
data_3 <- select(data, UrbanPop, Murder)
dim(data_3)
data_4 <- select(data, -Rape, -Assault)
dim(data_4)

# Clean workspace
rm(data1, data_1, data2, data_2, data3, data_3, data4, data_4)

# Current working directory 
getwd()
# Setting a new one
setwd("C:/TEST")

## Downloading and unzipping a file

# Create new directory where files will be saved
if(!dir.exists("data")){dir.create("data")}
library(utils)
# Download file
download.file(url = "http://www.rigis.org/geodata/bnd/muni97d.zip",
              destfile = "data/muni97d.zip")
# Unzip file
unzip(zipfile = "data/muni97d.zip", exdir = "data")
