load results2.mat
indicies=[1 9 25 57]; %corresponds to 8,16,32,64
unconstrained=log(sqrt(1+10.^(snrs/20)));
plot([results(:,indicies) unconstrained])


