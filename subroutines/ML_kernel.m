%%
function [Prop,Gtilde] = ML_kernel(padd,res,kn,dz)

kres = 1/(res*padd); 
ktick = ((0:padd-1)-padd/2)*kres;
[kx,ky] = meshgrid(ktick,ktick);

kz = zeros(padd,padd);
kz2 = (kn)^2-kx.^2-ky.^2;
indlist = find(kz2>0);
kz(indlist) = sqrt(kz2(indlist));

Prop = exp(1i*2*pi*kz*dz);

Gtilde = zeros(padd,padd);
Gtilde(indlist) = 1/(1i*4*pi)*Prop(indlist)./kz(indlist);