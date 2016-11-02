threshold = 2020
x = c(6, 6, 5, 4, 4)
# [Integer variable] the number of each unit type picked by the 1st stage of the model
avg.size = c(50, 100, 100, 400, 1000)
# the average size of each unit type in the model
avg.for = c(0.6, 0.85, 0.85, 0.9, 0.95)
# the average forced outage rate of each unit type in the model
for.rep = c(rep(avg.for[1], x[1]), rep(avg.for[2], x[2]), rep(avg.for[3], x[3]), rep(avg.for[4], x[4]), rep(avg.for[5], x[5]))
size = c(rep(avg.size[1], x[1]), rep(avg.size[2], x[2]), rep(avg.size[3], x[3]), rep(avg.size[4], x[4]), rep(avg.size[5], x[5]))
x.on = diag(c(rep(avg.for[1], x[1]), rep(avg.for[2], x[2]), rep(avg.for[3], x[3]), rep(avg.for[4], x[4]), rep(avg.for[5], x[5])))
x.off = diag(c(1-diag(x.on)))
x.size = diag(c(size))
x.tot = sum(x)

x = c

y = t(sapply(for.rep, function(x) rbinom(n=1000, size=1, prob =x)))


