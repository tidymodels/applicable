get_recipe <- function(training_data){
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

  training_recipe
}
