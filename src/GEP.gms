$ontext
A generation expansion planning problem (GEP) with one producer attempting to satisfy a known demand at one node using two technologies while minimzing the cost of providing electricity service. Each technology alternative has a fixed and marginal cost, which needs to be balanced in order to select the optimal production mix. As expected low marginal cost technologies tend to have higher fixed costs. In this early model version, we implement the formulation as a one period optimization problem. 
$offtext

Sets
n node /n1/
t technology /t1, t2/
;
Variables
z objective function value
;
Positive variables
y(t) number of hours to run each power plant using technology t
;
Integer variables
x(t) number of power plants using technology t to build 
;
Parameters
$ontext Plant characteristics $offtext
s(t) average size of plant t in MW
  /t1 100
   t2 200 /
k(t) fixed cost of plant t in USD per MW
  /t1 10
   t2 20  /
c(t) marginal cost of plant t in USD per MWh
  /t1 3
   t2 1 / 
r(t) forced outage rate of plant t in percent
  /t1 0.80
   t2 0.95  /
$ontext Demand characteristics $offtext
d(n) demand at node n in MWh
  /n 100  /
$ontext demand doesn't need an index in the single node case $offtext
b budget for the period
  /200/
;
Equations
obj               objective function value
demand(n)         satisfy demand at node n
supply(t)         supply from technology t cannot exceed its availability
budget            constraint on the investments that can be made during the period
;
obj.. z =e= sum(t, x(t)*s(t)*k(t) + y(t)*c(t)) ;
demand(n).. sum(t, x(t)*s(t)*y(t)) =g= d(n) ;
supply(t).. x(t)*s(t)*y(t) =l= x(t)*s(t)*8760*r(t) ;
budget.. sum(t, x(t)*k(t)) =l= b;

model gep /all/;
solve gep using mip minimizing z;
