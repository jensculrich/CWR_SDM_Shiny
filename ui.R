###########################
# ui.R for CWR Shiny App  #
###########################

# Written by Jens Ulrich 
# OCTOBER 2024

###########################
# LIBRARIES               #
###########################

library(shiny)
library(raster)
library(sp)
library(leaflet)
library(htmltools)
library(shinydashboard)
library(markdown)

###########
# LOAD UI #
###########

# ui structure: one navbar page with 3 tab panels

ui <- fluidPage(
  
  dashboardPage(
    
    skin = "red",
    
    dashboardHeader(title = "Canadian Crop Wild Relative Species Distribution Models", titleWidth = 500),
    
    dashboardSidebar(
      
      sidebarMenu(
        menuItem("Wild Apple Species Distributions", tabName = "apple", icon = icon("apple")),
        menuItem("About", tabName = "aknow", icon = icon("tasks"))
      ), # end sidebarMenu
      
      width = 300         
    ), # end dashboardSidebar
    
    dashboardBody(
      tabItems(
        
        # Fourth tab element
        tabItem(tabName = "apple",
                
                includeMarkdown("www/apple.md"),
                
                fluidRow(
                  box(
                    width = 4,
                    collapsible = T,
                    
                    # want to update this so it's dependent on users choice of provinces v. ecoregions
                    # user chooses a species of interest
                    selectInput("inAppleSpecies", "Select an apple CWR species", 
                                choices = c("Malus coronaria (sweet crabapple)", 
                                            "Malus fusca (Pacific crabapple)"),
                                selected = "Malus coronaria (sweet crabapple)"
                    ), # end select input
                    # user chooses an emissions scenario of interest
                    selectInput("inSelectedEmissions", "Select an emissions scenario", 
                                choices = c("low (ssp245)", "high (ssp585)"),
                                selected = "low (ssp245)"
                    ), # end select input
                    # user chooses a time projection of interest
                    selectInput("inSelectedProjection", "Select a time projection", 
                                choices = c("historical (1970-2000)", "2030", "2050", "2070"),
                                selected = "2030"
                    ), # end select input
                    # user chooses a habitat suitability degree
                    # update this so that user can choose a CWR without first selecting crop
                    selectInput("inSelectedHabitatSuitability", "Select degree of habitat suitability", 
                                choices = c("low to high", 
                                            "moderate to high", 
                                            "high"),
                                selected = "moderate to high"
                    ) # end select input
                  ), # end box
                  
                  box(
                    width = 8,
                    collapsible = T,
                    leafletOutput("choroplethPlot", 
                                  width = "100%", height = "700px")
                  ) # end box
                  
                ), # end fluidRow
                
                includeMarkdown("www/apple2.md")
                
        ), # end fifth tabItem element
        
        tabItem(tabName = "aknow", 
                
                includeMarkdown("www/aknow.md")
        ) # end fifth tabItem element
        
      ) # end tabItems
    ) # end dashboardBody
  ) # end dashboardPage
) # ui

