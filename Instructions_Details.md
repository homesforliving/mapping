# Zoning Classification:

We are harmonizing the zoning of municipalities in the CRD into the [categories outlined here](https://github.com/homesforliving/mapping/blob/main/harmonized_zones.md). 

# Instructions:

Each municipality folder (i.e., `/ViewRoyalZoning`) contains a shapefile of that municipality's zoning, and a .csv  (i.e., `zonemap_viewroyal.csv`) indicating how the various zoning IDs map to our list of classification types. For most cases, a link to the zoning bylaws document for each municipality are also in the README. (Feel free to add missing ones.)

The zoning codes of each muni are already located in the .csv files; we are filling in the 'SIMPLIFIED' column, and any relevant notes or info added to the 'NOTES' column (including indicating classifications you're unsure about or want someone to double-check).
The zoning bylaw documents contain the info for each code that can be used to choose which category the zoning belongs to.

For example, Thetis Lake Park in the municipality of View Royal has it's own zoning code: `P-1` (details on page 101 of the [View Royal Zoning](https://www.viewroyal.ca/assets/Town~Hall/Bylaws/900%20-%20Zoning%20Bylaw.pdf) document). We're categorizing parks as "Recreational" so that was entered next to this zoning code in the .csv file.

Then again, View Royal has a bunch of "Comprehensive Development" zones (i.e. `CD-8`) that also have categories (`(A), (B)`) with different rules. Based on the dominant / max use of each zoning type, `CD-8 (A)` was classified `Mixed Use` (having principal uses including cafes, medical clinics, offices, and apartments), while `CD-8 (B)` was classified `Missing Middle` (because it has principal uses including residential townhouses or rowhouses, though live/work studios and parks and open spaces are included in this zoning type). It's all very straightforward! `/s` 

Please see the .csv files of completed municipalities such as [Oak Bay](https://github.com/homesforliving/mapping/blob/main/data/OakBayZoning/zonemap_oakbay.csv) or [View Royal](https://github.com/homesforliving/mapping/blob/main/data/ViewRoyalZoning/zonemap_viewroyal.csv) for examples.

You can edit in a text editor of your choice, or directly in the browser window (if you have access to mofidy the repo). 
If you download the .csv and add simplified categories and aren't familiar with github, feel free to send it to someone in the **#zoning-map-project** channel and we can upload it for you or help you out!

Finally, if you notice something in the map that doesn't look right, please open an [Issue](https://github.com/homesforliving/mapping/issues) so that we can keep track. 

