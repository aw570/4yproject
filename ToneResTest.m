
%simulate modulation of a single block with tone injection
carriernum=255; %this is the number of /independent/ carriers. the remainder will be complex conjugates to make the signal real
% res_proportion=32; % 1 carrier in every (This number) is reserved
injected_carriers=[3 17 82 146 208];
%injected_carriers=[injected_carriers 513-injected_carriers];
L=numel(injected_carriers);
oversampling=1;
phasorList=[1 -1 1i -1i];
symbols=ceil(rand((carriernum)-L,1)*numel(phasorList));
X=zeros(carriernum,1);
indicies=true(carriernum,1);
indicies(injected_carriers)=false;
X(indicies)=phasorList(symbols);
%X is now the half-spectrum with zeros in place of the reserved carriers
X=[0;X;0;conj(X(end:-1:1))];
%and now the full spectrum
x=ifft(X,'symmetric');
injected_carriers2=[1+injected_carriers  513-injected_carriers(end:-1:1)];
cn2=2*(1+carriernum);
Q=conj(dftmtx(cn2)/cn2);
Qhat=Q(:,injected_carriers2);
A=[[Qhat;-Qhat] -ones(2*cn2,1)];
A=[real(A) -imag(A);imag(A) real(A)];
b=[-x;x];
b=[real(b);imag(b)];
c=[zeros(2*L,1);1];
c=[real(c);imag(c)];
Aeq=[zeros(1,4*L+1) 1];
beq=0;
Ct=linprog(c,A,b,Aeq,beq);
X2=X;
size(Ct(1:numel(Ct)/2-1))
size(Ct(numel(Ct)/2+1:end))
X2(injected_carriers2)=complex(Ct(1:numel(Ct)/2-1),Ct(numel(Ct)/2+1:end-1));
x2=ifft(X2);
max(abs(x2))./sum(abs(x2).^2)
max(abs(x))/sum(abs(x).^2)