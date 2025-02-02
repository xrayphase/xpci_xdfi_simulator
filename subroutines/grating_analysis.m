function [atten,dpc,df] = grating_analysis(Is,Ibg)

% Determine the number of phase steps based on the input data
nscan = size(Is, 3);

% Obtain the normalized Fourier transform along the phase step dimension
objFFT = fft(Is, nscan, 3) / nscan;
refFFT = fft(Ibg, nscan, 3) / nscan;

% Get amplitudes
refA0 = mean(Ibg,3);
objA0 = mean(Is,3);

% Get first Fourier coefficients
refA1 = abs(refFFT(:,:,2)); 
objA1 = abs(objFFT(:,:,2));

% Get the dark-field
refDF = refA1 ./ refA0;
objDF =  objA1 ./ objA0;
df = objDF ./ refDF; 

% Attenuation
% atten = -log(objA0./refA0);
atten = objA0./refA0;

% Phases for the object and reference
oAngle = angle(objFFT(:,:,2));
rAngle = angle(refFFT(:,:,2));

% Find differential phase images
dpc = oAngle - rAngle;