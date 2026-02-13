# L03 Model workflows & recipes ----
# Lab setup

## load packages ----
library(tidymodels)
library(tidyverse)
kc <- read_csv("data/kc_house_data.csv")

#From L02 we know that we will want to perform a $log_{10}$ transformation of our outcome variable.
#We will want to re-type several variables as nominal/un-ordered factors: `waterfront`, `view`, `condition`, and `grade`.

kc_clean <- kc |> 
  mutate(
    waterfront = factor(waterfront),
    view = factor(view),
    condition = factor(condition),
    grade = factor(grade),
    price_log10 = log10(price)
  )

save(kc_clean, file = "data/clean/kc_clean.rda")

set.seed(49)
kc_split <- initial_split(kc_clean, prop = .8, strata = price)
kc_train <- training(kc_split)
kc_test <- testing(kc_split)

save(kc_test, kc_train, file = "data/split/kc_split.rda")
