# temporary file for water quality - community correlations

library(tidyverse)

lake_WQ <- read.csv("data_out/lake_WQ.csv")
Survey_FourCommunities <- read.csv("data_out/survey_house_FourCommunities.csv")

lake_WQ$cyanobacterial_counts <- as.numeric(lake_WQ$cyanobacterial_counts)

# define enviro & bio variables to keep
evars.good <- c("DO.mg_L", "COND.µS", "PH")
bvars.good <- c("cyanobacterial_counts", "chloroa.µg_L",
                "perc_Microcystis", "coliforms.MPN_100ml", 
                "ecoli.MPN_100ml")

lake_wq_sub <- lake_WQ %>%
  select(site, evars.good, bvars.good)

names(lake_wq_sub)[2:9] <- c("DO", "Cond", "pH", "Cyanos",
                             "ChlA", "Micro.perc", "Colif",
                             "EColi")
all_avg <- lake_wq_sub %>%
  gather(key="variable", "value", -site) %>%
  group_by(site, variable) %>%
  dplyr::summarise(avg = mean(value, na.rm=TRUE)) %>%
  spread(variable, avg) %>%
  full_join(Survey_FourCommunities, by=c("site"="beach.name")) %>%
  select(-eab.med, -eab.max, -filter, -trt.max, -borehole, -tap,
         -lake.water, -other, -boiling,
         -eab.min, -trt.avg, -Cond, -pH, -Micro.perc)

library("PerformanceAnalytics")
my_data <- all_avg[,-1]

chart.Correlation(my_data, histogram=TRUE, pch=19)

