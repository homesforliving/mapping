## Load libraries
library(sf)
library(dplyr)
library(mapview)
library(stringr)
library(RColorBrewer)
library(here)

###############
# Load
###############
COL_Zones <- read_sf(here("ColwoodZoning", "Zoning.shp"))
ESQ_Zones <- read_sf(here("EsquimaltZoning", "Esquimalt.shp"))
LAN_Zones <- read_sf(here("LangfordZoning", "Langford_Zoning.shp"))
NS_Zones <- read_sf(here("NorthSaanichZoning", "NorthSaanich_Zoning.shp"))
OB_Zones <- read_sf(here("OakBayZoning", "Oak_Bay_Zoning.shp"))
SA_Zones <- read_sf(here("SaanichZoning", "Zoning.shp"))
SID_Zones <- read_sf(here("SidneyZoning", "Sidney_Zoning_LEO_v10.shp"))
VIC_Zones <- read_sf(here("VictoriaZoning", "Zoning_Boundary.shp"))
VR_Zones <- read_sf(here("ViewRoyalZoning", "VR_Zoning.shp"))


OB_LookupTable <- read.csv(here("OakBayZoning", "OB_Zone_Lookup.csv"), stringsAsFactors = F)
SA_LookupTable <- read.csv(here("SaanichZoning", "Saanich_Zone_Lookup.csv"), stringsAsFactors = F)

###############
# Process
###############

## What are the zone types?
# unique(OB_Zones$ZONE_)

# select only the required attributes
OB_Zones <- OB_Zones %>% select(AREA, ZONE_)
SA_Zones <- SA_Zones %>% select(TYPE, CLASS)

## Merge with lookup table to get the simplified zone types
OB_Zones <- merge(OB_Zones, OB_LookupTable, by.x = "ZONE_", by.y = "OB_ZONE")

## Merge with lookup table to get the simplified zone names
SA_Zones <- merge(SA_Zones, SA_LookupTable, by.x = "CLASS", by.y = "CLASS") %>% 
  select(TYPE, SIMPLIFIED)

## Rename the attribute "ZONE_" to "TYPE" in the OB data so it can be merged with SA
OB_Zones <- OB_Zones %>% select(ZONE_, SIMPLIFIED) %>% rename(TYPE = ZONE_)

## Start some logic to sort the victoria zone types (this is not at all complete!)
VIC_Zones <- VIC_Zones %>% mutate(SIMPLIFIED = case_when(substr(Zoning, 1, 2) == "R1" ~ "Single Family Detached",
                                            substr(Zoning, 1, 1) == "C" ~ "Commercial"))

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

# st_crs(VIC_Zones)
# st_crs(OB_Zones)
# st_crs(SA_Zones)

# This is probably not the right way to do it.  Do we need to transform?
SA_Zones <- st_set_crs(SA_Zones, 4617)
OB_Zones <- st_set_crs(OB_Zones, 4617)
VIC_Zones <- st_set_crs(VIC_Zones, 4617)

## Bind all the data into one large sf spatial object
VIC_OB_SA_Zones <- rbind(VIC_Zones, OB_Zones, SA_Zones)

## dissolved internal boundaries
VIC_OB_SA_Zones <- VIC_OB_SA_Zones %>% group_by(SIMPLIFIED) %>% st_buffer(0) %>% summarize()

## make a map object with colors based on the simplified zone names save the map as an html file 
m1 <- mapview(VIC_OB_SA_Zones, zcol = "SIMPLIFIED")
mapshot(m1, url = here("map_output.html"), selfcontained=FALSE)

## Leo asked for a csv file with all the CoV zoes, this bit of code makes that
unique(VIC_Zones$TYPE)
x<-VIC_Zones %>% st_drop_geometry() %>% group_by(TYPE, SIMPLIFIED) %>% summarize(numberPolys = n()) 
write.csv(x, "VictoriaZones.csv", row.names = F)
