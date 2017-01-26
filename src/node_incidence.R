install.packages("C:/Users/bloh356/Downloads/gdxrrw_0.4.0.zip", repos = NULL) 
require(gdxrrw)
# The code below generates an node-branch incidence matrix for a complete network with n vertices. For more information see the Appendix C of 
# Complementarity Modelling of Energy Markets
# The number of vertices
n = 3
# The number of edges in a complete graph (one edge for each direction) with n nodes is: 
#edges = n*(n - 1)
edges = 3
incidence.matrix = matrix(rep(0, n*edges), nrow = n, ncol = edges)
z = seq(from = 1, to = edges, by = (n-1))
for (i in 1:n) {
  if (i == 1) {incidence.matrix[i, z[i]:(n-1)] = 1} else {incidence.matrix[i, z[i]:(z[i] + n - 2)] = 1}
  if (i != 1) { a = incidence.matrix
                incidence.matrix[1, ] = a[i, ]
                incidence.matrix[i, ] = a[1, ]
                incidence.matrix[2:n, z[i]:(z[i] + n - 2)] = diag(-1, (n-1))} else {incidence.matrix[2:n, 1:(n-1)] = diag(-1, (n-1))}
}  

# Set the reference node (i.e., phase angle equals zero) and remove that node from the node-incidence matrix
reference.node = n
incidence.matrix = incidence.matrix[which(1:n != reference.node), ]
# Susceptance vector
susceptance = rep(0.5, edges)
# Susceptance matrix
X = diag(susceptance)
# Power flows p610
C.11 = incidence.matrix%*%X%*%t(incidence.matrix)
# Sensitivity matrix, p610
C.8 = X%*%t(incidence.matrix)%*%solve(B)

# The above is probably not that useful since all we care about is the net flow (I think).
# Need to figure out how to send this data back to GAMS
# Might be cool to figure out how to make a node-incidence matrix for not complete graphs (using information on the edges)
# 1. Generate a 2 column matrix with all possible combinations of the number of nodes
# 2. If column 1 is greater than column 2 than entry A[column 1, column 2] is +1. 
# 3. If column 1 is less than column 2 than entry A[column 1, column 2] is -1. 
# 4. All other entries are zero. 