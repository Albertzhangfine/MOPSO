function b = Domination(pop1,pop2)
b=0;
x = pop1.fitness;
y = pop2.fitness;

% b=1受支配，否则不受支配
b=all(x<=y) && any(x<y);   % 以极小值为例[/hide]