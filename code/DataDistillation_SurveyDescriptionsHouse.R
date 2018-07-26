# Generating Community Site descriptors for water quality - survey comparison
# jrc

# Load relevant libraries
library(tidyverse)

# Household survey distillation ####
survey_house <- read.csv("data_out/survey_house_WQ.csv")
str(survey_house)

# number of households in each community
survey_count <- as.data.frame(table(survey_house$Beach.Name))
names(survey_count) <- c("Beach.Name", "Count")

# Water source by percentages
water_gathering <- survey_house %>%
  select(Beach.Name, lake.water, borehole, river, tap, fishpond, rain, school) %>%
  gather(key = source, value = use, -Beach.Name) %>%
  group_by(Beach.Name, source) %>%
  summarise(count = sum(use, na.rm=TRUE)) %>%
  spread("source", "count") %>%
  full_join(survey_count) %>%
  # combine answers with few responses
  mutate(other = fishpond+river+school) %>%
  select(-c(fishpond, river, school)) %>%
  gather(key = source, value = use, -Beach.Name, -Count) %>%
  group_by(Beach.Name, source) %>%
  summarise(
    percent = use/Count
  ) %>%
  spread("source", "percent")

# Water treatment
water_trt_no <- survey_house %>%
  select(Beach.Name, types.no) %>%
  group_by(Beach.Name) %>%
  summarise(trt.avg = mean(types.no, na.rm=TRUE),
            trt.max = max(types.no, na.rm=TRUE),
            # calculate percent of homes with no treatment
            trt.none.perc = sum(types.no == 0)/length(types.no))

# Water treatment type
water_trt <- survey_house %>%
  select(Beach.Name, boiling, chlorine, aeration, filter) %>%
  gather(key=treatment, value=use, -Beach.Name) %>%
  group_by(Beach.Name, treatment) %>%
  summarise(use.perc = sum(use)/length(use)) %>%
  filter(use.perc > 0) %>% # removes treatments not in use
  spread("treatment", "use.perc")

# Create dataframe with the percent of households using different treatment
# options.
water_treat <- full_join(water_trt, water_trt_no)

# Determine percent of households in each community that wash clothes in lake
# or collect from the same spot

water_lakeuse <- survey_house %>%
  select(Beach.Name, wash.clothes.in.lake, same.collection.spot) %>%
  group_by(Beach.Name) %>%
  summarise(
    wash.clotes.perc = sum(wash.clothes.in.lake == "Y")/length(wash.clothes.in.lake),
    same.spot.perc = sum(same.collection.spot == "Y")/length(same.collection.spot)
  )

# Join datasets

community_house <- full_join(water_lakeuse, water_treat)
community_house <- full_join(community_house, water_gathering)

str(community_house)

# Fishery survey distillation ####

survey_fish <- read.csv("data_out/survey_fish_WQ.csv")

str(survey_fish)

# Earliest bloom

fish.bloom <- survey_fish %>%
  select(beach.name, earliest.algal.bloom) %>%
  group_by(beach.name) %>%
  summarise(
    eab.min = min(earliest.algal.bloom, na.rm=TRUE),
    eab.max = max(earliest.algal.bloom, na.rm=TRUE),
    eab.mean = mean(earliest.algal.bloom, na.rm=TRUE),
    eab.med = median(earliest.algal.bloom, na.rm=TRUE)
  )

# Combining fish and household data ####

Survey_FourCommunities <- full_join(fish.bloom, community_house, by = c("beach.name" = "Beach.Name"))
