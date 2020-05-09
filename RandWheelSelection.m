function rand_Index=RandWheelSelection(P)

K = rand;
Pcum = cumsum(P);

rand_Index = find( K<Pcum,1,'first');