
#specify directory name.  Change as necessary.

library(foreign)  #this allows reading of dbf files
library(scales)
library(tidyverse)

##############################
#  read in species codes     #
##############################

spp_codes <- read_csv("C:/Users/wheelandl/Documents/species codes (lookup).csv")
spp_codes$code <- as.numeric(spp_codes$Spc_Code)

##############################
#  read in FFS data dbf      #
##############################

RV.SET=read.dbf("C:/Users/wheelandl/Documents/multispecies surveys/trip summary/TEL190/RV_SET.dbf")
RV.Catch=read.dbf("C:/Users/wheelandl/Documents/multispecies surveys/trip summary/TEL190/RV_CATCH.dbf")

############################
# match spp names to codes #
############################

RV.Catch <- left_join(RV.Catch, spp_codes, by=c("SPECIES" = "code"))


top15spp <- RV.Catch %>% 
  group_by(SPECIES) %>% 
  summarize(weight=sum(WEIGHTC)) %>% 
  top_n(15) %>% 
  ggplot +
  geom_col(aes(x=reorder(as.factor(SPECIES), -weight), y=weight))+
  scale_y_continuous(expand=c(0,0), limits=c(0,1500))+
  ylab("Total catch weight (kg)")+
  xlab("Species")+
  theme(axis.text=element_text(size=10),
        axis.title=element_text(size=12),
        plot.title = element_text(hjust = 0.5,size=14),
        axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0)),
        axis.title.x = element_text(margin = margin(t = 10, r = 20, b = 0, l = 0)),
        plot.margin=unit(c(0.25,1,0.5,0.25),"cm"),
        panel.border = element_rect(colour = "black", fill=NA, size=0.75))

ggsave(filename="TEL190_top15catch_weight.tiff", plot=top10spp, dpi=300, width=7, height=5, units=c("in"))



###############################################################################
###############################################################################
RV.SET %>% 
  group_by(depth.bin) %>% 
  summarize(mean.temp=mean(FISH_TEMP, na.rm=T))

temp <- RV.SET %>% 
  ggplot()+
  geom_point(aes(y=MEAN_DEPTH, x=FISH_TEMP), size=2)+
  scale_y_reverse()+
  ylab("Depth (m)")+
  xlab("Temperature (°C)")+
  theme(axis.text=element_text(size=10),
        axis.title=element_text(size=12),
        plot.title = element_text(hjust = 0.5,size=14),
        axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0)),
        axis.title.x = element_text(margin = margin(t = 10, r = 20, b = 0, l = 0)),
        plot.margin=unit(c(0.25,1,0.5,0.25),"cm"),
        panel.border = element_rect(colour = "black", fill=NA, size=0.75))

  
ggsave(filename="TEL190_temp_by_fishingdepth.tiff", plot=temp, dpi=300, width=5, height=6, units=c("in"))

###############################################################################
###############################################################################


