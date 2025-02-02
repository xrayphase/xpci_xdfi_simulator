function [Nalv,Talv] = lung_model(lung,padd1,res1,dz,ctr1)

% 1: 'healthy'; 2: 'fibrosis'; 3: 'emphysema'; 4: emphysema (mild); 
% 5: emphysema (moderate); 6: edema; 7: pneumonia
Dalv = (-0.3421*ctr1+33.9263)*1e9; % density (per m^3)
Talv = round(11.4e-6/2/res1); % mean wall thickness: 11.4 micron

switch lung
    case 1 % healthy
    case 2 % fibrosis
	    Dalv = Dalv/4;
        Talv = round(Talv*40);
    case 3 % emphysema
        Dalv = Dalv*0.2;
        Talv = round(12.13e-6/2/res1);
    case 4 % emphysema (mild)
	    Dalv = Dalv*0.8; 
        Talv = round(12.13e-6/2/res1);
    case 5 % emphysema (moderate)
	    Dalv = Dalv*0.5;
	    Talv = round(12.13e-6/2/res1);
    case 6 % edema
	    Talv = Talv*1.2;
    case 7 % pneumonia
end

Nalv = round(Dalv*(padd1*res1)^2*dz);
