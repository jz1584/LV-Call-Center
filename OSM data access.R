#library('osmar')
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


leaflet(nv)%>%
  addTiles()%>%
  addCircles()



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




