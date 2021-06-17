require(leaflet)
require(osmdata)
require(sf)

bb = getbb('Ciudad Autonoma de Buenos Aires, Argentina',format_out = 'polygon')
parks = opq(bb) %>% 
  add_osm_feature(key = 'leisure', value = "park") %>% 
  osmdata_sf() %>% trim_osmdata(bb)

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



plot(parks$osm_polygons[1],reset=FALSE)
plot(nature_reserve$osm_lines[1])
plot(parks$osm_polygons[1],add=TRUE)

features = available_features()
ft_tag = lapply(features,function(ft){
  paste(ft,available_tags(ft),sep=',')
})

ft_tagged = do.call(c,ft_tag)
ft_tagged = c('feature,tag',ft_tagged)
writeLines(ft_tagged,'OSM_feature-tages.csv')
ft_tagged = read.csv('OSM_feature-tages.csv')
ft_tagged$tag
nrow(ft_tagged)
# Busco parks
ft_tagged$feature[grep('park',ft_tagged$feature)]
ft_tagged$tag[grep('park',ft_tagged$tag)]
# Me gustan las
ids = c(6,8,9)
to_save = ft_tagged[grep('park',ft_tagged$tag)[ids],]
# Busco beachs
ft_tagged[grep('beach',ft_tagged$tag),]
ft_tagged[grep('beach',ft_tagged$feature),]
to_save = rbind(to_save,ft_tagged[grep('beach',ft_tagged$tag)[2],])

# Busco naturals
key = 'natural'
ft_tagged[grep(key,ft_tagged$tag),]
ft_tagged[grep(key,ft_tagged$feature),]

# Busco naturals
key = 'natural'
ft_tagged[grep(key,ft_tagged$tag),]
ft_tagged[grep(key,ft_tagged$feature),]

# Leisures
key = 'leisure'
ft_tagged[grep(key,ft_tagged$tag),]
ft_tagged[grep(key,ft_tagged$feature),]

# gardens
key = 'garden'
ft_tagged[grep(key,ft_tagged$tag),]
ft_tagged[grep(key,ft_tagged$feature),]
to_save = rbind(to_save,ft_tagged[grep(key,ft_tagged$tag)[2],])


key = 'landuse'
ft_tagged[grep(key,ft_tagged$tag),]
ft_tagged[grep(key,ft_tagged$feature),]

key = 'grass'
ft_tagged[grep(key,ft_tagged$tag),]
ft_tagged[grep(key,ft_tagged$feature),]
to_save = rbind(to_save,ft_tagged[grep(key,ft_tagged$tag),])


key = 'greenfield'
ft_tagged[grep(key,ft_tagged$tag),]
ft_tagged[grep(key,ft_tagged$feature),]
to_save = rbind(to_save,ft_tagged[grep(key,ft_tagged$tag),])

write.csv(to_save,'selected_fields.csv',row.names=FALSE)
