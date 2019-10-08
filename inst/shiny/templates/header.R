argonHeader <- argonDashHeader(
  gradient = TRUE,
  color = "primary",
  separator = TRUE,
  separator_color = "secondary",
  argonH1(
    display = 3,
    "Applicability Domain Methods",
    htmltools::span("with examples")
  ) %>% argonTextColor(color = "white") ,
  argonRow(
    argonColumn(
      width = 12,
      argonAlert(
        icon = argonIcon("basket"),
        status = "danger",
        "Note: This application is currently in development.",
        closable = TRUE
      )
    )
  )
  #argonLead("some info here") %>% argonTextColor(color = "white")
)
