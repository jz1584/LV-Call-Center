
leaflet()%>% addTiles()%>% #addProviderTiles("CartoDB.Positron")%>%
  fitBounds(lat1=36.337530 ,lng1=-115.390434,lat2=36.097106,lng2=-114.980507)%>%
  addPolylines(data=vegas,weight=2,color='blue',opacity=1,group = '<font color="#1E43A8" size=4><u>Las Vegas City</u></font>')%>%
  addPolygons(data=vegas,fillOpacity = 0.5,stroke=FALSE,group = '<font color="#cc0000" size=4><u>Labor Market Demographics </u></font>(<b>Population Density(age 18-62)</b>)',
              color=~pal(Labor_SQMI),
              popup = paste0(
                "Zip Code: ",vegas$ZCTA5CE10, "<br>",
                "Zip Code Area: ",vegas$ALAND_SQMI, "   SqMile<br>",
                "Median Household Income: $",vegas$MedianIncome,"<br>",
                "Population: ",vegas$Population,'<br>',
                "<b>Population Density: ",round(vegas$Labor_SQMI,0)," per SQMI</b>"
              )) %>%
  addPolygons(data=vegas,fillOpacity = 0.5,stroke=FALSE,group = '<font color="#cc0000" size=4><u>Local Household Income</u></font>',
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
            group = '<font color="#cc0000" size=4><u>Labor Market Demographics </u></font>(<b>College</b>)'
  )%>%
  addMarkers(lng=college$lon,lat=college$lat,popup = college$Name,group = '<font color="#cc0000" size=4><u>Labor Market Demographics </u></font>(<b>College</b>)'
  )%>%
  
  addMeasure(position = 'bottomright',completedColor = "#000000",activeColor = '#FF0000')%>%
  addKML(kml,color = 'black',weight = 4,opacity = 1,fill = FALSE,markerType = 'marker',group ='<font color="#000000" size=4><u>Las Vegas Strip</u></font>')%>%
  hideGroup(c(
    '<font color="#cc0000" size=4><u>Local Household Income</u></font>',
    '<font color="#cc0000" size=4><u>Labor Market Demographics </u></font>(<b>College</b>)',
    '<font color="#000000" size=4><u>Las Vegas Strip</u></font>'
  ))%>%
  addLayersControl(overlayGroups =  c('<font color="#1E43A8" size=4><u>Las Vegas City</u></font>',
                                      '<font color="#cc0000" size=4><u>Local Household Income</u></font>',
                                      '<font color="#cc0000" size=4><u>Labor Market Demographics </u></font>(<b>Population Density(age 18-62)</b>)',
                                      '<font color="#cc0000" size=4><u>Labor Market Demographics </u></font>(<b>College</b>)',
                                      '<font color="#000000" size=4><u>Las Vegas Strip</u></font>'
                                      
                                      #'<font color="#008000" size=2><u>NYC Agencies Office Location</u></font>',
  ),
  options=layersControlOptions(collapsed = FALSE, autoZIndex = FALSE))%>%
  addLegend(colors="#FFFFFF",labels='',position = 'topleft',
            title = HTML('<font color="#000000" size=10><b>City of Las Vegas</b></font>'))












