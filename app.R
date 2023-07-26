# DEPhabitat app
# MassDEP Habitat of Potential Regional or Statewide Importance viewer Shiny app
# See https://github.com/bwcompton/DEPhabitat
# Before initial deployment on shinyapps.io, need to restart R and:
#    library(remotes); install_github('bwcompton/readMVT'); install_github('bwcompton/leaflet.lagniappe')
# B. Compton, 26 Jul 2023 (from DEPMEP.R)



library(shiny)
library(leaflet)
library(leaflet.lagniappe)

home <- c(-71.6995, 42.1349)  # center of Massachusetts
zoom <- 8                     # starting zoom level (shows all of Massachusetts)


ui <- fluidPage(
   mainPanel(
      leafletOutput('map', width = '680')
   )
)


server <- function(input, output) {
   output$map <- renderLeaflet({
      leaflet() |>
         addTiles(urlTemplate = '', attribution =
                     '<a href="https://www.mass.gov/orgs/massachusetts-department-of-environmental-protection"
                      target="_blank" rel="noopener noreferrer">Mass DEP</a>
                      | <a href="https://umassdsl.org" target="_blank" rel="noopener noreferrer">UMass DSL</a>
                      | <a href="https://umassdsl.webgis1.com/hesk" target="_blank" rel="noopener noreferrer">Get help</a>') |>
         addProviderTiles(providers$Esri.WorldTopoMap) |>
         addWMSTiles(
            'https://umassdsl.webgis1.com/geoserver/wms',
            layers = 'DEPhabitat:DEPhabitat',
            options = WMSTileOptions(opacity = 0.25),
         ) |>
         setView(lng = home[1], lat = home[2], zoom = zoom) |>
         osmGeocoder(email = 'bcompton@umass.edu') |>
         addScaleBar(position = 'bottomright') |>
         addFullscreen()
   })
}

shinyApp(ui, server)
