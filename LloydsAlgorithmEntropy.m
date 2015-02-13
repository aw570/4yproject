constellation_norm=sqrt(M)*constellationpoints/norm(constellationpoints); %normalise for unit energy
ypdf=zeros(size(grid));
noisevar=.1;
for j=1:M
    thispdf=reshape(mvnpdf([real(grid(:)) imag(grid(:))],[real(constellation_norm(j)) imag(constellation_norm(j))],eye(2)*noisevar)/M,gridsize,gridsize);
%     mesh(real(grid),imag(grid),thispdf);
%     pause(5);
    ypdf=ypdf+thispdf;
end
% contour(real(grid),imag(grid),ypdf);
constellationentropy=sum(-xlogx(ypdf(:)))*((2*gridbound)/gridsize)^2-log(sqrt(noisevar)*(2*pi*exp(1)));