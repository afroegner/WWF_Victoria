# Generating site descriptors

survey_house <- read.csv("data_out/survey_house_WQ.csv")

# Earliest bloom

house.bloom <- survey_house %>%
  select(beach.name, earliest.algal.bloom) %>%
  group_by(beach.name) %>%
  summarise(
    eab.min = min(earliest.algal.bloom, na.rm=TRUE),
    eab.max = max(earliest.algal.bloom, na.rm=TRUE),
    eab.mean = mean(earliest.algal.bloom, na.rm=TRUE)
  )
