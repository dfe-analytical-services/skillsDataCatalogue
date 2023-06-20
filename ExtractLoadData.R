####
# Title: All skills variable import
# Author: Paul James
# Date: 15th Jun 2022
# Last updated: 
# Aim: Loads the listed variables
# Use: To update any datasets, delete the relevant file within the relevant folder, and paste in the new data file. 

# Load libraries ----
library(openxlsx) # use read.xlsx, read.csv

# 1.Variables ----
## 1.1 Load all variales list ----
sheetNum <- "AllVar"
I_AllVar <- read.xlsx(xlsxFile = "R/skillsDataCatalogue/Data/SkillsDataUFS.xlsx", sheet = sheetNum, skipEmptyRows = T)
