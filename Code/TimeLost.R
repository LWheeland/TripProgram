### Time lost
categories <- c("Mechanical Issues", "Weather", "Other")

mech <- 3 #enter the number of hours lost to "MEchanical Issues"
weather <- 5 #enter the number of hours lost to "Weather"
other <- 19 #enter the number of hours lost to "other" causes

time <- c(mech, weather, other)

time_lost <- data.frame(cbind(categories, time))

hourslost <- sum(as.numeric(as.character(time_lost$time)))
