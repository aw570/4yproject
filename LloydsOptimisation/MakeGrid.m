function [ grid ] = MakeGrid( gridsize, gridpoints)
%MAKEGRID Summary of this function goes here
%   Detailed explanation goes here
line=ones(gridpoints,1)*linspace(-gridsize,gridsize,gridpoints);
grid=complex(line,line');

end

