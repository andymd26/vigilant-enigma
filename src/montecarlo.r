require(dplyr)

threshold = 65000
x = c(100, 150, 200, 25, 30)
x= c(1000)
# [Integer variable] the number of each unit type picked by the 1st stage of the model
avg.size = c(50, 50, 100, 500, 1000)
avg.size = 1
# the average size of each unit type in the model
avg.for = c(0.6, 0.85, 0.85, 0.9, 0.95)
avg.for = 0.9
# the average forced outage rate of each unit type in the model
for.rep = c(rep(avg.for[1], x[1]), rep(avg.for[2], x[2]), rep(avg.for[3], x[3]), rep(avg.for[4], x[4]), rep(avg.for[5], x[5]))
for.rep = c(rep(avg.for[1], x[1]))
size.rep = matrix(c(rep(avg.size[1], x[1]), rep(avg.size[2], x[2]), rep(avg.size[3], x[3]), rep(avg.size[4], x[4]), rep(avg.size[5], x[5])), nrow = 1)
size.rep = matrix(c(rep(avg.size[1], x[1])), nrow = 1)


y = t(sapply(for.rep, function(x) rbinom(n=50000, size=1, prob =x)))
x = data.frame(mw = c(size.rep %*% y)) %>%
  group_by(mw) %>%
  summarize(freq=n()) %>%
  mutate(rel.freq = freq/sum(freq)) %>%
  arrange(desc(mw)) %>%
  # Arrange in descending order (for the cumulative probability calculation)
  mutate(cum.prob = cumsum(rel.freq))) %>%
  # Calculate the cumulative probability of each state (i.e., Prob(X >= x mw))
  filter(mw >= threshold) %>%
  # The user specifies a capacity threshold that corresponds with a probability of outage (calculated from the load duration curve)
  # Identify the states with equivalent or greater capacity
  filter(cum.prob == max(cum.prob))

x.value = 84
x.percentile = 0.0275
f2 = function(lambda) ppois(x.value, lambda) - x.percentile
uniroot(f2, c(0, 10000))[1]
max(f2(floor(as.numeric(uniroot(f2, c(0, 10000))[1]))), f2(ceiling(as.numeric(uniroot(f2, c(0, 10000))[1]))))

floor(as.matrix(uniroot(f2, c(0, 10000))[1]),ceiling(uniroot(f2, c(0, 10000))[1]))
