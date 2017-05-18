#Testing The data
library(readr)

kml<-read_file('Las Vegas Strip.kml')
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
  vegas$MedianIncome,
  pretty = FALSE,
  bins=c(20000,40000,60000,80000,110000)#setting 1000 as maximum index, any number outside would be grayed out. 
)





leaflet()%>% addTiles()%>% #addProviderTiles("CartoDB.Positron")%>%
  fitBounds(lat1=36.337530 ,lng1=-115.390434,lat2=36.097106,lng2=-114.980507)%>%
  addPolylines(data=vegas,weight=2,color='blue',opacity=1,group = '<font color="#1E43A8" size=4><u>Las Vegas City</u></font>')%>%
  addPolygons(data=vegas,fillOpacity = 0.5,stroke=FALSE,group = '<font color="#cc0000" size=4><u>Labor Market Demographics </u></font>(<b>Population Density,age 18-62</b>)',
              color=~pal(Labor_SQMI),
              popup = paste0(
                "Zip Code: ",vegas$ZCTA5CE10, "<br>",
                "Zip Code Area: ",vegas$ALAND_SQMI, "   SqMile<br>",
                "Median Household Income: $",vegas$MedianIncome,"<br>",
                "Population: ",vegas$Population,'<br>',
                "<b>Population Density: ",round(vegas$Labor_SQMI,0)," per SQMI</b>"
              )) %>%
  addPolygons(data=vegas,fillOpacity = 0.5,stroke=FALSE,group = '<font color="#08519C" size=4><u>Local Household Income</u></font>',
              color=~pal2(MedianIncome),
              popup = paste0(
                "Zip Code: ",vegas$ZCTA5CE10, "<br>",
                "Zip Code Area: ",vegas$ALAND_SQMI, "   SqMile<br>",
                "Median Household Income: $",vegas$MedianIncome,"<br>",
                "Population: ",vegas$Population,'<br>',
                "<b>Population Density: ",round(vegas$Labor_SQMI,0)," per SQMI</b>"
              )) %>%
  
  addPopups(lng=college[college$Size500More=='YES',]$lon,lat=college[college$Size500More=='YES',]$lat,
            popup =paste('<font color="#cc0000"size=2><b>',college[college$Size500More=='YES',]$Name,'</b></u></font>'),
            options = popupOptions(closeButton = TRUE),
            group = '<font color="#cc0000" size=4><u>Labor Market Demographics </u></font>(<b>COLLEGE</b>)'
  )%>%
  addMarkers(lng=college$lon,lat=college$lat,popup = college$Name,group = '<font color="#cc0000" size=4><u>Labor Market Demographics </u></font>(<b>COLLEGE</b>)'
  )%>%
  
  addMeasure(position = 'bottomright',completedColor = "#000000",activeColor = '#FF0000')%>%
  addKML(kml,color = 'black',weight = 4,opacity = 1,fill = FALSE,markerType = 'marker',group ='<font color="#000000" size=4><u>Las Vegas Strip</u></font>')%>%
  hideGroup(c(
    '<font color="#08519C" size=4><u>Local Household Income</u></font>',
    '<font color="#cc0000" size=4><u>Labor Market Demographics </u></font>(<b>COLLEGE</b>)',
    '<font color="#000000" size=4><u>Las Vegas Strip</u></font>'
  ))%>%
  addLayersControl(overlayGroups =  c('<font color="#1E43A8" size=4><u>Las Vegas City</u></font>',
                                      '<font color="#08519C" size=4><u>Local Household Income</u></font>',
                                      '<font color="#cc0000" size=4><u>Labor Market Demographics </u></font>(<b>Population Density,age 18-62</b>)',
                                      '<font color="#cc0000" size=4><u>Labor Market Demographics </u></font>(<b>COLLEGE</b>)',
                                      '<font color="#000000" size=4><u>Las Vegas Strip</u></font>'
                                      
                                      #'<font color="#008000" size=2><u>NYC Agencies Office Location</u></font>',
  ),
  options=layersControlOptions(collapsed = FALSE, autoZIndex = FALSE))%>%
  addLegend(colors="#FFFFFF",labels='',position = 'topleft',
            title = HTML('<font color="#000000" size=10><b>City of Las Vegas</b></font>'))%>%
  addLegend(layerId = 'unique',pal =pal,values=vegas$Labor_SQMI,na.label = 'No Available',
            title = HTML('<font color="#FF3371" size=3><b>Labor Density (Age 18-62, Per Square Mile)</b></font>'))
            # labFormat = labelFormat('<b>',
            #                         suffix=c(' (Not affordable)',' (Less affordable)',' (Probably Affordable)',
            #                                  ' (More affordable)',' (Most affordable)')))












