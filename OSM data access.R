#library('osmar')
#http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf
library('osmar')
library('geosphere')
lv.box <- corner_bbox(left =-115.3949,right = -114.9294,top = 36.3256,bottom =  35.9691)
api <- osmsource_api()
lv <- get_osm(lv.box, source = api)

summary(lv$nodes$tags$k)

point<-lv$nodes$tags
point.attr<-lv$nodes$attrs;names(point.attr)
point.attr<-point.attr[,c("id","timestamp","lat","lon")]


# In dividual point: 
all<-merge(point,point.attr,all.x=TRUE,by='id')
#all<-merge(all,lv$ways$tags,all.x=TRUE,by='id')


all<-all[!grepl('addr',all$k),]
all<-all[!grepl('ele',all$k),]
all<-all[!grepl('is_in',all$k),]
all<-all[!grepl('name:ar',all$k),]

library(data.table)
a<-dcast(setDT(all),id~rowid(id),value.var = c('k','v'))
View(a)
# lines: 




####
#### Alternative:
library(rjson)
library(rgdal)
library(proj4)
library(raster)
library(maptools)
library(leaflet)
library(leaflet.extras)

nv<-readOGR('OSM dataset/','gis.osm_pois_free_1',verbose = FALSE)
nv<-as.data.frame(nv)


labor<-nv[nv$fclass%in%c('college','university','school'),]
labor$timeStamp<-NA

for (i in labor$osm_id){
  timeSt<-get_osm(node(i))$nodes$attrs$timestamp
  print(as.Date(timeSt))
  labor$timeStamp[labor$osm_id==i]<-as.Date(timeSt)
}


College<-nv[nv$fclass%in%c('college','university'),]
school<-nv[nv$fclass%in%c('school'),]





leaflet()%>%
  addTiles()%>%
  addCircles(lng = school$coords.x1,lat=school$coords.x2,
             popup = paste(school$fclass,school$name),color='red',radius = 500)%>%
  addMarkers(lng=College$coords.x1,lat=College$coords.x2,label = College$name)


#check by id:
get_osm(node(357555757))











####

ways <- find(rome, way(tags(k == "shop")))
ways <- find_down(rome, way(ways))
ways <- subset(rome, ids = ways)

hw_lines <- as_sp(ways, "lines") 
spplot(hw_lines, zcol = "uid")

mapview::mapview(hw_lines)

plot(hw_lines, xlab = "Lon", ylab = "Lat")




