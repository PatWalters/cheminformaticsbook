# Listing 8
# predict activities of 3 test sets for a training set


library(randomForest)
library(Kendall)

# calculate the root mean squared error
rmsError<-function(a,b){
	sqrt(sum((a-b)**2)/length(a))
}

# merge descriptors and experimental data into a single data frame
mergeData<-function(descriptors,logS){
	mergedData = merge(logS,descriptors,by=0)
	mergedData = mergedData[,-c(1,3)]
	mergedData
}

# build a predictive model from descritptors and experimental data
buildModel<-function(descriptors,logS){
	mergedData = mergeData(descriptors,logS)
	rf = randomForest(LOGS~.,mergedData)
	rf
}

# use a model to predict test set activity
predictTestSet<-function(model,name,suffix){
	descriptors  = read.table(paste(name,suffix,sep=""),header=T,row.names=1)
        logS = read.table(paste(name,".sol",sep=""),header=T,row.names=1)
        mergedData = mergeData(descriptors,logS)	
        pred = predict(model,mergedData)
        r2 = cor(mergedData$LOGS,pred)**2
        err = rmsError(mergedData$LOGS,pred)
	kt = Kendall(mergedData$LOGS,pred)$tau
        output = list("name"=name,"r2"=r2,"rms_error"=err,"exper"=mergedData$LOGS,"pred"=pred,"kendall"=kt)
	output
}

descriptorSuffix = ".rdkit"

# read the training set and build a random forest model
huuskonenTrainDes = read.table(paste("huuskonen_train",descriptorSuffix,sep=""),header=T,row.names=1)
huuskonenTrainSol = read.table("huuskonen_train.sol",header=T,row.names=1)
rf = buildModel(huuskonenTrainDes,huuskonenTrainSol)


# read the test sets and predict activity
testSets = c("huuskonen_test","jcim","pubchem")
cat(sprintf("%-15s %8s %8s %8s\n","DataSet","R**2","Kendall","RMS Error"))
for (fileName in testSets){
    res = predictTestSet(rf,fileName,descriptorSuffix)
    cat(sprintf("%-15s %8.2f %8.2f %8.2f\n",res$name,res$r2,res$kendall,res$rms_error))
}


