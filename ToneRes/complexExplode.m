function [ out ] = complexExplode( in )
%COMPLEXEXPLODE Convert vectors and matricies to exploded form
%   That means vector x -> [Re(x);Im(x)]
%   Matrix A -> [Re(A) -Im(A);Im(A) Re(A)]

if size(in,2)==1
    out=[real(in);imag(in)];
else
    out=[real(in) -imag(in);imag(in) real(in)];
end

end

