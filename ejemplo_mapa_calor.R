require(sf)
require(osmdata)
parques1 = read_sf('osm_data/leisure-park-osm_polygons.gpkg')
parques2 = read_sf('osm_data/leisure-park-osm_multipolygons.gpkg')
caba = read_sf('') 
parques = rbind(parques1[1],parques2[1])
bb = getbb('Ciudad Autonoma de Buenos Aires, Argentina',format_out = 'polygon')
polycity = bb[[2]][[1]]
polycity = st_polygon(list(polycity))
polycity = st_sfc(polycity,crs=4326)
polygrid = st_transform(st_make_grid(st_transform(polycity,crs=22183),cellsize = 300),crs=4326)
plot(polycity,reset=FALSE)
it = st_intersects(polygrid,polycity)
it = sapply(it,length)
it = which(it>0)
polygrid = polygrid[it]
plot(polygrid,add=TRUE)
itp = st_intersects(polygrid,parques)
length(itp)
i = 16
polygrid_areas = sapply(1:length(polygrid),function(i){
  gd = polygrid[i]
  ids = itp[[i]]
  if(length(ids)>0){
    #print(i)
    ps = parques[ids,]
    r = as.numeric(sum(st_area(st_intersection(gd,ps))))
  }else{
    r = 0
  }
  return(r)
})

grid_nei = st_intersects(polygrid,polygrid)
area_9x9 = sapply(1:length(polygrid),function(i){
  ids = grid_nei[[i]]
  ids = unique(unlist(grid_nei[ids]))
  sum(polygrid_areas[ids])
})
polygrid_sf = st_sf(polygrid)
polygrid_sf$area_9x9 = area_9x9/10**4
plot(polygrid_sf['area_9x9'],main='',lwd=0.01)
