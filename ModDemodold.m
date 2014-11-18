classdef ModDemod<handle
    properties
        phasorList
        symProb
    end
    methods
        function obj=ModDemod()
            obj.phasorList=complex([-3  -1  3 1 -3 -1 3 1 -3 -1 3 1 -3 -1 3 1],[ones(4,1)'*-3 ones(4,1)'*-1, ones(4,1)'*3 ones(4,1)']);
            obj.phasorList=obj.phasorList/max(abs(obj.phasorList)); % normalise for unit peak energy
            obj.symProb=ones(1,16)/16; %all 16 symbols are equiprobable
            obj.phasorList=obj.phasorList/sum(abs(obj.phasorList).^2.*obj.symProb); % normalise for unit average energy

        end
        function phasors=MapSymbols(obj,symbols)
            phasors=nan(size(symbols));
            phasors=obj.phasorList(symbols);
        end
        function signal=Modulate(obj,phasors,preflen)
            signal=ifft(phasors,[],2);
            %signal=[signal(:,[(end-preflen+1):end]) signal];
        end
        function phasors=Demodulate(obj,signal,preflen)
            %signal=signal(:,(preflen+1):end);
            phasors=fft(signal,[],2);
        end
 
        function probabilities=PosteriorProb(obj,phasors,sigma)
            %calculate the a posteriori probability densities of each signal having
            %been transmitted. note: liable to catch fire if sigma=0
            %probabilities=f(symbol|observation)=f(observation and
            %symbol)/p(observation)
            probabilities=zeros([size(phasors) numel(obj.phasorList)]);
            %initialise vector of appropriate size. pre-allocation of
            %memory improves performance
            for i=[1:numel(obj.phasorList)] %todo: vectorise this
                eucdist=abs(phasors-obj.phasorList(i));
                probabilities(:,:,i)=eucdist.*exp(-((eucdist/sigma).^2)/2)/(sigma*sigma);
                %probabilities(j,k,i)=probability density of observation j,k given
                %i was transmitted=f(j,k|i)
                probabilities(:,:,i)=probabilities(:,:,i)*obj.symProb(i);
%                 max(max(probabilities(:,:,i))')
                %any(any(isnan(probabilities(:,:,i)))')
                %probabiltities(j,k,i) contains f(j,k UNION
                %i)=f(j,k|i)*Pr(i)
            end
           
            %now condition on i transmitted: Pr(i | j,k)=f(j,k UNION
            %i)/f(j,k) where f(j,k)= sum over i of f(j,k UNION i)
            for j=[1:size(phasors,1)] %also needs to be vectorised
                for k=[1:size(phasors,2)]
                        %sum(squeeze(probabilities(j,k,:)))
                        
                        probabilities(j,k,:)=probabilities(j,k,:)/(sum(squeeze(probabilities(j,k,:))));
                end
            end
        end
            
            
        function symbols=MAPdecision(obj,probabilities)
            %choose a transmitted signal based on maximum a posteriori
            [~,symbols]=max(probabilities,[],3);
        end
        function noisysig=AddNoise(obj,sig,sigma)
            noisysig=sig+(randn(size(sig))+1i*randn(size(sig)))*sigma;
        end
        function Scatter(obj,phasors,errormap)
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