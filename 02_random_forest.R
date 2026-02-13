## Random Forest 

library(tidyverse)
library(tidymodels)
set.seed(49)

load("data/split/kc_split.rda")

## build model NEED A MODE (class/reg)
rf_mod <- rand_forest(trees = 500, min_n = 5) |> 
  set_engine("ranger")  |> 
  set_mode("regression")

## Define recipe 
# Define a recipe that uses `waterfront`, `sqft_living`, `yr_built`, and `bedrooms` to predict the target/outcome variable. 
# Add a `step_dummy()` to handle your factor variable(s).
rf_recipe <- recipe(price_log10 ~ waterfront + sqft_living + yr_built + bedrooms,
                    data = kc_train) |> 
  step_dummy(all_nominal_predictors())
#prep and bake (debugging)
check <- prep(rf_recipe) |> 
  bake(new_data = NULL)
# or bake(new_data = slice_head(kc_train, n = 20)) if the training is very big

## Create workflow 
rf_wkflow <- workflow() |> 
  add_model(rf_mod) |> 
  add_recipe(rf_recipe)

rf_wkflow

## train/fit the model
rf_fit <- fit(rf_wkflow, kc_train)

rf_fit |> 
  extract_fit_engine()

## Save results
save(rf_fit, file = "data/results/rf_fit.rda")

