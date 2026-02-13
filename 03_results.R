## RESULTS
library(tidyverse)
load("data/split/kc_split.rda")
results <- kc_test |> 
  select(price_log10) |> 
  bind_cols(predict(lm_fit, kc_test)) |> 
  rename("lm_pred" = .pred)


results <- results |> 
  bind_cols(predict(lasso_fit, kc_test)) |> 
  rename("lasso_pred" = .pred)

results <- results |> 
  bind_cols(predict(ridge_fit, kc_test)) |> 
  rename("ridge_pred" = .pred)

results <- results |> 
  bind_cols(predict(rf_fit, kc_test)) |> 
  rename("rf_pred" = .pred)

result_tbl <- tibble(
  model = c("lm", "lasso", "ridge", 'rf'),
  rmse = c(
    rmse(results, price_log10, lm_pred)$.estimate,
    rmse(results, price_log10, lasso_pred)$.estimate,
    rmse(results, price_log10, ridge_pred)$.estimate,
    rmse(results, price_log10, rf_pred)$.estimate
  )
)

save(result_tbl, file = "data/results/result_tbl.rda")
