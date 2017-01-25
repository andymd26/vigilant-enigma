$ontext
A two-stage generation expansion planning problem (GEP) with one producer attempting to satisfy a known demand at one node using two technologies while minimzing the cost of providing electricity service. Each technology alternative has a fixed and marginal cost, which needs to be balanced in order to select the optimal production mix. As expected low marginal cost technologies tend to have higher fixed costs. In this early model version, we implement the formulation as a one period optimization problem. In this version of the model we allow the number of power plants built to be continuous, as opposed to discrete. In later versions we will implement the integer model. 
$offtext

$setglobal R "D:\Program Files\R-3.3.2\bin\R.exe"
*Location of the R executable
$setglobal Rfile "D:\Users\andymd26\Documents\vigilant-enigma\src\ptdf.r"
*Location of the rscript to be run

Sets
n node /n1*n3/
*The reference node is node 3
p technology /p1,p2/
s scenario /low, medium, high/
L transmission line /L1*L3/
;
execute_unload "D:\Users\andymd26\Documents\vigilant-enigma\src\output\sets.gdx";  
*Location where the rscript expects the set data to be
execute "=%R% --rhome=%system.fp% CMD BATCH %rfile% %rfile%.log"
if(errorlevel<>0,
display "--- Errors encountered in %rfile%"
display "--- Process will be aborted"
display "--- Check the %rfile%.log"
abort "Errors found in %Rfile%";
);
*Stops the process if errors exist in the R code
$CALL GDXXRW.EXE "D:\Users\andymd26\Documents\vigilant-enigma\src\output\ptdf.csv" par=PTDF rng=A1:D4
*Convert the .csv file to a .gdx file
$GDXIN ptdf.gdx
$LOAD PTDF
$GDXIN

Variables
z 'objective function value'
;
Positive variables
y(n,p,s) 'amount of time to run each power plant technology p at node n for scenario s (2nd stage decision)'
x(n,p)   'number of power plants using technology p to build at node n (1st stage decision)'
w(n,p,s) 'McCormick envelope variable'
;

Parameters
*Transmission network characteristics
p(L);
PTDF(i,j);

*Plant characteristics
size(p) 'average size of plant p in MW'
  /p1 100
   p2 200 / ;
k(p) 'fixed cost of plant p in USD per MW'
  /p1 10
   p2 20  / ;
c(p) 'marginal cost of plant p in USD per MWh'
  /p1 3
   p2 1 / ;
a(p) 'forced outage rate of plant p in percent'
  /p1 0.80
   p2 0.95  / ;
$ontext
Demand characteristics
$offtext
b 'budget for the period'
  /200/ ;

Table d(n,s) 'demand at node n for scenario s in MWh'
      low   medium  high
  n1  50000 100000  150000
  n2  50000 100000  150000 
  n3  50000 100000  150000
$ontext
demand doesn't need an index in the single node case
$offtext
;
Table prob(n,s) 'probability of each demand scenario'
      low   medium  high
  n1  0.25  0.50    0.25
  n2  0.25  0.50    0.25
  n3  0.25  0.50    0.25  
;
Table incidence(n, L) 'node-incidence matrix'
      L1  L2  L3
  n1  1   1   0
  n2  -1  0   1
;
Table reactance(L,L) 'transmission line reactance matrix'
      q1  q2  q3
  L1  1   0   0
  L2  0   1   0
  L3  0   0   1
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
$ontext
demand(n,s).. sum(p, x(n,p)*size(p)*y(n,p,s)) =g= d(n,s) ;
original constraint
where w(n,p,s) = x(n,p)*y(n,p,s)
$
demand(n,s).. sum(p, w(n,p,s)*size(p)) =g= d(n,s);
mcc_2(n,s).. w(n,p,s) =g= xl*y(n,p,s) + x(n,p)*yl - xl*yl;
mcc_3(n,s).. w(n,p,s) =l= xu*y(n,p,s) + x(n,p)*yl - xu*yu;
mcc_4(n,s).. w(n,p,s) =g= xu*y(n,p,s) + x(n,p)*yu - xu*yu;
mcc_5(n,s).. w(n,p,s) =l= x(n,p)*yu + xl*y(n,p,s) - xl*yu;
production(n,p,s).. y(n,p,s) =l= a(p)*x(n,p)*8760 ;
budget.. sum((n,p), x(n,p)*k(p)*size(p)) =l= b;

model gep /all/;
solve gep using rminlp minimizing z;
