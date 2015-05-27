function [ improvement] = ToneResTest( carriernum, reservednum,ntries)
%TONERESTEST Summary of this function goes here
%   Detailed explanation goes here
%simulate modulation of a single block with tone reservation

L=reservednum;
oversampling=1; %not implemented
phasorList=[1 -1 1i -1i];
symbols=ceil(rand((carriernum)-L,1)*numel(phasorList));
improvements=nan(ntries,1);
for j=1:ntries
    injected_carriers=randperm(carriernum,reservednum);

    X=zeros(carriernum,1);

    %get a list of *non*-reserved indicies
    indicies=true(carriernum,1);
    indicies(injected_carriers)=false;
    X(indicies)=phasorList(symbols);


    x=ifft(X);
    x_real=complexExplode(x);

    %injected_carriers2=[1+injected_carriers  513-injected_carriers(end:-1:1)];
    % cn2=2*(1+carriernum);
    Q=conj(dftmtx(carriernum)/carriernum); %idft matrix
    Qhat=Q(:,injected_carriers); 
    Qhat_exploded=complexExplode(Qhat);
    A=[[Qhat_exploded;-Qhat_exploded] -ones(4*carriernum,1)];
    % A_exploded=complexExplode(A);
    b=[-x;x];
    b_exploded=complexExplode(b);
    c=[zeros(L*2,1);1];
    % c_exploded=(c);

    % [Ct,~,exitflag]=linprog(c,A,b,Aeq,beq);
    % size(A_exploded)
    % size(b_exploded)
    [Ct_exploded,~,exitflag]=linprog(c,A,b_exploded);
    Ct=complexImplode(Ct_exploded(1:end-1));
    X2=X;
    % size(Ct(1:numel(Ct)/2-1))
    % size(Ct(numel(Ct)/2+1:end))

    X2(injected_carriers)=Ct;
    x2=ifft(X2);
    x2_real=complexExplode(x2);
    optimised_papr=max(abs(x2_real))./sum(abs(x2_real).^2);
    orig_papr=max(abs(x_real))/sum(abs(x_real).^2);
    improvements(j)=optimised_papr/orig_papr;
end
improvement=min(improvements);

end

