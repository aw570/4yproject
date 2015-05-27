function [  ] = ConstellationVisualise( constellation,nearestpoint,gridsize,gridpoints )
%CONSTELLATIONVISUALISE Summary of this function goes here
%   Detailed explanation goes here

M=numel(constellation);
%Generate a colourmap (there must be a nicer way to do this - maybe using 4
%colour theorem
% colourmap=[];
% for i=1:M
%    colourmap=[colourmap; i/M mod(2*i,M)/M mod(4*i,M)/M];
% end
colourmap=jet(M);
colourmap=colourmap(randperm(M),:);

imshow(nearestpoint,colourmap);
hold on;
constellation_scaled=round(constellation*gridpoints/gridsize/2+complex(1,1)*gridpoints/2);
plot(constellation_scaled,'+');
hold off;

end

