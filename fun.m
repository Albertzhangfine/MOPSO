function fitness = fun(x)
y1 = (x(1)-0.1)^2+(x(2)-0.9)^2;
y2 = -20*exp(-0.2*sqrt((x(1)^2+x(2)^2)/2))-exp((cos(2*pi*x(1))+cos(2*pi*x(2)))/2)+20+2.71289;
fitness = [y1;y2];
