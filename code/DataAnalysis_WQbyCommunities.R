# Comparing water quality and survey data
# jrc

library(vegan)
source("code/biostats.R")

lake_WQ <- read.csv("data_out/lake_WQ.csv")

str(lake_WQ)
str(Survey_FourCommunities)

names(lake_WQ)

lake_WQ$cyanobacterial_counts <- as.numeric(lake_WQ$cyanobacterial_counts)

# define enviro & bio variables to keep
evars <- c("DO.mg_L", "COND.µS", "PH", "TN.µgN_L",
           "Nitrates.µgN_L", "TP.µgP_L", "SRP.µgP_L")
bvars <- c("cyanobacterial_counts", "chloroa.µg_L",
           "perc_Microcystis", "perc_Anabaena",
           "coliforms.MPN_100ml", "ecoli.MPN_100ml", "totalMC.ug_L")

lake_sub <- lake_WQ %>%
  select(site, month, evars, bvars)

lake_sub[,3:ncol(lake_sub)] <- apply(lake_sub[,3:ncol(lake_sub)],2,as.numeric)

# Visualize lake "water quality" data by chemistry and biology

lake_sub %>%
  select(site, evars) %>%
  gather(key="variable", value="value", -site) %>%
  ggplot(aes(x=site, y=value)) +
  geom_boxplot() + facet_wrap(~variable, scales="free")

lake_sub %>%
  select(site, bvars) %>%
  gather(key="variable", value="value", -site) %>%
  ggplot(aes(x=site, y=value)) +
  geom_boxplot() + facet_wrap(~variable, scales="free")

# Based on visualizations, these data are complete and variable across
# sites:

evars.good <- c("DO.mg_L", "COND.µS", "PH")
bvars.good <- c("cyanobacterial_counts", "chloroa.µg_L",
                "perc_Microcystis", "coliforms.MPN_100ml", 
                "ecoli.MPN_100ml")

lake_wq_sub <- lake_sub %>%
  select(site, evars.good, bvars.good)

names(lake_wq_sub)[2:9] <- c("DO", "Cond", "pH", "Cyanos",
                             "ChlA", "Micro.perc", "Colif",
                             "EColi")

lake_wq_sub <- lake_wq_sub[complete.cases(lake_wq_sub),]

lake.pca <- prcomp(lake_wq_sub[,2:9], scale=TRUE)
summary(lake.pca)

screeplot(lake.pca, bstick=TRUE)

ordi.monte(lake_wq_sub[,2:9], ord='pca', dim=5)

biplot(lake.pca)

# Prettier ordination plot
library(devtools)
install_github("ggbiplot", "vqv")
library(ggbiplot)
Sample <- lake_wq_sub[,1] # extract vector for label names
# create biplot using ggbiplot
g <- ggbiplot(lake.pca, obs.scale = 1, var.scale = 1, 
              groups = Sample, ellipse = FALSE, circle = FALSE) + # draws ellipse around groups
  geom_point(aes(color = Sample), size=4)
# g <- g + scale_shape_discrete(name = '')  # adds group name for legend
g + theme_bw(14)
ggsave("figures/PCA_lake_wq.png", width=5, height=5)

# Perform correlation analysis among variables ####

all_avg <- lake_sub %>%
  select(site, evars.good, bvars.good) %>%
  gather(key="variable", "value", -site) %>%
  group_by(site, variable) %>%
  dplyr::summarise(avg = mean(value, na.rm=TRUE)) %>%
  spread(variable, avg) %>%
  full_join(Survey_FourCommunities, by=c("site"="beach.name")) %>%
  select(-eab.med, -eab.max, -filter, -trt.max, -borehole, -tap,
         -lake.water, -other, -boiling, -COND.µS, -DO.mg_L, -PH,
         -eab.min, -trt.avg, -perc_Microcystis)

library("PerformanceAnalytics")
my_data <- all_avg[,-1]

chart.Correlation(my_data, histogram=TRUE, pch=19)

# Model: Is chlorine treatment related to water quality?
model.cl <- lm(chlorine ~ ecoli.MPN_100ml, data=all_avg)
summary(model.cl)

# Rename variables for easier coding
names(lake_sub)[3:16] <- c("DO", "Cond", "pH", "TN", "NO3",
                             "TP", "SRP", "Cyanos", "ChlA",
                             "MCR.prc", "ANA.prc", "Colif",
                             "EColi", "MC.tot")

# PCA is below ####
# This approach seems not so helpful due to abundance of 
# missing data (jrc)

impute.med <- function(x){
  z <- median(x, na.rm=TRUE)
  x[is.na(x)] <- z
  return(x)
}

lake_imp[,3:16] <- data.frame(apply(lake_sub[,3:16],2,impute.med))

uv.plots(lake_imp[,3:16])

# Need to transform Cond, NO3,SRP, ChlA
log_var <- c("Cond", "NO3", "SRP", "ChlA")
lake_trans <- data.trans(lake_imp, method='log', var="Cond",
                         plot=FALSE)
lake_trans <- data.trans(lake_trans, method='log', var="NO3",
                         plot=FALSE)
lake_trans <- data.trans(lake_trans, method='log', var="SRP",
                         plot=FALSE)
lake_trans <- data.trans(lake_trans, method='log', var="ChlA",
                         plot=FALSE)

uv.plots(lake_trans[,3:16])

decorana(lake_sub[,3:16], ira=0)
# Axis length of DCA1 = 0.6, therefore RDA!

# Run PCA
lake.pca <- prcomp(lake_trans[,3:16], scale=TRUE)
summary(lake.pca)

screeplot(lake.pca, bstick=TRUE)

ordi.monte(lake_trans[,3:16], ord='pca', dim=5)

pca.eigenvec(lake_trans[,3:16])

