function [ constellation, grid, nearestpoint, informations, ypdf] = LloydsOptimise_ArbitraryFn( constellation, iterations, noisevar, gridsize, gridpoints)
%LLOYDSOPTIMISE Create a constellation using Lloyd's algorithm
%Create an optimised QAM constellation using lloyd's algorithm with
%gaussian weightings. Usage:
% [constellation, nearestpoint, informations, pdf] =
% LloydsOptimise(constellation,iterations,noisevar,gridsize,gridpoints)
% constellation can take 3 forms:
% A column vector of complex constellation points
% A positive scalar integer, in which case a random constellation of this
% size will be generated
% A negative scalar square number, in which case a square constellation of
% this size will be generated. (eg constellation=-16 will create a QAM
% constellation)
%
%The optimised constellation is output as constellation, an M-by-1 complex
%
%grid is a gridponts-by-gridpoints matrix of linearly space complex points
%on the gridsize-by-gridsize plane
%
%nearestpoint is a gridpoints-by-gridpoints matrix indicating which
%constellation point is closest to each point on the grid.
%
%The mutual informations are calculated at each iteration and are output as
%the iterations-by-1 vector iterations
%
%pdf is a gridpoints-by-gridpoints matrix of matricies
%
%Note: operation is sped up significantly when using only the first 3
%output arguments (not mutual information of y PDF). In this case the
%noisevar argument will be ignored

debug=false;
normalise=true;

%Generate random constellation if necessary
if numel(constellation)==1
    M=abs(constellation);
    if constellation>0
        constellation=complex(randn(M,1),randn(M,1));
    else
        % Will assume user is not an idiot, and therefore will not check
        % that this is actually a square number.
        M=-constellation;
        m=sqrt(M);
        constellationline=ones(m,1)*((1-m):2:(m-1));
        constellation=complex(constellationline,constellationline');
        constellation=constellation(:);
        clear constellationline m;
    end

else
    M=numel(constellation);
end
constellation=sqrt(M)*constellation/norm(constellation);

%Create a grid
grid=MakeGrid(gridsize,gridpoints);

%Create and empty informations vector
informations=zeros(iterations,1);

%Perform the iteration
for i=1:iterations
%     distances=abs(grid(:)*ones(1,M)-ones(gridpoints^2,1)*constellation');
%     [~,nearestpoint]=min(distances,[],2);
    %%the 2 lines above are faster (~2x) than the one below, but seem to
    %%inexplicably flip the imaginary axis upside down
    nearestpoint=dsearchn(complex2components(constellation(:)),complex2components(grid(:))); %i think there's some way to speed up this command
   
    if debug
        ConstellationVisualise(constellation,reshape(nearestpoint,gridpoints,gridpoints),gridsize,gridpoints);
        print(sprintf('intermediate%d.png',i),'-dpng','-r300');
%         pause(.5);
    end
    
    for j=1:M
        decisionregion=grid(nearestpoint==j);
        thispdf=normpdf_radial(decisionregion);
        constellation(j)=sum(decisionregion.*thispdf)/sum(thispdf); %find the gaussian-weighted centroid
    end
    if nargout>3
        [informations(i)]=ConstellationInformationMC(constellation,noisevar,1e5);
    end
    
    if normalise
        constellation=sqrt(M)*constellation/norm(constellation);
    end

end

[~,ypdf]=ConstellationInformation(constellation,noisevar,gridsize,gridpoints);


if iterations~=0    
nearestpoint=reshape(nearestpoint,gridpoints,gridpoints);
end

end

