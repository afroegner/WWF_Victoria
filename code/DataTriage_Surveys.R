setwd("/nfs/waterwomenfisheries-data")

library(dplyr)

# Fishermen Survey
survey_fish_raw <- read.csv("Surverys_fishermen_AR.csv", header=TRUE, stringsAsFactors = FALSE)

# Name columns we want to keep
WQ_relevant <- c(grep("bloom", names(survey_fish_raw), value=TRUE),
                 grep("water", names(survey_fish_raw), value=TRUE),
                 grep("plant", names(survey_fish_raw), value=TRUE),
                 "future.for.fishery", "comment.fishery.unedited")

Fish_relevant <- c(grep("fish", names(survey_fish_raw), value=TRUE),
                    grep("catch", names(survey_fish_raw), value=TRUE),
                    "cause.size.change")

survey_fish_WQ <- survey_fish_raw %>%
  select(beach.name, WQ_relevant)

# Household Survey
survey_house_raw <- read.csv("Surveys_household_AR.csv", header=TRUE, stringsAsFactors = FALSE)

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
