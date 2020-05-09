function rep=FindGridIndex(rep,Grid)
global nObj    % 目标函数个数
nGrid=numel(Grid(1).LB);
rep.GridSubIndex=zeros(1,nObj);
for i=1:nObj
    rep.GridSubIndex(i) = find( rep.fitness(i)<Grid(i).UB,1,'first');
end

% 对GridIndex计算更新--每个目标函数的索引值
rep.GridIndex = rep.GridSubIndex(1);
for i=2:nObj
%     rep.GridIndex = nGrid*( rep.GridIndex-1 ) + rep.GridSubIndex(i);
    rep.GridIndex = rep.GridIndex + rep.GridSubIndex(i);
end