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
            obj.phasorList=[1 1i -1 -1i]';
            obj.symProb=ones(4,1)/4; %all 16 symbols are equiprobable
            obj.phasorList=obj.phasorList/sum(abs(obj.phasorList).^2.*obj.symProb); % normalise for unit average energy
            obj.noisevar=noisevar;
            obj.impulseresponse=impulseresponse; %time-domain convolution coefficients
        end
        function phasors=MapSymbols(obj,symbols)
            phasors=obj.phasorList(symbols);
            
            phasors=[ones(numel(obj.impulseresponse)-1,1)*obj.phasorList(1);phasors];%stuff it with ones, otherwise conv would stuff it with zeros and confuse viterbi
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
   
             noisysig=conv(noisysig,obj.impulseresponse,'valid'); % linear filter
            
        end
        function symbols=ViterbiDec(obj,phasors)
            N=numel(phasors);
            M=numel(obj.phasorList);
            L=numel(obj.impulseresponse); %not yet used
            ViterbiStates=zeros(numel(phasors),M,M); %note: filter is implicitly 2-tap
            ViterbiBranchMetric=ViterbiStates;
            ViterbiBranchMetric(1,:,2:end)=inf(M,M-1); %cost of symbol 0 being non-1 is infinite
            for i=1:M
                ViterbiBranchMetric(1,i,1)=norm(phasors(1)-obj.impulseresponse'*obj.phasorList([i 1]));
            end
%             ViterbiBranchMetric(1,:,1,1)            
            for t=2:N
                for j_0=1:M %j_k is the index of symbol k timesteps ago
                    for j_1=1:M
                        PathCost=norm(phasors(t)-obj.impulseresponse'*obj.phasorList([j_0,j_1]));
                        [val,index]=min(ViterbiBranchMetric(t-1,j_1,:));
                        ViterbiBranchMetric(t,j_0,j_1)=val+PathCost;
                        ViterbiStates(t,j_0,j_1)=index;
                    
                    end
                end
            end
            symbols=zeros(N,1);
            t=N;
            costs=squeeze(ViterbiBranchMetric(t,:,:));
            [~,i]=max(costs(:));
            [state(1),state(2)]=ind2sub(size(costs),i)
            symbols(t)=state(1);
            state(3)=ViterbiStates(t,state(1),state(2));
            for t=N-1:-1:1 
                state=[state(2:3), ViterbiStates(t,state(1),state(2))];
                symbols(t)=state(1);
            end
                
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