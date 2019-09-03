source("elements/pca.R")

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
        argonTab(
          tabName = "PCA",
          active = FALSE,
          tabPCA
        ),
        argonTab(
          tabName = "Similarity Statistics",
          active = TRUE,
          tabPCA
        ),
        argonTab(
          tabName = "Hat Values",
          active = FALSE,
          tabPCA
        )
      )
    )
  )
)
