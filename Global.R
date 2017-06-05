#Testing The data
library(readr)
library(rjson)
library(rgdal)
library(proj4)
library(raster)
library(maptools)
library(leaflet)
library(leaflet.extras)
library(shiny)
#library(mapview)

#Load data
kml<-read_file('Las Vegas Strip.kml')
vegas<-readOGR('cleaned data/shapefile','vegas',verbose = FALSE)
college<-dget('cleaned data/colleges/college')
callCenters<-dget('cleaned data/callCenters')
netdist<-dget('cleaned data/netdist')
Wynn<-geocode('3131 S Las Vegas Blvd, Las Vegas, NV 89109')




#transportation rank
callCenters$travel.Rank<-NA
callCenters$travel.Rank[order(callCenters$Wynn.distance.Mins)]<-1:nrow(callCenters)

#call center & crime:
crime<-vegas@data[,c("Theft","Burglary","Assault","Vandalism","Robbery","Total_Crim","Crime_SQMI","ZCTA5CE10")]
crime$Crime_SQMI<-round(crime$Crime_SQMI,0)
library(stringi)
callCenters$ZCTA5CE10<-stri_sub(callCenters$address,-5)
callCenters$ID<-1:12
callCenters<-merge(callCenters,crime,all.x=TRUE,by='ZCTA5CE10')
callCenters<-callCenters[order(callCenters$ID), ]
callCenters$Safety.Rank<-NA
callCenters$Safety.Rank[order(callCenters$Crime_SQMI)]<-1:nrow(callCenters)




#Map block color Setting
clrs <- RColorBrewer::brewer.pal(5, "YlOrRd")
pal<-colorBin(
  palette = clrs,
  vegas$Labor_SQMI,
  pretty = FALSE,
  bins=c(1000,2000,3000,4000,5000)#setting 1000 as maximum index, any number outside would be grayed out. 
)

clrs2 <- RColorBrewer::brewer.pal(5, "Blues")
pal2<-colorBin(
  palette = clrs2,
  vegas$MedianInco,
  pretty = FALSE,
  bins=c(20000,40000,60000,80000,110000)#setting 1000 as maximum index, any number outside would be grayed out. 
)


pal.crime<-colorBin(
  palette = clrs,
  vegas$Crime_SQMI,
  pretty = FALSE,
  bins=c(25,50,100,200,400,800)#setting 1000 as maximum index, any number outside would be grayed out. 
)




local1<-makeIcon(
  iconUrl = 'logo/callCenter.png',
  iconWidth = 30, iconHeight = 30)


school<-makeIcon(
  iconUrl = 'logo/graduation_cap.png',
  iconWidth = 40, iconHeight = 30)


#popup magines:

callcenterImages<-c("<img src='https://raw.githubusercontent.com/jz1584/Map/master/CityCenterWest.PNG' style='width:337px;height:150px;'>",
                    "<img src='https://raw.githubusercontent.com/jz1584/Map/master/TheCanyons.PNG' style='width:337px;height:150px;'>",
                    "<img src='https://raw.githubusercontent.com/jz1584/Map/master/4245SGrand.PNG' style='width:337px;height:150px;'>",
                    "<img src='https://raw.githubusercontent.com/jz1584/Map/master/FortApache.PNG' style='width:337px;height:150px;'>",
                    "<img src='https://raw.githubusercontent.com/jz1584/Map/master/101ConventionCenter.PNG' style='width:337px;height:150px;'>",
                    "<img src='https://raw.githubusercontent.com/jz1584/Map/master/The1785Office.PNG' style='width:337px;height:150px;'>",
                    "<img src='https://raw.githubusercontent.com/jz1584/Map/master/3773Howard.PNG' style='width:337px;height:150px;'>",
                    
                    "<img src='https://raw.githubusercontent.com/jz1584/Map/master/3800HowardHC.PNG' style='width:337px;height:150px;'>",
                    "<img src='https://raw.githubusercontent.com/jz1584/Map/master/3993HowardHC.PNG' style='width:337px;height:150px;'>",
                    "<img src='https://raw.githubusercontent.com/jz1584/Map/master/Greystone.PNG' style='width:337px;height:150px;'>",
                    "<img src='https://raw.githubusercontent.com/jz1584/Map/master/PointeFlamnigo.PNG' style='width:337px;height:150px;'>",
                    "<img src='https://raw.githubusercontent.com/jz1584/Map/master/MiracleFlights.PNG' style='width:337px;height:150px;'>"
)




