
# Regression models

library(tidymodels)
load("data/split/kc_split.rda")

## Recipe
reg_recipe <- recipe(price_log10 ~ waterfront + sqft_living + yr_built + bedrooms,
                    data = kc_train) |> 
  step_dummy(all_nominal_predictors())
### Regression Model
lm_mod <- linear_reg() |> 
  set_engine("lm")

lm_wkflow <- workflow() |> 
  add_model(lm_mod) |> 
  add_recipe(reg_recipe)

lm_fit <- fit(lm_wkflow, kc_train)

save(lm_fit, file = "data/results/lm_fit.rda")

#lm_fit <- lm_mod |> 
#  fit(price_log10 ~ waterfront + sqft_living + yr_built + bedrooms, data = kc_house_train)

#save(lm_fit, file = "data/results/lm_fit.rda")

#tidy(lm_fit)

### Lasso Model
lasso_mod <- linear_reg(penalty = .01, mixture = 1) |> 
  set_engine('glmnet')

lasso_wkflow <- workflow() |> 
  add_model(lasso_mod) |> 
  add_recipe(reg_recipe)

lasso_fit <- fit(lasso_wkflow, kc_train)

save(lasso_fit, file = "data/results/lasso_fit.rda")

#lasso_fit <- lasso_mod |> 
#  fit(price_log10 ~ waterfront + sqft_living + yr_built + bedrooms, data = kc_house_train)

#tidy(lasso_fit)

#s#ave(lasso_fit, file = "data/results/lasso_fit.rda")

### Ridge Model

ridge_mod <- linear_reg(mixture = 0, penalty = .01) |> 
  set_engine("glmnet")

ridge_wkflow <- workflow() |> 
  add_model(ridge_mod) |> 
  add_recipe(reg_recipe)

ridge_fit <- fit(ridge_wkflow, kc_train) 

save(ridge_fit, file = "data/results/ridge_fit.rda")

#ridge_fit <- ridge_mod |> 
 # fit(price_log10 ~ waterfront + sqft_living + yr_built + bedrooms, data = kc_house_train)

#save(ridge_fit, file = "data/results/ridge_fit.rda")

#tidy(ridge_fit)


# Notes  -----------------
#workflow binds together model and recipes 

# Feature engineering is data manipulation
## Check the chart for preprocessing recommendations in tmwr 
## Dummy variables, single value variables, imputing, transforming, decorrelation, normalize

# First, you build your recipe (use training data), then pipe steps on for feature engineering
# step_BoxCox(), step_impute_mean(all_numeric_predictors()) 
## IE, don't forget 'predictors' because then you're imputing the regressand
## IE, check recipes.tidymodels.org

# common steps: step_corr(), step_zv(), step_rm()