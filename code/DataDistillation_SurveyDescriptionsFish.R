# Generating site descriptors

survey_fish <- read.csv("data_out/survey_fish_WQ.csv")

# Earliest bloom

fish.bloom <- survey_fish %>%
  select(beach.name, earliest.algal.bloom) %>%
  group_by(beach.name) %>%
  summarise(
    eab.min = min(earliest.algal.bloom, na.rm=TRUE),
    eab.max = max(earliest.algal.bloom, na.rm=TRUE),
    eab.mean = mean(earliest.algal.bloom, na.rm=TRUE)
  )


