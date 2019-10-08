upload_tab <- argonTabItem(
  tabName = "upload",

  argonH1("Upload Data", display = 4),

  h3("Upload your training and sample data sets. You can use the example data sets!"),

  downloadLink("downloadExampleData", "Download Example Data Sets"),

  br(), br(), br(),

  argonRow(
    #argonColumn(
    #  width = 12,
      #"Download example data sets:",
      #br(),
    #  downloadLink("downloadExampleData", "Download Example Data Sets"),
    #  br(), br()
    #),

    argonColumn(
      width = 6,
      fileInput(inputId = "uploaded_train_data",
                label = "Choose a training set",
                buttonLabel = "Browse...",
                placeholder = "No file selected",
                multiple = FALSE,
                accept = c(".csv"))
    ),

    argonColumn(
      width = 6,
      disabled(fileInput(inputId = "uploaded_test_data",
                label = "Choose a sample set",
                buttonLabel = "Browse...",
                placeholder = "No file selected",
                multiple = FALSE,
                accept = c(".csv")))
    ),

    argonColumn(
      width = 12,
      selectInput("data_cols", "Selected columns", choices = "", multiple = TRUE, width = '100%')
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
      "Below you will find an overview of your training data set. You can explore it and choose the columns (above) you would like to use as predictors.",
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
      "Below you will find an overview of your sample data set. You can explore it and choose the columns (above) you would like to use as predictors.",
      DTOutput("testDataOverview")
    )
  )
)
