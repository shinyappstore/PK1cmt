#### Load required libraries for ui.R
library(shiny)
library(shinydashboard)

## Source all files with the R functions - This will load the functions in the environment
file.sources = list.files("./Functions",full.names = T)
sapply(file.sources,source,.GlobalEnv)

## Shiny UI code
shinyUI( 
  dashboardPage(skin = "black",
                dashboardHeader(title = "Pharmacokinetic profiles", titleWidth = 250,
                                tags$li(a(href = 'http://www.PMXSolutions.com', # Link to the website
                                          img(src = 'Logo.png',
                                              title = "PMX Solutions", height = "50px"),
                                          style = "padding-top:0px; padding-bottom:0px;"),
                                        class = "dropdown")),
  

  # Specify the sidebar menu items with icons
  dashboardSidebar(
    tags$style(type = "text/css", 
               ".irs-grid-text {color: white !important}",
               ".irs-grid-text {font-size: 1rem !important}"),
    
    sliderInput("dose", "Dose",
                min = 10, max = 1000,
                value = 500,post=" mg"),
    
    hr(),
    
    sliderInput("KA", "Absorption rate constant:",
                min = 0, max = 5,step = 0.1,
                value = 0.5,post=" /h"),
    
    sliderInput("BIOF", "Bioavailability:",
                min = 0, max = 100,
                value = 42,post=" %"),
    
    hr(),
    
    sliderInput("CL", "Clearance:",
                min = 0, max = 100,
                value = 10,post=" L/h"),
    
    
    sliderInput("VD", "Volume of distribution:",
                min = 0, max = 1000,
                value = 48, post=" L"),
    
    hr(),
    
    actionButton("save","Save profile", class = "btn-warning")
    
    
    

  ),
  
  # body of the app
  dashboardBody(
UIhome()
    
  )
))