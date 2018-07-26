# Generating site descriptors

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
