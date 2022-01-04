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
    fileInput("upload", NULL, buttonLabel = "Upload", multiple = FALSE, accept = ".csv"),
    actionButton("load_penguins", "Use Practice Data"),
    actionButton("load_upload", "Use Uploaded Data")
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
  
  # Change dataset to penguins
  observeEvent(input$load_penguins, {
    output$head <- renderTable({
      head(penguins)
    })
  })
  
  # Change dataset to uploaded data
  observeEvent(input$load_upload, {
    output$head <- renderTable({
      head(upload_dataset())
    })
  })

}

# RUN
shinyApp(ui = ui, server = server)
