tfunction hdist=hammingdist(a,b)
xored=bitxor(a-1,b-1);
hdist=zeros(size(xored));
hdist(find(ismember(xored,[1 2 4 8])))=1;
hdist(find(ismember(xored,[3 5 9 6 10])))=2;
hdist(find(ismember(xored,[11 7 14 13])))=3;
hdist(find(xored==15))=4;
end

