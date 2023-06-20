####
# Title: Variable database transform
# Author: Paul James
# Date: 16/6/23
# Last updated: 
# Use: Transforms/format the raw excel into the dataframes used in the dashboard.
# The dataframes are then saved as .csv in ./Data/AppData to be read by the dashboard app.
# Sources: The files created by running ExtractLoadData.R
# Running time: ~0mins
###

# Load libraries ----
library(dplyr)
library(tidyr)
library(stringr)

# Tidy up data text table
C_AllVar<-I_AllVar%>%
  rename(Source=X1,Table=Breakdown)%>%
  mutate(across(c(-Source,-Publication,-Table), ~as.character(.)))%>%#get all as character
  pivot_longer(!c("Source",,"Publication","Table"), names_to = "Variables", values_to = "count")%>%#make long
  filter(count=="x")%>%#just keep data
  select(-count)%>%
  mutate(Variables=str_to_sentence(gsub("_"," ",Variables)))#Tidy variable names
write.csv(C_AllVar, file = "./R/skillsDataCatalogue/Data/AppData/C_AllVar.csv", row.names = FALSE)

