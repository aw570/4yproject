function [ out ] = complexImplode( in )
%COMPLEXIMPLODE undo what complexExplode did
%   Detailed explanation goes here
halfway=size(in,1)/2;
if size(in,2)==1
    
    out=complex(in(1:halfway),in((halfway+1):end));
else
    %there is no sanity check here to make sure this is of the right form
    out=complex(in(1:halfway,1:halfway),in((halfway+1):end,1:halfway));
end

