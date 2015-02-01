%simulate modulation of a single block with tone injection
% carriernum=512;
% res_proportion=32; % 1 carrier in every (This number) is reserved
oversampling=4;
injectiontries=256; %how many different patterns to try
phasorList=[1 -1 1i -1i];
symbols=ceil(rand(carriernum*(1-1/res_proportion),1)*numel(phasorList));
phasors=nan(carriernum,1);
indicies=logical(mod((1:carriernum)-1,res_proportion));
phasors(indicies)=phasorList(symbols);
randomphasors=randn(carriernum/res_proportion,injectiontries)+1i*randn(carriernum/res_proportion,injectiontries);
paprs=nan(injectiontries,1);
randomphasors(:,end)=0; %no injection on the last one, for comparison
for i=[1:injectiontries]
phasors(1:res_proportion:end)=randomphasors(:,i);
signal=ifft(phasors,carriernum*oversampling);
%                 signal=[signal([(end-obj.preflen+1):end],:); signal];

%                 signal=signal(:); %flatten it into a long stream of samples
paprs(i)=max(abs(signal)).^2/mean(abs(signal).^2);
end
minpapr=min(paprs);