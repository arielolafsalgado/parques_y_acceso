require(leaflet)
require(osmdata)
require(sf)
to_download = read.csv('selected_fields.csv')

bb = getbb('Ciudad Autonoma de Buenos Aires, Argentina',format_out = 'polygon')
for(q in 1:nrow(to_download)){
  fields = paste(to_download[q,],collapse='-')
  print(fields)
  data = opq(bb) %>% 
    add_osm_feature(key = to_download$feature[q], value = to_download$tag[q]) %>% 
    osmdata_sf() %>% trim_osmdata(bb)
  if(!all(sapply(data[grep('osm',names(data))],is.null))){
    ids = which(!sapply(data[grep('osm',names(data))],is.null))
    nids = names(ids)
    for(nid in nids){
      d = data[[nid]]
      if(nrow(d)>0){
        nm = paste(fields,'-',nid,'.gpkg',sep='')
        plot(d[1],main=nm)
        st_write(d,dsn = nm)
      }
    }
    
  }
}

nature_reserve = opq(bb) %>% 
  add_osm_feature(key = 'leisure', value = "nature_reserve") %>% 
  osmdata_sf() %>% trim_osmdata(bb)

beach = opq(bb) %>% 
  add_osm_feature(key = 'natural', value = "beach") %>% 
  osmdata_sf() %>% trim_osmdata(bb)

national_park = opq(bb) %>% 
  add_osm_feature(key = 'landuse', value = "recreation_ground ") %>%
  add_osm_feature(key = 'ownership', value = "national ") %>%
  osmdata_sf() %>% trim_osmdata(bb)

