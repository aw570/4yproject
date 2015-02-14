function [ information,pdf ] = ConstellationInformation( constellation, grid, noisevar )
%CONSTELLATIONENTROPY Calculate mutual information of consetllation
%  Calculate the mutual information of a constellation observed in an AWGN
%  channel. Also return the pdf of the received signal.

M=numel(constellation);
constellation=sqrt(M)*constellation/norm(constellation);

ypdf=zeros(size(grid));

for i=1:M
    ypdf=ypdf+reshape(mvnpdf(complex2components(grid(:)),complex2components(constellation(i)),eye(2)*noisevar)/M,gridpoints,gridpoints);
    


end

