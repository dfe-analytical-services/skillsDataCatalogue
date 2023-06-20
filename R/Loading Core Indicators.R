# load app data
C_AllVar <- read.csv(file = "./Data/AppData/C_AllVar.csv", check.names = FALSE)
# convert to dataframe to make intercative filters work
C_AllVar <- as.data.frame(C_AllVar)

# load publication data
C_Pubs <- read.csv(file = "./Data/AppData/C_Pubs.csv", check.names = FALSE)
