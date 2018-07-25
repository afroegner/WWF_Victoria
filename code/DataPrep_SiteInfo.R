# Creation of beach site information data file

Communities <- read.csv("/nfs/waterwomenfisheries-data/Site_Info.csv")
Lake_Sites <- read.csv("/nfs/waterwomenfisheries-data/Site_Info_Lakes.csv")

# Need to add info on water source and % primarily collected from water based
# on house hold survey information

# Want to only use data from sites with both community and water sampling

levels(Communities$Site)
levels(Lake_Sites$Site)

locations <- intersect(Communities$Site, Lake_Sites$Site)

GPS_overlaps <- Communities[Communities$Site %in% locations, ]
