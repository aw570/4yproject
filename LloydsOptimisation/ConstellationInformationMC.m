function [ information ] = ConstellationInformationMC( constellation, noisevar,samples)
%CONSTELLATIONENTROPY Calculate mutual information of consetllation
%  Calculate the mutual information of a constellation observed in an AWGN
%  channel using monte carlo

%note to self: remember that noisevar=sigma^2, sigma=sqrt(noisevar)


M=numel(constellation);
constellation=sqrt(M)*constellation/norm(constellation);

%calculate H(X)
HX=log(M);

%monte carlo for H(Y|X)
%first initialise a container

%pick a load of y values from the distribution
X=constellation(ceil(rand(samples,1)*M));
Y=X+complex(randn(samples,1),randn(samples,1)).*sqrt(noisevar);
%do a sanity check - delete this
plot(Y,'.')
axis equal
%now for each y value, compute the joint p(Y=y,X) for all X
pYX=reshape(mvnpdf(complex2components(repmat(Y,[M 1])),complex2components(reshape(repmat(constellation.',[samples 1]),[],1)),noisevar*eye(2)),samples,M)/M;
%now pYX(i,j)=p(Y(i),constellation(j));
%calculate p(X|Y=y)=p(X,Y=y)/sum over X(p(X,Y=y)
posterior=pYX./repmat(sum(pYX,2),[1 M]);
%any([isinf(posterior(:));isnan(posterior(:))])

%calculate H(Y|X)
HYX=-sum(xlogx(posterior),2);

information=mean(HX-HYX);




end

