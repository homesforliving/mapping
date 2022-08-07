## Load libraries
library(sf)
library(dplyr)
library(mapview)
library(stringr)
library(RColorBrewer)
library(here)
library(smoothr)
###############
# Load
###############
COL_Zones <- read_sf(here("data/ColwoodZoning", "Zoning.shp"))
ESQ_Zones <- read_sf(here("data/EsquimaltZoning", "Esquimalt.shp"))
HIG_Zones <- read_sf(here("data/HighlandsZoning", "Highlands_Zoning.shp"))
LAN_Zones <- read_sf(here("data/LangfordZoning", "Langford_Zoning.shp"))
NS_Zones <- read_sf(here("data/NorthSaanichZoning", "NorthSaanich_Zoning.shp"))
OB_Zones <- read_sf(here("data/OakBayZoning", "Oak_Bay_Zoning.shp"))
SA_Zones <- read_sf(here("data/SaanichZoning", "Zoning.shp"))
SID_Zones <- read_sf(here("data/SidneyZoning", "Sidney_Zoning_LEO_v10.shp"))
VIC_Zones <- read_sf(here("data/VictoriaZoning", "Zoning_Boundary.shp"))
VR_Zones <- read_sf(here("data/ViewRoyalZoning", "VR_Zoning.shp"))

COL_LookupTable <- read.csv(here("data/ColwoodZoning", "zonemap_colwood.csv"), stringsAsFactors = F)
ESQ_LookupTable <- read.csv(here("data/EsquimaltZoning", "zonemap_esquimalt.csv"), stringsAsFactors = F)
HIG_LookupTable <- read.csv(here("data/HighlandsZoning", "zonemap_highlands.csv"), stringsAsFactors = F)
LAN_LookupTable <- read.csv(here("data/LangfordZoning", "zonemap_langford.csv"), stringsAsFactors = F)
NS_LookupTable <- read.csv(here("data/NorthSaanichZoning", "zonemap_northsaanich.csv"), stringsAsFactors = F)
OB_LookupTable <- read.csv(here("data/OakBayZoning", "zonemap_oakbay.csv"), stringsAsFactors = F)
SA_LookupTable <- read.csv(here("data/SaanichZoning", "zonemap_saanich2.csv"), stringsAsFactors = F)
SID_LookupTable <- read.csv(here("data/SidneyZoning", "zonemap_sidney.csv"), stringsAsFactors = F)
# VIC currently not being read from a mapping. 
VR_LookupTable <- read.csv(here("data/ViewRoyalZoning", "zonemap_viewroyal.csv"), stringsAsFactors = F)


###############
# Process
###############

# correct CRS
# Most are in 4269 but not all, transform them to 4269.
# COL_Zones <- st_transform(COL_Zones, 4269)
# ESQ_Zones <- st_transform(ESQ_Zones, 4269)
# LAN_Zones <- st_set_crs(LAN_Zones, 4269) #langford has no CRS set???
# NS_Zones <- st_transform(NS_Zones, 4269)
# OB_Zones <- st_transform(OB_Zones, 4269)
# SA_Zones <- st_transform(SA_Zones, 4269)
# SID_Zones <- st_transform(SID_Zones, 4269)
# VIC_Zones <- st_transform(VIC_Zones, 4269)
# VR_Zones <- st_transform(VR_Zones, 4269)

## What are the zone types?
# unique(OB_Zones$ZONE_)

# select only the required attributes and rename to a standard ZONE
COL_Zones <- COL_Zones %>% select(Zone_) %>% rename(ZONE = Zone_)
ESQ_Zones <- ESQ_Zones %>% select(Zone) %>% rename(ZONE = Zone)
HIG_Zones <- HIG_Zones %>% select(Zoning) %>% rename(ZONE = Zoning)
LAN_Zones <- LAN_Zones %>% select(ZONE_ABR) %>% rename(ZONE = ZONE_ABR)
NS_Zones <- NS_Zones %>% select(Zone) %>% rename(ZONE = Zone)
OB_Zones <- OB_Zones %>% select(ZONE_) %>% rename(ZONE = ZONE_)
SA_Zones <- SA_Zones %>% select(TYPE, CLASS) %>% rename(ZONE = TYPE)
SID_Zones <- SID_Zones %>% select(ZoneClass) %>% rename(ZONE = ZoneClass)
VR_Zones <- VR_Zones %>% select(ZONE_) %>% rename(ZONE = ZONE_)


## Merge with lookup table to get the simplified zone types
COL_Zones <- merge(COL_Zones, COL_LookupTable, by.x = "ZONE", by.y = "Zone_")
ESQ_Zones <- merge(ESQ_Zones, ESQ_LookupTable, by.x = "ZONE", by.y = "Zone")
HIG_Zones <- merge(HIG_Zones, HIG_LookupTable, by.x = "ZONE", by.y = "CLASS")
LAN_Zones <- merge(LAN_Zones, LAN_LookupTable, by.x = "ZONE", by.y = "ZONE_ABR")
NS_Zones <- merge(NS_Zones, NS_LookupTable, by.x = "ZONE", by.y = "Zone")
OB_Zones <- merge(OB_Zones, OB_LookupTable, by.x = "ZONE", by.y = "OB_ZONE")
SA_Zones <- merge(SA_Zones, SA_LookupTable, by.x = "ZONE", by.y = "CLASS") %>% 
  select(-CLASS)
