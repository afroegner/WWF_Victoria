# Code for QA/QC-ing Water quality data
# to create publication quality dataset

library(tidyverse)

lake_raw <- read.csv("/nfs/waterwomenfisheries-data/kisumubay2_cyanos.csv")

str(lake_raw)

# Fix dates
lake_raw$Date <- as.Date(lake_raw$Date, format="%m/%d/%y")

table(lake_raw$Location)
table(lake_raw$Depth)

# Upload littoral data
littoral_raw <- read.csv("/nfs/waterwomenfisheries-data/community_intake_cyanodata.csv")
str(littoral_raw)
table(littoral_raw$site)
# weird spaces
littoral_raw$site <- gsub("\\s", "", littoral_raw$site)

littoral_WQ <- littoral_raw %>%
  filter(site %in% locations)

write.csv(littoral_WQ, "data_out/lake_WQ.csv")

params <- "ecol|sec|coli|chlo|nitra|SRP"

litt.col <- grep(params, names(littoral_raw), value=TRUE, 
             ignore.case = T)
lake.col <- grep(params, names(lake_raw), value=TRUE,
             ignore.case = T)

lake_small <- lake_raw %>%
  select(Date, Location, Depth, lake.col) %>%
  filter(Depth != "Integrated") %>%
  select(-Depth)
names(lake_small)[3:8] <- c("SRP", "NO3", "ChlA", "Colif", 
                            "EColi", "Secchi")
lake_small$site <- as.character(lake_small$Location)

lake_all_raw <- littoral_raw %>%
  select(site, month, litt.col) 
names(lake_all_raw)[3:7] <- c("ChlA", "NO3", "SRP", "Colif", "EColi")

cdata <- lake_all_raw %>%
  full_join(lake_small) %>%
  filter(site != "")

str(cdata)

library("PerformanceAnalytics")
my_data <- cdata[,-c(1:2,8:9)]

chart.Correlation(my_data, histogram=TRUE, pch=19)

# Correlations between NO3 and Chl a, Coliforms, Ecoli

ggplot(cdata, aes(x=NO3, y=EColi)) +
  geom_point() +
  scale_x_log10() +
  scale_y_log10() +
  stat_smooth(method="lm")
