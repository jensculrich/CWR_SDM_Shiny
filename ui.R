###########################
# ui.R for CWR Shiny App  #
###########################

# Written by Jens Ulrich 
# OCTOBER 2024

###########################
# LIBRARIES               #
###########################

library(shiny)
library(tidyverse)
library(raster)
library(leaflet)
library(htmltools)
library(shinydashboard)
library(markdown)

###########
# LOAD UI #
###########

# ui structure: one navbar page with 5 tab panels

ui <- fluidPage(
  
  includeCSS("www/style.css"),
  
  dashboardPage(
    
    skin = "blue",
    
    dashboardHeader(title = "Canadian Crop Wild Relative Species Distribution Models", titleWidth = 1000),
    
    dashboardSidebar(
      
      sidebarMenu(
        menuItem("CWR Species Distribution Models", tabName = "apple", icon = icon("apple")),
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
                                            "Malus fusca (Pacific crabapple)", 
                                            ""),
                                selected = ""
                    ), # end select input
                    # user chooses an emissions scenario of interest
                    selectInput("inSelectedEmissions", "Select an emissions scenario", 
                                choices = c("low (ssp245)", "high (ssp585)"),
                                selected = ""
                    ), # end select input
                    # user chooses a time projection of interest
                    selectInput("inSelectedProjection", "Select a time projection", 
                                choices = c("2030", "2050", "2070"),
                                selected = ""
                    ), # end select input
                    # user chooses a habitat suitability degree
                    # update this so that user can choose a CWR without first selecting crop
                    selectInput("inSelectedHabitatSuitability", "Select degree of habitat suitability", 
                                choices = c("",
                                            "low to high", 
                                            "moderate to high", 
                                            "high"),
                                selected = "moderate to high"
                    ) # end select input
                  ), # end box
                  
                  box(#title = "Range map", solidHeader = T,
                    width = 8, collapsible = T,
                    leafletOutput("choroplethPlot3")
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

