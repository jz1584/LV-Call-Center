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



#distance labeling
netdist<-callCenters
netdist$ID<-1:nrow(netdist)
Wynn<-geocode('3131 S Las Vegas Blvd, Las Vegas, NV 89109')
netdist$name<-as.character(netdist$name)
#netdist[(nrow(netdist)+1):(nrow(netdist)*2),]<-NA #create empty rows
netdist[(nrow(netdist)+1):(nrow(netdist)*2),]$name<-'Wynn Hotel'
netdist[13:24,c("lon","lat")]<-Wynn
netdist[13:24,c('ID')]<-1:12


callCenters$Wynn.distance.Mins<-NA
callCenters$Wynn.distance.mile<-NA
for (i in 1:nrow(callCenters)){
  temp<-mapdist(as.numeric(Wynn),as.numeric(callCenters[i,c("lon","lat")]),mode = 'driving')
  callCenters$Wynn.distance.Mins[i]<-round(temp$minutes,2)
  callCenters$Wynn.distance.mile[i]<-round(temp$miles,2)
}
  
  
  

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





##################################################################################################################################################################
##################################################################################################################################################################
# Mapping Part:
LasVegas<-leaflet()%>% addTiles()%>% #addProviderTiles("CartoDB.Positron")%>%
  fitBounds(lat1=36.337530 ,lng1=-115.390434,lat2=36.097106,lng2=-114.980507)%>%
  addPolylines(data=vegas,weight=2,color='black',opacity=1,group = '<font color="#000000" size=4><u>Las Vegas City</u></font>')%>%
  
  # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  locations of interest 
  addMarkers(data=callCenters,lng = callCenters$lon,lat=callCenters$lat,
             icon=local1,
             popup=paste0(
               '<b>Location:',callCenters$name,"<br>",
               callCenters$address,"<br>",
               '<font color="#FF0000">Annual Cost per Sqft: ',callCenters$Cost,"</font></b><br>",
               callcenterImages
             ),
             group = '<font color="#1E43A8" size=4><u>Possible Call Center Locations</u></font>')%>%
  
  addPulseMarkers(lng=Wynn$lon,lat=Wynn$lat,icon=makePulseIcon(heartbeat = 0.8,iconSize = 40),
                  group ='<font color="#cc0000" size=4><u>Wynn Hotel</u></font> <b>(Red-Pulse Markers) with driving distance to call centers</b>')%>%
  # addPopups(
  #   data=callCenters,lng = callCenters$lon,lat=callCenters$lat,popup=paste0(
  #     'Location Name:',callCenters$name,"<br>",
  #     'Annual Cost per Sqft:',callCenters$annual.cost.per.sf,"<br>",
  #     callcenterImages
  #   ),
  #   group = '<font color="#1E43A8" size=4><u>Possible Call Center Locations</u></font>',
  #   options = popupOptions(closeButton = TRUE)
  # )%>%


# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  locations of interest 

