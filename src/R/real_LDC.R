# This file reads in real electricity system data for the year 2016 for the company PEPCO (a member of PJM). We use the data to create some realistic estimates for the toy model.
require(dplyr)
require(ggplot2)
setwd("D:/Users/andymd26/Documents/vigilant-enigma/data")
file = "pepco_2016.txt"
elec = scan(file, what="numeric", skip = 1)
#scan reads in a matrix as a single vector. In this case data is stored by (rows=days, columns=hours). Instead we would like a single column vector.
dat=data.frame(elec, hours = seq(from=1, to=8783, by=1))

dat = dat %>%
  mutate(elec=as.numeric(as.character(elec))) %>%
  arrange(desc(x)) %>%
  mutate(index = seq(from=1,to=8783, by=1))

ggplot() + geom_line(aes(x=dat$index,y=dat$elec))

perc = 0.05
threshold = dat[round(perc*8783), 'elec']
