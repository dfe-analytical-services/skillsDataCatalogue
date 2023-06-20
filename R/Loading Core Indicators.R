# load app data
C_AllVar <- read.csv(file = "./Data/AppData/C_AllVar.csv", check.names = FALSE)

#Turn all into factors so datatable filters are multiselect
# C_AllVar[sapply(C_AllVar, is.character)] <- lapply(C_AllVar[sapply(C_AllVar, is.character)], 
#                                        as.factor)

#convert to dataframe to make intercative filters work
C_AllVar = as.data.frame(C_AllVar)