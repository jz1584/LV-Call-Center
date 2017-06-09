source('Global.R')



##################################################################################################################################################################
##################################################################################################################################################################
# Mapping Part:
LasVegas<-leaflet()%>% addTiles()%>% #addProviderTiles("CartoDB.Positron")%>%
  fitBounds(lat1=36.337530 ,lng1=-115.390434,lat2=36.097106,lng2=-114.980507)%>%
  setMaxBounds(lat1=36.406915,lng1=-115.477295,lat2=36.010228,lng2=-114.966431)%>%
  addPolylines(data=vegas,weight=2,color='black',opacity=1,group = '<font color="#000000" size=3><u><b>Las Vegas City</b></u></font>')%>%
  
  # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  locations of interest 
  addMarkers(data=callCenters,lng = callCenters$lon,lat=callCenters$lat,
             icon=local1,
             popup=paste0(
               '<b><font color="#FF0000">ID=',callCenters$ID,'</font>    --------',callCenters$name,"----------<br>",
               callCenters$address,"<br>",
               '<font color="#FF0000">Annual Cost per Sqft: ',callCenters$Cost,"</font></b><br>",
               '<b>Lease Cost Ranking: <font color="#FF0000" size=2>',callCenters$Cost.Rank,' out of ',nrow(callCenters),"</font></b><br>",
               '<b>Crime Risk Ranking: <font color="#FF0000" size=2>',callCenters$Safety.Rank,' out of ',nrow(callCenters),"</font></b><br>",
               callcenterImages
             ),
             label=paste(callCenters$ID),labelOptions=labelOptions(noHide=T,direction = 'left',
                                                                   style=list(
                                                                     'color'='red',
                                                                     'font-family'= 'serif',
                                                                     'font-style'= 'italic',
                                                                     'box-shadow' = '1px 1px rgba(0,0,0,0)',
                                                                     'font-size' = '16px',
                                                                     'border-color' = 'rgba(0,0,128,0.8)'
                                                                   )),
             group = '<font color="#1E43A8" size=3><u><b>Possible Call Center Locations</b></u></font>')%>%
  
  addPulseMarkers(lng=Wynn$lon,lat=Wynn$lat,icon=makePulseIcon(heartbeat = 0.8,iconSize = 40),
                  group ='<font color="#cc0000" size=3><u><b>Wynn Hotel</b></u></font> <b>(Red-Pulse Markers) with driving distance to call centers</b>')%>%
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

addPolygons(data=vegas,fillOpacity = 0.5,stroke=FALSE,group = '<font color="#cc0000" size=3><u><b>Crime Rate 2016</b></u></font>(<b>Theft, Burglary, Assault, Vandalism, Robbery</b>)',
            color=~pal.crime(Crime_SQMI),
            popup = paste0(
              "Zip Code: ",vegas$ZCTA5CE10, "<br>",
              "Zip Code Area: ",vegas$ALAND_SQMI, "   SqMile<br>",
              "Median Household Income: $",vegas$MedianInco,"<br>",
              "General Population: ",vegas$Population,'<br>',
              "Labor Population Density: ",round(vegas$Labor_SQMI,0)," per SQMI",'<br>',
              "<b>2016 Crime Rate: ",round(vegas$Crime_SQMI,0)," per SQMI</b>"
            )) %>%

