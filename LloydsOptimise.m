function [ constellation,  entropies, pdf] = LloydsOptimise( constellation, iterations, noisevar, gridsize, gridpoints)
%LLOYDSOPTIMISE Create a constellation using Lloyd's algorithm
%Create an optimised QAM constellation using lloyd's algorithm with
%gaussian weightings. Usage:
% [constellation, entropies, pdf] =
% LloydsOptimise(constellation,iterations,noisevar,gridsize,gridpoints)
% constellation can take 3 forms:
% A column vector of complex constellation points

%Generate random constellation if necessary
if numel(constellation)==1
    M=abs(constellation);
    if constellation>0
        constellation=complex(randn(M,1),randn(M,1));
        constellation=constellation/norm(constellation);
    else
        % Will assume user is not an idiot, and therefore will not check
        % that this is actually a square number.
        constellationline=ones(8,1)*[-7:2:7];

else
    M=numel(constellation);
end

%Create a grid
line=ones(gridpoints,1)*linspace(-gridsize,gridsize,gridpoints);
grid=complex(line,line');
clear line;

%Perform the iteration
for i=1:iterations
%     distances=abs(repmat(grid,[1 1 numel(constellationpoints)])-permute(repmat(constellationpoints,[1 gridsize gridsize]),[2 3 1]));
%     [~,nearestpoint]=min(distances,[],3);
    nearestpoint=dsearchn(complex2components(constellation(:)),complex2components(grid(:))); %not quite the same as the above two lines it replaces, i think due to edge cases (two equal distances)
    
    


end

