# mapping
This repo contains Mapping and Zoning related projects for Homes for Living within the Capital Regional District in B.C., Canada.

The goal is to unify the zoning of municipalities making up the CRD for easier GIS analysis.

Differing municipalities have varying numbers of zoning types; Saanich, for example, has under 20, while the municipality of Victoria has > 100.

A preview of the dataset in its current state is located [here](https://housesforliving.github.io/mapping/).

**Unifying zoning types:**

We are currently working to figure out which categories the various zonings fall into. For example, **Parks and Recreation, Industrial and Commercial** are categories we want to capture. We also want to capture general housing characteristics namely by density, distinguishing **single family detached housing (SFH/Duplexes)** from higher densities like **Missing Middle** and **Low Rise Residential / Apartments**.

For the full list and details, click [here](https://github.com/housesforliving/mapping/blob/main/harmonized_zones.md).

**Current Status:**

| Municipality | Population | Size (sq.km) | Pop. Density (per sq.km)| Shapefile | Categories Assigned | Zoning Doc. Link|
| ------------ | ---------- | ------------ | ------------------------------| --------- | ----------------- |---|
| Saanich | 117,735 | 103.59 | 1,136.6 | :heavy_check_mark: | | 
| Victoria | 91,867 | 19.45 | 4,722.3 | :heavy_check_mark: | | 
| Langford | 46,584 | 41.43 | 1,124.4 | :heavy_check_mark: | | 
| Colwood | 18,961 | 17.66 | 1,073.6 | :heavy_check_mark: | | 
| Oak Bay | 17,990 | 10.52 | 1,710.1 | :heavy_check_mark: | | 
| Esquimalt | 17,533 | 7.08 | 2,476.7 | :heavy_check_mark: || https://www.esquimalt.ca/business-development/building-zoning
| Central Saanich | 17,385 | 41.20 | 421.9 | :x: ||
| Sidney | 12,318 | 5.11 | 2,412.8 | :heavy_check_mark: ||
| North Saanich | 12,235 | 37.16 | 329.2 | :heavy_check_mark: ||
| View Royal | 11,575 | 14.33 | 807.6 | :heavy_check_mark: ||
| Metchosin | 5,067 | 69.57 |72.8	| :x: ||
| Highlands | 2,482 | 38.01 | 65.3 | :heavy_check_mark: ||
