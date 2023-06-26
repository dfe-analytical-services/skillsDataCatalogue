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
library(janitor)

# Tidy up data variables table
C_AllVar <- I_AllVar %>%
  rename(Source = X1, Table = Breakdown) %>%
  mutate(across(c(-Source, -Publication, -Table), ~ as.character(.))) %>% # get all as character
  pivot_longer(!c("Source", , "Publication", "Table"), names_to = "Variables", values_to = "count") %>% # make long
  filter(count == "x") %>% # just keep data
  select(-count) %>%
  mutate(Variables = str_to_sentence(gsub("_", " ", Variables)))%>% # Tidy variable names
  #add on all variables
  left_join(
  C_AllVar%>%
  group_by(Source, Publication, Table) %>%
  summarise(AllVariables = toString(Variables)) %>%
  ungroup())
write.csv(C_AllVar, file = "./Data/AppData/C_AllVar.csv", row.names = FALSE)

# Tidy up publications table
C_Pubs <- I_Pubs %>%
  janitor::row_to_names(2) %>%
  mutate(`Statistical Release` = paste0("<a href='", Link, "'>", `Statistical Release`, "</a>")) %>%
  select(-Link, -`Further Information`)
write.csv(C_Pubs, file = "./Data/AppData/C_Pubs.csv", row.names = FALSE)
