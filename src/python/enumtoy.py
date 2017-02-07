budget = 1000
aveCap = 4365 # lambda (MW)
H = 2
S = 1
LOLCC = 0.95
VLL = 1000 # ($/MW)


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

N = [
    {"prob": [[0], [0]],
     "demand": [[0], [0]]
     }
    ]

### Variables

minObj = float("inf") #Stores the smallest know objective function value, initialised to INF

# Import or export of power to or from node n for operating mode h under scenario s
# (MWh)
mhns = [[[0 for k in range(S)] for j in range(len(N))] for i in range(H)]

# Unserved energy at node n during operating level h for scenario s
#(MWh)
uehns = [[[0 for k in range(S)] for j in range(len(N))] for i in range(H)]

# Number of each type of each power production technology p to build at node n
# integer
xnp = [[0 for j in range(len(P))] for i in range(len(N))]

#  capacity of power production technology p used at node n
# during operating mode h under scenario s
# (MW)
yhnsp = [[[[0 for l in range(len(P))] for k in range(S)] for j in range(len(N))] for i in range(H)]

#loop over all possible well-formed solutions
    #If not feasible, next salution
    #Evaluate objective value for current solution
    
        #If value is smaller than stored value, store current value and solution
#Return solution and objective value

def evalObj(xnp, yhnsp, euhns):
    print(P)
    print(xnp)
