# DEPhabitat app
# MassDEP Habitat of Potential Regional or Statewide Importance/five color IEI viewer Shiny app
# for embedding in umasscaps.org
# See https://github.com/bwcompton/DEPhabitat
# Before initial deployment on shinyapps.io, need to restart R and:
#    library(remotes); install_github('bwcompton/readMVT'); install_github('bwcompton/leaflet.lagniappe')
# Create geoTIFFs with x:\CAPS\makeCAPSland2020.R then prepare them with makeDEPhabitatTIFFs.R
# B. Compton, 26-27 Jul 2023 (from DEPMEP.R)



library(shiny)
library(leaflet)
library(leaflet.lagniappe)

home <- c(-71.6995, 42.1349)  # center of Massachusetts
zoom <- 8                     # starting zoom level (shows all of Massachusetts)


ui <- fluidPage(
   tags$head(src = 'www/matomo.js'),              # add Matomo tracking JS

   mainPanel(
      leafletOutput('map', width = '680')
   )
)


server <- function(input, output, session) {

   observe({                  # get maptype parameter from URL
      session$userData$maptype <- as.numeric(parseQueryString(session$clientData$url_search)$maptype)[1]
      if(is.na(session$userData$maptype)) session$userData$maptype <- 1  # default is important habitat map
   })

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
            layers = switch(session$userData$maptype , 'DEPhabitat:DEPhabitat', 'DEPhabitat:fivecolor'),
            options = WMSTileOptions(opacity = switch(session$userData$maptype , 0.25, 0.4))) |>
         setView(lng = home[1], lat = home[2], zoom = zoom) |>
         osmGeocoder(email = 'bcompton@umass.edu') |>
         addScaleBar(position = 'bottomright') |>
         addFullscreen()
   })
}

shinyApp(ui, server)
