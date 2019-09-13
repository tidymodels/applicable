library(shiny)
library(DT)
library(argonR)
library(argonDash)
library(magrittr)
library(applicable)
library(ggplot2)
library(readr)

# Load templates
source("templates/sidebar.R")
source("templates/header.R")
source("templates/footer.R")

# Load elements
source("elements/upload_tab.R")
source("elements/models_tab.R")
source("elements/help_tab.R")

# Load functions
source("functions/pre_process_data.R")
source("functions/get_example_data.R")
source("functions/utils.R")

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

    options(shiny.maxRequestSize=10*1024^2)

    # Get uploaded train data
    train_data <- reactive({
      infile <- input$uploaded_train_data

      if (is.null(infile))
        return(NULL)

      read_csv(infile$datapath)
    })

    # Get uploaded test data
    test_data <- reactive({
      infile <- input$uploaded_test_data

      if (is.null(infile))
        return(NULL)

      read_csv(infile$datapath)
    })

    # Observe selected columns for train data
    observe({
      updateSelectInput(
        session,
        "data_cols",
        choices = names(train_data()),
        selected = names(train_data())
      )
    })

    output$downloadExampleData <- downloadHandler(
      filename = function(){
        paste("example_data", "zip", sep = ".")
      },
      content = function(fname) {
        tmpdir <- tempdir()
        setwd(tempdir())

        fs <- c(save_ames_data(tmpdir), save_binary_data(tmpdir))
        zip(zipfile=fname, files=fs)
      },
      contentType = "application/zip"
    )

    # Show a subset of the data based on the columns observed
    output$trainDataOverview <- renderDT({
      datatable(
        data = {
          if(!is.null(train_data()) && !is.null(input$data_cols))
            train_data() [, input$data_cols]
        },
        options = list(
          searching = FALSE,
          lengthChange= FALSE,
          scrollX = TRUE
        )
      )
    })

    # Show a subset of the data based on the columns observed
    output$testDataOverview <- renderDT({
      datatable(
        data = {
          if(!is.null(test_data()) && !is.null(input$data_cols))
            test_data() [, input$data_cols]
        },
        options = list(
          searching = FALSE,
          lengthChange= FALSE,
          scrollX = TRUE
        )
      )
    })

    # Get training recipe
    train_recipe <- reactive({
      if (is.null(train_data) || is.null(input$data_cols))
        return(NULL)

      get_recipe(train_data() [, input$data_cols])
    })

    # ArgonTable
    output$argonTable <- renderUI({
      if(is.null(train_data()))
         "Please upload your data"
      else {
        curData <- train_data() [, input$data_cols]

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

    # Server side for PCA
    pca <- reactive({
      if(!is.null(train_data()) && !is.null(input$data_cols)) {
        curData <- train_data() %>% select(input$data_cols)
        pca_modeling_function <- apd_pca(train_recipe(), curData)

        pcs_count <- pca_modeling_function$num_comp
        if(!is.null(pcs_count)){
          # Update slider options
          updateSliderInput(session, "pcs_range", value = floor(pcs_count/2),
                            min = 1, max = pcs_count)
        }

        pca_modeling_function
      }
    })

    output$pca_render <- renderPrint({
      pca_model <- pca()
      if(!is.null(pca_model)){
        print(pca_model)
      }
    })

    output$pca_plot_dist <- renderPlot({
      pca_model <- pca()
      if(!is.null(pca_model)){
        autoplot(pca_model, "distance")
      }
    })

    output$pca_plot_pcs <- renderPlot({
      pca_model <- pca()
      if(!is.null(pca_model)){
        # Create formatted list of pcs
        pcs_list <- create_formated_pcs_list(pca_model$num_comp)
        matches_string <- paste0("^PC", pcs_list[1:input$pcs_range], collapse = "|")
        autoplot(pca_model, matches(matches_string))
      }
    })

    output$pca_score <- renderDataTable({
      if(!is.null(pca())){
        round(score(pca(), test_data()), digits = 1)
      }
    })

    # Server side for Hat Values
    hat_values <- reactive({
      if(!is.null(train_data())) {
        curData <- train_data() [, input$data_cols]
        apd_hat_values(train_recipe() %>% step_lincomb(all_predictors()),
                       curData)
      }
    })

    output$hat_values_render <- renderPrint({
      if(!is.null(hat_values())){
        print(hat_values())
      }
    })

    output$hat_values_plot <- renderPlot({
    })

    output$hat_values_score <- renderDataTable({
      if(!is.null(hat_values())){
        round(score(hat_values(), test_data()), digits = 1)
      }
    })

    # Server side for Similarity
    sim <- reactive({
      if(!is.null(train_data())) {
        curData <- train_data() %>% select(input$data_cols)
        not_bin <- apply(curData, 2, function(x) any(x != 1 & x != 0))
        if (!any(not_bin)) {
          apd_similarity(curData)
        }
      }
    })

    output$sim_render <- renderPrint({
      if(!is.null(sim())){
        print(sim())
      }
      else{
        curData <- train_data() %>% select(input$data_cols)
        not_bin <- apply(curData, 2, function(x) any(x != 1 & x != 0))
        if (any(not_bin)) {
          bad_x <- colnames(curData)[not_bin]
          print(paste0("Unable to compute similarity statistics because ",
                       "the following variables are not binary: ",
                       paste0(bad_x, collapse = ", ")))
        }
      }
    })

    output$sim_plot <- renderPlot({
      if(!is.null(sim())){
        autoplot(sim())
      }
    })

    output$sim_score <- renderDataTable({
      if(!is.null(sim())){
        round(score(sim(), test_data()), digits = 1)
      }
    })
  })
