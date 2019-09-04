upload_tab <- argonTabItem(
  tabName = "upload",

  argonH1("Upload Data", display = 4),

  argonRow(
    argonColumn(
      width = 12,
      fileInput("uploaded_data", "Choose a data file",
                multiple = FALSE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv"))
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
        title = "Model Training Data",
        #argonColumn(tableOutput("dataSummary"))
        selectInput("train_data_cols", "Select columns to display", choices = "", multiple = TRUE),
        argonColumn(dataTableOutput("dataOverview"))
      )
    ),
    br(), br()
  )
)