addPolygons(data=vegas,fillOpacity = 0.5,stroke=FALSE,group = '<font color="#6327A3" size=3><u><b>Labor Market Demographics</b></u></font>(<b>Population Density,age 18-62</b>)',
            color=~pal(Labor_SQMI),
            popup = paste0(
              "Zip Code: ",vegas$ZCTA5CE10, "<br>",
              "Zip Code Area: ",vegas$ALAND_SQMI, "   SqMile<br>",
              "Median Household Income: $",vegas$MedianInco,"<br>",
              "General Population: ",vegas$Population,'<br>',
              "<b>Labor Population Density: ",round(vegas$Labor_SQMI,0)," per SQMI</b>"
            )) %>%
  addMarkers(lng=college$lon,lat=college$lat,icon = school,popup = college$Name,group = '<font color="#6327A3" size=3><u><b>Labor Market Demographics</b></u></font>(<b>COLLEGE</b>)'
  )%>%
  
  addPolygons(data=vegas,fillOpacity = 0.5,stroke=FALSE,group = '<font color="#08519C" size=4><u><b>Local Household Income</b></u></font>',
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
  
  addPolylines(data=neveda.road,popup = neveda.road$FULLNAME,color = 'red',opacity = 1,weight = 2,
               group='<font color="#cc0000" size=3><u><b>Major Highways</b></u></font>')%>%
  
  addMeasure(position = 'bottomright',completedColor = "#000000",activeColor = '#FF0000')%>%
  addKML(kml,color = 'black',weight = 4,opacity = 1,fill = FALSE,markerType = 'circleMarker',group ='<font color="#000000" size=3><u><b>Las Vegas Strip</b></u></font>')%>%
  hideGroup(c(
    '<font color="#08519C" size=4><u><b>Local Household Income</b></u></font>',
    '<font color="#6327A3" size=3><u><b>Labor Market Demographics</b></u></font>(<b>COLLEGE</b>)',
    '<font color="#000000" size=3><u><b>Las Vegas Strip</b></u></font>',
    '<font color="#cc0000" size=3><u><b>Wynn Hotel</b></u></font> <b>(Red-Pulse Markers) with driving distance to call centers</b>',
    '<font color="#cc0000" size=3><u><b>Crime Rate 2016</b></u></font>(<b>Theft, Burglary, Assault, Vandalism, Robbery</b>)',
    '<font color="#cc0000" size=3><u><b>Major Highways</b></u></font>'
  ))%>%
  addLayersControl(overlayGroups =  c('<font color="#000000" size=3><u><b>Las Vegas City</b></u></font>',
                                      '<font color="#1E43A8" size=3><u><b>Possible Call Center Locations</b></u></font>',
                                      
                                      '<font color="#6327A3" size=3><u><b>Labor Market Demographics</b></u></font>(<b>COLLEGE</b>)',
                                      '<font color="#000000" size=3><u><b>Las Vegas Strip</b></u></font>',
                                      '<font color="#cc0000" size=3><u><b>Wynn Hotel</b></u></font> <b>(Red-Pulse Markers) with driving distance to call centers</b>',
                                      '<font color="#cc0000" size=3><u><b>Major Highways</b></u></font>'
                                      
                                      #'<font color="#008000" size=2><u>NYC Agencies Office Location</u></font>',
  ),baseGroups = c(
    '<font color="#6327A3" size=3><u><b>Labor Market Demographics</b></u></font>(<b>Population Density,age 18-62</b>)',
    '<font color="#cc0000" size=3><u><b>Crime Rate 2016</b></u></font>(<b>Theft, Burglary, Assault, Vandalism, Robbery</b>)',
    '<font color="#08519C" size=4><u><b>Local Household Income</b></u></font>'
    
  ),
  options=layersControlOptions(collapsed = FALSE, autoZIndex = FALSE))%>%
  addLegend(colors="#FFFFFF",labels='',position = 'topleft',
            title = HTML('<font color="#000000" size=3><b>City of Las Vegas</b></font></a>'))%>%
  addLegend(layerId = 'unique',pal =pal,values=vegas$Labor_SQMI,na.label = 'No Available',
            title = HTML('<font color="#FF3371" size=2><b>Labor Density</b></font><font size=1>(Count/Square Mile)</font>'))%>%
  addLegend(layerId = 'income',pal =pal2,values=vegas$MedianInco,na.label = 'No Available',
            title = HTML('<font color="#FF3371" size=2><b>Household Income $</b></font>'))%>%
  addLegend(layerId = 'crime',pal =pal.crime,values=vegas$Crime_SQMI,na.label = 'No Available',
            title = HTML('<font color="#FF3371" size=2><b>Crime Rate</b></font><font size=1>(Count/Square Mile)</font>'))%>%
  addControl(html = "<img src='https://raw.githubusercontent.com/jz1584/Map/master/las%20vegas.PNG' style='width:337px;height:80px;'>",
             position = 'bottomleft')




LV<-LasVegas

for(i in unique(netdist$ID)){
  LV<- addPolylines(LV, data = netdist[netdist$ID == i,],
                    lat = ~lat, lng = ~lon,group ='<font color="#cc0000" size=3><u><b>Wynn Hotel</b></u></font> <b>(Red-Pulse Markers) with driving distance to call centers</b>',
                    weight=2,color='blue',opacity=1)
}

for(i in unique(netdist2$ID)){
  LV<- addPolylines(LV, data = netdist2[netdist2$ID == i,],
                    lat = ~lat, lng = ~lon,group ='<font color="#cc0000" size=3><u><b>Wynn Hotel</b></u></font> <b>(Red-Pulse Markers) with driving distance to call centers</b>',
                    weight=2,color='blue',opacity=1)
}


LV%>%addPopups(lng=callCenters$lon,lat=callCenters$lat,
               popup =paste('<font color="#cc0000"size=2><b>',callCenters$Wynn.distance.Mins,' mins</b></u></font>'),
               options = popupOptions(closeButton = TRUE),
               group = '<font color="#cc0000" size=3><u><b>Wynn Hotel</b></u></font> <b>(Red-Pulse Markers) with driving distance to call centers</b>'
)






####################################################################
#data saving
callCenters$DrivingTime<-paste(callCenters$Wynn.distance.Mins,'Mins')
dat.save<-callCenters[,c("ID","name","lease.type","Cost","Area","MeanCost","Crime_SQMI","Labor_SQMI","DrivingTime","Cost.Rank","Safety.Rank","LaborForce.Rank","travel.Rank","parking.ratio","address")]
names(dat.save)[names(dat.save)=='Cost']<-'Cost.per.sqft'
write.csv(dat.save,'cleaned data/real estate/OfficeProperties.csv',row.names = FALSE)




