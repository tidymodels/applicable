library(shiny)
library(argonR)
library(argonDash)
library(magrittr)

# templates
source("templates/sidebar.R")
source("templates/header.R")
source("templates/footer.R")

# elements
source("elements/upload_tab.R")
source("elements/models_tab.R")
source("elements/help_tab.R")

# App
shiny::shinyApp(
  ui = argonDashPage(
    title = "Applicability Domain Methods",
    author = "Marly Cormar & Max Kuhn",
    description = "Applicability Domain Methods Using `applicable`",
    sidebar = argonSidebar,
    header = argonHeader,
    body = argonDashBody(
      argonTabItems(
        upload_tab,
        models_tab,
        help_tab
      )
    ),
    footer = argonFooter
  ),
  server = function(input, output) {

    train_data <- reactive({
      infile <- input$uploaded_data

      if (is.null(infile))
        return(NULL)

      read.csv(infile$datapath, header = TRUE, sep = ",")
    })

    output$dataOverview <- renderDataTable({
      head(train_data())
    })

    # output$dataSummary <- renderTable({
    #   req(input$train_data)
    #   df <- read.csv(input$train_data$datapath)
    #   return(head(df))
    #   }, options = list(scrollX = FALSE)
    # )


  })
