%this used to be called ModDemod
classdef QpskMod<handle
    properties
        phasorList
        symProb
        noisevar
        impulseresponse
    end
    methods
        function obj=QpskMod(noisevar,impulseresponse)
            obj.phasorList=[1 1i -1 -1i];
            obj.symProb=ones(1,4)/4; %all 16 symbols are equiprobable
            obj.phasorList=obj.phasorList/sum(abs(obj.phasorList).^2.*obj.symProb); % normalise for unit average energy
            obj.noisevar=noisevar;
            obj.impulseresponse=impulseresponse; %time-domain convolution coefficients
        end
        function phasors=MapSymbols(obj,symbols)
            phasors=nan(size(symbols)+);
            phasors=obj.phasorList(symbols);
            phasors=[ones(numel(obj.impulseresponse))*obj.phasors(1);phasors];
        end
 
        function probabilities=PosteriorProb(obj,phasors)
            %calculate the a posteriori probability densities of each signal having
            %been transmitted. note: liable to catch fire if sigma=0
            %probabilities=f(symbol|observation)=f(observation and
            %symbol)/p(observation)
            sigma=obj.noisevar;
            probabilities=zeros([numel(phasors) numel(obj.phasorList)]);
            %initialise vector of appropriate size. pre-allocation of
            %memory improves performance
            eucdist=abs(phasors*ones(1,numel(obj.phasorList))-ones(numel(phasors),1)*obj.phasorList);
            probabilities=log(eucdist/sigma^2)-((eucdist/sigma).^2)/2+log(ones(numel(phasors),1)*obj.symProb);

        end
            
            
        function symbols=MAPdecision(obj,probabilities)
            %choose a transmitted signal based on maximum a posteriori
            [~,symbols]=max(probabilities,[],2);
        end
        function noisysig=Channel(obj,sig)
            noisysig=sig+(randn(size(sig))+1i*randn(size(sig)))*obj.noisevar; %add noise
            a=numel(noisysig);
             noisysig=conv(noisysig,obj.impulseresponse); % linear filter
             noisysig=noisysig(1:a);
        end

            
        function Scatter(obj,phasors,errormap)
            figure
            colours=zeros([numel(phasors) 1]);
            colours(errormap)=6;
            scatter(real(phasors(:)),imag(phasors(:)),[],colours)
            %axis([-.8 .8 -.8 .8])
        end
%         function Scatter(obj,phasors)
%             obj.Scatter(phasors,[]);
%         end
       
    end
end