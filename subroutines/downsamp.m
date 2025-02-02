%%
function DS = downsamp(padd1,detpxl)

n1 = padd1/detpxl;
a1 = sparse([ones(1,n1) zeros(1,padd1-n1)])/n1;

DS(1,:) = a1;
for ctr = 2:detpxl
    DS(ctr,:) = circshift(a1,[0 (ctr-1)*n1]);
end