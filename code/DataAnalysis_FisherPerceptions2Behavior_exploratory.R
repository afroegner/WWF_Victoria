# Generating Predictor and Response Variables for Perceptions and Behavior or Decision
# Amber Roegner ed. 07.26.2018

# Load relevant libraries
library(tidyverse)
library(dplyr)
library (ggplot2)

######## start here######******
# Data distillation of Fisher Perceptions and Responses ####
survey_Fisher_All<- read.csv("data_out/survey_FisherWQperception_All.csv")
str(survey_Fisher_All)

Behavior_site_selection<- select(survey_Fisher_All, beach.name, choice.fishing.area,  water.clarity.change, 
water.smell.change, fish.spp.change, bloom.effect.waterqual, bloom.effect.fish)
str(Behavior_site_selection)

# replace all ambiguous responses with NA
Behavior_site_selection$water.clarity.change[Behavior_site_selection$water.clarity.change=="interested in learning more"]<- ""
Behavior_site_selection$water.clarity.change[Behavior_site_selection$water.clarity.change=="clean at middle; decreased at shore"]<- ""
Behavior_site_selection$water.clarity.change[Behavior_site_selection$water.clarity.change=="depends on current"]<- ""
Behavior_site_selection$water.clarity.change[Behavior_site_selection$water.clarity.change=="depends on season"]<- ""
Behavior_site_selection$water.clarity.change[Behavior_site_selection$water.clarity.change=="unknown"]<- ""

Behavior_site_selection$water.smell.change[Behavior_site_selection$water.smell.change=="at times"]<- ""
Behavior_site_selection$water.smell.change[Behavior_site_selection$water.smell.change=="no smell"]<- ""
Behavior_site_selection$water.smell.change[Behavior_site_selection$water.smell.change=="seasonal"]<- ""

# number of households in each community
survey_count <- as.data.frame(table(Behavior_site_selection$beach.name))
names(survey_count) <- c("beach.name", "count")

###################  Get number of counts per site selection category by community ####
Site_selection <- Behavior_site_selection %>%
  group_by(beach.name, choice.fishing.area) %>%
  tally(sort = TRUE)

#### Getting percentages for fishing selection site by community 
Site_selection<-Behavior_site_selection %>%
  group_by(beach.name, choice.fishing.area) %>%
  summarise(n=n()) %>%
  mutate(freq = n/sum(n))
########
# make stacked barplot by community for selection of fisher site
library(ggplot2)


#### logistic regression - preliminary analysis 
model<-glm(choice.fishing.area~., family=binomial(link='logit'), data=Behavior_site_selection)
summary(model)
anovatable<- anova(model, test="Chisq")
anovatable<-do.call("rbind", anovatable)

#### Below is just junk work 
survey_Fisher_All %>%
  group_by( bloom.effect.waterqual, beach.name)%>%
  summarise(n=n()) %>%
  summarise(total=sum(n))

survey_Fisher_Al<- survey_Fisher_All %>%
  group_by(bloom.effect.waterqual, beach.name)%>%
  summarise(n=n())

# add together worksheets _ rbind () to create master total for all communities 
# Perceptions Effects of Blooms 
# Water treatment
# Perceptions of cause of Bloom
# Perceptions of Future for fishery
# Perceptiosn of Catch changes
# Response of Choice fishing area  choice.fishing.area","no.days.per.month.lake"
# Characteristics of respondent age.respondent",years fishing 

