numeach=64;
carriernum=256;
reservednums=2:32;
improvements=nan(size(reservednums));
more off;
for i=1:numel(reservednums)
    reservednum=reservednums(i)
    improvements(i)=ToneResTest(carriernum,reservednum,32);
end
