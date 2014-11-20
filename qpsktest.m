noisevar=0.1;
close all
impulseresponse=0.9.^[0 1 ]';
% impulseresponse=[1 .5+.6*1i]';
impulseresponse=impulseresponse/sum(impulseresponse.^2);
clear m;
m=QpskMod(noisevar,impulseresponse);
symbols=ceil(rand(2048,1)*4);
phasors=m.MapSymbols(symbols);
noisyphasors=m.Channel(phasors);

decoded=m.ViterbiDec(noisyphasors);
errormap=find(decoded~=symbols);
errors=numel(errormap);
m.Scatter(noisyphasors,errormap);
numsym=numel(symbols);
errors/numsym
