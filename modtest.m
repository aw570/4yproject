noisevar=0.2
preflen=16
%initialise a ModDemod object
clear m;
m=ModDemod();
%fill up an array with random symbols. it has to be 2D for now (consider
%symbols(i,j)=the i'th symbol on the j'th carrier
symbols=ceil(rand(1024,512)*16); %symbols belongs to [1..16] because silly matlab array indexing. 1024 random symbols, with 512 carriers
%modulate
phasors=m.MapSymbols(symbols);
%add noise
phasors=m.AddNoise(phasors,noisevar);
%visualise
m.Scatter(phasors);
%demodulate (returns array of a posteriori probabilities)
probabilities=m.PosteriorProb(phasors,noisevar);
%make a hard decision (MAP)
symrec=m.MAPdecision(probabilities);
%calculate error rate
errornum=numel(find(symrec~=symbols));
errorrate=errornum/numel(symbols);
fprintf('Received %d symbols, including %d errors. Error rate=%.2f percent\n',numel(symrec),errornum,100*errorrate)
