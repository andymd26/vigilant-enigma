install.packages("hier.part")
require(hier.part)
# the combos function is found in this package

threshold = 2020
x = c(6, 6, 5, 4, 4)
# [Integer variable] the number of each unit type picked by the 1st stage of the model
avg.size = c(50, 100, 100, 400, 1000)
# the average size of each unit type in the model
avg.for = c(0.6, 0.85, 0.85, 0.9, 0.95)
# the average forced outage rate of each unit type in the model
size = c(rep(avg.size[1], x[1]), rep(avg.size[2], x[2]), rep(avg.size[3], x[3]), rep(avg.size[4], x[4]), rep(avg.size[5], x[5]))
x.on = diag(c(rep(avg.for[1], x[1]), rep(avg.for[2], x[2]), rep(avg.for[3], x[3]), rep(avg.for[4], x[4]), rep(avg.for[5], x[5])))
x.off = diag(c(1-diag(x.on)))
x.size = diag(c(size))
x.tot = sum(x)

unit.on = matrix(rbind(rep(0, x.tot), combos(x.tot)$binary), ncol=x.tot)
# Builds a matrix of all possible combinations of the binomial outcomes for each unit in the production mix (2^x.tot combinations)
# The combos function neglects the possibility of all units being off, which is why we add a row of zeros
# This matrix corresponds to all units being "on"
unit.off = 1 - unit.on
# This matrix corresponds to all units being "off"
x.mw = (unit.on %*% x.size) %*% matrix(rep(1, x.tot),ncol = 1)
# Determines the amount of capacity available at each state
cocpt = data.frame((unit.on %*% x.on + unit.off %*% x.off)) %>%
  # Because on and off are mutually exclusive we can create the cocpt as the sum of the probability of being "on" matrix + the probability of 
  # being "off" matrix
  transmute(prob = Reduce(`*`, .)) %>%
  # Determines the probability of each state (multiplies the likelihood of each unit in its present state)
  cbind(x.mw) %>%
  group_by(x.mw) %>%
  summarize(prob = sum(prob)) %>%
  # Accounts for the fact that several states can have the same amount of available capacity. Since we want the probability of the available 
  # capacity we need to sum these states.  
  ungroup() %>%    
  arrange(desc(x.mw)) %>%
  # Arrange in descending order (for the cumulative probability calculation)
  mutate(cum.prob = cumsum(prob)) %>%
  # Calculate the cumulative probability of each state (i.e., Prob(X >= x mw))
  filter(x.mw >= threshold) %>%
  # The user specifies a capacity threshold that corresponds with a probability of outage (calculated from the load duration curve)
  # Identify the states with equivalent or greater capacity
  filter(cum.prob == max(cum.prob))
  # Of the reduced set find the row with the maximum cumulative probability; this is the value we need to send back to GAMS

