function [ output_args ] = complex2components( input_args )
%COMPLEX2COMPONENTS Convert complex column vector to n-by-2 real vector

output_args=[real(input_args) imag(input_args)];


end

