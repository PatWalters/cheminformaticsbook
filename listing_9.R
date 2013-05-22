# Listing 9 
# calculate errors for regression and plot Pearson r with associated error bars

library(gplots)

# read the data
rc = read.table("compare_regression.txt",header=T,row.names=1)
# generate subsets of 25, 50, and 100 
subset25 = rc[0:25,]
subset50 = rc[0:50,]
subset100 = rc[0:100,]

# createList (actually vectors) to loop over
nameList = c("subset25","subset50","subset100")
dataList= list(subset25,subset50,subset100) 

# print the header
header = sprintf("%-15s %-15s %8s %8s %8s","Dataset","Method","R","CI LB","CI UB")
cat(header,"\n")

# loop over the 3 subsets
res = c()
for (i in 1:length(nameList)){
       name = nameList[i]
       data = data.frame(dataList[i])
       # calculate the correlation coefficents and confidence intervals
       resA = cor.test(data$LOGS,data$Method_A)
       resB = cor.test(data$LOGS,data$Method_B)
       # convert from a list to a vector of numbers
       outA = (as.numeric(c(resA$estimate,resA$conf.int)))
       # print the output
       strA = sprintf("%-15s %-15s %8.2f %8.2f %8.2f",name,"Method_A",resA$estimate,resA$conf.int[1],resA$conf.int[2])
       res = rbind(res,list(name,"Method_A",resA$estimate,resA$conf.int[1],resA$conf.int[2]))
       cat(strA,"\n")
       strB = sprintf("%-15s %-15s %8.2f %8.2f %8.2f",name,"Method_B",resB$estimate,resB$conf.int[1],resB$conf.int[2])
       res = rbind(res,list(name,"Method_B",as.numeric(resB$estimate),resB$conf.int[1],resB$conf.int[2]))
       cat(strB,"\n")
}
printDf = data.frame(res)
names(printDf) = c("DATASET","METHOD","R","CI_LB","CI_UB")

# reformat the results for a barplot with error bars
# reformat the r values
ma = as.numeric(printDf[printDf$METHOD=="Method_A",]$R)
mb = as.numeric(printDf[printDf$METHOD=="Method_B",]$R)
plotDf = data.frame(ma,mb)
row.names(plotDf)=c("subset25","subset50","subset100")
names(plotDf) = c("Method A","Method B")

# reformat the confidence interval lower bound
la = as.numeric(printDf[printDf$METHOD=="Method_A",]$CI_LB)
lb = as.numeric(printDf[printDf$METHOD=="Method_B",]$CI_LB)
lbDf = data.frame(la,lb)
row.names(lbDf)=c("subset25","subset50","subset100")
names(lbDf) = c("Method A","Method B")

# reformat the confidence interval upper bound
ua = as.numeric(printDf[printDf$METHOD=="Method_A",]$CI_UB)
ub = as.numeric(printDf[printDf$METHOD=="Method_B",]$CI_UB)
ubDf = data.frame(ua,ub)
row.names(ubDf)=c("subset25","subset50","subset100")
names(ubDf) = c("Method A","Method B")

# plot the barplot
par(fig=c(0,0.8,0,1))
barplot2(t(plotDf),beside=T,ci.l=t(lbDf),ci.u=t(ubDf),plot.ci=TRUE,ylim=c(0,1),ylab="Pearson r")
# plot the legend
par(fig=c(0.4,1,0,1),new=TRUE)
smartlegend(x="right",y="top",legend=c("Method 1","Method 2"),ncol=1,fill=c("red","yellow"))


