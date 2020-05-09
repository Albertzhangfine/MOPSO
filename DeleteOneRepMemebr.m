function rep=DeleteOneRepMemebr(rep,gamma)

    % 所有的非支配解节点索引数
    GridIndex=[rep.GridIndex];
    % 唯一出现的数值，从小到大排序
    unique_GridIndex=unique(GridIndex);
    % 初始化，唯一出现该数值的次数
    N=zeros(size(unique_GridIndex));
    for k=1:numel(unique_GridIndex)
        N(k)=numel(find(GridIndex==unique_GridIndex(k)));
    end
    % 选择概率
    P=exp(gamma*N);
    P=P/sum(P);
    % 轮赌法随机选择一个节点
    rand_Index=RandWheelSelection(P);
    % 获取对应节点的节点索引数
    rand_GridIndex=unique_GridIndex(rand_Index);
    % 在GridIndex中寻找rand_GridIndex所在的索引值
    index=find(GridIndex==rand_GridIndex);
    % 在【1到numel(index)】之间随机生成一个整数
    integer=randi([1 numel(index)]);
    % zbest
    rep(index(integer)) = [];