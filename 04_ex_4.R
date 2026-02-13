library(tidyverse)
library(splines)

load("data/split/kc_split.rda")

ggplot(kc_train, aes(x = sqft_lot, y = price_log10)) +
  geom_point()

ggsave("data/lot_plot.png", plot = get_last_plot)
##Funnel shapes tend to benefit from log transformation 
ggplot(kc_train, aes(x = log(sqft_lot), y= price_log10)) +
  geom_point()



ggplot(kc_train, aes(x = lat, y = price_log10)) +
  geom_point() +
  geom_smooth(method = "lm",
              formula = y~ns(x, df = 5),
              se = FALSE
              )
