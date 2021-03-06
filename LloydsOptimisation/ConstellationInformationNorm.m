function [ information,ypdf ] = ConstellationInformation( constellation, noisevar, gridsize, gridpoints)
%CONSTELLATIONENTROPY Calculate mutual information of consetllation
%  Calculate the mutual information of a constellation observed in an AWGN
%  channel. Also return the pdf of the received signal.

%note to self: remember that noisevar=sigma^2, sigma=sqrt(noisevar)

grid=MakeGrid(gridsize,gridpoints);

M=numel(constellation);
constellation=sqrt(M)*constellation/norm(constellation);
% mean(abs(constellation).^2)

% ypdf=zeros(size(grid));
% 
% for i=1:M
%     ypdf=ypdf+reshape(mvnpdf(complex2components(grid(:)),complex2components(constellation(i)),noisevar*eye(2))/M,gridpoints,gridpoints);
% end
%%Todo some day: make this monstrosity work
ypdf=reshape(sum(reshape(mvnpdf(complex2components(repmat(grid(:),[M 1])),complex2components(reshape(repmat(constellation.',[gridpoints.^2 1]),[],1)),noisevar*eye(2)),gridpoints.^2,M),2),gridpoints,gridpoints)/M;

% size(reshape(repmat(complex2components(constellation).',[gridpoints.^2 1]),[],1))
% size(repmat(complex2components(grid(:)),[M 1]))
% ypdf=reshape(mvnpdf(repmat(complex2components(grid(:)),[M 1]),reshape(repmat(complex2components(constellation).',[gridpoints.^2 1]),[],1),noisevar*eye(2))/M,gridpoints,gridpoints);
% size(ypdf);

pdfscale=sum(ypdf(:));

%calculate h(Y) (where y is the observed signal after AWGN channel)
hY=sum(-xlogx(ypdf(:))/sum(ypdf(:)));
%calculate h(Y|X), which is simply the entropy of the noise
hYX=1+log(2*pi*noisevar); % NOT sqrt(noisevar)... d'oh
%calculate I(Y;X)=h(Y)-h(Y|X)
information=hY-hYX;

end

