pcaTab <- function(name, options = NULL, active = FALSE) {
  return(
    argonTab(
      tabName = name,
      active = active,
      argonCard(
        width = 12,
        title = "About",
        paste("PCA (Principal Component Analysis) computes the principal components of the training set",
              "that account for up to either 95% or the provided threshold of variability",
              sep = " "),
        argonBadge(
          text = "4",
          src = "https://www.google.com",
          pill = TRUE,
          status = "success"
        ),
        paste(".",
              "It also computes the percentiles of the absolute value of the principal",
              "components",
              sep = " "),
        argonBadge(
          text = "2",
          src = "https://www.google.com",
          pill = TRUE,
          status = "success"
        ),
        paste("and the mean of each principal component",
              sep = " "),
        argonBadge(
          text = "1",
          src = "https://www.google.com",
          pill = TRUE,
          status = "success"
        ),
        ".",
        br(),
        paste("On the new samples, the function computes",
              "the principal components and their percentiles as compared to the training data.",
              "The number of principal components computed depends on the threshold choosen.",
              "It also computes the multivariate distance",
              "between each principal component and its mean",
              sep = " "),
        argonBadge(
          text = "2",
          src = "https://www.google.com",
          pill = TRUE,
          status = "success"
        ),
        "."
        #verbatimTextOutput(paste(outputModel, "render", sep = "_"))
      ),
      argonCard(
        width = 12,
        title = "Principal Components - Training Set",
        icon = icon("argon"),
        status = 'primary',
        argonRow(
          argonColumn(
            width = 6,
            sliderInput("pcs_range",
                        "Select Range:",
                        min = 1, max = 100,
                        value = 10, step = 1)
          ),
          argonColumn(
            width = 6,
            sliderInput("pcs_threshold",
                        "Select Threshold:",
                        min = 1, max = 100,
                        value = 95, step = 1)
          )),
        plotOutput("pca_plot_pcs")
      ),
      argonCard(
        width = 12,
        icon = icon("argon"),
        status = 'primary',
        title = "Distance Metric - Training Set",
        plotOutput("pca_plot_dist")
      ),
      argonCard(
        width = 12,
        status = 'warning',
        icon = icon("argon"),
        title = "Score plot - New Samples",
        ggiraphOutput("pca_score_plot")
      ),
      argonCard(
        width = 12,
        status = 'warning',
        icon = icon("argon"),
        title = "Score output - New Samples",
        DTOutput("pca_score")
      )
    )
  )
}

hatsTab <- function(name, options = NULL, active = FALSE) {

  return(
    argonTab(
      tabName = name,
      active = active,
      argonCard(
        width = 12,
        title = "About",
        paste("PCA (Principal Component Analysis) computes the principal components of the training set",
              "that account for up to either 95% or the provided threshold of variability",
              sep = " "),
        argonBadge(
          text = "4",
          src = "https://www.google.com",
          pill = TRUE,
          status = "success"
        ),
        paste(".",
              "It also computes the percentiles of the absolute value of the principal",
              "components",
              sep = " "),
        argonBadge(
          text = "2",
          src = "https://www.google.com",
          pill = TRUE,
          status = "success"
        ),
        paste("and the mean of each principal component",
              sep = " "),
        argonBadge(
          text = "1",
          src = "https://www.google.com",
          pill = TRUE,
          status = "success"
        ),
        ".",
        br(),
        paste("On the new samples, the function computes",
              "the principal components and their percentiles as compared to the training data.",
              "The number of principal components computed depends on the threshold choosen.",
              "It also computes the multivariate distance",
              "between each principal component and its mean",
              sep = " "),
        argonBadge(
          text = "2",
          src = "https://www.google.com",
          pill = TRUE,
          status = "success"
        ),
        "."
        #verbatimTextOutput(paste(outputModel, "render", sep = "_"))
      ),
      argonCard(
        width = 12,
        status = 'warning',
        icon = icon("argon"),
        title = "Score plot - New Samples",
        ggiraphOutput("hat_values_score_plot")
      ),
      argonCard(
        width = 12,
        status = 'warning',
        icon = icon("argon"),
        title = "Score output - New Samples",
        DTOutput("hat_values_score")
      )
    )
  )
}

simTab <- function(name, options = NULL, active = FALSE) {

  return(
    argonTab(
      tabName = name,
      active = active,
      argonCard(
        width = 12,
        title = "About",
        paste("PCA (Principal Component Analysis) computes the principal components of the training set",
              "that account for up to either 95% or the provided threshold of variability",
              sep = " "),
        argonBadge(
          text = "4",
          src = "https://www.google.com",
          pill = TRUE,
          status = "success"
        ),
        paste(".",
              "It also computes the percentiles of the absolute value of the principal",
              "components",
              sep = " "),
        argonBadge(
          text = "2",
          src = "https://www.google.com",
          pill = TRUE,
          status = "success"
        ),
        paste("and the mean of each principal component",
              sep = " "),
        argonBadge(
          text = "1",
          src = "https://www.google.com",
          pill = TRUE,
          status = "success"
        ),
        ".",
        br(),
        paste("On the new samples, the function computes",
              "the principal components and their percentiles as compared to the training data.",
              "The number of principal components computed depends on the threshold choosen.",
              "It also computes the multivariate distance",
              "between each principal component and its mean",
              sep = " "),
        argonBadge(
          text = "2",
          src = "https://www.google.com",
          pill = TRUE,
          status = "success"
        ),
        "."
        #verbatimTextOutput(paste(outputModel, "render", sep = "_"))
      ),
      argonCard(
        width = 12,
        title = "Plot Model",
        plotOutput("sim_plot")
      ),
      argonCard(
        width = 12,
        status = 'warning',
        icon = icon("argon"),
        title = "Score plot - New Samples",
        ggiraphOutput("sim_score_plot")
      ),
      argonCard(
        width = 12,
        status = 'warning',
        icon = icon("argon"),
        title = "Score output - New Samples",
        DTOutput("sim_score")
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
        pcaTab("PCA", active = TRUE),
        hatsTab("Hat Values"),
        simTab("Similarity Statistics")
      ),
      argonCard(
        width = 12,
        title = "Data Summary",
        uiOutput("argonTable")
      )
    )
  )
)
