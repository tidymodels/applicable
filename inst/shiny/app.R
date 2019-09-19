library(shiny)
library(DT)
library(argonR)
library(argonDash)
library(magrittr)
library(dplyr)
library(recipes)
library(applicable)
library(ggplot2)
library(ggiraph)
library(ggforce)
library(readr)
library(shinyjs)


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
      useShinyjs(),
      tags$head(
        tags$script(src="js/functions.js"),
        tags$link(rel = "stylesheet", type = "text/css", href = "css/styles.css")
      ),
      argonTabItems(
        upload_tab,
        models_tab,
        help_tab
      )
    ),
    footer = argonFooter
  ),
  server = function(input, output, session) {

    # Increase file upload size to 10MB
    options(shiny.maxRequestSize=10*1024^2)

    # Get uploaded train data
    train_data <- reactive({
      req(input$uploaded_train_data)
      infile <- input$uploaded_train_data
      read_csv(infile$datapath)
    })

    # Get uploaded test data
    test_data <- reactive({
      req(input$uploaded_train_data, input$uploaded_test_data)
      infile <- input$uploaded_test_data
      output_file <- read_csv(infile$datapath)

      col_names <- names(train_data())
      if(!identical(col_names, names(output_file))) {
        showModal(modalDialog(
          title = "Mismatching Columns",
          "The sample set must contain the same columns as the training set. Please try to upload the sample set again.",
          easyClose = TRUE,
          footer = NULL
        ))
        shinyjs::reset('uploaded_test_data')
        output_file <- NULL
      }

      output_file
    })

    observe({
      if(is.null(input$uploaded_train_data)){
        shinyjs::disable("uploaded_test_data")
      }
      else {
        shinyjs::enable("uploaded_test_data")
      }
    })

    # Observe selected columns for train data
    observe({
      req(input$uploaded_train_data, input$uploaded_test_data)

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
      req(input$uploaded_train_data, input$uploaded_test_data, input$data_cols)

      datatable(
        data = {
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
      req(input$uploaded_train_data, input$uploaded_test_data, input$data_cols)

      datatable(
        data = {
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
      req(input$data_cols, input$uploaded_train_data, input$uploaded_test_data)

      get_recipe(train_data() [, input$data_cols])
    })

    # ArgonTable
    output$argonTable <- renderUI({
      req(input$data_cols, input$uploaded_train_data, input$uploaded_test_data)

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
      req(input$data_cols, input$uploaded_train_data, input$uploaded_test_data)
      train_data_val <- train_data()
      curData <- train_data_val %>% select(input$data_cols)
      pca_modeling_function <- apd_pca(train_recipe(), curData, (input$pcs_threshold)*0.01)

      pcs_count <- pca_modeling_function$num_comp
      if(!is.null(pcs_count)){
        # Update slider options
        updateSliderInput(session, "pcs_range", value = min(10, pcs_count),
                          min = 1, max = pcs_count)
      }

      pca_modeling_function

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

    output$pca_score <- renderDT({
      datatable(
        data = {
          pca_output <- pca()
          if(!is.null(pca_output)){
            round(score(pca_output, test_data()), digits = 1)
          }
        },
        options = list(
          searching = FALSE,
          lengthChange= FALSE,
          scrollX = TRUE
        )
      )
    })

    output$pca_score_plot <- renderggiraph({
      pca_model <- pca()
      if(!is.null(pca_model)){
        unk_pca <-
          score(pca_model, test_data()) %>%
          select(1:min(pca_model$num_comp, 3)) %>%
          mutate(row_num  = row_number())

        tr_pca <-
          score(pca_model, train_data()) %>%
          select(1:min(3, pca_model$num_comp))

        tr_pca_cols <- colnames(tr_pca)

        scat_mat <-
          ggplot(unk_pca) +
          geom_point(data = tr_pca, aes(x = .panel_x, y = .panel_y), alpha = .1, cex = .1,) +
          geom_point_interactive(aes(x = .panel_x, y = .panel_y, tooltip = row_num),
                                 col = "#5e72e4") +
          facet_matrix(vars(dplyr::one_of(tr_pca_cols)))

        girafe(ggobj = scat_mat)

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

    output$hat_score_plot <- renderPlot({
    })

    output$hat_values_score <- renderDT({
      datatable(
        data = {
          hats_output <- hat_values()
          if(!is.null(hats_output)){
            round(score(hats_output, test_data()), digits = 1)
          }
        },
        options = list(
          searching = FALSE,
          lengthChange= FALSE,
          scrollX = TRUE
        )
      )
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
      sim_output <- sim()
      if(!is.null(sim_output)){
        autoplot(sim_output)
      }
    })

    output$sim_score_plot <- renderPlot({
      if(!is.null(sim())){
        autoplot(sim())
      }
    })

    output$sim_score <- renderDT({
      datatable(
        data = {
          sim_output <- sim()
          if(!is.null(sim_output)){
            round(score(sim_output, test_data()), digits = 1)
          }
        },
        options = list(
          searching = FALSE,
          lengthChange= FALSE,
          scrollX = TRUE
        )
      )
    })
  })
