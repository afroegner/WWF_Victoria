# Exploratory data analysis
# jrc 180725

library(tidyverse)

lake_WQ <- read.csv("data_out/lake_WQ.csv")

str(lake_WQ)

# Compare water quality across sites and variables

lake_WQ %>%
  select(site, chloroa.µg_L, TN.µgN_L, Nitrates.µgN_L, Ammonium.µgN_L,
         TP.µgP_L, SRP.µgP_L, coliforms.MPN_100ml, ecoli.MPN_100ml, totalMC.ug_L) %>%
  gather(key=variable, value = value, -site) %>%
  ggplot(aes(x=site, y=value)) + 
    geom_boxplot() + 
    facet_wrap(~variable, scales="free")
