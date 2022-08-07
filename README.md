# mapping
This repo contains Mapping and Zoning related projects for Homes for Living within the Capital Regional District in B.C., Canada.

There are hundreds of different zones in the various municipalities which are difficult to understand.  The goal of this project is to map these zones to a harmonized subset that describes what can be built on the land as simply as possible, as well as laying the groundwork for further GIS analysis of the broader region.

Differing municipalities have varying numbers of zones; Saanich, for example, has only a few dozen, while the municipality of Victoria has over 700.

A preview of the dataset in its current state is located [here](https://homesforliving.github.io/mapping/).

**Harmonized zoning categories**

The [simplified zoning categories are listed here](https://github.com/homesforliving/mapping/blob/main/harmonized_zones.md) and are based on the ones used in the similar [UBC zoning project](https://zoning.sociology.ubc.ca/).   We also want to capture general housing characteristics namely by density, distinguishing **single family detached housing (SFH/Duplexes)** from higher densities like **Missing Middle** and **Low Rise Residential / Apartments**.

**Current Status:**

See the table below for status of the project by municipality.  To map a municipality's zoning to the harmonized set, please assign yourself to the issue linked, then complete the mapping CSV in the associated data folder.

| Municipality | Population | Size (sq.km) | Pop. Density (per sq.km)| Shapefile | Categories Assigned | Zoning Doc. Link|
| ------------ | ---------- | ------------ | ------------------------------| --------- | ----------------- |---|
| Saanich | 117,735 | 103.59 | 1,136.6 | :heavy_check_mark: | ✔️ | https://www.saanich.ca/assets/Local~Government/Documents/Planning/zone8200.pdf
| Victoria | 91,867 | 19.45 | 4,722.3 | :heavy_check_mark: | [#7](https://github.com/homesforliving/mapping/issues/7) | https://www.victoria.ca/EN/main/residents/planning-development/development-services/zoning/zoning-regulation-bylaw.html Downtown: https://www.victoria.ca/assets/Departments/Planning~Development/Development~Services/Zoning/Bylaws/Zoning%20Bylaw%202018.pdf 
| Langford | 46,584 | 41.43 | 1,124.4 | :heavy_check_mark: | [#8](https://github.com/homesforliving/mapping/issues/8) | https://www.langford.ca/wp-content/uploads/2020/10/Zoning-Bylaw-20210621.pdf |
| Colwood | 18,961 | 17.66 | 1,073.6 | :heavy_check_mark: | ✔️ | https://colwood.civicweb.net/document/1999/ |
| Oak Bay | 17,990 | 10.52 | 1,710.1 | :heavy_check_mark: | ✔️ | https://www.oakbay.ca/sites/default/files/heritage/Consolidated%20Zoning%20Bylaw%20as%20of%20November%2013%2C%202018%20Reduced.pdf
| Esquimalt | 17,533 | 7.08 | 2,476.7 | :heavy_check_mark: | ✔️ | https://www.esquimalt.ca/business-development/building-zoning
| Central Saanich | 17,385 | 41.20 | 421.9 | :x: | [#12](https://github.com/homesforliving/mapping/issues/12) |
| Sidney | 12,318 | 5.11 | 2,412.8 | :heavy_check_mark: |[#13](https://github.com/homesforliving/mapping/issues/13) |
| North Saanich | 12,235 | 37.16 | 329.2 | :heavy_check_mark: |[#14](https://github.com/homesforliving/mapping/issues/14)|
| View Royal | 11,575 | 14.33 | 807.6 | ✔️ | ✔️ | https://www.viewroyal.ca/assets/Town~Hall/Bylaws/900%20-%20Zoning%20Bylaw.pdf
| Metchosin | 5,067 | 69.57 |72.8	| :x: |[#16](https://github.com/homesforliving/mapping/issues/16)|
| Highlands | 2,482 | 38.01 | 65.3 | :heavy_check_mark: |[#17](https://github.com/homesforliving/mapping/issues/17)| https://www.highlands.ca/DocumentCenter/View/5053/100---Zoning-Bylaw-No-100-1998-Consolidated-Version---June-4-2018
