# This file reads in real electricity system data for the year 2016 for the company PEPCO (a member of PJM). We use the data to create some realistic estimates for the toy model.
require(dplyr)
require(ggplot2)
require(rpart)

setwd("D:/Users/andymd26/Documents/vigilant-enigma/data")
file = "pepco_2016.txt"
elec = scan(file, what="numeric", skip = 1)
#scan reads in a matrix as a single vector. In this case data is stored by (rows=days, columns=hours). Instead we would like a single column vector.
dat=data.frame(elec, hours = seq(from=1, to=8783, by=1))

dat = dat %>%
  mutate(elec=as.numeric(as.character(elec))) %>%
  arrange(desc(elec)) %>%
  mutate(index = seq(from=1,to=8783, by=1))

# Haven't finished this yet but regression trees might be a useful tool for determining the optimal number of load segments (i.e., minimized the squared distance from the LDC)
# The tree identifies the break points in the data that minimize the 'distance'. If we used these break points is the best guess at the load for that duration equal to the mean of the x-values in that bin?
tree = rpart(elec ~ index, data = dat, control=rpart.control(minsplit=2, cp=0.0001))
printcp(tree) # display the results
plotcp(tree) # visualize cross-validation results
summary(tree) # detailed summary of splits

plot(tree, uniform=TRUE,
     main="Classification Tree for Kyphosis")
text(tree, use.n=TRUE, all=TRUE, cex=.8)

ggplot() + geom_line(aes(x=dat$index,y=dat$elec))

perc = 0.05
threshold = dat[round(perc*8783), 'elec']


