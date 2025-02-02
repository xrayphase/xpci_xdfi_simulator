clear; clc;
close all;

%%
savepath = 'C:\Users\ysung4\Documents\Projects\XPCI_XDFI\Result\Healthy';

% simulation condition
res = 0.01e-2;
padd0 = 4096;

% Detector
bin = 4;
detres = res*bin; 

% Define N, marg, subdiv (only for tiled = 1)
N = 64; % padd0/N should be an integer

detpxl = padd0/N/bin; % should be an integer

%% Generate raw attenuation, dpc, and df images
clear Is_all Ibg_all

for ctr1 = 1:48
    for ctr2 = 10:57
        fname = [savepath '/XDFI_result_' num2str(ctr1) '_' num2str(ctr2) '.mat'];
        load(fname,'Is','Ibg');
        
        row0 = (ctr1-1)*detpxl + 1;
        col0 = (ctr2-10)*detpxl + 1;
        row1 = ctr1*detpxl;
        col1 = (ctr2-9)*detpxl;
        
%         figure(61), montage(Is,"size",[1 8],"DisplayRange",[0 0.06]);
%         figure(62), montage(Ibg,"size",[1 8]);
% 
%         [atten,dpc,df] = grating_analysis(Is,Ibg);
% 
%         figure(301); imagesc(atten); title('Attenuation');
%          colormap gray; axis image off; colorbar;
% 
%         figure(302); imagesc(dpc); title('Differential phase'); 
%         colormap gray; axis image off; colorbar; caxis([-pi/2 pi/2]);
% 
%         figure(303); imagesc(df); title('Dark-field');
%          colormap gray; axis image off; colorbar; caxis([0.7 1.1]);
        
        Is_all(row0:row1,col0:col1,:) = Is;
        Ibg_all(row0:row1,col0:col1,:) = Ibg;
    end
end

figure(301), montage(Is_all,"size",[2 4],"DisplayRange",[0 0.07]);
colorbar; set(gca,'fontsize',16);
% figure(302), montage(Ibg_all,"size",[2 4]);

figure(303), montage(Is_all,"size",[2 4],"DisplayRange",[0 0.07]);
colorbar; set(gca,'fontsize',28);

[atten,dpc,df] = grating_analysis(Is_all,Ibg_all);

figure(501); imagesc(-log10(atten),[0 2.5]); colormap(gray); 
colorbar; set(gca,'fontsize',18); axis image; axis off; 

figure(502); imagesc(dpc,[-0.025 0.025]); colormap gray; 
colorbar; set(gca,'fontsize',18); axis image; axis off; 
   
figure(503); imagesc(df,[0.7 1]); colormap(flipud(gray));
colorbar; set(gca,'fontsize',18); axis image; axis off; 

newstr = split(savepath,'/');
newstr{end} = join([newstr{end} '.mat']);
savename = char(join(newstr,'/'));

% save(savename,'atten','dpc','df');