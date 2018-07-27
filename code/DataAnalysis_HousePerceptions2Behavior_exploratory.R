# Data distillation of Household Perceptions and Responses ####
#load libraries
library(dplyr)

# import data 

survey_Household_All<- read.csv("data_out/survey_HouseWQperception_All.csv")
str(survey_Household_All)
Lake_Ecosystem_Services<- select(survey_Household_All, Beach.Name, chlorine, boiling, wash.clothes.in.lake, harvest.plants.lake, same.collection.spot, water.concerns.raw)

#  Creation of new column of Y or N concerned about water quality from water.concerns.raw

survey_household_WQconcern<- Lake_Ecosystem_Services %>%
  mutate(WQconcern= ifelse(grepl('(not clean | odour | smells | is bad | not good | typhoid | diarrhoea | bacteria | activities | not safe | should | blooms | question | greenish | diirty| be treated |unsafe | dirty | polluted | diseases |disease | smell | sick | green | infected)',
                                 water.concerns.raw), 'Y', 'N')) 
