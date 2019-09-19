
tabsSkeleton <- function(name, options = NULL, active = FALSE) {

  outputModels <- list(
    "PCA" = "pca",
    "Hat Values" = "hat_values",
    "Similarity Statistics" = "sim"
  )

  outputModel <- outputModels[[name]]

  return(
    argonTab(
      tabName = name,
      active = active,
      argonCard(
        width = 12,
        title = paste0(name, " Output"),
        verbatimTextOutput(paste(outputModel, "render", sep = "_"))
      ),
      if(name == "PCA")
        argonCard(
          width = 12,
          title = "Distance Metric",
          plotOutput(paste(outputModel, "plot", "dist", sep = "_"))
        ),
      if(name == "PCA"){
        argonCard(
          width = 12,
          title = "Principal Components",
          argonRow(
          argonColumn(
            width = 6,
            sliderInput("pcs_range",
                      "PCs Range:",
                      min = 1, max = 100,
                      value = 10, step = 1)
          ),
          argonColumn(
            width = 6,
            sliderInput("pcs_threshold",
                      "Threshold:",
                      min = 1, max = 100,
                      value = 95, step = 1)
          )),
          plotOutput(paste(outputModel, "plot", "pcs", sep = "_"))
        )
      },
      if(name == "Similarity Statistics")
        argonCard(
          width = 12,
          title = "Plot Model",
          plotOutput(paste(outputModel, "plot", sep = "_"))
        ),
      argonCard(
        width = 12,
        title = "Score plot",
        ggiraphOutput(paste(outputModel, "score", "plot", sep = "_"))
      ),
      argonCard(
        width = 12,
        title = "Score output",
        DTOutput((paste(outputModel, "score", sep = "_")))
      )
    )
  )
}

models_tab <- argonTabItem(
  tabName = "models",

  argonRow(
    # Horizontal Tabset
    argonColumn(
      width = 12,
      argonH1("Modeling Functions", display = 4),
      argonTabSet(
        id = "tab-1",
        card_wrapper = TRUE,
        horizontal = TRUE,
        circle = FALSE,
        size = "sm",
        width = 12,
        iconList = lapply(X = 1:3, FUN = argonIcon, name = "atom"),
        tabsSkeleton("PCA", active = TRUE),
        tabsSkeleton("Hat Values"),
        tabsSkeleton("Similarity Statistics")
      ),
      argonCard(
        width = 12,
        title = "Data Summary",
        uiOutput("argonTable")
      )
    )
  )
)
