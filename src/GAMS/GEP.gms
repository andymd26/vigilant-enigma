$ontext
A two-stage generation expansion planning problem (GEP) with one producer attempting to satisfy a (1) known demand for (2) one operating level at (3) one node using (4) two technologies while minimzing the cost of providing electricity service. Each technology alternative has a fixed and marginal cost, which needs to be balanced in order to select the optimal production mix. As expected low marginal cost technologies tend to have higher fixed costs. In this early model version, we implement the formulation as a one period optimization problem. In this version of the model we allow the number of power plants built to be continuous, as opposed to discrete. In later versions we will implement the integer model.
$offtext

$setglobal R "D:\Program Files\R-3.3.2\bin\R.exe"
*Location of the R executable
$setglobal Rfile "D:\Users\andymd26\Documents\vigilant-enigma\src\ptdf.r"
*Location of the rscript to be run
option Limcol = 10;
option Limrow = 10;

Sets
h operating modes /h1*h1/
n node /n1*n1/
*ref_node(n) 'Reference node for which the phase angle is set to zero' /n3/
*The reference node is node 3
p technology /p1,p2/
s scenario /low, medium, high/
t time period /t1*t1/
L transmission line /L1*L3/;
*nn(n);
*nn(n) = yes$(not ref_node(n));
*Generates a subset of all nodes that aren't the reference node.

$ontext
execute_unload "D:\Users\andymd26\Documents\vigilant-enigma\src\output\sets.gdx";
*Location where the rscript expects the GAMS output data to be. Any changes here need to be matched in the R script.
execute "=%R% --rhome=%system.fp% CMD BATCH %rfile% %rfile%.log"
*Command to run the R script and have GAMS wait for the result before continuing.
if(errorlevel<>0,
display "--- Errors encountered in %rfile%"
display "--- Process will be aborted"
display "--- Check the %rfile%.log"
abort "Errors found in %Rfile%";
);
*Stops the process if the R code kicks off any errors
$CALL GDXXRW.EXE "D:\Users\andymd26\Documents\vigilant-enigma\src\output\ptdf.csv" par=PTDF rng=A1:D4
*Convert the .csv file to a .gdx file. We could have the R script generate the GDX file but it didn't seem to work the first time I tried it.
$GDXIN ptdf.gdx
$LOAD PTDF
$GDXIN
*Load the ptdf matrix.
$offtext

Variables
z 'objective function value';

Positive variables
m(h,n,s) 'the import or export of power to or from node n for operating mode h under scenario s'
UE(h,n,s) 'unserved energy at node no during operating level h for scenario s'
*w(n,p,s) 'McCormick envelope variable'
x(n,p)   'number of power plants using technology p to build at node n (1st stage decision)'
y(h,n,p,s) 'amount of time to run each power plant technology p under operating level h at node n for scenario s (2nd stage decision)';

Parameters
*Transmission network characteristics
$ontext
p(L) 'Power flow on arc L';
PTDF(L,nn) 'Power transfer distribution factors (empty matrix)';
reactance(L) 'Transmission line L reactance in ...'
  /L1 0.05
   L2 0.05
   L3 0.05/
l.line(L) 'lower bound on transmission line l capacity'
  /L1 1000
   L2 1000
   L3 1000 /
u.line(L) 'upper bound on transmission line l capacity'
  /L1 1000
   L2 1000
   L3 1000 /
$offtext
*Plant characteristics
size(p) 'Average size of plant p in MW'
  /p1 100
   p2 200 /
k(p) 'Fixed cost of plant p in USD per MW'
  /p1 10
   p2 20  /
c(p) 'Marginal cost of plant p in USD per MWh'
  /p1 3
   p2 1 /
a(p) 'Forced outage rate of plant p in percent'
  /p1 0.80
   p2 0.95  /

*Other system parameters
b 'budget constraint for the period'
  /200/
lambda 'average capacity in MW of the target Poisson distribution'
  /100/
LOLP_threshold 'exogeneously determined loss of load probability threshold'
  /0.10/
VLL 'value of lost load (i.e., penalty for unmet demand)'
  /9000/;

Table d(h,n,s) 'demand at node n for operating level h of scenario s in MWh'
      n1.low     n1.medium       n1.high
  h1  50000      100000          150000  ;
$ontext
  n2  50000      100000          150000
  n3  50000      100000          150000  ;
$offtext
Table prob(h,n,s) 'probability of each operating level h in demand scenario s'
      n1.low     n1.medium       n1.high
  h1  0.25       0.50            0.25
$ontext
  n2  0.25       0.50            0.25
  n3  0.25       0.50            0.25  ;
$offtext
loop((n,h), abort$(abs(sum(s,prob(h,n,s))-1)>0.001) "Probabilities do not sum to one");
*This loop sums the probabilites of each outcome state for each scenario and node, and ensures that the probabilities sum to one

Equations
obj                      'objective function value'
poisson_approx           'poisson approximation of reliability constraint'
node_balance(h,n,s)      'satisfy demand at node n for operating level h of scenario s'
availability(n,p,s)      'capacity constraint on using tech'
budget                   'constraint on the investments that can be made during the period'
;
obj.. z =e= sum(p, size(p)*k(p)*sum(n, x(n,p))) + sum((h,n,s), prob(h,n,s)*sum(p, y(h,n,p,s)*c(p) + VLL*UE(h,n,s))) ;
poisson_approx.. sum((n,p), x(n,p)*a(p)*size(p)) =g= lambda ;
node_balance(h,n,s).. sum(p, y(h,n,p,s)) + m(h,n,s) + UE(h,n,s) =g= d(h,n,s) ;
availability(n,p,s).. sum(h, y(h,n,p,s)) =l= a(p)*x(n,p)*size(p)*8760 ;
budget.. sum(p, k(p)*size(p)*sum(n, x(n,p))) =l= b ;


model gep /all/;
$ontext
model_name.tryLinear = 1;
*Might be a worthwhile command when the model is shifted back to the MIP. Examine empirical NLP model to see if there are any NLP terms active. If there are none the default LP solver will be used. To activate use model_name.trylinear=1. Default value is 0. The procedure also checks to see if QCP, and DNLP models can be reduced to an LP; MIQCP and MINLP can be solved as an MIP; RMIQCP and RMINLP can be solved as an RMIP.
$offtext
solve gep using lp minimizing z;
