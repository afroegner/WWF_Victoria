######## start here######******
# Data distillation  and Figure generation for Fisher Site Selection ####  AR 07.27.2018
survey_Fisher_All<- read.csv("data_out/survey_FisherWQperception_All.csv")
str(survey_Fisher_All)

# select relevant categories
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

# make stacked barplot by community for selection of fisher site
library(ggplot2)
attach(Behavior_site_selection)
 
p<- ggplot(Behavior_site_selection) + geom_bar(aes(x=beach.name, na.rm = TRUE, fill= choice.fishing.area)) 
p + labs(x="Fishing village community",y="counts (selection of fishing sites)") + theme_classic()+ theme(axis.text.x = element_text(angle = 60, hjust = 1))

ggsave("figures/Fig_FisherSiteSel.png", width=6, height=4)

                                               