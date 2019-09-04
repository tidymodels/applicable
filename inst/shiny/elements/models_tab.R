source("models/pca.R")

tabsSkeleton <- function(name, outputOptions) {
  return(
    argonTab(
      tabName = name,
      active = TRUE,
      tabPCA()
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
        tabsSkeleton("PCA"),
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
