crime<-read.csv('raw data/crime data/2016HomicideLog_FINAL.csv')
crime$Location.of.Discovery<-as.character(crime$Location.of.Discovery)


crime$location<-paste(crime$Location.of.Discovery,', las vegas, NV')

crime$location<-gsub('&','and',crime$location)
crime<-crime[crime$A.C!='',]

crime$lon<-NA
crime$lat<-NA


for (i in 1:nrow(crime)){
  
  temp<-geocode(crime$location[i])
  crime$lon[i]<-temp$lon
  crime$lat[i]<-temp$lat
  
}





leaflet()%>% addTiles()%>% addCircles(lng=crime$lon,lat=crime$lat,color = 'red')
