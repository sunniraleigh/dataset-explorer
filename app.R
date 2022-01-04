# LOAD PACKAGES
library(shiny)
library(shinydashboard)
library(tidyverse)
library(palmerpenguins)

# FUNCTIONS


# UI
ui <- fluidPage(
  dashboardHeader(),
  dashboardSidebar(
    fileInput("upload", NULL, buttonLabel = "Upload", multiple = FALSE, accept = ".csv")
  ),
  dashboardBody(
    tableOutput("head")
  )
)

# SERVER
server <- function(input, output) {
  # Handle data upload
  dataset <- shiny::reactice({
    req(input$upload)
    
    # validate input
    ext <- tools::file_ext(input$upload$name)
    switch(ext,
           csv = vroom::vroom(input$upload$datapath, delim = ","),
           validate("Invalid file; Please upload a .csv file")
    )
  })
  
  # Create ouput
  output$head <- renderTable({
    head(data())
  })
  
}

# RUN
shinyApp(ui = ui, server = server)
