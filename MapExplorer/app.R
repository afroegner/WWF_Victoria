#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
# 
# Helpful link for integrating leaflet in shiny: 
# https://rstudio.github.io/leaflet/shiny.html

library(shiny)
library(leaflet)
library(htmltools)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Lake Victoria Communities and Water Quality"),
      
      # Show a Leaflet map
      mainPanel(
         leafletOutput("map")
      )
   )

# Define server logic required to display a Leaflet map
server <- function(input, output) {
  df <- read.csv("/nfs/waterwomenfisheries-data/Site_Info.csv") #read in csv with lat, long, and info you want displayed for each location
  
   output$map <- renderLeaflet({
      leaflet(df) %>%
       addTiles()  %>%
       # can add separate Markers for communities and water samples
       addMarkers(~Longitude,#from df
                  ~Latitude,#from df
                  popup = ~ HTML(paste0("Beach:", Site, "<br>",
                                   ))
                  ) # specify which columns contain the information you want displayed in the popups
       
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

