upload_tab <- argonTabItem(
  tabName = "upload",

  argonH1("Upload Data", display = 4),

  argonRow(
    argonColumn(
      width = 6,
      fileInput("uploaded_train_data", "Choose a training set",
                multiple = FALSE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv"))
    ),

    argonColumn(
      width = 6,
      fileInput("uploaded_test_data", "Choose a test set",
                multiple = FALSE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv"))
    ),

    argonRow(
      argonCard(
        width = 6,
        src = NULL,
        icon = icon("cogs"),
        status = "success",
        shadow = TRUE,
        border_level = 2,
        hover_shadow = TRUE,
        title = "Model Training Data",
        #argonColumn(tableOutput("dataSummary"))
        selectInput("train_data_cols", "Select columns", choices = "", multiple = TRUE),
        argonColumn(dataTableOutput("trainDataOverview"))
      ),
      argonCard(
        width = 6,
        src = NULL,
        icon = icon("cogs"),
        status = "success",
        shadow = TRUE,
        border_level = 2,
        hover_shadow = TRUE,
        title = "Model Test Data",
        #argonColumn(tableOutput("dataSummary"))
        selectInput("test_data_cols", "Select columns", choices = "", multiple = TRUE),
        argonColumn(dataTableOutput("testDataOverview"))
      )
    ),
    br(), br()
  )
)
