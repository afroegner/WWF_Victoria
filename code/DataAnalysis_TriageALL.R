
# Triage of Data for Water Quality Perceptions Influence on Behavior or Decisions
# take 2 ;) Amber Roegner 07.26.2018


# Fishermen Survey
survey_fish_raw <- read.csv("/nfs/waterwomenfisheries-data/Surveys_fishermen_EightCommunities.csv", 
                            header=TRUE, stringsAsFactors = FALSE)

# QA/QC data taken from Jess
# catch.size.change is not all capitalized
survey_fish_raw$catch.size.change <- gsub("y", "Y", survey_fish_raw$catch.size.change)
survey_fish_raw$earliest.algal.bloom <- as.numeric(survey_fish_raw$earliest.algal.bloom)
survey_fish_raw$future.for.fishery <- gsub("Yes", "Y", survey_fish_raw$future.for.fishery)
survey_fish_raw$future.for.fishery <- gsub("No", "N", survey_fish_raw$future.for.fishery)

str(survey_fish_raw)

# Household Survey- QA/QC taken from Jess
survey_house_raw <- read.csv("/nfs/waterwomenfisheries-data/Surveys_household_eight_communities.csv", header=TRUE, stringsAsFactors = FALSE)
survey_house_raw$wash.clothes.in.lake <- gsub("y","Y", survey_house_raw$wash.clothes.in.lake)
survey_house_raw$same.collection.spot <- gsub("y","Y", survey_house_raw$same.collection.spot)
survey_house_raw$same.collection.spot <- gsub("tapwater","Y", survey_house_raw$same.collection.spot)
survey_house_raw$same.collection.spot <- gsub("alternate source","Y", survey_house_raw$same.collection.spot)

str(survey_house_raw)

# Columns to keep from Fisher surveys for WQ perception and behavior from 
# raw fisher and household surveys

library(dplyr)

survey_fisher= select(survey_fish_raw, 1:3, 8:29)
write.csv(survey_fisher, "data_out/survey_FisherWQperception_All.csv")

survey_household=select(survey_house_raw,1:3, 5:8, 18:19, 28, 33:39,41:52, 58:59, 61,66:67, 69:70)
write.csv(survey_household, "data_out/survey_HouseWQperception_All.csv")
