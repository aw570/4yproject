function [ y] = normpdf_radial( x )
%NORMPDF_2S Summary of this function goes here
%   Detailed explanation goes here
y=ones(size(x)); 
y(abs(x)<0.8)=0;
y(abs(x)>1.2)=0;
%  y=normpdf((sqrt(real(x).^2+imag(x).^2)-1));
y=abs(x).*exp(-abs(x).^2/2);
y=y/sum(y(:));

end

