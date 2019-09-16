upload_tab <- argonTabItem(
  tabName = "upload",

  argonH1("Upload Data", display = 4),

  argonRow(
    argonColumn(
      width = 12,
      "Download example data sets:",
      br(),
      downloadButton("downloadExampleData", "Download Data Sets"),
      br(), br()
    ),

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
      width = 12,
      selectInput("data_cols", "Select columns", choices = "", multiple = TRUE, width = '100%')
    ),

    argonCard(
      width = 12,
      src = NULL,
      icon = icon("cogs"),
      status = "success",
      shadow = TRUE,
      border_level = 2,
      hover_shadow = TRUE,
      title = "Training Set",
      DTOutput("trainDataOverview")
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
      DTOutput("testDataOverview")
    )
  )
)
