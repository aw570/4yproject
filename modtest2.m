noisevar=0.01;
preflen=16;
carriernum=512;
close all
% impulseresponse=rand(16,1);
impulseresponse=079.^[0:13]';
% impulseresponse=[1 1+1i]';
% impulseresponse=1;
 impulseresponse=impulseresponse/sum(impulseresponse.^2); %random impulse response with zero power gain

tic
%initialise a ModDemod object
clear m;
m=OfdmMod(carriernum,preflen,noisevar,impulseresponse);
%fill up an array with random symbols. it has to be 2D for now (consider
%symbols(i,j)=the i'th symbol on the j'th carrier
symbols=ceil(rand(32*carriernum,1)*16); %symbols belongs to [1..16] because silly matlab array indexing. 32 random frames, with 512 carriers each
%create symbols
phasors=m.MapSymbols(symbols);
%modulate
signal=m.Modulate(phasors);
%add noise
signal=m.Channel(signal);

%demodulate
phasors=m.Demodulate(signal);
%m.EyeDiag(phasors);
%demodulate (returns array of a posteriori probabilities)
probabilities=m.PosteriorProb(phasors);
%make a hard decision (MAP)
symrec=m.MAPdecision(probabilities);
%calculate error rate
errormap=find(symrec~=symbols);
errornum=numel(errormap);
errorrate=errornum/numel(symbols);
fprintf('Received %d symbols, including %d errors. Error rate=%.2f percent\n',numel(symrec),errornum,100*errorrate)
toc
%visualise
m.Scatter(phasors,errormap);
