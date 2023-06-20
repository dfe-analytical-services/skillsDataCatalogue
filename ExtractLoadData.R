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
## 1.1 Load all variables list ----
sheetNum <- "AllVar"
I_AllVar <- read.xlsx(xlsxFile = "./Data/SkillsDataUFS.xlsm", sheet = sheetNum, skipEmptyRows = T)

## 1.1 Load all variables list ----
sheetNum <- "List of publications"
I_Pubs <- read.xlsx(xlsxFile = "./Data/SkillsDataUFS.xlsm", sheet = sheetNum, skipEmptyRows = T)
