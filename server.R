#### Load required libraries
library(shiny)
library(shinydashboard)
library(mrgsolve)
library(dplyr)
library(ggplot2)
library(flux)
library(rmarkdown)
library(cowplot)
library(RColorBrewer)
library(magrittr)


## Shiny server code
shinyServer(function(input, output,session) {

mod <- mread_cache("popPK",soloc='mrgsolve')  


  saved_params = data.frame(amt= 500,
                            TVKA = 0.5,
                            TVF = 42,
                            TVCL =10,
                            TVVC = 48)
  saved_params <- reactiveVal(saved_params)
  
  
  saved_plots_label= "Default"
  saved_plots_label <- reactiveVal(saved_plots_label)
  
  counter <- 2
  counter <- reactiveVal(counter)
  
  
  
  
  
  
  
################ Parameter set
sim_parameters <- reactive({
  if(input$dose ==0 | input$KA == 0 | input$BIOF == 0 | input$CL == 0 | input$VD ==0 ) {return(NULL)}
  
  param <- data.frame(amt=input$dose*100,
                         TVKA = input$KA,
                         TVF = input$BIOF,
                         TVCL =input$CL,
                         TVVC = input$VD)

  param
  }) 

sim_parameters_d <- sim_parameters %>% 
  debounce(500)




######################################################################################
################# Run mrgsolve simulation upon button click
# DF_Simulation holds simulated data
DF_Simulation <- reactive({
  print(sim_parameters_d())
  if(!is.null(sim_parameters_d())){
    simulated_Data <- run_simulation(input,mod,sim_parameters_d())
    simulated_Data
  }

})




# lin_log_plots is a ggplot object of the simulated PK profiles
lin_log_plots <- reactive({

 graph_function(DF_Simulation(),input)
})





###############################################################
##################### Save the plot to a list
observeEvent(input$save, {
  
  ## Get current counter
  current_count <- counter()
  
  ####### Add labels
  add_label=c(saved_plots_label(),paste('Figure',current_count))
  saved_plots_label(add_label)

  #### Update the selectinput 
  updateSelectInput(session, "saved_figures",
                    choices = saved_plots_label()
  )

  
  

  ######### Add df
  current_params <- saved_params()
  current_params <- rbind(current_params,
               data.frame(amt=input$dose,
               TVKA = input$KA,
               TVF = input$BIOF,
               TVCL =input$CL,
               TVVC = input$VD) )

  
  print(current_params)
  saved_params(current_params)
  
  next_counter <-  current_count + 1
  
  counter(next_counter)

  showNotification("Plot saved to list")
  
}) 




observeEvent(input$saved_figures, {
  
  
  figure_selected <-input$saved_figures
  
  if(length(figure_selected) == 1){
    
    current_params <- saved_params()
    
    ## Select the plot
    selected_parameters <- current_params[match(figure_selected,saved_plots_label()),]
    
    #### Update the slider
    updateSliderInput(session, "dose",value=selected_parameters$amt)
    updateSliderInput(session, "KA",value=selected_parameters$TVKA)
    updateSliderInput(session, "BIOF",value=selected_parameters$TVF)
    updateSliderInput(session, "CL",value=selected_parameters$TVCL)
    updateSliderInput(session, "VD",value=selected_parameters$TVVC)
    
  }
    
})



## Show the plot 
output$PKplot <- renderPlot({
  
    lin_log_plots()

})





  
  
})
