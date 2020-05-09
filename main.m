% 基于PSO算法的多目标函数寻优
clc,clear,close all
warning off
format longG
% web('halcom.cn')
global nObj
nObj = 2;   % 2个目标
nVar = 2;   % 2个未知量
% PSO 参数
c1 = 1.4995;  
c2 = 1.4995;
Vmin = -1;      % 粒子最大速度
Vmax = 1;       % 粒子最小速度
popmin1 = -1;  popmax1 = 1; % x1
popmin2 = -1;  popmax2 = 1; % x2
nVar=2;         % 未知量个数
maxiter = 50;   % 迭代次数
sizepop = 100;  % 种群数量
repository = 50; % 非支配解种群数量
w = 0.5;         % 初始权重
wdamp=0.99;      % 权重衰减因子
nGrid=7;            % 每个目标函数解集域的扩展网格大小，单周期数
alpha=0.1;          % 非支配解的解集的扩展因子
beta=2;             % 非支配解的选择因子
gamma=2;            % 非支配解的淘汰因子

% 初始化种群
x.Pos=[];  % 未知量的解
x.V=[];    % 粒子速度
x.fitness=[];         % 粒子适应度值
x.Best.Pos=[];        % 最优解
x.Best.fitness=[];    % 最优解对应的适应度值--目标函数值
x.IsDominated=[];        % 是否非支配解，支配解=1, 非支配解=0
x.GridIndex=[];          % 非支配解的网格化参数值-索引总循环数（并排目标函数的序列化内）
x.GridSubIndex=[];       % 每一个非支配解的网格化索引值（扩展取值范围内）
pop=repmat(x,sizepop,1); % 初始化的种群
clear x
for i=1:sizepop
    pop(i).Pos(1) = unifrnd(popmin1,popmax1,1);
    pop(i).Pos(2) = unifrnd(popmin2,popmax2,1);
    pop(i).V = zeros(1,nVar);
    % 适应度函数
    pop(i).fitness = fun(pop(i).Pos);
    % 种群个体最优
    pop(i).Best.Pos=pop(i).Pos;
    % 种群最优适应度值
    pop(i).Best.fitness=pop(i).fitness;
end

% 确定种群之间是否存在支配解
pop=JudgePopDomination(pop);
% 然后获取非支配解
rep=pop(~[pop.IsDominated]);
% 扩展非支配解的适应度函数取值范围
Grid=CreateGrids(rep,nGrid,alpha);
% 计算扩展非支配解的GridIndex
for i=1:numel(rep)
    rep(i)=FindGridIndex(rep(i),Grid);
end

%% AWPSO算法的多目标函数寻优主程序
for i=1:maxiter
    for j=1:sizepop
        % 轮盘赌算子随机选择一个非支配解，扰动解，避免陷入局部最优
% zbest=Selectzbest(rep,beta);
        zbest=rep(1);
        % 粒子速度更新
        pop(j).V = w*pop(j).V +c1*rand(1,nVar).*(pop(j).Best.Pos-pop(j).Pos) ...
            +c2*rand(1,nVar).*(zbest.Pos-pop(j).Pos);
        
        % 粒子位置更新
        pop(j).Pos = pop(j).Pos + 0.5*pop(j).V;
        
        % 粒子取值范围约束
        pop(j).Pos(1) = max(pop(j).Pos(1), popmin1);
        pop(j).Pos(1) = min(pop(j).Pos(1), popmax1);
        pop(j).Pos(2) = max(pop(j).Pos(2), popmin2);
        pop(j).Pos(2) = min(pop(j).Pos(2), popmax2);
        
        % 适应度函数值
        pop(j).fitness = fun(pop(j).Pos);

        % 是否受支配
        if Domination(pop(j),pop(j).Best)
            pop(j).Best.Pos=pop(j).Pos;
            pop(j).Best.fitness=pop(j).fitness;
        else
            if rand<0.5
                pop(j).Best.Pos=pop(j).Pos;
                pop(j).Best.fitness=pop(j).fitness;
            end
        end
    end
   
    % 增加非支配解
    rep =[rep; pop(~[pop.IsDominated])];
    % 非支配解是否有支配解
    rep=JudgePopDomination(rep);
    % 删除支配解
    rep=rep(~[rep.IsDominated]);
   
    % 扩展非支配解的适应度函数取值范围
    Grid=CreateGrids(rep,nGrid,alpha);
    for k=1:numel(rep)
        rep(k)=FindGridIndex(rep(k),Grid);
    end
   
    % 非支配解是否达到最大的非支配解的种群数
    if numel(rep)>repository
        % 将超过的种群删除
        Extra=numel(rep)-repository;
        for k=1:Extra
            rep=DeleteOneRepMemebr(rep,gamma);
        end
    end

     w=w*wdamp;  % 惯性权重
     
    figure(1);
    Plotfitness(pop,rep);
    pause(0.01);

end
% % 确定种群之间是否存在支配解
% pop=JudgePopDomination(pop);
% % 增加非支配解
% rep =[rep; pop(~[pop.IsDominated])];
% rep = uniqueRep(rep);
figure(1);
Plotfitness(pop,rep);

% 最优结果
for i=1:size( rep,1 )
    zbest_sol(i,:) = rep(i).Pos;
    if i==1
        fprintf('\n')
        disp('PSO多目标计算的第一组结果如下：')
        disp(['x1 = ',num2str(zbest_sol(i,1))])
        disp(['x2 = ',num2str(zbest_sol(i,2))])
        disp(['最优适应度值为  ',num2str([rep(i).fitness]')])
        fprintf('\n')
    else
        disp('PSO多目标计算结果有多个Pareto解集')
    end
end