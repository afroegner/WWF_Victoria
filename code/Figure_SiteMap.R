# Creation of site map

source("code/DataPrep_SiteInfo.R")

library(ggmap)
# Map of Winam Gulf
bbox <- c(left=34,bottom=-0.6,right=34.9,top=0)
g <- ggmap(get_stamenmap(bbox, zoom=11, maptype="toner-lite"))
g +  geom_point(data=Lake_Sites,
                aes(x=Longitude, y=Latitude, color=Location), size=3, alpha=0.95) +
  geom_point(data=Communities,
             aes(x=Longitude, y=Latitude), alpha=0.5, color="black")

  
             