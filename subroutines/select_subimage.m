function Apatch_pad = select_subimage(A,ctr1,ctr2,padd0,N,marg)

win = padd0/N;

row0 = (ctr1-1)*win + 1;
col0 = (ctr2-1)*win + 1;
row1 = ctr1*win;
col1 = ctr2*win;

xrow0 = row0 - marg;
xrow1 = row1 + marg;
xcol0 = col0 - marg;
xcol1 = col1 + marg;

if ctr1==1 && ctr2==1
    Apatch = A(1:xrow1,1:xcol1);
    Apatch_pad = padarray(Apatch,[marg marg],'replicate','pre');
elseif ctr1==1 && ctr2==N
    Apatch = A(1:xrow1,xcol0:padd0);
    Apatch_pad = padarray(Apatch,[marg 0],'replicate','pre');
    Apatch_pad = padarray(Apatch_pad,[0 marg],'replicate','post');
elseif ctr1==N && ctr2==1
    Apatch = A(xrow0:padd0,1:xcol1);
    Apatch_pad = padarray(Apatch,[marg 0],'replicate','post');
    Apatch_pad = padarray(Apatch_pad,[0 marg],'replicate','pre');
elseif ctr1==N && ctr2==N
    Apatch = A(xrow0:padd0,xcol0:padd0);
    Apatch_pad = padarray(Apatch,[marg marg],'replicate','post');
elseif ctr1==1
    Apatch = A(1:xrow1,xcol0:xcol1);
    Apatch_pad = padarray(Apatch,[marg 0],'replicate','pre');
elseif ctr1==N
    Apatch = A(xrow0:padd0,xcol0:xcol1);
    Apatch_pad = padarray(Apatch,[marg 0],'replicate','post');
elseif ctr2==1
    Apatch = A(xrow0:xrow1,1:xcol1);
    Apatch_pad = padarray(Apatch,[0 marg],'replicate','pre');
elseif ctr2==N
    Apatch = A(xrow0:xrow1,xcol0:padd0);
    Apatch_pad = padarray(Apatch,[0 marg],'replicate','post');
else
    Apatch = A(xrow0:xrow1,xcol0:xcol1);
    Apatch_pad = Apatch;
end