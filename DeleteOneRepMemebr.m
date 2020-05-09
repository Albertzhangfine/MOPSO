function rep=DeleteOneRepMemebr(rep,gamma)

    % ���еķ�֧���ڵ�������
    GridIndex=[rep.GridIndex];
    % Ψһ���ֵ���ֵ����С��������
    unique_GridIndex=unique(GridIndex);
    % ��ʼ����Ψһ���ָ���ֵ�Ĵ���
    N=zeros(size(unique_GridIndex));
    for k=1:numel(unique_GridIndex)
        N(k)=numel(find(GridIndex==unique_GridIndex(k)));
    end
    % ѡ�����
    P=exp(gamma*N);
    P=P/sum(P);
    % �ֶķ����ѡ��һ���ڵ�
    rand_Index=RandWheelSelection(P);
    % ��ȡ��Ӧ�ڵ�Ľڵ�������
    rand_GridIndex=unique_GridIndex(rand_Index);
    % ��GridIndex��Ѱ��rand_GridIndex���ڵ�����ֵ
    index=find(GridIndex==rand_GridIndex);
    % �ڡ�1��numel(index)��֮���������һ������
    integer=randi([1 numel(index)]);
    % zbest
    rep(index(integer)) = [];