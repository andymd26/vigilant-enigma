Sets
p technology /p1*p4/
;
Variables
z;
Positive Variables
x(p),y(p)
;
Parameters
size(p) 'average size of plant t in MW'
  /p1 100
   p2 200 /
k(p) 'fixed cost of plant t in USD per MW'
  /p1 10
   p2 7
   p3 16
   p4 6 /
c(p) 'marginal cost of plant t in USD per MWh'
  /p1 4
   p2 4.5
   p3 3.2
   p4 5.5 /
r(p)
  /p1 1
   p2 1
   p3 1
   p4 1 /
d 'demand'
  /10/
;

Equations
obj
demand
pr(p)
;
obj.. z =e= sum(p, x(p)*k(p) + y(p)*c(p));
demand.. sum(p, y(p)) =g= d ;
pr(p).. y(p) =l= x(p)*r(p) ;

model toy_gep /all/;
solve toy_gep using lp minimizing z;

