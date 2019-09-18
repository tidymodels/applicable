argonSidebar <- argonDashSidebar(
  vertical = TRUE,
  skin = "light",
  background = "white",
  size = "md",
  side = "left",
  id = "my_sidebar",
  brand_url = "https://www.github.com/tidymodels/applicable",
  brand_logo = "images/logo.png",
  argonSidebarHeader(title = "Main Menu"),
  argonSidebarMenu(
    argonSidebarItem(
      tabName = "upload",
      icon = argonIcon(name = "cloud-upload-96", color = "info"),
      "Upload Data"
    ),
    argonSidebarItem(
      tabName = "models",
      icon = argonIcon(name = "atom", color = "warning"),
      "Modeling Functions"
    ),
    argonSidebarItem(
      tabName = "help",
      icon = argonIcon(name = "books", color = "green"),
      "Help"
    )
  ),
  argonSidebarDivider()
)
