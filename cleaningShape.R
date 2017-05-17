#####################################################################################################
#@@@@---->shapefile cleaning####
library(rjson)
library(rgdal)
library(proj4)
library(raster)
library(maptools)
library(leaflet)
library(leaflet.extras)
#https://www.census.gov/geo/maps-data/data/tiger-line.html

#original zip file -usa ziplevel####
us<-readOGR('raw data/rawShape/','tl_2016_us_zcta510',verbose = FALSE)

zipCounty<-read.csv('raw data/County-Zip Relationship/zcta_county_rel_10.csv')
clarkZip<-zipCounty[zipCounty$COUNTY==3 & zipCounty$STATE==32,]

#filtering
clark<-us[as.integer(as.character(us$ZCTA5CE10))%in%clarkZip$ZCTA5,]
clark<-spTransform(clark,CRS("+proj=longlat +datum=WGS84")) #change to lon & lat coordination system

#Las Vegas zipcode:
vegasZip<-c(88901,89104,89109,89128,89133,89138,89146,89152,89157,89163,
         88905,89106,89110,89125,89129,89134,89143,89147,89153,89158,89164,
         89101,89107,89116,89126,89130,89136,89144,89149,89154,
         89102,89108,89117,89127,89131,89137,89145,89151,89155,89162,89185)

#,89124,89166,89161

# keep vegas only:
vegas<-clark[as.integer(as.character(clark$ZCTA5CE10))%in%vegasZip,]

# population data:
population<-read.csv('raw data/population ACS15/cleaned.csv')
# income data 
income<-read.csv('raw data/Income Data/cleaned.csv')


###
# MERGING
###
vegas@data$order<-1:nrow(vegas@data)
vegas@data<-merge(vegas@data,population,all.x=TRUE,by.x='ZCTA5CE10',by.y='ZIP')
vegas@data<-vegas@data[order(vegas@data$order),]# back to original order 
vegas@data<-merge(vegas@data,income,all.x=TRUE,by.x='ZCTA5CE10',by.y='ZIP')
vegas@data<-vegas@data[order(vegas@data$order),]# back to original order 

#Desity estimation
vegas$ALAND_SQMI<-round(vegas$ALAND10*0.0000003861022,5)#corrected to the more accurate version
vegas$PopDen_SQMI<-vegas$Population/vegas$ALAND_SQMI #population density: per sql mile #2015


#Testing The data
library(readr)

kml<-read_file('Las Vegas Strip.kml')
clrs <- RColorBrewer::brewer.pal(5, "YlOrRd")
pal<-colorBin(
  palette = clrs,
  vegas$PopDen_SQMI,
  pretty = FALSE,
  bins=c(1000,3000,5000,7000,9000,10000)#setting 1000 as maximum index, any number outside would be grayed out. 
)

pal2<-colorBin(
  palette = clrs,
  vegas$MedianIncome,
  pretty = FALSE,
  bins=c(20000,40000,60000,80000,110000)#setting 1000 as maximum index, any number outside would be grayed out. 
)



leaflet()%>% addTiles()%>% #addProviderTiles("CartoDB.Positron")%>%
  fitBounds(lat1=36.337530 ,lng1=-115.390434,lat2=36.097106,lng2=-114.980507)%>%
  addPolylines(data=vegas,weight=2,color='blue',opacity=1,group = '<font color="#1E43A8" size=4><u>Las Vegas City</u></font>')%>%
  addPolygons(data=vegas,fillOpacity = 0.5,stroke=FALSE,group = '<font color="#cc0000" size=4><u>Population Density</u></font>',
              color=~pal(PopDen_SQMI),
              popup = paste0(
                "Zip Code: ",vegas$ZCTA5CE10, "<br>",
                "Zip Code Area: ",vegas$ALAND_SQMI, "   SqMile<br>",
                "Median Household Income: $",vegas$MedianIncome,"<br>",
                "Population: ",vegas$Population,'<br>',
                "<b>Population Density: ",round(vegas$PopDen_SQMI,0)," per SQMI</b>"
              )) %>%
  addPolygons(data=vegas,fillOpacity = 0.5,stroke=FALSE,group = '<font color="#cc0000" size=4><u>Local Household Income</u></font>',
              color=~pal2(MedianIncome),
              popup = paste0(
                "Zip Code: ",vegas$ZCTA5CE10, "<br>",
                "Zip Code Area: ",vegas$ALAND_SQMI, "   SqMile<br>",
                "Median Household Income: $",vegas$MedianIncome,"<br>",
                "Population: ",vegas$Population,'<br>',
                "<b>Population Density: ",round(vegas$PopDen_SQMI,0)," per SQMI</b>"
              )) %>%
  addMeasure(position = 'bottomright',completedColor = "#000000",activeColor = '#FF0000')%>%
  addKML(kml,color = 'black',weight = 4,opacity = 1,fill = FALSE,markerType = 'marker',group ='<font color="#000000" size=4><u>Las Vegas Strip</u></font>')%>%
  hideGroup(c(
    '<font color="#cc0000" size=4><u>Local Household Income</u></font>',
    '<font color="#cc0000" size=4><u>Population Density</u></font>',
    '<font color="#000000" size=4><u>Las Vegas Strip</u></font>'
  ))%>%
  addLayersControl(overlayGroups =  c('<font color="#1E43A8" size=4><u>Las Vegas City</u></font>',
                                      '<font color="#cc0000" size=4><u>Local Household Income</u></font>',
                                      '<font color="#cc0000" size=4><u>Population Density</u></font>',
                                      '<font color="#000000" size=4><u>Las Vegas Strip</u></font>'
                                      
                                      #'<font color="#008000" size=2><u>NYC Agencies Office Location</u></font>',
  ),
  options=layersControlOptions(collapsed = FALSE, autoZIndex = FALSE))












