###############################
# server.R for CWR Shiny App  #
###############################

# Written by Jens Ulrich 
# October 2024

########################################
# DATA INPUTS                          #
########################################

#fus_high_ssp585_70 <- readRDS(paste0("data/fus_pred_high_ssp585_70_crop.rds"))
#fus_high_ssp585_50 <- readRDS(paste0("data/fus_pred_high_ssp585_50_crop.rds"))
#fus_high_ssp585_30 <- readRDS(paste0("data/fus_pred_high_ssp585_30_crop.rds"))
#fus_mod_ssp585_70 <- readRDS(paste0("data/fus_pred_mod_ssp585_70_crop.rds"))
#fus_mod_ssp585_30 <- readRDS(paste0("data/fus_pred_mod_ssp585_30_crop.rds"))
#fus_low_ssp585_70 <- readRDS(paste0("data/fus_pred_low_ssp585_70_crop.rds"))
#fus_low_ssp585_50 <- readRDS(paste0("data/fus_pred_low_ssp585_50_crop.rds"))
#fus_low_ssp585_30 <- readRDS(paste0("data/fus_pred_low_ssp585_30_crop.rds"))
#fus_high_ssp245_70 <- readRDS(paste0("data/fus_pred_high_ssp245_70_crop.rds"))
#fus_high_ssp245_50 <- readRDS(paste0("data/fus_pred_high_ssp245_50_crop.rds"))
#fus_high_ssp245_30 <- readRDS(paste0("data/fus_pred_high_ssp245_30_crop.rds"))
#fus_mod_ssp245_70 <- readRDS(paste0("data/fus_pred_mod_ssp245_70_crop.rds"))
#fus_mod_ssp245_50 <- readRDS(paste0("data/fus_pred_mod_ssp245_50_crop.rds"))
#fus_mod_ssp245_30 <- readRDS(paste0("data/fus_pred_mod_ssp245_30_crop.rds"))
#fus_low_ssp245_70 <- readRDS(paste0("data/fus_pred_low_ssp245_70_crop.rds"))
#fus_low_ssp245_50 <- readRDS(paste0("data/fus_pred_low_ssp245_50_crop.rds"))
#fus_low_ssp245_30 <- readRDS(paste0("data/fus_pred_low_ssp245_30_crop.rds"))

#cor_high_ssp585_70 <- readRDS(paste0("data/cor_pred_high_ssp585_70_crop.rds"))
#cor_high_ssp585_50 <- readRDS(paste0("data/cor_pred_high_ssp585_50_crop.rds"))
#cor_high_ssp585_30 <- readRDS(paste0("data/cor_pred_high_ssp585_30_crop.rds"))
#cor_mod_ssp585_70 <- readRDS(paste0("data/cor_pred_mod_ssp585_70_crop.rds"))
#cor_mod_ssp585_50 <- readRDS(paste0("data/cor_pred_mod_ssp585_50_crop.rds"))
#cor_mod_ssp585_30 <- readRDS(paste0("data/cor_pred_mod_ssp585_30_crop.rds"))
#cor_low_ssp585_70 <- readRDS(paste0("data/cor_pred_low_ssp585_70_crop.rds"))
#cor_low_ssp585_50 <- readRDS(paste0("data/cor_pred_low_ssp585_50_crop.rds"))
#cor_low_ssp585_30 <- readRDS(paste0("data/cor_pred_low_ssp585_30_crop.rds"))
#cor_high_ssp245_70 <- readRDS(paste0("data/cor_pred_high_ssp245_70_crop.rds"))
#cor_high_ssp245_50 <- readRDS(paste0("data/cor_pred_high_ssp245_50_crop.rds"))
#cor_high_ssp245_30 <- readRDS(paste0("data/cor_pred_high_ssp245_30_crop.rds"))
#cor_mod_ssp245_70 <- readRDS(paste0("data/cor_pred_mod_ssp245_70_crop.rds"))
#cor_mod_ssp245_50 <- readRDS(paste0("data/cor_pred_mod_ssp245_50_crop.rds"))
#cor_mod_ssp245_30 <- readRDS(paste0("data/cor_pred_mod_ssp245_30_crop.rds"))
#cor_low_ssp245_70 <- readRDS(paste0("data/cor_pred_low_ssp245_70_crop.rds"))
#cor_low_ssp245_50 <- readRDS(paste0("data/cor_pred_low_ssp245_50_crop.rds"))
#cor_low_ssp245_30 <- readRDS(paste0("data/cor_pred_low_ssp245_30_crop.rds"))

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
    
    if(c == "2030"){
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
    
    stringy_cat <- paste0(stringy1, "_pred_", stringy4, "_", stringy2, "_", stringy3)
    
    r <- raster(paste0("data/", stringy_cat, "_crop.tif"))
    #r <- raster("data/fus_pred_mod_ssp585_70_crop.tif")
    r[r[] < 1 ] = NA 
    
    return(r)
    
  })
  
  output$choroplethPlot3 <- renderLeaflet({
    
    # Basic choropleth with leaflet
    leaflet() %>% 
      addTiles() %>%
      setView(lat=45, lng=-98 , zoom=3.5)  
    
  }) # end renderPlot
  
  observe({
    leafletProxy("choroplethPlot3") %>%
      clearImages() %>%
      addRasterImage(applePlotData(),
                     colors = "blue",
                     opacity = 0.5)
  })
  
}) # shinyServer
