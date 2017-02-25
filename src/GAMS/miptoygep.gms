Sets
p technology /p1*p2/
t modes /t1*t2/
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
  /p1 100
   p2 300 /

k(p) 'fixed cost of plant p in USD'
  /p1 70000
   p2 100000 /

c(p) 'marginal cost of plant t in USD per MWh'
  /p1 5
   p2 4 /

d(t) 'demand in MW'
  /t1 3980
   t2 2712/

ld(t) 'load duration in hours (leap year, 8784 hrs)'
  /t1 2584
   t2 6200/

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

