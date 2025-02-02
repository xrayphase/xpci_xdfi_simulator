function FTI0 = define_source(d_g0g1,d_g1g2,p0,focalspot,res1,padd1)

penum = (d_g0g1+d_g1g2)/d_g0g1-1;

fwhm.a = p0*penum;
fwhm.b = focalspot*penum;

src.a = fwhm.a/(2*sqrt(2*log(2)));
src.b = fwhm.b/(2*sqrt(2*log(2)));

[jjx,iix] = meshgrid(1:padd1,1:padd1);

kres1 = 1/res1/padd1;
Udetx = (iix-padd1/2-1)*kres1; 
Vdetx = (jjx-padd1/2-1)*kres1;

FTI0 = exp(-2*pi^2*((src.a*Udetx).^2+(src.b*Vdetx).^2));