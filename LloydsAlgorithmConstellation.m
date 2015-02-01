%We want to make a  constellation which looks like sigma=1 white noise
% colourmap=uint8([ 0 0 0 ; 0 0 255;0 255 0; 0 255 255;255 0 0; 255 0 255; 255 255 0; 255 255 255]);
gridsize=256;
gridbound=3; %most of the normal distribution is in this range
M=31;
line=ones(gridsize,1)*linspace(-gridbound,gridbound,gridsize);
grid=complex(line,line');
%constellationpoints=[1 1i -1 -1i complex(2,2) complex(2,-2) complex(-2,-2) complex(-2,2)]';
%constellationpoints=linspace(-2,2,8)';
constellationpoints=randn(M,1)+1i*randn(M,1);
for i=1:128
    distances=abs(repmat(grid,[1 1 numel(constellationpoints)])-permute(repmat(constellationpoints,[1 gridsize gridsize]),[2 3 1]));
%it is possible to do imshow(distances(:,:,n)) at this point to verify that
%everything is sane
    [~,nearestpoint]=min(distances,[],3);
%     imshow(nearestpoint/M); %this is the decision region map for the first guess
%      pause(0.2);
    for i=1:numel(constellationpoints)
        decisionregion=grid(nearestpoint==i);
        regionprob(i)=sum(normpdf_2d(decisionregion))*(2*gridbound/gridsize)^2;
        constellationpoints(i)=sum(decisionregion.*normpdf_2d(decisionregion))/sum(normpdf_2d(decisionregion));
    end
end
 imshow(nearestpoint/M);
regionprob