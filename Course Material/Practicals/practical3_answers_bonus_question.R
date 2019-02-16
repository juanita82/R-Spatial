## BONUS QUESTION: make an interactive map using shiny of robberies happening on Saturdays between 10pm and 6am with pop-ups displaying the hour of the robbery (Hint: you need to transform the hour variable from integer to character using the as.chacrater() function)

bul_apt_t$hour_s<-as.character(bul_apt_t$hour)

library(shiny)
shinyApp(
  ui = fluidPage(leafletOutput('myMap')),
  server = function(input, output) {
    map<-leaflet(data = bul_apt_t) %>% addTiles() %>%
      #     addMarkers(~lon, ~lat)  %>%
      addPopups(~lon, ~lat, popup = ~hour_s) # popup
    output$myMap = renderLeaflet(map)
  }
)