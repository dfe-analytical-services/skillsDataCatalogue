####
# Title: Variable database transform
# Author: Paul James
# Date: 16/6/23
# Last updated:
# Use: Transforms/format the raw excel into the dataframes used in the dashboard.
# The dataframes are then saved as .csv in ./Data/AppData to be read by the dashboard app.
# Themes: The files created by running ExtractLoadData.R
# Running time: ~0mins
###

# Load libraries ----
library(dplyr)
library(tidyr)
library(stringr)
library(janitor)

# Tidy up data variables table
C_AllVarPt1 <- I_AllVar %>%
  row_to_names(row_number = 2) %>%
  rename(Table = Breakdown) %>%
  #publication link
  mutate(`Publication name` = Publication) %>%
  mutate(Publication = paste0("<a href='", Link, "'>", Publication, "</a>")) %>% # get url
  select(-Link) %>%
  #table link
  mutate(`Table name` = Table) %>%
  mutate(Table = paste0("<a href='", TableLink, "'>", Table, "</a>")) %>% # get url
  select(-TableLink) %>%
  
  mutate(across(c(-Theme, -Publication, -`Publication name`, -Table), ~ as.character(.))) %>% # get all as character
  pivot_longer(!c("Theme", "Publication name", "Publication", "Table"), names_to = "Variables", values_to = "count") %>% # make long
  filter(count == "x") %>% # just keep data
  select(-count) %>%
  mutate(Variables = str_to_sentence(gsub("_", " ", Variables))) # Tidy variable names
# add on all variables
C_AllVar <- C_AllVarPt1 %>%
  left_join(C_AllVarPt1 %>%
    group_by(Theme, Publication, `Publication name`, Table) %>%
    summarise(AllVariables = toString(Variables)))%>%
#add on attribute type
left_join(I_AllVarName%>%
            mutate(Variable.description = str_to_sentence(gsub("_", " ", Variable.description)))%>% # Tidy variable names
            #multiple versions of variables so pick the top (they are repeeated anyway) to avoid n to many
            group_by(Variable.description)%>%slice_head(n = 1)%>%
            select(Variable.description,Metric.or.Attribute)
          , by = join_by(Variables==Variable.description))
write.csv(C_AllVar, file = "./Data/AppData/C_AllVar.csv", row.names = FALSE)

# Tidy up publications table
C_Pubs <- I_Pubs %>%
  janitor::row_to_names(2) %>%
  mutate(`Statistical Release` = paste0("<a href='", Link, "'>", `Statistical Release`, "</a>")) %>%
  select(-Link, -`Further Information`)
write.csv(C_Pubs, file = "./Data/AppData/C_Pubs.csv", row.names = FALSE)
