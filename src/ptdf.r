#install.packages("reshape2")
#setwd("C:/Users/andymd26/Downloads")
#install.packages("gdxrrw_a.b.c.zip")
library(reshape2)
library(gdxrrw)
igdx("D:/Program Files/24.8")

setwd("D:/Users/andymd26/Documents/vigilant-enigma/src/output")
L = rgdx.set("sets.gdx", "L")
n = rgdx.set("sets.gdx", "n")

setwd("D:/Users/andymd26/Documents/vigilant-enigma/src/output")
L.reactance = diag(1/rgdx.param("sets.gdx","reactance")[,2])
setwd("D:/Users/andymd26/Documents/vigilant-enigma/data")
incidence.matrix = as.matrix(read.table("node_incidence.csv", sep= ",", header=TRUE, row.names=1))
if(nrow(incidence.matrix) != nrow(as.matrix(n))) stop('The number of nodes does not align with the node incidence matrix does not match the problem')
if(ncol(incidence.matrix) != nrow(as.matrix(L))) stop('The number of transmission lines does not align with the node incidence matrix')
reference.node = 3
incidence.matrix = incidence.matrix[which(1:nrow(incidence.matrix) != reference.node), ]

Pf = L.reactance%*%t(incidence.matrix)
P = incidence.matrix%*%Pf
ptdf = L.reactance %*% t(incidence.matrix) %*% solve(P)
ptdf = L.reactance %*% t(incidence.matrix) %*% solve(incidence.matrix%*%Pf)
rownames(ptdf)= as.matrix(L)
write.csv(A, file="ptdf.csv")
q('no');

