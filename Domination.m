function b = Domination(pop1,pop2)
b=0;
x = pop1.fitness;
y = pop2.fitness;

% b=1��֧�䣬������֧��
b=all(x<=y) && any(x<y);   % �Լ�СֵΪ��[/hide]