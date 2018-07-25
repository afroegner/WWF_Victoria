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
