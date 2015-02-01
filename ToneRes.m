%this used to be called ModDemod
classdef ToneRes<handle
    properties
        phasorList
        symProb
        carriernum
        preflen
        noisevar
        impulseresponse
        equaliser
        oversampling
        res_proportion
        injectiontries %the number of different random patterns to try
    end
    methods
        function obj=ToneRes(carriernum,preflen,noisevar,impulseresponse,res_proportion)
            obj.phasorList=[1 -1 1i -1i];
            obj.phasorList=obj.phasorList/max(abs(obj.phasorList)); % normalise for unit peak energy
            obj.symProb=ones(1,4)/4; %all 4 symbols are equiprobable
            obj.phasorList=obj.phasorList/sum(abs(obj.phasorList).^2.*obj.symProb); % normalise for unit average energy
            obj.carriernum=carriernum;
            obj.preflen=preflen;
            obj.res_proportion=res_proportion;
            obj.noisevar=noisevar;
            obj.oversampling=4 %according to (FIND THE CITATION), this is a good oversampling factor for PAPR measurement
            obj.impulseresponse=impulseresponse; %time-domain convolution coefficients - NEED TP IMPLEMENT SOME OVERSAMPLING
            obj.equaliser=1./(fft(impulseresponse,carriernum*obj.oversampling)); %minimum mean-squared error frequency domain filter
            obj.injectiontries=128;
        end
        function signal=Modulate(obj,symbols)
            phasors=nan(numel(symbols)*(1/(1-1/obj.res_proportion)),1);
            indicies=find(mod((1:obj.carriernum)-1,obj.res_proportion));
            phasors(indicies)=obj.phasorList(symbols)
%             phasors=reshape(phasors,obj.carriernum,[]);
            randomphasors=randn(obj.carriernum/obj.res_proportion,obj.injectiontries)+1i*randn(obj.carriernum/obj.res_proportion,obj.injectiontries);
            paprs=nan(obj.injectiontries,1);
            randomphasors(:,end)=0;
            for i=[1:obj.injectiontries]
                phasors(1:obj.res_proportion:end)=randomphasors(:,i);
                signal=ifft(phasors,obj.carriernum*obj.oversampling);
%                 signal=[signal([(end-obj.preflen+1):end],:); signal];
           
%                 signal=signal(:); %flatten it into a long stream of samples
                paprs(i)=max(abs(signal)).^2/mean(abs(signal).^2);
            end
            sort(paprs./paprs(end))
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