SID_Zones <- merge(SID_Zones, SID_LookupTable, by.x = "ZONE", by.y = "ZoneClass")
VR_Zones <- merge(VR_Zones, VR_LookupTable, by.x = "ZONE", by.y = "ZONE_")

# VICTORIA ####
## Start some logic to sort the victoria zone types (this is not at all complete!)
VIC_Zones <- VIC_Zones %>% 
  mutate(SIMPLIFIED = case_when(substr(Zoning, 1, 2) == "R1" ~ "Single/Duplex",
                                substr(Zoning, 1, 1) == "C" ~ "Commercial",
                                Zoning == "R-2" ~ "Single/Duplex"))
## define missing middle zones
missingMid_Vic <- c("R-J", "R-K", "R-N", "RT")

## appartment zones
appt_vic <- c("R3-1", "R3-2", "R-3-C", "R3-A1", "R3-A2", "R3-AM-1", "R3-AM-2", "R-48", "RTM", "URMD")

## apply these zone types
VIC_Zones$SIMPLIFIED[VIC_Zones$Zoning %in% missingMid_Vic] <- "Missing Middle"
VIC_Zones$SIMPLIFIED[VIC_Zones$Zoning %in% appt_vic] <- "Missing Middle"

## select only what is needed and rename to match SA and OB
VIC_Zones <- VIC_Zones %>% select(Zoning, SIMPLIFIED)
VIC_Zones <- VIC_Zones %>% rename(ZONE = Zoning)
VIC_Zones$NOTES <- rep(NA, nrow(VIC_Zones))
VIC_Zones = VIC_Zones[,c(1,2,4,3)]

## Bind all the data into one large sf spatial object
# FIXME for some reason this fails if we add all the zones.

# COLWOOD ####
#FIX for Colwood is to remove the invalid row
if ((is.na(unique(st_is_valid(COL_Zones))) == TRUE) & (length(unique(st_is_valid(COL_Zones))) == 1)) {
  COL_Zones = st_make_valid(COL_Zones)
}
# CAUSED ERROR:
# COL_Zones <- COL_Zones[!is.na(st_is_valid(COL_Zones)),]

# LANGFORD ####
#FIX Langford by giving it a proper crs
st_crs(LAN_Zones) <- "+proj=utm +zone=10 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"

#Just set everything to 3005, BC Albers  \_(ツ)_/¯
LAN_Zones <- st_transform(LAN_Zones, 3005)
COL_Zones <- st_transform(COL_Zones, 3005)
ESQ_Zones <- st_transform(ESQ_Zones, 3005)
HIG_Zones <- st_transform(HIG_Zones, 3005)
NS_Zones <- st_transform(NS_Zones, 3005)
OB_Zones <- st_transform(OB_Zones, 3005)
SA_Zones <- st_transform(SA_Zones, 3005)
SID_Zones <- st_transform(SID_Zones, 3005)
VIC_Zones <- st_transform(VIC_Zones, 3005)
VR_Zones <- st_transform(VR_Zones, 3005)

# Remove identical features
VR_Zones = VR_Zones %>% distinct()

# Fix other stuff
NS_Zones = st_zm(NS_Zones)
####

ALL_zones <- rbind(COL_Zones, LAN_Zones, ESQ_Zones, HIG_Zones, OB_Zones, NS_Zones, SA_Zones, SID_Zones, VIC_Zones, VR_Zones)
ALL_zones = ALL_zones %>% st_buffer(0)
# Save as output shapefile
st_write(ALL_zones, "Harmonized_Zones.shp", append = FALSE)

## dissolve internal boundaries
ALL_zones_d <- ALL_zones %>% group_by(SIMPLIFIED) %>% st_buffer(0) %>% summarize()

test = smoothr::drop_crumbs(ALL_zones_d, drop_empty=T,threshold = 10)
test = smoothr::fill_holes(test, threshold = 10)

# Save as output shapefile
st_write(test, "Harmonized_Zones_Dissolved.shp", append = FALSE)

## make a map object with colors based on the simplified zone names save the map as an html file 
m1 <- mapview(ALL_zones_d, zcol = "SIMPLIFIED")
m1

beepr::beep()
# m1 <- mapview(VR_Zones, zcol = "SIMPLIFIED")
# m1

mapshot(m1, url = here("map_output.html"), selfcontained = FALSE)


## Leo asked for a csv file with all the CoV zones, this bit of code makes that
unique(VIC_Zones$TYPE)
x<-VIC_Zones %>% st_drop_geometry() %>% group_by(TYPE, SIMPLIFIED) %>% summarize(numberPolys = n()) 
write.csv(x, "VictoriaZones.csv", row.names = F)
