function Trans_F = Fresnel_kernel(padd1,res1,k0,zz)kres1 = 1/(res1*padd1);[jj,ii] = meshgrid(1:padd1,1:padd1);kx = (ii-padd1/2-1)*kres1;ky = (jj-padd1/2-1)*kres1;kz = k0 - 1/2/k0*(kx.^2+ky.^2);Trans_F = exp(1i*2*pi*kz*zz);end