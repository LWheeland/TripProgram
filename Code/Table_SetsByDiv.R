# MAKE A TABLE
RV.SET$set <- ifelse(RV.SET$DAMAGE==1, "successful", "unsuccessful")

num_sets <- RV.SET %>% 
  group_by(NAFO_DIV) %>% 
  group_by(set, add=T) %>% 
  summarize(N_sets=n())

kable(num_sets, format = "markdown")
