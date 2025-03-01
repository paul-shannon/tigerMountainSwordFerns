library(shiny)
library(leaflet)
#----------------------------------------------------------------------------------------------------
ui <- fluidPage(
  tags$style(type = "text/css", "#mymap {height: calc(100vh - 40px) !important;}"),
  leafletOutput("mymap"),
  p(),
  actionButton("recalc", "New points")
  )
#----------------------------------------------------------------------------------------------------
map <- leaflet()
centerLon <- -121.956570
centerLat <- 47.501663
initialZoom <- 12
map <- leaflet()
map <- setView(map, centerLon, centerLat, zoom=initialZoom)
options.tile <- tileOptions(minZoom=0, maxZoom=22, maxNativeZoom=18)
map <- addTiles(map, options=options.tile)
map <- addScaleBar(map)

#----------------------------------------------------------------------------------------------------
server <- function(input, output, session) {

  output$mymap <- renderLeaflet(map)

  observeEvent(input$mymap_marker_click, {
     proxy <- leafletProxy("mymap", session)
     id <- input$mymap_marker_click$id
     printf("click: %s", id)
     removeMarker(proxy, id)
     })

  observe({   # helpful in accurate positioning of markers
     x <- input$mymap_click
     req(x)
     printf("--- map_click")
     printf("lat: %f", x$lat)
     printf("lon: %f", x$lng)
     })



} # server
#----------------------------------------------------------------------------------------------------
runApp(shinyApp(ui, server), host="0.0.0.0", port=6781)

