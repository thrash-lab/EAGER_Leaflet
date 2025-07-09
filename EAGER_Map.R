#########📚Libaries📚###########

library(leaflet)
library(leaflet.extras2)
library(readr)
library(htmltools)

########🧭 GPS Points ########
gps_points <- read_tsv("gps_points.txt")

# Define circle color and size
custom_colors <- colorFactor(c("red", "red", "red", "red"), levels = c('CJ','ARD','TBON','LKB'))
circle_radius <- 8500

######## 🍁 Leaflet Map 1 ######## 

# 🍁 Tile sources for Map 1
usgs_shaded_relief <- "https://basemap.nationalmap.gov/arcgis/rest/services/USGSShadedReliefOnly/MapServer/tile/{z}/{y}/{x}"
usgs_hydro <- "https://basemap.nationalmap.gov/arcgis/rest/services/USGSHydroCached/MapServer/tile/{z}/{y}/{x}"
esri_satellite <- providers$Esri.WorldImagery  # TRUE satellite for Map 2

map1 <- leaflet(options = leafletOptions(zoomControl = FALSE)) %>%
  addTiles(urlTemplate = usgs_shaded_relief, attribution = "USGS Shaded Relief | U.S. Geological Survey") %>%
  addTiles(urlTemplate = usgs_hydro, attribution = "USGS Hydrography") %>%
  addCircles(
    data = gps_points, lat = ~Latitude, lng = ~Longitude,
    color = ~custom_colors(Site), fillColor = ~custom_colors(Site),
    fillOpacity = 1, stroke = TRUE, radius = circle_radius
  ) %>%
  addLabelOnlyMarkers(
    data = gps_points, lat = ~Latitude, lng = ~Longitude,
    label = ~Site,
    labelOptions = labelOptions(
      noHide = TRUE, direction = 'bottom', textOnly = TRUE,
      style = list("font-size" = "20px", "font-weight" = "bold", "color" = "black")
    )
  ) %>%
  addScaleBar(position = "bottomright", options = scaleBarOptions(metric = TRUE, imperial = FALSE)) %>%
  addMiniMap(
    tiles = esri_satellite, toggleDisplay = FALSE,
    position = "topleft", width = 200, height = 200, zoomLevelOffset = -5
  ) %>%
  addControl(
    html = HTML("
      <style>
        .leaflet-top.leaflet-left .leaflet-control-minimap {
          margin-top: 60px !important;
          margin-left: 30px !important;
        }
        .leaflet-control-container .leaflet-control-layers {
          display: none !important;
        }
        .leaflet-control-minimap svg line {
          display: none !important;
        }
      </style>
    "), position = "topright"
  )

print(map1)

