appInfo <- "There are times when a model’s prediction should be taken with some
skepticism. For example, if a new data point is substantially different from
the training set, it’s predicted value may be suspect. In chemistry, it is not
uncommon to create an “applicability domain” model that measures the amount of
potential extrapolation new samples have from the training set. applicable
contains different methods to measure how much a new data point is an
extrapolation from the original data (if at all)."

help_tab <- argonTabItem(
  tabName = "help",
  argonDashHeader(
    gradient = TRUE,
    color = "warning",
    separator = TRUE,
    separator_color = "info",
    top_padding = 5,
    bottom_padding = 5,
    argonRow(
      argonColumn(
        width = 6,
        h1("Help")
      )
    )
  ),
  argonDashHeader(
    gradient = FALSE,
    color = "info",
    top_padding = 2,
    bottom_padding = 2,
    argonRow(
      argonCard(
        width = 12,
        src = NULL,
        icon = icon("cogs"),
        status = "success",
        shadow = TRUE,
        border_level = 2,
        hover_shadow = TRUE,
        h1("The applicable package"),
        appInfo
      )
    )
  )
)
