Sets
i Craft area /1,2,3,4/
j Priority /1,2,3,4/;

Parameters
D(i) 'artificial cost to assign regular before project crews a function of backlog '
/
1 2
2 3
3 1
4 4
/

S(i) 'supply of regular crew labor-hours available in craft area i '
/
1 1440
2 960
3 1632
4 144
/
;
Table Q(i,j) ' labor-hours required in craft area i for completion of priority j work orders'
   1      2    3    4
1  1080  720  360   0 
2  600   600  240   0
3  1350  480  630   0
4  90    90   60    0
;
Table V(i,j) ' artificial cost to stimulate completing high priority work orders first'
    1   2   3   4
1   0   10  15  17
2   0   10  15  17
3   0   10  15  17
4   0   10  15  17      
;

Scalars
T 'supply of project crew labor-hours available ' /864/
B 'base maintenance cost per hour ' /25/
m ' fraction of work that must be done by regular crew before using project crew' /0.5/
k 'fraction of total labor-hours that can be added as overtime' /0.05/;

Variables
z 'objective fucntion to minimize cost'
R(i,j) 'hours used by the regular crew in craft area i to satisfy priority j work orders'
P(i,j) 'hours used by the projects crew in craft area i to satisfy priority j work orders'
U(i,j) 'unscheduled hours in craft area i for priority j work orders';

Positive variable R(i,j),P(i,j),U(i,j);

Equations
Objective 'objective function to minimize cost'
Const1 ' Regular crew supply constraint'
Const2 'Project Crew Supply constraint'
Const3 'Overtime constraint'
Const4 ' Regular Crew demand constarint for #1 priority work'
Const5 ' Labour Demand Constraint for #1 priority work'
Const6 ' unscheduled hours constraint-1'
Const7 ' unscheduled hours constraint-2';

Objective.. z=e=sum((i,j),((B+V(i,j))*R(i,j))+((B+V(i,j)+D(i))*P(i,j))+(U(i,j)*99));
Const1(i).. sum(j,R(i,j-1))=l=S(i);
Const2.. sum((i,j),P(i,j))=l=T;
Const3.. sum(i,R(i,'4')+P(i,'4'))=l=k*(T+sum((i),S(i)));
Const4(i).. R(i,'1')=g=m*(R(i,'1')+P(i,'1'));
Const5(i).. R(i,'1')+P(i,'1')+R(i,'4')+P(i,'4')=e=Q(i,'1');
Const6(i).. R(i,'2')+P(i,'2')+U(i,'2')=e=Q(i,'2');
Const7(i).. R(i,'3')+P(i,'3')+U(i,'3')=e=Q(i,'3');

Model maintenance/all/;

Solve maintenance using lp minimizing z;

Display z.l,R.l,P.l,U.l;
