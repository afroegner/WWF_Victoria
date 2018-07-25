library(tidyverse)

# Fishermen Survey
survey_fish_raw <- read.csv("/nfs/waterwomenfisheries-data/Surveys_fishermen_EightCommunities.csv", 
                            header=TRUE, stringsAsFactors = FALSE)

# QA/QC data
# catch.size.change is not all capitalized
survey_fish_raw$catch.size.change <- gsub("y", "Y", survey_fish_raw$catch.size.change)
survey_fish_raw$earliest.algal.bloom <- as.numeric(survey_fish_raw$earliest.algal.bloom)
survey_fish_raw$future.for.fishery <- gsub("Yes", "Y", survey_fish_raw$future.for.fishery)
survey_fish_raw$future.for.fishery <- gsub("No", "N", survey_fish_raw$future.for.fishery)

table(survey_fish_raw$future.for.fishery)

str(survey_fish_raw)
# Name columns we want to keep
WQ_relevant <- c(grep("bloom", names(survey_fish_raw), value=TRUE),
                 grep("water", names(survey_fish_raw), value=TRUE),
                 grep("plant", names(survey_fish_raw), value=TRUE),
                 "future.for.fishery", "comment.fishery.unedited")

Fish_relevant <- c(grep("fish", names(survey_fish_raw), value=TRUE),
                    grep("catch", names(survey_fish_raw), value=TRUE),
                    "cause.size.change")

survey_fish_WQ <- survey_fish_raw %>%
  select(beach.name, WQ_relevant) %>%
  filter(beach.name %in% locations)

table(survey_fish_WQ$beach.name)

write.csv(survey_fish_WQ, "data_out/survey_fish_WQ.csv")

# QA/QC data
str(survey_fish_raw)

# Household Survey
survey_house_raw <- read.csv("/nfs/waterwomenfisheries-data/Surveys_household_eight_communities.csv", header=TRUE, stringsAsFactors = FALSE)
survey_house_raw$wash.clothes.in.lake <- gsub("y","Y", survey_house_raw$wash.clothes.in.lake)
survey_house_raw$same.collection.spot <- gsub("y","Y", survey_house_raw$same.collection.spot)
survey_house_raw$same.collection.spot <- gsub("tapwater","Y", survey_house_raw$same.collection.spot)
survey_house_raw$same.collection.spot <- gsub("alternate source","Y", survey_house_raw$same.collection.spot)

table(survey_house_raw$same.collection.spot)

WQ_house_relevant <- c("pot", "jerricans", "superdrum", "bucket", "barrel",
                       "tank", "drum", "stored.no", "other.source.water",
                       "Other.sources.of.water", "lake.water", "borehole", "river",
                       "tap", "fishpond", "rain", "school", "sources.count",
                       "comment.sources.raw", "raw", "boiling", "chlorine",
                       "aeration", "filter", "types.no", "water.concerns.raw",
                       "wash.clothes.in.lake", "same.collection.spot", "comments.site.collection.raw")

survey_house_WQ <- survey_house_raw %>%
  select(Beach.Name, WQ_house_relevant)

str(survey_house_WQ)

write.csv(survey_fish_WQ, "data_out/survey_house_WQ.csv")
