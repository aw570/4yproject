function [ information,ypdf ] = ConstellationInformation( constellation, noisevar, gridsize, gridpoints, grid )
%CONSTELLATIONENTROPY Calculate mutual information of consetllation
%  Calculate the mutual information of a constellation observed in an AWGN
%  channel. Also return the pdf of the received signal.

%note to self: remember that noisevar=sigma^2, sigma=sqrt(noisevar)

M=numel(constellation);
constellation=sqrt(M)*constellation/norm(constellation);
% mean(abs(constellation).^2)

ypdf=zeros(size(grid));

for i=1:M
    ypdf=ypdf+reshape(mvnpdf(complex2components(grid(:)),complex2components(constellation(i)),noisevar*eye(2))/M,gridpoints,gridpoints);
end

%calculate h(Y) (where y is the observed signal after AWGN channel)
hY=sum(-xlogx(ypdf(:)))*((2*gridsize)/gridpoints)^2;
%calculate h(Y|X), which is simply the entropy of the noise
hYX=1+log(2*pi*sqrt(noisevar));
%calculate I(Y;X)=h(Y)-h(Y|X)
information=hY-hYX;

end

