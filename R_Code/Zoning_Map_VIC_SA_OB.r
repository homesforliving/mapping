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

COL_LookupTable <- read.csv(here("ColwoodZoning", "zonemap_colwood.csv"), stringsAsFactors = F)
ESQ_LookupTable <- read.csv(here("EsquimaltZoning", "zonemap_esquimalt.csv"), stringsAsFactors = F)
LAN_LookupTable <- read.csv(here("LangfordZoning", "zonemap_langford.csv"), stringsAsFactors = F)
NS_LookupTable <- read.csv(here("NorthSaanichZoning", "zonemap_northsaanich.csv"), stringsAsFactors = F)
OB_LookupTable <- read.csv(here("OakBayZoning", "zonemap_oakbay.csv"), stringsAsFactors = F)
SA_LookupTable <- read.csv(here("SaanichZoning", "zonemap_saanich.csv"), stringsAsFactors = F)
SID_LookupTable <- read.csv(here("SidneyZoning", "zonemap_sidney.csv"), stringsAsFactors = F)
# VIC currently not being read from a mapping. 
VR_LookupTable <- read.csv(here("ViewRoyalZoning", "zonemap_viewroyal.csv"), stringsAsFactors = F)


###############
# Process
###############

# correct CRS
# Most are in 4269 but not all, transform them to 4269.
COL_Zones <- st_transform(COL_Zones, 4269)
ESQ_Zones <- st_transform(ESQ_Zones, 4269)
LAN_Zones <- st_set_crs(LAN_Zones, 4269) #langford has no CRS set???
NS_Zones <- st_transform(NS_Zones, 4269)
OB_Zones <- st_transform(OB_Zones, 4269)
SA_Zones <- st_transform(SA_Zones, 4269)
SID_Zones <- st_transform(SID_Zones, 4269)
VIC_Zones <- st_transform(VIC_Zones, 4269)
VR_Zones <- st_transform(VR_Zones, 4269)

## What are the zone types?
# unique(OB_Zones$ZONE_)

# select only the required attributes and rename to a standard ZONE
COL_Zones <- COL_Zones %>% select(Zone_) %>% rename(ZONE = Zone_)
ESQ_Zones <- ESQ_Zones %>% select(Zone) %>% rename(ZONE = Zone)
LAN_Zones <- LAN_Zones %>% select(ZONE_ABR) %>% rename(ZONE = ZONE_ABR)
NS_Zones <- NS_Zones %>% select(Zone) %>% rename(ZONE = Zone)
OB_Zones <- OB_Zones %>% select(ZONE_) %>% rename(ZONE = ZONE_)
SA_Zones <- SA_Zones %>% select(TYPE, CLASS) %>% rename(ZONE = TYPE)
SID_Zones <- SID_Zones %>% select(ZoneClass) %>% rename(ZONE = ZoneClass)
VR_Zones <- VR_Zones %>% select(ZONE_) %>% rename(ZONE = ZONE_)


## Merge with lookup table to get the simplified zone types
COL_Zones <- merge(COL_Zones, COL_LookupTable, by.x = "ZONE", by.y = "Zone_")
ESQ_Zones <- merge(ESQ_Zones, ESQ_LookupTable, by.x = "ZONE", by.y = "Zone")
LAN_Zones <- merge(LAN_Zones, LAN_LookupTable, by.x = "ZONE", by.y = "ZONE_ABR")
NS_Zones <- merge(NS_Zones, NS_LookupTable, by.x = "ZONE", by.y = "Zone")
OB_Zones <- merge(OB_Zones, OB_LookupTable, by.x = "ZONE", by.y = "OB_ZONE")
SA_Zones <- merge(SA_Zones, SA_LookupTable, by.x = "ZONE", by.y = "CLASS") %>% 
  select(ZONE, SIMPLIFIED)
SID_Zones <- merge(SID_Zones, SID_LookupTable, by.x = "ZONE", by.y = "ZoneClass")
VR_Zones <- merge(VR_Zones, VR_LookupTable, by.x = "ZONE", by.y = "ZONE_")


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

VIC_Zones <- VIC_Zones %>% rename(ZONE = Zoning)

## Bind all the data into one large sf spatial object
# FIXME for some reason this fails if we add all the zones.
ALL_zones <- rbind(ESQ_Zones, OB_Zones, SA_Zones, SID_Zones, VIC_Zones, VR_Zones)

## dissolved internal boundaries
ALL_zones <- ALL_zones %>% group_by(SIMPLIFIED) %>% st_buffer(0) %>% summarize()

## make a map object with colors based on the simplified zone names save the map as an html file 
m1 <- mapview(ALL_zones, zcol = "SIMPLIFIED")
mapshot(m1, url = here("map_output.html"), selfcontained=FALSE)

## Leo asked for a csv file with all the CoV zoes, this bit of code makes that
unique(VIC_Zones$TYPE)
x<-VIC_Zones %>% st_drop_geometry() %>% group_by(TYPE, SIMPLIFIED) %>% summarize(numberPolys = n()) 
write.csv(x, "VictoriaZones.csv", row.names = F)
