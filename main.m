clear; clc;
close all;

%% Part I. Set Simulation Parameters
%% X-ray Source
E = 50e3; % X-ray energy

focalspot = 1.2e-3; % X-ray source focal spot size

%% Grating Parameters (No Effect on Geometric Magnification)
d_g0g1 = 1.6; % G0-G1 distance
d_g1g2 = 0.25; % G1-G2 distance

%% Lung Model
% 1: 'healthy'; 2: 'fibrosis'; 3: 'emphysema'; 4: emphysema (mild); 
% 5: emphysema (moderate); 6: edema; 7: pneumonia
lung = 1;

pus_ratio = 0.1; % only needed for penmonia (7)

%% Parallel Processing Parameter
poolsize = 2;

%% Axial Averaging
skip = 20; % number of added slices before wave propagation

%% Directory for raw image files (XCAT simulation result)
% rawdir = [pwd '/raw'];
rawdir = 'C:\Users\ysung4\Documents\Projects\XPCI_XDFI\Codes\Solver\raw';





%% Part II. Other Parameters Used for Simulation
% Do Not Change Anything From This Point!!!
%% Directory Locations
% Directory for saving results
savepath = [pwd '/result'];
if ~exist(savepath,'dir')
       mkdir(savepath)
end

% Directory for ICRU46 files
matdir0 = [pwd '/materials'];

% Add the 'subroutines' directory to search path
addpath([pwd '/subroutines']);

%% Define the Grids Used in Simulation
res = 0.01e-2; % simulation resolution
padd0 = 4096; % pixel number along each dimension
dz = 0.01e-2; % slice thickness

% Define N, marg, subdiv
N = 64; % padd0/N should be an integer
marg = 4; % 1 detector pixel overlap (shuold be an integer)
subdiv = 80; % res/subdiv should be 1/8 of the grating period

padd1 = (padd0/N+2*marg)*subdiv;
res1 = res/subdiv;

% Detector
bin = 4;
detres = res*bin; 
detpxl = padd0/N/bin; % Number of detector pixels for each subregion

padd2 = detpxl+2*marg/bin;

%% Define Grating Arrays 
period = 8;
nscan = 8; % number of steps
dphi = pi/2; % phase added by G1

p1 = period*res1; % G1 period
p2 = p1; % G2 period
p0 = p2*d_g0g1/d_g1g2; % G0 period

bimask1 = repmat([zeros(period/2,padd1);ones(period/2,padd1)],[padd1/period 1]);
bimask2 = bimask1;

%% Define the Fourier mask for the X-ray Source
FTI0 = define_source(d_g0g1,d_g1g2,p0,focalspot,res1,padd1);

%% Define Kernel and Transfer Function for Multi-Layer Propagation
lambda = 1.239841875/(E/1000)*1e-9; % vacuum wavelength
k0 = 1/lambda; % vacuum wave number

nm = 1; % refractive index of the medium (air)

% Kernel for multi-layer propagation in the phantom
[Prop,Gtilde] = ML_kernel(padd1,res1,k0*nm,dz*skip);

% Transfer function for G1-G2 propagation
Trans_F = Fresnel_kernel(padd1,res1,k0,d_g1g2);

%% Define Detector Downsampling Operator
DS = downsamp(padd1,padd2);

%% Load XCAT Parameters
% XCAT image number
img_num = 0:2504;

% Load XCAT material information
load([matdir0 '/id_to_mater_comp.mat'],'M1','M2');



%% Part III. Launch Simulation
%%
poolobj = gcp('nocreate');
delete(poolobj);

parpool(poolsize)

parfor ctr1 = 1:48
    for ctr2 = 10:57
        fname = [savepath '/XDFI_result_' num2str(ctr1) '_' num2str(ctr2) '.mat'];

        if isfile(fname)
            continue;
        else
            [Nalv,Talv] = lung_model(lung,padd1,res1,dz,ctr1);

            count = 0;
            nslice = 0;
            Upad = ones(padd1,padd1);
            for num = 1:length(img_num)
                % Load an XCAT slice
                A = load_image(img_num(num),rawdir,padd0);

                % Crop the (ctr1,ctr2)-th region
                Apatch_pad = select_subimage(A,ctr1,ctr2,padd0,N,marg);

                % Incorporate the complex refractive index information
                % And Augment the lung region using Voronoi grids
                if lung==7
                    tmp = get_nslice_pneumonia(Apatch_pad,E,padd0,N,marg,subdiv,Nalv,Talv, ...
                        M1,M2,matdir0,pus_ratio);
                else
                    tmp = get_nslice(Apatch_pad,E,padd0,N,marg,subdiv,Nalv,Talv, ...
                        M1,M2,matdir0);
                end

                % Apply the wave propagation for every skip-th slices
                nslice = (nslice*count+tmp)/(count+1);
                count = count + 1;

                if ~mod(num,skip)
                    Upad = ML_prop_dz(Upad,nslice,dz*skip,Prop,k0,nm);
                    count = 0;
                    nslice = 0;
                end
            end

            % Generate sample and background images at the detector
            % for different grating positions
            [Is,Ibg] = grating_stepping(Upad,detpxl,marg/bin,nscan,dphi,period, ...
                bimask1,bimask2,DS,Trans_F,FTI0);

            % Save the result (Is and Ibg) for the (ctr1,ctr2)-th region
            parsave(fname,Is,Ibg);
        end
    end
end

poolobj = gcp('nocreate');
delete(poolobj);
