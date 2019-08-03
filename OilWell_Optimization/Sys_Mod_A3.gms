Sets
       i   production node   / OW1, OW2, OW3, OW4, OW5, OW6 /
       j   cleaning facility  / Iclean1, Iclean2, Dclean1, Dclean2 /
       k   sink nodes   / City1, City2, IWell1, IWell2, IWell3 /;

Table  ct(i,j)   cost of transporting by truck from i to j

            Iclean1 Iclean2 Dclean1    Dclean2
    OW1       2.15    3.15      4.3     6.3
    OW2       2.3     2.94      4.6     5.88
    OW3       2.52    2.73      5.04    5.46
    OW4       2.73    2.52      5.46    5.04
    OW5       2.94    2.3       5.88    4.6
    OW6       3.15    2.15      6.30    4.3   ;

Table  cp(i,j)  cost of transporting by pipe from i to j
            Iclean1 Iclean2 Dclean1 Dclean2
    OW1       0.1      0.15     0.2    0.25
    OW2       0.11     0.14     0.21   0.24
    OW3       0.12     0.13     0.22   0.23
    OW4       0.13     0.12     0.23   0.22
    OW5       0.14     0.11     0.24   0.21
    OW6       0.15     0.10     0.25   0.20     ;

Table  ct2(j,k)   cost of transporting by truck from j to k
              City1  City2     IWell1 IWell2 IWell3
    Iclean1   999999 999999     2.1    2.425  2.25
    Iclean2   999999 999999     2.625  2.425  2.1
    Dclean1    1     1.5        2.1    2.1    2.625
    Dclean2    1.5   1          2.625  2.1    2.1 ;

Table  cp2(j,k)   cost of transporting by pipe from j to k
              City1  City2   IWell1 IWell2 IWell3
    Iclean1   999999 999999   0.1    0.1   0.125
    Iclean2   999999 999999   0.125  0.1   0.1
    Dclean1    -1.1  -1.05    0.1    0.1   0.125
    Dclean2    -1.05 -1.1     0.125  0.1   0.1 ;



Parameter  cc(j)   cost of cleaning at facility j
         /Iclean1  1
         Iclean2   1
         Dclean1   2
         Dclean2   2/;

Parameter  f(j)   cost of using facility j
         /Iclean1  10000000
         Iclean2   10000000
         Dclean1   11000000
         Dclean2   11000000/;

Parameter  f2(k)   cost of using sink k
         /City1  0
         City2   0
         Iwell1  50000
         IWell2  50000
         IWell3  50000/;


Parameter  W(i)   water produced at node i
         /OW1  4500
         OW2   5000
         OW3   5500
         OW4   6000
         OW5   6500
         OW6   7000/;

Parameter  A(k)   water aborbsed by node k
        /City1    35000
         City2    35000
         IWell1   20000
         IWell2   25000
         IWell3   30000/;

Parameter

         frt /2500000/
         frp /3000000/
         M /9999999999999/;



Positive Variables
     t(i,j) Water transported from node i to facility j by truck
     p(i,j) Water transported from node i to facility j by pipe
     t2(j,k) Water transported from node j to facility k by truck
     p2(j,k) Water transported from node j to facility k by pipe;

Variable
     z      total cost
     z1     cost of shipping to cleaning facilty
     z2     cost of cleaning
     z3     cost of shipping to sinks    ;

Binary variables
b(k) decision to inject or sell water at sink k
d(j) Decision to use facility j
e(i,j) Decision to truck between i and j
g(i,j) Decision to pipe between i and j
e2(j,k) Decision to truck between j and k
g2(j,k) Decision to pipe between j and k;




Equations
     cost1     cost of shipping to cleaning facilities
     cost2     cost of cleaning facilities
     cost3     cost of shipping to sinks
     cost        define objective function
     water(i)   controlling for water produced
     balance(j) water going into treatment facility has to come out of that facility
     sinkcap(k)     amount of water each sink can take
     sink(k)  decision to put water at sink k
     clean(j)  decision to open clean facility j
     truck(i,j) decision to use trucks on i to j
     pipe(i,j) decision to use pipes on i to j
     truck2(j,k) decision to use trucks on j to k
     pipe2(j,k) decision to use trucks on j to k;

cost1 ..        z1  =e=  sum((i,j), ct(i,j)*t(i,j)+cp(i,j)*p(i,j)+frt*e(i,j)+frp*g(i,j));
cost2..         z2 =e= sum((i,j),cc(j)*(t(i,j)+p(i,j))) + sum(j,f(j)*d(j));
cost3..         z3 =e= sum((j,k), ct2(j,k)*t2(j,k)+cp2(j,k)*p2(j,k)+frt*e2(j,k)+frp*g2(j,k)) + sum(k,f2(k)*b(k));
cost..          z =e= z1+z2+z3;
water(i)..    sum(j,t(i,j)+p(i,j))  =e=  W(i) ;
balance(j)..  sum(i,t(i,j)+p(i,j)) =e= sum(k,t2(j,k) + p2(j,k));
sinkcap(k)..  sum(j,t2(j,k)+p2(j,k))  =l=  A(k) ;
sink(k)..     sum(j,t2(j,k)+p2(j,k))  =l=  M*b(k);
clean(j)..    sum(i,t(i,j)+p(i,j))  =l=  M*d(j);
truck(i,j)..  t(i,j) =l= M*e(i,j);
pipe(i,j)..   p(i,j) =l= M*g(i,j);
truck2(j,k)..  t2(j,k) =l= M*e2(j,k);
pipe2(j,k)..   p2(j,k) =l= M*g2(j,k);





Model program / all /

option optcr = 0.0, optca = 0.0, mip = cplex ;

solve program using mip min z;

display z1.l, z2.l, z3.l, z.l, d.l, b.l, e.l, t.l, e2.l, t2.l, g.l, p.l, g2.l, p2.l;

