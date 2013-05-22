# Listing 5
# add simulated error to experimental data to examine the impact of error on correlations

# calculate the maximum correlation that can be achieved give a measure of experimental error
# values - the experimental data
# error - the standard deviation of the error to be added, mean is 0
# repeats - the number of times to repeat the simulation
maxError<-function(values,error=0.3,repeats=1000){
	correlationList = c()
	for (i in 1:repeats){
		errorList = rnorm(n=length(values),mean=0,sd=error)
		correlationList[i] = cor(values,values+errorList)**2
	}
	mean(correlationList)
}

# load the solubility data
hus = read.table("huuskonen.sol",header=T,row.names=1)
jcim_train = read.table("jcim_train.sol",header=T,row.names=1)
pub = read.table("pubchem_sample.sol",header=T,row.names=1)

# write the output table
cat(sprintf("%-20s %8s %8s %8s\n","Dataset","Max@0.3","Max@0.5","Max@1.0"))
for (data in list(c(hus,"Huuskonen"),c(jcim_train,"JCIM"),c(pub,"PubChem"))){
    name =  data[2]
    maxCorrelationList = c()
    i = 1
    for (err in c(0.3,0.5,1.)){
      maxCorrelationList[i] = maxError(data[1]$LOGS,err)
      i = i+1
    }
    cat(sprintf("%-20s %8.2f %8.2f %8.2f\n",name,maxCorrelationList[1],maxCorrelationList[2],maxCorrelationList[3]))
}