# Get/save the AmesHousing data and info about them.
save_ames_data <- function(dir_name){
  library(AmesHousing)
  ames <- make_ames()

  ames_cols <- names(ames_new)
  training_data <-
    ames %>%
    # For consistency, only analyze the data on new properties
    dplyr::select(one_of(ames_cols)) %>%
    mutate(
      # There is a new neighborhood in ames_new
      Neighborhood = as.character(Neighborhood),
      Neighborhood = factor(Neighborhood, levels = levels(ames_new$Neighborhood))
    )

  training_recipe <-
    recipe( ~ ., data = training_data) %>%
    step_dummy(all_nominal()) %>%
    # Remove variables that have the same value for every data point.
    step_zv(all_predictors()) %>%
    # Transform variables to be distributed as Gaussian-like as possible.
    step_YeoJohnson(all_numeric()) %>%
    # Normalize numeric data to have a mean of zero and
    # standard deviation of one.
    step_normalize(all_numeric())

  prep_train_data <- prep(training_recipe, training = training_data, retain = TRUE)
  train_data_juiced <- juice(prep_train_data, all_predictors())
  test_data_baked <- bake(prep_train_data, new_data = ames_new, all_predictors())

  train_data_filename <- 'ames_train_data.csv'
  new_samples_filename <- 'ames_new_samples.csv'
  about_filename <- 'Ames_Data_Set.txt'

  about <- paste("The files",
                 train_data_filename,
                 "and",
                 new_samples_filename,
                 "contain data from properties sold in Ames, IA from 2006 to",
                 "2010. The file ames_train_data.csv contains data to train",
                 "the model and the file ames_new_samples.csv contains new",
                 "samples to test our model. More details about the Ames",
                 "Housing data can be",
                 "found in De Cock, 2011, Journal of Statistics Education",
                 "(http://ww2.amstat.org/publications/jse/v19n3/decock.pdf).",
                 "The raw data are at http://bit.ly/2whgsQM but we will use",
                 "a processed version found in the AmesHousing package",
                 "(https://github.com/topepo/AmesHousing).",
                 sep = " ")

  write_csv(training_data, paste(dir_name, train_data_filename, sep = "/"))
  write_csv(ames_new, paste(dir_name, new_samples_filename, sep = "/"))
  write(about, paste(dir_name, about_filename, sep = "/"))

  return(c(train_data_filename, new_samples_filename, about_filename))
}

# Get/save the Binary fingerprints data and info about them.
save_binary_data <- function(dir_name){
  data(qsar_binary)

  train_data_filename <- 'binary_train_data.csv'
  new_samples_filename <- 'binary_new_samples.csv'
  about_filename <- 'Binary_Data_Set.txt'

  about <- paste("The files",
                 train_data_filename,
                 "and",
                 new_samples_filename,
                 "contain data from two QSAR data sets where binary",
                 "fingerprints are used as predictors.",
                 sep = " ")

  write_csv(binary_tr, paste(dir_name, train_data_filename, sep = "/"))
  write_csv(binary_unk, paste(dir_name, new_samples_filename, sep = "/"))
  write(about, paste(dir_name, about_filename, sep = "/"))

  return(c(train_data_filename, new_samples_filename, about_filename))
}
