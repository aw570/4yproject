counts=1e4;
snrs=[-20:1:40]';
results=zeros(numel(snrs),1);
for j=1:numel(snrs)
    noisevar=10.^-(snrs(j)/10);
    fprintf('j=%d\n',j)

    results(j,1)=ConstellationInformationMC(constellation,noisevar,counts);
    results(j,2)=ConstellationInformationMC(constellation2,noisevar,counts);

end

