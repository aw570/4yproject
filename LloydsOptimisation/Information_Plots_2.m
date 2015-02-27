gridsize=10;
gridpoints=1024;
snrs=[-20:1:10]';
results=zeros(numel(snrs),1);
for j=1:numel(snrs)
    noisevar=10.^-(snrs(j)/10);
    fprintf('j=%d\n',j)
    results(j)=ConstellationInformation(constellation,noisevar,gridsize,gridpoints);
end
