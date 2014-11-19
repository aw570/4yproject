%this used to be called ModDemod
classdef OfdmMod<handle
    properties
        phasorList
        symProb
        carriernum
        preflen
        noisevar
        impulseresponse
        equaliser
    end
    methods
        function obj=OfdmMod(carriernum,preflen,noisevar,impulseresponse)
            obj.phasorList=complex([-3  -1  3 1 -3 -1 3 1 -3 -1 3 1 -3 -1 3 1],[ones(4,1)'*-3 ones(4,1)'*-1, ones(4,1)'*3 ones(4,1)']);
            obj.phasorList=obj.phasorList/max(abs(obj.phasorList)); % normalise for unit peak energy
            obj.symProb=ones(1,16)/16; %all 16 symbols are equiprobable
            obj.phasorList=obj.phasorList/sum(abs(obj.phasorList).^2.*obj.symProb); % normalise for unit average energy
            obj.carriernum=carriernum;
            obj.preflen=preflen;
            obj.noisevar=noisevar;
            obj.impulseresponse=impulseresponse; %time-domain convolution coefficients
            obj.equaliser=1./(fft(impulseresponse,carriernum)); %minimum mean-squared error frequency domain filter
%             obj.equaliser=fft(makezfe(impulseresponse));
        end
        function phasors=MapSymbols(obj,symbols)
            phasors=nan(size(symbols));
            phasors=obj.phasorList(symbols);
        end
        function signal=Modulate(obj,phasors)
            phasors=reshape(phasors,obj.carriernum,[]);
            signal=ifft(phasors);
            signal=[signal([(end-obj.preflen+1):end],:); signal];
           
            signal=signal(:); %flatten it into a long stream of samples
        end
        function phasors=Demodulate(obj,signal)
            signal=reshape(signal,obj.carriernum+obj.preflen,[]);
            
            signal=signal((obj.preflen+1):end,:);
            
            phasors=fft(signal);
            obj.Scatter(phasors,[]);
      
             phasors=phasors.*(obj.equaliser*ones(1,size(phasors,2)));
       
            phasors=phasors(:);
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