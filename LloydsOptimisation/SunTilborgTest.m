M=64;
counts=4e3;
if mod(M,2)
    equipoints=[1/(M+1):1/(M+1):1-1/(M+1)].';
else
    equipoints=[1/2/M:1/M:1].';
end
gausspoints=norminv(equipoints);
equipoints=equipoints-.5;
equipoints=sqrt(M)*equipoints/norm(equipoints);
gausspoints=sqrt(M)*gausspoints/norm(gausspoints);
snrs=[-20:1:60];
results=nan(numel(snrs),2);
for i=1:numel(snrs)
    i
    noisevar=10.^-(snrs(i)/10);
    results(i,:)=[ConstellationInformationMC(gausspoints,noisevar,counts) ConstellationInformationMC(equipoints,noisevar,counts)];
end
    