library(rjson)
library(rgdal)
library(proj4)
library(raster)
library(maptools)
library(leaflet)
library(leaflet.extras)


#community college:
nv<-readOGR('OSM dataset/','gis.osm_pois_free_1',verbose = FALSE)
nv<-as.data.frame(nv)
education<-nv[nv$fclass%in%c('college','university','school'),]
education$timeStamp<-as.Date(NA)

highsc<-grepl('high',education$name,ignore.case=TRUE)
college2<-education[grepl('college|university|career',education$name,ignore.case = TRUE) & !highsc,]
ccollege<-college2[grepl('community',college2$name,ignore.case = TRUE),]

for (i in ccollege$osm_id){
  timeSt<-get_osm(node(i))$nodes$attrs$timestamp
  print(as.Date(timeSt))
  ccollege$timeStamp[ccollege$osm_id==i]<-as.Date(timeSt)
}

dput(ccollege,'cleaned data/colleges/CommunityCollege')

leaflet()%>% #sample view
  addTiles()%>%
  addMarkers(lng=ccollege$coords.x1,lat=ccollege$coords.x2,label = ccollege$name)



#Bank & ATM:
education<-nv[nv$fclass%in%c('bank','atm'),]