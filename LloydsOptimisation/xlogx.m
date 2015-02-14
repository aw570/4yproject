function [ out ] = xlogx( in )
%Calculate xlogx, but without catching fire and returning NaN (-Inf*0) for x=0
out=zeros(size(in));
indicies=(in~=0);
out(indicies)=in(indicies).*log(in(indicies));


end

