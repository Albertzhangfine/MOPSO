function Plotfitness(pop,rep)
    % ɾ�������ʵĽ⼯
    flag=[];
    for i=1:size(pop,1)
        if(pop(i).fitness(1) == 1e6 && pop(i).fitness(2) == 1e6)
            flag = [flag, i];
        end
    end
    pop(flag) = [];
   
    % ֧���
    pop_fitness=[pop.fitness];
    plot(pop_fitness(1,:),pop_fitness(2,:),'ko');
    hold on;
    popBest_fitness=[pop.Best];
    popBest_fitness=[popBest_fitness.fitness];
    plot(popBest_fitness(1,:),popBest_fitness(2,:),'b.');
    % ��֧���
    rep_fitness=[rep.fitness];
    plot(rep_fitness(1,:),rep_fitness(2,:),'r*');
   
    xlabel('1^{st} Objective');
    ylabel('2^{nd} Objective');
   
    grid on;
    hold off;

end