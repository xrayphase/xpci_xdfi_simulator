%%
function [Is,Ibg] = grating_stepping(Upad,detpxl,flap,nscan,dphi,period, ...
    bimask1,bimask2,DS,Trans_F,FTI0)

%%
Is = zeros(detpxl,detpxl,nscan);
Ibg = Is;

for num = 1:nscan
    g1 = circshift(exp(1i*dphi*bimask1),[(num-1)/nscan*period 0]);
%     g1 = circshift(bimask1,[(num-1)/nscan*period 0]);
   
    tmp = Fresnel_propagation(Upad.*g1,Trans_F);
    tmp = tmp.*bimask2;
    tmp = (abs(tmp).^2);
    tmp = source_blur(tmp,FTI0);
    tmp = (DS*tmp)*DS.';
    Is(:,:,num) = tmp(1+flap:end-flap,1+flap:end-flap);
    
    tmp = Fresnel_propagation(g1,Trans_F);
    tmp = tmp.*bimask2;
    tmp = (abs(tmp).^2);
    tmp = source_blur(tmp,FTI0);
    tmp = (DS*tmp)*DS.';
    Ibg(:,:,num) = tmp(1+flap:end-flap,1+flap:end-flap);
end

function I2 = source_blur(I1,FTI0)

tmp = fftshift(fftn(ifftshift(I1)));
tmp = tmp.*FTI0;
I2 = ifftshift(ifftn(fftshift(tmp)));