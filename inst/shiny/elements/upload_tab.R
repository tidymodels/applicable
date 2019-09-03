upload_tab <- argonTabItem(
  tabName = "upload",

  argonH1("Upload Data", display = 4),
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
      fileInput("file1", "Choose a data file",
                multiple = FALSE,
                accept = c("text/csv",".csv")),
      # Horizontal line ----
      tags$hr(),
      argonRow(
        argonColumn(
          width = 6,
          sliderInput(
            "obs",
            "Number of observations:",
            min = 0,
            max = 1000,
            value = 500
          )
        ),
        argonColumn(width = 6, plotOutput("distPlot"))
      )
    ),
    br(), br()
  )
)
