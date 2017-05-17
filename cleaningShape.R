#####################################################################################################
#@@@@---->shapefile cleaning####
library(rjson)
library(rgdal)
library(proj4)
library(raster)
library(maptools)

#original zip file -usa ziplevel####
zipb<-readOGR('raw data/Shape','Elev_Contour',verbose = FALSE)
zipb<-spTransform(zipb,CRS("+proj=longlat +datum=WGS84")) #change to lon & lat coordination system


