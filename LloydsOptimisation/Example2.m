%Generate a 16-QAM optimised constellation, visualise it with decision
%regions and display pdf

M=64;
iterations=32;
noisevar=0.1;
gridsize=3;
gridpoints=256;

figure;;
plot(M,'+')
title('Seed constellation');

[ constellation, grid, nearestpoint,  informations,ypdf]=LloydsOptimise(-M,iterations,noisevar,gridsize,gridpoints);

figure;
ConstellationVisualise(constellation,nearestpoint,gridsize,gridpoints);
title('64-QAM optimised constellation')

figure;
plot(informations);
title(sprintf('%d-QAM, noisevar=%.1f, gridsize=%d, gridpoints=%d',numel(M),noisevar,gridsize,gridpoints));
xlabel('Iteration number')
ylabel('Mutual information (nats)')

figure;
mesh(real(grid),imag(grid),ypdf);
title('pdf of constellation in white noise')
