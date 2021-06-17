require(leaflet)
require(osmdata)
require(sf)
require(htmlwidgets)

datasets = dir('osm_data/',full.names = TRUE)
ds = datasets[1]
ds
for(ds in datasets){
  d = st_read(ds)
  map = leaflet() %>% addProviderTiles(providers$OpenStreetMap)
  if(grepl('points',ds)){
    map = map %>% addCircles(data=d)
  }else if(grepl('line',ds)){
    map = map %>% addPolylines(data=d)
  }else{
    map = map %>% addPolygons(data=d)
  }
  map = map  %>% addControl(ds,position='topright')
  saveWidget(map,gsub('.gpkg','_map.html',ds))
}
