function [ y] = normpdf_2d( x )
%NORMPDF_2S Summary of this function goes here
%   Detailed explanation goes here
y=normpdf(real(x)).*normpdf(imag(x));

end

