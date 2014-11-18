noisevars=logspace(0,-3,1024);
bers=nan(size(noisevars));
symnum=1;
for i=1:numel(noisevars)
    noisevar=noisevars(i);
    modtest3
    bers(i)=errorrate;
    if errornum<64
        i
        symnum=symnum*2
        if symnum>1024*8
            break
        end
    end
end

    