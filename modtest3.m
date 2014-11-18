
preflen=16;
carriernum=512;
impulseresponse=rand(15,1);
impulseresponse=impulseresponse/sum(impulseresponse.^2); %random impulse response with zero power gain
%initialise a ModDemod object
clear m;
m=ModDemod();
%fill up an array with random symbols. it has to be 2D for now (consider
%symbols(i,j)=the i'th symbol on the j'th carrier
symbols=ceil(rand(symnum*carriernum,1)*16); %symbols belongs to [1..16] because silly matlab array indexing. 32 random frames, with 512 carriers each
%create symbols
phasors=m.MapSymbols(symbols);
%modulate
signal=m.Modulate(phasors,preflen,carriernum);
%add noise
signal=m.AddNoise(signal,noisevar);
%demodulate
phasors=m.Demodulate(signal,preflen,carriernum);

%demodulate (returns array of a posteriori probabilities)
probabilities=m.PosteriorProb(phasors,noisevar);
%make a hard decision (MAP)
symrec=m.MAPdecision(probabilities);
%calculate error rate
errormap=find(symrec~=symbols);
errornum=numel(errormap);
errorrate=errornum/numel(symbols);
%visualise
%m.Scatter(phasors,errormap);
