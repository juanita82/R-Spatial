## Interactive mapping with shiny: an example
library(shiny)
shinyApp(
  ui = fluidPage(leafletOutput('myMap')),
  server = function(input, output) {
    map<-leaflet(data = murder_m) %>% addTiles() %>%
      addMarkers(~lon, ~lat)  %>%
      addPopups(~lon, ~lat, popup = ~time) # popup
    output$myMap = renderLeaflet(map)
  }
)