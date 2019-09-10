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
      fileInput("uploaded_test_data", "Choose a sample set",
                multiple = FALSE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv"))
    ),

    argonColumn(
      width = 6,
      selectInput("data_cols", "Select columns", choices = "", multiple = TRUE)
    ),

    argonColumn(
      width = 6,
      "Download example data sets:",
      br(),
      downloadButton("downloadExampleData", "Download Data Sets")
    ),

    argonRow(
      argonCard(
        width = 12,
        src = NULL,
        icon = icon("cogs"),
        status = "success",
        shadow = TRUE,
        border_level = 2,
        hover_shadow = TRUE,
        title = "Training Set",
        #argonColumn(tableOutput("dataSummary"))
        argonColumn(dataTableOutput("trainDataOverview"))
      ),
      argonCard(
        width = 12,
        src = NULL,
        icon = icon("cogs"),
        status = "success",
        shadow = TRUE,
        border_level = 2,
        hover_shadow = TRUE,
        title = "Sample Set",
        #argonColumn(tableOutput("dataSummary"))
        argonColumn(dataTableOutput("testDataOverview"))
      )
    ),
    br(), br()
  )
)
