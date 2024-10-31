###############################
# server.R for CWR Shiny App  #
###############################

# Written by Jens Ulrich 
# October 2024

################
# SERVER LOGIC #
################

shinyServer(function(input, output, session){
  
  ####################
  #  3) Apple SDMs   #  
  ####################
  
  # generate an apple sdm based on user inputs
  applePlotData <- reactive({ 
    
    a <- input$inAppleSpecies
    
    if(a == "Malus coronaria (sweet crabapple)"){
      stringy1 = "cor"
    } else {
      stringy1 = "fus"
    }
    
    b <- input$inSelectedEmissions
    
    if(b == "low (ssp245)"){
      stringy2 = "ssp245"
    } else {
      stringy2 = "ssp585"
    }
    
    c <- input$inSelectedProjection
    
    if(c=="historical (1970-2000)"){
      stringy3 = "hist"
    } else if(c == "2030"){
      stringy3 = "30"
    } else if(c == "2050") {
      stringy3 = "50"
    } else{
      stringy3 = "70"
    }
    
    d <- input$inSelectedHabitatSuitability
    
    if(d == "high"){
      stringy4 = "high"
    } else if(d == "moderate to high") {
      stringy4 = "mod"
    } else{
      stringy4 = "low"
    }
    
    if(c=="historical (1970-2000)"){
      stringy_cat <- paste0("data/", stringy1, "_pred_", stringy4, "_", stringy3, "_crop.tif")
    } else{
      stringy_cat <- paste0("data/", stringy1, "_pred_", stringy4, "_", stringy2, "_", stringy3, "_crop.tif")
    }
    
    r <- raster(stringy_cat)
    r[r[] < 1 ] = NA 
    
    return(r)
    
  })
  
  output$choroplethPlot <- renderLeaflet({
    
    # Basic choropleth with leaflet
    leaflet() %>% 
      addTiles() %>%
      setView(lat=50, lng=-98 , zoom=3.5)  
    
  }) # end renderPlot
  
  observe({
    
    leafletProxy("choroplethPlot") %>%
      leaflet::clearImages() %>%
      leaflet::addRasterImage(applePlotData(),
                     opacity = 0.5,
                     colors = "blue")
  })
  
}) # shinyServer
