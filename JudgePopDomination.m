function pop = JudgePopDomination(pop)
sizepop = numel(pop);  % 种群数量
for i=1:sizepop
    pop(i).IsDominated=0;
end

for i=1:sizepop-1
    for j=i+1:sizepop
        b1 = Domination(pop(i),pop(j));
        b2 = Domination(pop(j),pop(i));
        if b1==1
            pop(j).IsDominated=1;
        end
        if b2==1
            pop(i).IsDominated=1;
        end
    end
end