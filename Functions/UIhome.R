#####################################
## Set all model parameters
UIhome <- function() {

  fluidRow(
    box(solidHeader = TRUE, status = "primary",collapsible = F,title="Pharmacokinetic profile over time",width=9,
        plotOutput("PKplot",height=600)
    ),
    box(solidHeader = TRUE, status = "primary",collapsible = F,title="Saved profiles",width=3,
        selectInput("saved_figures","",size=10,multiple=F,choices="Default",selected="Default",selectize = F)

    )
  )
}


