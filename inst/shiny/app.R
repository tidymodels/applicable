library(shiny)
library(argonR)
library(argonDash)
library(magrittr)
library(applicable)

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


    # ArgonTable
    output$argonTable <- renderUI({

      if(is.null(train_data()))
         "Please upload your data"
      else {
        curData <- train_data() [, input$train_data_cols]

        argonTable(
          cardWrap = FALSE,
          title = "aljsdf",
          headTitles = c(
            "No. Predictors",
            "No. Samples",
            "Selected Columns"
          ),
          argonTableItems(
            argonTableItem(dataCell = TRUE, ncol(curData)),
            argonTableItem(dataCell = TRUE, nrow(curData)),
            argonTableItem(paste(colnames(curData), collapse = ", "))
          )
        )
      }
    })

    output$pca <- renderUI({
      if(is.null(train_data()))
        "Please upload your data"
      else {
        curData <- train_data() [, input$train_data_cols]
        "apd_pca(curData)"
      }
    })

    output$hat_values <- renderUI({
      if(is.null(train_data()))
        "Please upload your data"
      else {
        curData <- train_data() [, input$train_data_cols]
        "apd_hat_values(curData)"
      }
    })

    output$sim <- renderUI({
      if(is.null(train_data()))
        "Please upload your data"
      else {
        curData <- train_data() [, input$train_data_cols]
        "apd_similarity(curData)"
      }
    })

    # output$dataSummary <- renderTable({
    #   req(input$train_data)
    #   df <- read.csv(input$train_data$datapath)
    #   return(head(df))
    #   }, options = list(scrollX = FALSE)
    # )
  })
