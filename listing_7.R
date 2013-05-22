# Listing 7
# load data and display box plots to compare distributions

# load the required library
library(plyr)

# read the data
d = read.table("similarity.txt",header=T)
# generate the boxplot
boxplot(Similarity~Dataset,d,ylab="Tanimoto Similarity to the Huuskonen Training Set")
# generate a table of mean and median for each dataset
res = ddply(d, c("Dataset"), function(x)c(mean(x$Similarity),median(x$Similarity)))
# format the results into a table 
res = data.frame(res)
names(res) = c("Dataset","Mean","Median")
res$Mean = round(res$Mean, digits=2)
res$Median = round(res$Median, digits=2)
# print the table
print(res)

