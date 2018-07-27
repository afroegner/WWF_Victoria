# Creation of site map

source("code/DataPrep_SiteInfo.R")

library(tidyverse)

# Map of Winam Gulf with all sites
bbox <- c(left=34,bottom=-0.6,right=34.9,top=0)
g <- ggmap(get_stamenmap(bbox, zoom=11, maptype="toner-lite"))
g +  geom_point(data=Lake_Sites,
                aes(x=Longitude, y=Latitude, color=Location), size=3, alpha=0.95) +
  geom_point(data=Communities,
             aes(x=Longitude, y=Latitude), alpha=0.5, color="black") +
  geom_hline(yintercept = 0, color = "black") +
  geom_vline(xintercept = 34.9, color="black") +
  theme_classic(12) 

# Map of Winam Gulf with only relevant sites
bbox <- c(left=34,bottom=-0.6,right=34.9,top=0)
g <- ggmap(get_stamenmap(bbox, zoom=11, maptype="toner-lite"))
g +  geom_point(data=GPS_overlaps,
                aes(x=Longitude, y=Latitude), size=3, alpha=0.95) +
  geom_hline(yintercept = 0, color = "black") +
  geom_vline(xintercept = 34.9, color="black") +
  theme_classic(12) 
ggsave("figures/Map_WinamGulf.png", width=5, height=4)


             