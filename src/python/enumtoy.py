budget = 1000
aveCap = 0.5 # lambda 
# scenarioProb = [0.25, 0.5, 0.25] # prob_s, probability of each scenario

# *_p technology parameters
technologies = [
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

# Variables
maxObjective = 0

#Store 0 as max objective value
#loop over all possible well-formed solutions
    #Check feasibility of current solution
        #If not feasible, next salution
    #Evaluate objective value for current solution
        #If value is higher than stored value, store current value and solution
#Return solution and objective value
