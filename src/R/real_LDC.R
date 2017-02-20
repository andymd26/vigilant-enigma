install.packages("dplyr")
install.packages("ggplot2")
install.packages("rpart")
install.packages("earth")
install.packages("splines")
# This file reads in real electricity system data for the year 2016 for the company PEPCO (a member of PJM). We use the data to create some realistic estimates for the toy model.
require(dplyr)
require(earth)
require(ggplot2)
require(rpart)
require(splines)

setwd("D:/Users/andymd26/Documents/vigilant-enigma/data")
setwd("~/Documents/vigilant-enigma/data")
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
# Apporoach to implement after getting back: loop through x by 1 where x is the hours in a year. Calculate the average of electricity capacity on either side of the hour chosen. Calculate the squared difference between the actual electricity and the mean for each of the hours. The minimum of this is the best break point.

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

function
y = seq(1,nrow(dat),1)
z = function(y){
  a.mean = (dat[1:y,'elec'] - mean(dat[1:y,'elec']))^2
}
y.1 = sapply(sapply(y,z),sum)

z = function(dat) {1:max(dat[,'index'])
  
}

a = sapply(sapply(y, function(x) (dat[1:x,'elec'] - mean(dat[1:x,'elec']))^2 + 
                    (dat[(x+1):max(x),'elec'] - mean(dat[(x+1):max(x),'elec']))^2), sum)

a = sapply(y, function(x) mean(dat[(x+1):max(x),'elec']))


a.mean = sapply(y, function(x) (dat[1:x,'elec'] - mean(dat[1:x,'elec']))^2) +
                  (dat[(x+1):(max(y)-1),'elec'] - mean(dat[(x+1):(max(y)-1),'elec']))^2) 

a.mean = sapply(sapply(y, function(x) (dat[1:x,'elec'] - mean(dat[1:x,'elec']))^2),sum)
b.mean = sapply(sapply(y, function(x) (dat[(x+1):8783,'elec'] - mean(dat[(x+1):8783,'elec']))^2),sum)

D=0
K=5
knots = nrow(dat) * (1:K)/(K+1)

X1 = outer(dat$elec, 1:D,"^")
X2 = outer(dat$elec, knots, ">") * outer(dat$elec, knots,"-")^D
X = cbind(X1,X2)  
  
  
  
  