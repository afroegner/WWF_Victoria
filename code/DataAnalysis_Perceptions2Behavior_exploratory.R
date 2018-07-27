# Generating Predictor and Response Variables for Perceptions and Behavior or Decision
# Amber Roegner ed. 07.26.2018

# Load relevant libraries
library(tidyverse)


# Data distillation of Fisher Perceptions and Responses ####
survey_Fisher_All<- read.csv("data_out/survey_FisherWQperception_All.csv")
str(survey_Fisher_All)


survey_Fisher_All %>%
  group_by( bloom.effect.waterqual, beach.name)%>%
  summarise(n=n()) %>%
  summarise(total=sum(n))

survey_Fisher_All %>%
  group_by(bloom.effect.waterqual)%>%
  summarise(n=n())

# add together worksheets _ rbind ()


# Perceptions Effects of Blooms 
# Water treatment
# Perceptions of cause of Bloom
# Perceptions of Future for fishery
# Perceptiosn of Catch changes

# Response of Choice fishing area  choice.fishing.area","no.days.per.month.lake"
# Characteristics of respondent age.respondent",years fishing 

