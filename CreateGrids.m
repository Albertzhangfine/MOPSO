function Grid=CreateGrids(rep,nGrid,alpha)
global nObj
F = [rep.fitness];
Fmin = min(F,[],2);
Fmax = max(F,[],2);

% 适应度值范围扩展
dF=Fmax-Fmin;
Fmin=Fmin-alpha*dF;
Fmax=Fmax+alpha*dF;

for i=1:nObj
    Grid(i).LB = [];
    Grid(i).UB = [];
end

for i=1:nObj
   Fi = linspace( Fmin(i),Fmax(i), nGrid+1 );
   Grid(i).LB = [-inf, Fi];
   Grid(i).UB = [Fi, +inf];
end