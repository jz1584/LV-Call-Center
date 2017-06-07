
library(ggmap)


#######################
# Colleges:
#######################
college<-read.csv('raw data/college/CollegeNavigator_Search_2017-05-18_11.08.17.csv')
college$lon<-NA
college$lat<-NA
for (i in 1:nrow(college)){
  found<-geocode(as.character(college$Address[i]))
  college$lon[i]<-found$lon
  college$lat[i]<-found$lat
}

college$Size500More<-'NO'
college$Size500More[college$Student.population>500]<-'YES'
dput(college,'cleaned data/colleges/college')




#######################
#call center locations: part I
#######################
callCenters<-read.csv('raw data/target properties/Properties info.csv')

callCenters$lon<-NA
callCenters$lat<-NA
for (i in 1:nrow(callCenters)){
  found<-geocode(as.character(callCenters$address[i]))
  callCenters$lon[i]<-found$lon
  callCenters$lat[i]<-found$lat
}

callCenters$Cost<-NA
callCenters[is.na(callCenters$annualCost.Max),]$Cost<-paste('$',callCenters[is.na(callCenters$annualCost.Max),]$annual.cost.per.sf)
callCenters[!is.na(callCenters$annualCost.Max),]$Cost<-paste('$',callCenters[!is.na(callCenters$annualCost.Max),]$annual.cost.per.sf,'-','$',callCenters[!is.na(callCenters$annualCost.Max),]$annualCost.Max)
callCenters$MeanCost<-rowMeans(callCenters[,c('annual.cost.per.sf','annualCost.Max')],na.rm = TRUE)


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


#available area
callCenters$Area<-NA
callCenters[is.na(callCenters$areaMax),]$Area<-paste(callCenters[is.na(callCenters$areaMax),]$area,'sqft')
callCenters[!is.na(callCenters$areaMax),]$Area<-paste('(',callCenters[!is.na(callCenters$areaMax),]$area,'-',callCenters[!is.na(callCenters$areaMax),]$areaMax,') sqft')



callCenters$Cost.Rank<-NA
callCenters$Cost.Rank[order(callCenters$MeanCost)]<-1:nrow(callCenters)

dput(callCenters,'cleaned data/callCenters')
dput(netdist,'cleaned data/netdist')




#######################
#call center locations: part II, from Carole, 6.6.17
#######################
callCenters2<-read.csv('raw data/target properties/Properties info-partII.csv')
callCenters2<-callCenters2[!is.na(callCenters2$area),]


callCenters2$lon<-NA
callCenters2$lat<-NA
for (i in 1:nrow(callCenters2)){
  found<-geocode(as.character(callCenters2$address[i]))
  callCenters2$lon[i]<-found$lon
  callCenters2$lat[i]<-found$lat
}

callCenters2$Cost<-NA
callCenters2[is.na(callCenters2$annualCost.Max),]$Cost<-paste('$',callCenters2[is.na(callCenters2$annualCost.Max),]$annual.cost.per.sf)
callCenters2[!is.na(callCenters2$annualCost.Max),]$Cost<-paste('$',callCenters2[!is.na(callCenters2$annualCost.Max),]$annual.cost.per.sf,'-','$',callCenters2[!is.na(callCenters2$annualCost.Max),]$annualCost.Max)
callCenters2$MeanCost<-rowMeans(callCenters2[,c('annual.cost.per.sf','annualCost.Max')],na.rm = TRUE)


#distance labeling
netdist2<-callCenters2
netdist2$ID<-c(1:6,8:11)
Wynn<-geocode('3131 S Las Vegas Blvd, Las Vegas, NV 89109')
netdist2$name<-as.character(netdist2$name)
#netdist2[(nrow(netdist2)+1):(nrow(netdist2)*2),]<-NA #create empty rows
netdist2[(nrow(netdist2)+1):(nrow(netdist2)*2),]$name<-'Wynn Hotel'
netdist2[11:20,c("lon","lat")]<-Wynn
netdist2[11:20,c('ID')]<-c(1:6,8:11)


callCenters2$Wynn.distance.Mins<-NA
callCenters2$Wynn.distance.mile<-NA
for (i in 1:nrow(callCenters2)){
  temp<-mapdist(as.numeric(Wynn),as.numeric(callCenters2[i,c("lon","lat")]),mode = 'driving')
  callCenters2$Wynn.distance.Mins[i]<-round(temp$minutes,2)
  callCenters2$Wynn.distance.mile[i]<-round(temp$miles,2)
}


#available area
callCenters2$Area<-NA
callCenters2[is.na(callCenters2$areaMax),]$Area<-paste(callCenters2[is.na(callCenters2$areaMax),]$area,'sqft')
callCenters2[!is.na(callCenters2$areaMax),]$Area<-paste('(',callCenters2[!is.na(callCenters2$areaMax),]$area,'-',callCenters2[!is.na(callCenters2$areaMax),]$areaMax,') sqft')



callCenters2$Cost.Rank<-NA
callCenters2$Cost.Rank[order(callCenters2$MeanCost)]<-1:nrow(callCenters2)

dput(callCenters2,'cleaned data/callCenters2')
dput(netdist2,'cleaned data/netdist2')















