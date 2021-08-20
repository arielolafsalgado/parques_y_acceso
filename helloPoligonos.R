require(leaflet)
require(osmdata)
require(sf)

bb = getbb('Ciudad Autonoma de Buenos Aires, Argentina',format_out = 'polygon')
parks = opq(bb) %>% 
  add_osm_feature(key = 'leisure', value = "park") %>% 
  osmdata_sf() %>% trim_osmdata(bb)

plot(parks$osm_polygons[1],reset=FALSE)

map = leaflet() %>% addPolygons(data=parks$osm_polygons) %>% addProviderTiles(providers$OpenStreetMap)
map

map = leaflet() %>%