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


#############################
### Labor Market Demographics
#############################
# Labor Force
labor<-read.csv('raw data/population ACS15/laborForce.csv')
labor$Year18_Year62<-labor$Estimate..SEX.AND.AGE...18.years.and.over-labor$Estimate..SEX.AND.AGE...62.years.and.over
labor<-labor[,c("Id2",'Year18_Year62')]

# Colleges
college<-read.csv('raw data/college/CollegeNavigator_Search_2017-05-18_11.08.17.csv')
library(ggmap)
college$lon<-NA
college$lat<-NA
for (i in 1:nrow(college)){
  found<-geocode(as.character(college$Address[i]))
  college$lon[i]<-found$lon
  college$lat[i]<-found$lat
}

college$Size500More<-'NO'
college$Size500More[college$Student.population>500]<-'YES'

###
# MERGING
###
vegas@data$order<-1:nrow(vegas@data)
vegas@data<-merge(vegas@data,population,all.x=TRUE,by.x='ZCTA5CE10',by.y='ZIP')
vegas@data<-vegas@data[order(vegas@data$order),]# back to original order 
vegas@data<-merge(vegas@data,income,all.x=TRUE,by.x='ZCTA5CE10',by.y='ZIP')
vegas@data<-vegas@data[order(vegas@data$order),]# back to original order 
vegas@data<-merge(vegas@data,labor,all.x=TRUE,by.x='ZCTA5CE10',by.y='Id2')
vegas@data<-vegas@data[order(vegas@data$order),]# back to original order 


#Desity estimation
vegas$ALAND_SQMI<-round(vegas$ALAND10*0.0000003861022,5)#corrected to the more accurate version
vegas$PopDen_SQMI<-vegas$Population/vegas$ALAND_SQMI #population density: per sql mile #2015
vegas$Labor_SQMI<-vegas$Year18_Year62/vegas$ALAND_SQMI #labor force: per sql mile #2015




#saving the dataset
writePolyShape(vegas,'cleaned data/shapefile/vegas')







