# Listing 1
# load data and display box plots to compare distributions

# add a label to a dataframe
labelData<-function(dataIn,label){
	namesIn = names(dataIn)
	dataOut = data.frame(dataIn,rep(label,nrow(dataIn)))
	names(dataOut) = c(namesIn,"DATASET")
	row.names(dataIn) = as.character(row.names(dataIn))
	dataOut
}

# display a boxplot and provide a table with boxplot statistics
summaryTable<-function(dataIn){
	bp = boxplot(LOGS~DATASET,dataIn,ylab="LogS")
	bpStats = bp$stats
	bpStats = rbind(bpStats,abs(bpStats[2,]-bpStats[4,]),abs(bpStats[1,]-bpStats[5,]))
	bpStats = data.frame(bpStats)
	names(bpStats) = levels(dataIn$DATASET)
	row.names(bpStats) = c("LOWER WHISKER","LOWER HINGE","MEDIAN","UPPER HINGE","UPPER WHISKER","IQR","RANGE")
	t(round(bpStats,digits=2))
}

# load the solubility data
hus = read.table("huuskonen.sol",header=T,row.names=1)
jcim_train = read.table("jcim_train.sol",header=T,row.names=1)
pub = read.table("pubchem_sample.sol",header=T,row.names=1)

# label the data
hus = labelData(hus,"HUUSKONEN")
jcim_train = labelData(jcim_train,"JCIM")
pub = labelData(pub,"PUBCHEM")

# combine the 3 datasets into 1 dataframe
allData = rbind(hus,jcim_train,pub)

# define an order for the x-axis in the boxplot
allData$DATASET = factor(allData$DATASET,levels=c("HUUSKONEN","JCIM","PUBCHEM"))

# display a boxplot of LogS vs Dataset and a corresponding table of boxplot statistics
print(summaryTable(allData))








