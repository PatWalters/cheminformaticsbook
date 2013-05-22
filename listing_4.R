# Listing 4
# train and test a random forest model based on a subset of the Huuskonen dataset
# not that this listing is just a variation on Listing 3

# load the required libraries
library(randomForest)
library(Kendall)

# calculate the root mean squared error
rmsError<-function(a,b){
	sqrt(sum((a-b)**2)/length(a))
}

# split a dataset into training and test sets
splitTrainTest<-function(dataSet,trainingFraction=0.7){
	idxList = sample(1:nrow(dataSet))	
	numTrain = floor(trainingFraction * nrow(dataSet))
	trainIdx = idxList[1:numTrain]
	testIdx = idxList[(numTrain+1):length(idxList)]
	list("train"=trainIdx,"test"=testIdx)
}

# merge descriptors and experimental data into a single dataframe
mergeData<-function(descriptors,logS){
	mergedData = merge(logS,descriptors,by=0)
	mergedData = mergedData[,-c(1,3)]
	mergedData
}

# use descriptors and experimental data to train and test a random forest model
predictRf<-function(mergedData,trainingFraction=0.7){
	ttSplit = splitTrainTest(mergedData,trainingFraction)
	rf = randomForest(LOGS~.,mergedData[ttSplit$train,])
	pred = predict(rf,mergedData[ttSplit$test,])
	list("train"=ttSplit$train,"test"=ttSplit$test,"pred"=pred,"exper"=mergedData[ttSplit$test,]$LOGS,"model"=rf)
}

# read the data
desc = read.table("huuskonen.rdkit",header=T,row.names=1)
logS = read.table("huuskonen.sol",header=T,row.names=1)
# merge descriptors and solubility data
mergedData = mergeData(desc,logS)	
# create a subset with LogS between -6 and -3
realisticSubset = mergedData[mergedData$LOGS >= -6 & mergedData$LOGS <= -3,]
res = predictRf(realisticSubset)
# plot the test set results
plot(res$exper,res$pred,xlab="Experimental LogS",ylab="Predicted LogS")
# output results
cat(sprintf("      Train = %d\n",length(res$train)))
cat(sprintf("       Test = %d\n",length(res$test)))
cat(sprintf("  Pearson r = %.2f\n",cor(res$pred,res$exper)))
cat(sprintf("Kendall tau = %.2f\n",Kendall(res$pred,res$exper)$tau))
cat(sprintf("  RMS error = %.2f\n",rmsError(res$pred,res$exper)))

