$ontext
A two-stage generation expansion planning problem (GEP) with one producer attempting to satisfy a known demand at one node using two technologies while minimzing the cost of providing electricity service. Each technology alternative has a fixed and marginal cost, which needs to be balanced in order to select the optimal production mix. As expected low marginal cost technologies tend to have higher fixed costs. In this early model version, we implement the formulation as a one period optimization problem. In this version of the model we allow the number of power plants built to be continuous, as opposed to discrete. In later versions we will implement the integer model. 
$offtext

Sets
n node /n1*n2/
p technology /p1, p2/
s scenario /low, medium, high/
;
Variables
z objective function value
;
Positive variables
y(n,p,s) 'amount of time to run each power plant technology p at node n for scenario s (2nd stage decision)'
x(n,p)   'number of power plants using technology p to build at node n (1st stage decision)'
;

Parameters
$ontext
Plant characteristics
$offtext
size(p) 'average size of plant p in MW'
  /p1 100
   p2 200 /
k(p) 'fixed cost of plant p in USD per MW'
  /p1 10
   p2 20  /
c(p) 'marginal cost of plant p in USD per MWh'
  /p1 3
   p2 1 /
a(p) 'forced outage rate of plant p in percent'
  /p1 0.80
   p2 0.95  /
$ontext
Demand characteristics
$offtext
b 'budget for the period'
  /200/
;

Table d(n,s) 'demand at node n for scenario s in MWh'
      low   medium  high
  n1  50000 100000  150000
  n2  50000 100000  150000  
$ontext
demand doesn't need an index in the single node case
$offtext
;
Table prob(n,s) 'probability of each demand scenario'
        low   medium  high
  n1    0.25  0.50    0.25
  n2    0.25  0.50    0.25
;

loop(n, abort$(abs(sum(s,prob(n,s))-1)>0.001) "Probabilities do not sum to one");
$ontext
This loop sums the probabilites of each outcome state for each scenario and node, and ensures that the probabilities sum to one
$offtext

Equations
obj               'objective function value'
demand(n,s)       'satisfy demand at node n'
production(n,p,s) 'hours of production from technology p at node n cannot exceed its availability'
budget            'constraint on the investments that can be made during the period'
;
obj.. z =e= sum(n, sum(p, x(n,p)*size(p)*k(p))) + sum((n,s), prob(n,s)*sum(p, y(n,p,s)*c(p))) ;
demand(n,s).. sum(p, x(n,p)*size(p)*y(n,p,s)) =g= d(n,s) ;
production(n,p,s).. y(n,p,s) =l= a(p)*x(n,p)*8760 ;
budget.. sum((n,p), x(n,p)*k(p)*size(p)) =l= b;

model gep /all/;
solve gep using rminlp minimizing z;
