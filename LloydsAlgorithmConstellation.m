%We want to make a  constellation which looks like sigma=1 white noise
% colourmap=uint8([ 0 0 0 ; 0 0 255;0 255 0; 0 255 255;255 0 0; 255 0 255; 255 255 0; 255 255 255]);
gridsize=256;
gridbound=3; %most of the normal distribution is in this range
M=64;
for i=1:M
    colourmap(i,:)=mod([i/M 2*i/M 4*i/M]-.5,1); %fix this
end
line=ones(gridsize,1)*linspace(-gridbound,gridbound,gridsize);
grid=complex(line,line');
%constellationpoints=[1 1i -1 -1i complex(2,2) complex(2,-2) complex(-2,-2) complex(-2,2)]';
%constellationpoints=linspace(-2,2,8)';
constellationpoints=rand(M,1)+1i*rand(M,1);
%%16-qam square
% constellationpoints=complex([-3  -1  3 1 -3 -1 3 1 -3 -1 3 1 -3 -1 3 1],[ones(4,1)'*-3 ones(4,1)'*-1, ones(4,1)'*3 ones(4,1)'])';
% constellationpoints=constellationpoints./norm(constellationpoints);
%%64-qam square
constellationline=ones(8,1)*[-7:2:7];
constellationpoints=complex(constellationline,constellationline');
constellationpoints=constellationpoints(:)./norm(constellationpoints);
entropies=[];
for i=1:16
    distances=abs(repmat(grid,[1 1 numel(constellationpoints)])-permute(repmat(constellationpoints,[1 gridsize gridsize]),[2 3 1]));
%it is possible to do imshow(distances(:,:,n)) at this point to verify that
%everything is sane
     LloydsAlgorithmEntropy;
    entropies=[entropies constellationentropy];
    [~,nearestpoint]=min(distances,[],3);
%      imshow(nearestpoint/M); %this is the decision region map for the first guess
%       pause(2);
    for i=1:numel(constellationpoints)
        decisionregion=grid(nearestpoint==i);
        regionprob(i)=sum(normpdf_2d(decisionregion))*(2*gridbound/gridsize)^2;
        constellationpoints(i)=sum(decisionregion.*normpdf_2d(decisionregion))/sum(normpdf_2d(decisionregion)); 
    end
    
end
close all;
 imshow(nearestpoint,colourmap);
 hold on;
 cp_scaled=round((constellationpoints)*gridsize/(gridbound*2))+(1+1i)*gridsize/2;
 plot(real(cp_scaled),imag(cp_scaled),'+');
 hold off;