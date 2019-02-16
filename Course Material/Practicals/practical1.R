## Introduction to the analysis of spatial data using R
# Practical exercises, Chapter 1

# 1) Open PDF document "A (very) short introduction to R" by Paul Torfs & Claudia Brauer. Create a new .R file called "intro.R" with the code lines in the document and reproduce its results. 

# 2) Install the following packages (required for this course): dplyr, rgdal, sp, maptools, rgeos, RColorBrewer, geosphere, spdep, ggmap, leaflet, shiny, stringdist. Note: An internet connection is required

# 3) Get information about your R Session by typying sessionInfo() in the console

# 4) Create a new data frame with the USArrests data. See the last 6 observations of the data frame on the console (without creating a new variable)

# 5) Plot UrbanPop against Murder, both in logs. What can you say about the relationship between these two variables?

# 6) Change axes names of the the previous plot  (hint: see x and y axis title options in ?plot). Save the plot as "plot_excersise1.jpeg" using the R Studio "Export" button 

# 7) Create new dataset with the first 20 observations and without the Rape variable

# 8) Create new dataset only with observations with Murder above the national mean

# 9) Create a new variable called "z_score" equal to the value of Assaults minus its mean over its standard deviation, and add it to the original dataset (try also using the mutate function of the dplyr package for this)

# 10) Create a new variable called crime_dummy equal to 1 if the sum of all crimes is larger than the national mean, and zero otherwise. Add it to the database

# 11) Save your .R file as answers_chapter1.R. Save your data as answers_chapter1.RData. Re-start R studio and load answers_chapter1.R and answers_chapter1.RData. After you are done, clear the workspace. 

# BONUS QUESTION: Do as many of the ToDos as you can of the document "A (very) short introduction to R" by Paul Torfs & Claudia Brauer and save them in an .R file called intro_excersises.R. After you are done, clear the workspace.  

# ADVANCED QUESTION. We explained how to download, unzip and save a single .zip file. Usually we would need to do this taks for multiple files. For instance, if you access this website, you will see the directory contains multiple .zip files

"ftp://ftp.ibge.gov.br/Censos/Censo_Demografico_2010/Cadastro_Nacional_de_Enderecos_Fins_Estatisticos/AC/"

# How can we download all the files at once? We can use the getURL function of the package RCurl, and a loop, in the following way:

# Create a variable with the directory containing all the .zip files
path0 <-'ftp://ftp.ibge.gov.br/Censos/Censo_Demografico_2010/Cadastro_Nacional_de_Enderecos_Fins_Estatisticos/AC/'
library(RCurl)
# Get the names of all the files in directory
files_AC_0 <- getURL(path0, dirlistonly = TRUE)

# We get a string made up of 11 numbers followed by .zip, then separated by \r\n). What we want is to get the name of each file as a string. The strsplit function splits the elements of the character vector where it finds the character vector "\r\n" and the substring function gets the number of characters we specify before "\r\n" (there are 15 characters in each file name) 

files_AC <- sapply(strsplit(files_AC_0,'\r\n'), function(x) substring(x, nchar(x)-15))

## Now we create a list where each element is a path to download each .zip file using the paste0 function and a simple loop. 

# First we delcare an empty list
path1<-list()
# Now we fill it up (Note: for lists we use double brackets to index)
for(i in files_AC){
  path1[[i]] <-paste0(path0,i)
}
# We use "unique" and "unlist" to work with character strings of each URL
path1<-unique(unlist(path1))

# Finally we download the files to our local directory
lpath <- "C:/TEST"
for (i in path1) {
  download.file(i, destfile = paste0(lpath, substring(i, nchar(i)-15)))
}