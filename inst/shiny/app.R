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
  server = function(input, output, session) {

    # Reactive uploaded data
    train_data <- reactive({
      infile <- input$uploaded_data

      if (is.null(infile))
        return(NULL)

      read.csv(infile$datapath, header = TRUE, sep = ",")
    })

    # Observe the change in column selection
    observe({
      updateSelectInput(
        session,
        "train_data_cols",
        choices = names(train_data()),
        selected = names(train_data())
      )
    })

    # Show a subset of the data based on the columns observed
    output$dataOverview <- renderDataTable({
      if(!is.null(train_data()))
        train_data() [, input$train_data_cols]
    })

    # Show a subset of the data based on the columns observed
    output$curDataSummary <- renderText({
      if(!is.null(train_data())){
        curData <- train_data() [, input$train_data_cols]
        outputString <- c(paste0("Predictors: ", ncol(curData)),
                          paste0("Samples: ", nrow(curData)),
                          paste0("Columns: ", colnames(curData))
        )
        outputString
      }
      else{
        "Something"
      }
    })

    # output$dataSummary <- renderTable({
    #   req(input$train_data)
    #   df <- read.csv(input$train_data$datapath)
    #   return(head(df))
    #   }, options = list(scrollX = FALSE)
    # )
  })
