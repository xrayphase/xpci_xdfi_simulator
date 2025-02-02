%%
function A = load_image(imgnum,dirname,padd0)

% disp(['Processing ' num2str(img_num(num)) ' out of ' num2str(length(img_num)) ' images...']);
tmp = num2str(10000+imgnum);
fname = [dirname '/test_act_1_' tmp(2:5) '.bin'];
fileID = fopen(fname,'r','l'); 
A0 = fread(fileID,[padd0 padd0],'int16'); 
A0 = int16(A0);
fclose(fileID);

A = flipud(A0.');
