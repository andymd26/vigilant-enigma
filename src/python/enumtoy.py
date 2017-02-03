budget = 1000
aveCap = 0.5 # lambda 
N = 1 # number of nodes
# scenarioProb = [0.25, 0.5, 0.25] # prob_s, probability of each scenario

# *_p technology parameters
P = [
    {"outageRate": 0.5,
     "marginalCost": 0,
     "fixedCost": 0,
     "size": 0
     },
    {"outageRate": 0.5,
     "marginalCost": 0,
     "fixedCost": 0,
     "size": 0
     }
    ]

S = [
    {"prob": [[0, 0], [0, 0], [0, 0]],
     "demand": [[0, 0], [0, 0], [0, 0]]
     },
    {"prob": [[0, 0], [0, 0], [0, 0]],
     "demand": [[0, 0], [0, 0], [0, 0]]
     },
    {"prob": [[0, 0], [0, 0], [0, 0]],
     "demand": [[0, 0], [0, 0], [0, 0]]
     }
    ]

# Variables
minObj = float("inf") #Stores the smallest know objective function value, initialised to INF

# Number of each type of each power production technology p to build at node n, integer
xnp = [[0 for j in xrange(len(P))] for i in xrange(len(N))]

#loop over all possible well-formed solutions
    #If not feasible, next salution
    #Evaluate objective value for current solution
        #If value is smaller than stored value, store current value and solution
#Return solution and objective value
