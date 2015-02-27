% M=16;
iterations=128;
% noisevar=0.1;
gridsize=8;
gridpoints=1024;

Ms=[8:64]';
Ms=[16 64 256 1024]';
size(Ms)
snrs=[0:1:40]'; %decibels
size(snrs)
results=zeros(numel(snrs),numel(Ms));

for i=numel(Ms):-1:1
        M=Ms(i);
[constellation,grid]=LloydsOptimise(M,iterations,[],gridsize,gridpoints);
	for j=1:numel(snrs)
        fprintf('i=%d,j=%d\n',i,j)
        noisevar=10.^-(snrs(j)/20);
        
        results(j,i)=ConstellationInformation(constellation,noisevar,gridsize,gridpoints,grid);
    end
end
