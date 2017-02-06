budget = 1000
aveCap = 0.5 # lambda
H = 1


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
     }
    ]

### Variables

minObj = float("inf") #Stores the smallest know objective function value, initialised to INF

# Number of each type of each power production technology p to build at node n, integer
mhns = [[[0 for k in range(len(S))] for j in range(len(S))] for i in range(3)]

# Number of each type of each power production technology p to build at node n, integer
uehns = [[0 for j in range(len(P))] for i in range(len(S))]

# Number of each type of each power production technology p to build at node n, integer
xnp = [[0 for j in range(len(P))] for i in range(len(S))]

# Number of each type of each power production technology p to build at node n, integer
yhnsp = [[0 for j in range(len(P))] for i in range(len(S))]

#loop over all possible well-formed solutions
    #If not feasible, next salution
    #Evaluate objective value for current solution
    
        #If value is smaller than stored value, store current value and solution
#Return solution and objective value

def evalObj(xnp):
    print(xnp)
