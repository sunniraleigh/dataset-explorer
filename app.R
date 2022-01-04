# LOAD PACKAGES
library(shiny)
library(shinydashboard)
library(tidyverse)
library(palmerpenguins)

# FUNCTIONS

# UI
ui <- dashboardPage(
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
  upload_dataset <- reactive({
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
    head(dataset())
  })
  
}

# RUN
shinyApp(ui = ui, server = server)