addPolygons(data=vegas,fillOpacity = 0.5,stroke=FALSE,group = '<font color="#cc0000" size=4><u>Labor Market Demographics </u></font>(<b>Population Density,age 18-62</b>)',
            color=~pal(Labor_SQMI),
            popup = paste0(
              "Zip Code: ",vegas$ZCTA5CE10, "<br>",
              "Zip Code Area: ",vegas$ALAND_SQMI, "   SqMile<br>",
              "Median Household Income: $",vegas$MedianInco,"<br>",
              "General Population: ",vegas$Population,'<br>',
              "<b>Labor Population Density: ",round(vegas$Labor_SQMI,0)," per SQMI</b>"
            )) %>%
  addMarkers(lng=college$lon,lat=college$lat,icon = school,popup = college$Name,group = '<font color="#cc0000" size=4><u>Labor Market Demographics </u></font>(<b>COLLEGE</b>)'
  )%>%
  
  addPolygons(data=vegas,fillOpacity = 0.5,stroke=FALSE,group = '<font color="#08519C" size=4><u>Local Household Income</u></font>',
              color=~pal2(MedianInco),
              popup = paste0(
                "Zip Code: ",vegas$ZCTA5CE10, "<br>",
                "Zip Code Area: ",vegas$ALAND_SQMI, "   SqMile<br>",
                "<b>Median Household Income: $",vegas$MedianInco,"<br></b>",
                "General Population: ",vegas$Population,'<br>',
                "Labor Population Density: ",round(vegas$Labor_SQMI,0)," per SQMI"
              )) %>%
  
  # addPopups(lng=college[college$Size500More=='YES',]$lon,lat=college[college$Size500More=='YES',]$lat,
  #           popup =paste('<font color="#cc0000"size=2><b>',college[college$Size500More=='YES',]$Name,'</b></u></font>'),
  #           options = popupOptions(closeButton = TRUE),
  #           group = '<font color="#cc0000" size=4><u>Labor Market Demographics </u></font>(<b>COLLEGE</b>)'
  # )%>%
  
  
  addMeasure(position = 'bottomright',completedColor = "#000000",activeColor = '#FF0000')%>%
  addKML(kml,color = 'black',weight = 4,opacity = 1,fill = FALSE,markerType = 'circleMarker',group ='<font color="#000000" size=4><u>Las Vegas Strip</u></font>')%>%
  hideGroup(c(
    '<font color="#08519C" size=4><u>Local Household Income</u></font>',
    '<font color="#cc0000" size=4><u>Labor Market Demographics </u></font>(<b>COLLEGE</b>)',
    '<font color="#000000" size=4><u>Las Vegas Strip</u></font>',
    '<font color="#cc0000" size=4><u>Wynn Hotel</u></font> <b>(Red-Pulse Markers) with driving distance to call centers</b>'
  ))%>%
  addLayersControl(overlayGroups =  c('<font color="#000000" size=4><u>Las Vegas City</u></font>',
                                      '<font color="#1E43A8" size=4><u>Possible Call Center Locations</u></font>',
                                      '<font color="#08519C" size=4><u>Local Household Income</u></font>',
                                      '<font color="#cc0000" size=4><u>Labor Market Demographics </u></font>(<b>Population Density,age 18-62</b>)',
                                      '<font color="#cc0000" size=4><u>Labor Market Demographics </u></font>(<b>COLLEGE</b>)',
                                      '<font color="#000000" size=4><u>Las Vegas Strip</u></font>',
                                      '<font color="#cc0000" size=4><u>Wynn Hotel</u></font> <b>(Red-Pulse Markers) with driving distance to call centers</b>'
                                      
                                      #'<font color="#008000" size=2><u>NYC Agencies Office Location</u></font>',
  ),
  options=layersControlOptions(collapsed = FALSE, autoZIndex = FALSE))%>%
  addLegend(colors="#FFFFFF",labels='',position = 'topleft',
            title = HTML('<font color="#000000" size=6><b>City of Las Vegas</b></font>'))%>%
  addLegend(layerId = 'unique',pal =pal,values=vegas$Labor_SQMI,na.label = 'No Available',
            title = HTML('<font color="#FF3371" size=2><b>Labor Density (Count / Square Mile)</b></font>'))%>%
  addLegend(layerId = 'income',pal =pal2,values=vegas$MedianInco,na.label = 'No Available',
            title = HTML('<font color="#FF3371" size=2><b>Household Income( $ )</b></font>'))%>%
  addControl(html = "<img src='https://raw.githubusercontent.com/jz1584/Map/master/las%20vegas.JPG' style='width:337px;height:150px;'>",
             position = 'bottomleft')








LV<-LasVegas

for(i in unique(netdist$ID)){
  LV<- addPolylines(LV, data = netdist[netdist$ID == i,],
                    lat = ~lat, lng = ~lon,group ='<font color="#cc0000" size=4><u>Wynn Hotel</u></font> <b>(Red-Pulse Markers) with driving distance to call centers</b>',
                    weight=2,color='blue',opacity=1)
}


LV%>%addPopups(lng=callCenters$lon,lat=callCenters$lat,
               popup =paste('<font color="#cc0000"size=2><b>',callCenters$Wynn.distance.Mins,' mins</b></u></font>'),
               options = popupOptions(closeButton = TRUE),
               group = '<font color="#cc0000" size=4><u>Wynn Hotel</u></font> <b>(Red-Pulse Markers) with driving distance to call centers</b>'
)















