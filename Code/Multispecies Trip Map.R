packages <- c("ggmap", "rgdal", "rgeos", "maptools", "dplyr", "tidyr","sf","maps","plyr","wesanderson")
package.check <- lapply(packages, FUN = function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x, dependencies = TRUE)
    library(x, character.only = TRUE)
  }
})

pal <- wes_palette("Zissou1", 50, type = "continuous")

newfoundland_sp<-st_read("NL_shapefile/NL.shp")

strata<-st_read("DFO Strata Files/2HJ3KLNOP_Strata_Polygons_WGS84.shp")

strata_new<-strata[strata$DIV%in%div,]#filters for the desired NAFO Divs

# EEZ<-st_read("C:/Users/rogersb/Desktop/EEZ/EEZ.shp")
# SPM<-st_read("C:/Users/rogersb/Desktop/EEZ/SPM/eez_8494.shp")
NAFO_div<-st_read("Divisions/Divisions.shp")
NAFO_div<-NAFO_div[NAFO_div$ZONE%in%div,]

# strata_new<-st_transform(strata_new,"+proj=utm +zone=21 +ellps=GRS80 +datum=NAD83 +units=m +no_defs")
# NAFO_div<-st_transform(NAFO_div,"+proj=utm +zone=21 +ellps=GRS80 +datum=NAD83 +units=m +no_defs")
# newfoundland_sp<-st_transform(newfoundland_sp,"+proj=utm +zone=21 +ellps=GRS80 +datum=NAD83 +units=m +no_defs")
# EEZ<-st_transform(EEZ,"+proj=utm +zone=21 +ellps=GRS80 +datum=NAD83 +units=m +no_defs")
# SPM<-st_transform(SPM,"+proj=utm +zone=21 +ellps=GRS80 +datum=NAD83 +units=m +no_defs")

# RV.SET$LAT_START<-
  as.numeric(substr(RV.SET$LAT_START,1,2))+as.numeric(substr(RV.SET$LAT_START,3,6))/60

head(RV.SET)
RV.SET.trim<-RV.SET%>%
  select(SET,LAT_START,LONG_START,LAT_END,LONG_END)
RV_f<-data.frame(SET=RV.SET.trim$SET,apply(RV.SET.trim[,-1],2,function(x){
  res<-as.numeric(substr(x,1,2))+as.numeric(substr(x,3,6))/60
}))
RV_f <- RV_f%>%
  mutate(LONG_START=0-LONG_START)%>%
  mutate(LONG_END=0-LONG_END)

RV_sp<-  SpatialPointsDataFrame(coords = RV_f[,c("LAT_START","LONG_START","LAT_END","LONG_END")], data = RV_f,
                                proj4string = CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))

# RV_sp<-st_transform(RV_sp,"+proj=utm +zone=21 +ellps=GRS80 +datum=NAD83 +units=m +no_defs")

colnames(strata_new)[3]<-"strat"

 ggplot()+
    theme_classic()+
    geom_sf(data=strata_new)+#Empty Strata plotting
    annotate("text",RV_sp$LONG_START,RV_sp$LAT_START,label=RV_sp$SET,hjust=-.5)+
    geom_point(aes(LONG_START,LAT_START),RV_f)+
    geom_path(aes(LONG_START,LAT_START),RV_f,lwd=1)+
    geom_sf(data=(NAFO_div), colour="black", fill=NA, lwd=1)+#Add NAFO lines
    geom_sf(data=fortify(newfoundland_sp),fill="burlywood3")+#Add NL
    theme(panel.grid.major=element_line(colour="transparent"))+
    theme(plot.title = element_text(size=12,hjust = 0.5),
          plot.subtitle = element_text(size=12,hjust = 0.5))+
    coord_sf(xlim = c(st_bbox(strata_new)[1],st_bbox(strata_new)[3]),ylim = c(st_bbox(strata_new)[2],st_bbox(strata_new)[4]))
