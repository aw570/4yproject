function zfe=makezfe(impulseresponse)
filtermatrix=toeplitz([impulseresponse zeros(1,512-numel(impulseresponse))],[impulseresponse(1), zeros(1,511)]);
delta=[zeros(511,1); 1];
zfe=filtermatrix\delta;
zfe=zfe';
end