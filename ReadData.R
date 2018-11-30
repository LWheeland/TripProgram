library(tidyverse)
library(knitr)
library(kableExtra)
library(foreign)

#  read in species codes     
spp_codes <- read_csv("species codes (lookup).csv")
spp_codes$code <- as.numeric(spp_codes$Spc_Code)

#  read in FFS data dbf      
RV.SET <- read.dbf("Data/RV_SET.dbf")
RV.Catch <- read.dbf("Data/RV_CATCH.dbf")

# match spp names to codes 
RV.Catch <- left_join(RV.Catch, spp_codes, by=c("SPECIES" = "code"))

