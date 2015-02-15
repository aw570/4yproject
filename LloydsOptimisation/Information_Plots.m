% M=16;
iterations=32;
% noisevar=0.1;
gridsize=3;
gridpoints=256;

Ms=[8:64]';
size(Ms)
snrs=[0:1:40]'; %decibels
size(snrs)
results=zeros(numel(snrs),numel(Ms));

for i=numel(Ms):-1:1
    for j=1:numel(snrs)
        fprintf('i=%d,j=%d\n',i,j)
        noisevar=10.^-(snrs(j)/20);
        M=Ms(i);
        [constellation,grid]=LloydsOptimise(M,iterations,noisevar,gridsize,gridpoints);
        
        results(j,i)=ConstellationInformation(constellation,noisevar,gridsize,gridpoints,grid);
    end
end
