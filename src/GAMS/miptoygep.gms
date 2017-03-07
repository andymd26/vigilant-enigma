$ontext
Capacity expansion problem from Birge and Leveux p 33
$offtext
Sets
p technology /p1*p4/
t modes /t1*t3/
;

Variables
z
;

Positive Variables
y(p, t)
u(t)
;

Integer Variables
x(p)
;

Parameters
size(p) 'nominal size of plant p in MW'
  /p1 1
   p2 1
   p3 1
   p4 1 /

k(p) 'fixed cost of plant p in USD'
  /p1 10
   p2 7
   p3 16
   p4 6 /

c(p) 'marginal cost of plant t in USD per MWh'
  /p1 4
   p2 4.5
   p3 3.2
   p4 5.5 /

d(t) 'demand in MW'
  /t1 1
   t2 3
   t3 2 /

ld(t) 'load duration in hours (leap year, 8784 hrs)'
  /t1 10
   t2 6
   t3 1/

vll 'value of lost load, the penalty cost for unserved energy in USD per MWh'
  /15/
;

Equations
obj
pr(p,t)
penalty(t)
;

obj.. z =e= sum(p, x(p)*k(p)*size(p)) + sum((p,t), y(p,t)*c(p)) + vll*sum(t, u(t));
pr(p,t).. y(p,t) =l= x(p)*size(p)*ld(t);
penalty(t).. u(t) =g= d(t)*ld(t) - sum(p, y(p, t));

model toy_gep /all/;
solve toy_gep using mip minimizing z;

