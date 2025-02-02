function m = xcat_material_refr_ind(matdir0,E,varargin)

lambda = 1.239841875/(E/1000)*1e-9;
re = 2.81794e-15;

matdir1 = fullfile(matdir0,'ICRU46');

% 0: water; 1: muscle; 2: lung; 3: dry_spine; 4: dry_rib;
% 5: adipose; 6: blood; 7: heart; 8: kidney; 9: liver; 10: lymph
% 11: pancreas; 12: intestine; 13: skull; 14: cartilage; 15: brain;
% 16: spleen; 17: iodine_blood; 18: iron; 19: pmma; 20: aluminum;
% 21: titanium; 22: air; 23: graphite; 24: lead; 25: breast_mammary;
% 26: skin; 27: iodine; 28: eye lens; 29: ovary; 30: red marrow;
% 31: yellow marrow; 32: testis; 33: thyroid; 34: bladder

% Mass attenuation coefficient from ICRU46: m2/kg
% Mass attenuation coefficient from NIST: cm2/g (= 0.1 m2/kg)
% RHOE in electrons/m3
% RHO in kg/m3
switch varargin{1}
    case 0 % water
        RHOE = 3340e26;
        RHO = 1000;
        mat = load([matdir1 '/WATER.PRN']);
        MAC = interp1a(mat(:,1),mat(:,6),E/1e6);
    case 1 % muscle
        RHOE = 3480e26;
        RHO = 1050;
        mat = load([matdir1 '/MUSCLE4.PRN']);
        MAC = interp1a(mat(:,1),mat(:,6),E/1e6);
    case 2 % lung
        RHOE = 3450e26;
        RHO = 1040;
        mat = load([matdir1 '/LUNG2.PRN']);
        MAC = interp1a(mat(:,1),mat(:,6),E/1e6);
    case 3 % dry spine (skeleton-vertebral column)
        RHOE = 4530e26;
        RHO = 1420;
        mat = load([matdir1 '/SKELTN28.PRN']);
        MAC = interp1a(mat(:,1),mat(:,6),E/1e6);
    case 4 % dry rib (skeleton-ribs)
        RHOE = 4500e26;
        RHO = 1410;
        mat = load([matdir1 '/SKELTN23.PRN']);
        MAC = interp1a(mat(:,1),mat(:,6),E/1e6);
    case 5 % adipose
        RHOE = 3180e26;
        RHO = 950;
        mat = load([matdir1 '/ADIPOS11.PRN']);
        MAC = interp1a(mat(:,1),mat(:,6),E/1e6);
    case 6 % blood (whole)
        RHOE = 3510e26;
        RHO = 1060;
        mat = load([matdir1 '/BLOOD3.PRN']);
        MAC = interp1a(mat(:,1),mat(:,6),E/1e6);
    case 7 % heart (blood-filled)
        RHOE = 3510e26;
        RHO = 1060;
        mat = load([matdir1 '/HEART6.PRN']);
        MAC = interp1a(mat(:,1),mat(:,6),E/1e6);
    case 8 % kidney
        RHOE = 3480e26;
        RHO = 1050;
        mat = load([matdir1 '/KIDNEY3.PRN']);
        MAC = interp1a(mat(:,1),mat(:,6),E/1e6);
    case 9 % liver (healthy)
        RHOE = 3510e26;
        RHO = 1060;
        mat = load([matdir1 '/LIVER3.PRN']);
        MAC = interp1a(mat(:,1),mat(:,6),E/1e6);
    case 10 % lymph
        RHOE = 3420e26;
        RHO = 1030;
        mat = load([matdir1 '/LYMPH.PRN']);
        MAC = interp1a(mat(:,1),mat(:,6),E/1e6);
    case 11 % pancreas
        RHOE = 3460e26;
        RHO = 1040;
        mat = load([matdir1 '/PANCREAS.PRN']);
        MAC = interp1a(mat(:,1),mat(:,6),E/1e6);
    case 12 % intestine (GI tract)
        RHOE = 3420e26;
        RHO = 1030;
        mat = load([matdir1 '/GITRACT.PRN']);
        MAC = interp1a(mat(:,1),mat(:,6),E/1e6);
    case 13 % skull (cranium)
        RHOE = 5070e26;
        RHO = 1610;
        mat = load([matdir1 '/SKELTN11.PRN']);
        MAC = interp1a(mat(:,1),mat(:,6),E/1e6);
    case 14 % cartilage
        RHOE = 3620e26;
        RHO = 1100;
        mat = load([matdir1 '/SKELTN01.PRN']);
        MAC = interp1a(mat(:,1),mat(:,6),E/1e6);
    case 15 % brain
        RHOE = 3460e26;
        RHO = 1040;
        mat = load([matdir1 '/BRAIN4.PRN']);
        MAC = interp1a(mat(:,1),mat(:,6),E/1e6);
    case 16 % spleen
        RHOE = 3510e26;
        RHO = 1060;
        mat = load([matdir1 '/SPLEEN2.PRN']);
        MAC = interp1a(mat(:,1),mat(:,6),E/1e6);
    case 22 % air
        RHOE = 3.622e26;
        RHO = 1.205;
        mat = load([matdir0 '/Air.txt']);
        MAC = interp1a(mat(:,1),mat(:,2),E/1e6)*0.1;
    case 28 % eye lens
        RHOE = 3530e26;
        RHO = 1070;
        mat = load([matdir1 '/EYELENS.PRN']);
        MAC = interp1a(mat(:,1),mat(:,6),E/1e6);
    case 29 % ovary
        RHOE = 3490e26;
        RHO = 1050;
        mat = load([matdir1 '/OVARY.PRN']);
        MAC = interp1a(mat(:,1),mat(:,6),E/1e6);
    case 30 % red marrow
        RHOE = 3420e26;
        RHO = 1030;
        mat = load([matdir1 '/SKELTN22.PRN']);
        MAC = interp1a(mat(:,1),mat(:,6),E/1e6);
    case 31 % yellow marrow
        RHOE = 3280e26;
        RHO = 980;
        mat = load([matdir1 '/SKELTN30.PRN']);
        MAC = interp1a(mat(:,1),mat(:,6),E/1e6);
    case 32 % testis
        RHOE = 3460e26;
        RHO = 1040;
        mat = load([matdir1 '/TESTIS.PRN']);
        MAC = interp1a(mat(:,1),mat(:,6),E/1e6);
    case 33 % thyroid
        RHOE = 3480e26;
        RHO = 1050;
        mat = load([matdir1 '/THYROID.PRN']);
        MAC = interp1a(mat(:,1),mat(:,6),E/1e6);
    case 34 % bladder (filled)
        RHOE = 3430e26;
        RHO = 1030;
        mat = load([matdir1 '/URBLADR2.PRN']);
        MAC = interp1a(mat(:,1),mat(:,6),E/1e6);
end

myu = MAC*RHO;
delta = re*lambda^2/2/pi*RHOE;
beta = lambda/4/pi*myu;
m = 1 - delta + 1i*beta;

%% 
function y2 = interp1a(x1,y1,x2)

y2 = zeros(size(x2));
for ctr = 1:length(x2)
    ind = find(diff(x1)==0);
    if isempty(ind)
        y2(ctr) = interp1(x1,y1,x2(ctr),'spline','extrap');
    else
        if x2(ctr)<x1(ind(1))
            y2(ctr) = interp1(x1(1:ind(1)),y1(1:ind(1)),x2(ctr),'spline','extrap');
        elseif x2(ctr)>x1(ind(end))
            y2(ctr) = interp1(x1(ind(end)+1:end),y1(ind(end)+1:end),x2(ctr),'spline','extrap');
        else
            for iii = 1:length(ind)
                if x2(ctr)>x1(ind(iii)) && x2(ctr)<x1(ind(iii+1))
                    y2(ctr) = interp1(x1(ind(iii)+1:ind(iii+1)),y1(ind(iii)+1:ind(iii+1)),...
                        x2(ctr),'spline','extrap');
                    continue;
                end
            end
        end
    end
end