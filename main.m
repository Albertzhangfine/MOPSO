% ����PSO�㷨�Ķ�Ŀ�꺯��Ѱ��
clc,clear,close all
warning off
format longG
% web('halcom.cn')
global nObj
nObj = 2;   % 2��Ŀ��
nVar = 2;   % 2��δ֪��
% PSO ����
c1 = 1.4995;  
c2 = 1.4995;
Vmin = -1;      % ��������ٶ�
Vmax = 1;       % ������С�ٶ�
popmin1 = -1;  popmax1 = 1; % x1
popmin2 = -1;  popmax2 = 1; % x2
nVar=2;         % δ֪������
maxiter = 50;   % ��������
sizepop = 100;  % ��Ⱥ����
repository = 50; % ��֧�����Ⱥ����
w = 0.5;         % ��ʼȨ��
wdamp=0.99;      % Ȩ��˥������
nGrid=7;            % ÿ��Ŀ�꺯���⼯�����չ�����С����������
alpha=0.1;          % ��֧���Ľ⼯����չ����
beta=2;             % ��֧����ѡ������
gamma=2;            % ��֧������̭����

% ��ʼ����Ⱥ
x.Pos=[];  % δ֪���Ľ�
x.V=[];    % �����ٶ�
x.fitness=[];         % ������Ӧ��ֵ
x.Best.Pos=[];        % ���Ž�
x.Best.fitness=[];    % ���Ž��Ӧ����Ӧ��ֵ--Ŀ�꺯��ֵ
x.IsDominated=[];        % �Ƿ��֧��⣬֧���=1, ��֧���=0
x.GridIndex=[];          % ��֧�������񻯲���ֵ-������ѭ����������Ŀ�꺯�������л��ڣ�
x.GridSubIndex=[];       % ÿһ����֧������������ֵ����չȡֵ��Χ�ڣ�
pop=repmat(x,sizepop,1); % ��ʼ������Ⱥ
clear x
for i=1:sizepop
    pop(i).Pos(1) = unifrnd(popmin1,popmax1,1);
    pop(i).Pos(2) = unifrnd(popmin2,popmax2,1);
    pop(i).V = zeros(1,nVar);
    % ��Ӧ�Ⱥ���
    pop(i).fitness = fun(pop(i).Pos);
    % ��Ⱥ��������
    pop(i).Best.Pos=pop(i).Pos;
    % ��Ⱥ������Ӧ��ֵ
    pop(i).Best.fitness=pop(i).fitness;
end

% ȷ����Ⱥ֮���Ƿ����֧���
pop=JudgePopDomination(pop);
% Ȼ���ȡ��֧���
rep=pop(~[pop.IsDominated]);
% ��չ��֧������Ӧ�Ⱥ���ȡֵ��Χ
Grid=CreateGrids(rep,nGrid,alpha);
% ������չ��֧����GridIndex
for i=1:numel(rep)
    rep(i)=FindGridIndex(rep(i),Grid);
end

%% AWPSO�㷨�Ķ�Ŀ�꺯��Ѱ��������
for i=1:maxiter
    for j=1:sizepop
        % ���̶��������ѡ��һ����֧��⣬�Ŷ��⣬��������ֲ�����
% zbest=Selectzbest(rep,beta);
        zbest=rep(1);
        % �����ٶȸ���
        pop(j).V = w*pop(j).V +c1*rand(1,nVar).*(pop(j).Best.Pos-pop(j).Pos) ...
            +c2*rand(1,nVar).*(zbest.Pos-pop(j).Pos);
        
        % ����λ�ø���
        pop(j).Pos = pop(j).Pos + 0.5*pop(j).V;
        
        % ����ȡֵ��ΧԼ��
        pop(j).Pos(1) = max(pop(j).Pos(1), popmin1);
        pop(j).Pos(1) = min(pop(j).Pos(1), popmax1);
        pop(j).Pos(2) = max(pop(j).Pos(2), popmin2);
        pop(j).Pos(2) = min(pop(j).Pos(2), popmax2);
        
        % ��Ӧ�Ⱥ���ֵ
        pop(j).fitness = fun(pop(j).Pos);

        % �Ƿ���֧��
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
   
    % ���ӷ�֧���
    rep =[rep; pop(~[pop.IsDominated])];
    % ��֧����Ƿ���֧���
    rep=JudgePopDomination(rep);
    % ɾ��֧���
    rep=rep(~[rep.IsDominated]);
   
    % ��չ��֧������Ӧ�Ⱥ���ȡֵ��Χ
    Grid=CreateGrids(rep,nGrid,alpha);
    for k=1:numel(rep)
        rep(k)=FindGridIndex(rep(k),Grid);
    end
   
    % ��֧����Ƿ�ﵽ���ķ�֧������Ⱥ��
    if numel(rep)>repository
        % ����������Ⱥɾ��
        Extra=numel(rep)-repository;
        for k=1:Extra
            rep=DeleteOneRepMemebr(rep,gamma);
        end
    end

     w=w*wdamp;  % ����Ȩ��
     
    figure(1);
    Plotfitness(pop,rep);
    pause(0.01);

end
% % ȷ����Ⱥ֮���Ƿ����֧���
% pop=JudgePopDomination(pop);
% % ���ӷ�֧���
% rep =[rep; pop(~[pop.IsDominated])];
% rep = uniqueRep(rep);
figure(1);
Plotfitness(pop,rep);

% ���Ž��
for i=1:size( rep,1 )
    zbest_sol(i,:) = rep(i).Pos;
    if i==1
        fprintf('\n')
        disp('PSO��Ŀ�����ĵ�һ�������£�')
        disp(['x1 = ',num2str(zbest_sol(i,1))])
        disp(['x2 = ',num2str(zbest_sol(i,2))])
        disp(['������Ӧ��ֵΪ  ',num2str([rep(i).fitness]')])
        fprintf('\n')
    else
        disp('PSO��Ŀ��������ж��Pareto�⼯')
    end
end