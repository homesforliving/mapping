## Load libraries
library(sf)
library(dplyr)
library(mapview)
library(stringr)
library(RColorBrewer)

## Load the Oak Bay shape file
OB_Zones <- read_sf("../data/zoning/OakBayZoning/Oak_Bay_Zoning.shp")

## What are the zone types?
unique(OB_Zones$ZONE_)

## Only need the area and the zone type attributes
OB_Zones <- OB_Zones %>% select(AREA, ZONE_)

## Read the OB lookup table
OB_LookupTable <- read.csv("../data/Zoning/OakBayZoning/OB_Zone_Lookup.csv", stringsAsFactors = F)

## Merge with lookup table to get the simplified zone types
OB_Zones <- merge(OB_Zones, OB_LookupTable, by.x = "ZONE_", by.y = "OB_ZONE")

## Load the Saanich Zones
SA_Zones <- read_sf("../data/Zoning/SaanichZoning/Zoning.shp") %>% select(TYPE, CLASS)

## Load the Saanich look up table
SA_LookupTable <- read.csv("../data/Zoning/SaanichZoning/Saanich_Zone_Lookup.csv", stringsAsFactors = F)

## Joing with lookup table to get the simplifed zone names
SA_Zones <- merge(SA_Zones, SA_LookupTable, by.x = "CLASS", by.y = "CLASS") %>% 
  select(TYPE, SIMPLIFIED)

## Rename the attribute "ZONE_" to "TYPE" in the OB data so it can be merged with SA
OB_Zones <- OB_Zones %>% select(ZONE_, SIMPLIFIED) %>% rename(TYPE = ZONE_)

## Load Victoria
VIC_Zones <- read_sf("../data/Zoning/VictoriaZoning/Zoning_Boundary.shp")

## Start some logic to sort the victoria zone types (this is not at all complete!)
VIC_Zones <- VIC_Zones %>% mutate(SIMPLIFIED = case_when(substr(Zoning, 1, 2) == "R1" ~ "Single Family Detached",
                                            substr(Zoning, 1, 1) == "C" ~ "Commerical"))

## define missing middle zones
missingMid_Vic <- c("R-2", "R-J", "R-K", "R-N", "RT")

## appartment zones
appt_vic <- c("R3-1", "R3-2", "R-3-C", "R3-A1", "R3-A2", "R3-AM-1", "R3-AM-2", "R-48", "RTM", "URMD")

## apply these zone types
VIC_Zones$SIMPLIFIED[VIC_Zones$Zoning %in% missingMid_Vic] <- "Missing Middle"
VIC_Zones$SIMPLIFIED[VIC_Zones$Zoning %in% appt_vic] <- "Missing Middle"

## select only what is needed and rename to match SA and OB
VIC_Zones <- VIC_Zones %>% select(Zoning, SIMPLIFIED)

VIC_Zones <- VIC_Zones %>% rename(TYPE = Zoning)

## Bind all the data into one large sf spatial object
VIC_OB_SA_Zones <- rbind(VIC_Zones, OB_Zones, SA_Zones)

## dissolved internal boundaries
VIC_OB_SA_Zones <- VIC_OB_SA_Zones %>% group_by(SIMPLIFIED) %>% st_buffer(0) %>% summarize()

## make a map object with colors based on the simplified zone names save the map as an html file 
m1 <- mapview(VIC_OB_SA_Zones, zcol = "SIMPLIFIED")
mapshot(m1, url = paste0(getwd(), "/OB_VIC_SA.html"))

## Leo asked for a csv file with all the CoV zoes, this bit of code makes that
unique(VIC_Zones$TYPE)
x<-VIC_Zones %>% st_drop_geometry() %>% group_by(TYPE, SIMPLIFIED) %>% summarize(numberPolys = n()) 
write.csv(x, "VictoriaZones.csv", row.names = F)
