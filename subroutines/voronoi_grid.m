function ind = voronoi_grid(padd1,Nalv,Talv)

marg = round(padd1/10);
padd3 = padd1 + 2*marg;

Nalv3 = round(Nalv*(padd3/padd1)^2);

x = rand([1 Nalv3])*padd3;
y = rand([1 Nalv3])*padd3;

[vx,vy] = voronoi(x,y);
vx = round(vx);
vy = round(vy);

[row,col] = find((vx>=1)&(vx<=padd3)&(vy>1)&(vy<=padd3));
vx = vx(row,col);
vy = vy(row,col);

I = zeros(padd3,padd3);
for ctr = 1:length(vx)
    x1 = vx(1,ctr);
    x2 = vx(2,ctr);
    y1 = vy(1,ctr);
    y2 = vy(2,ctr);
    
    if abs(x2-x1)>abs(y2-y1)
        xx = round(linspace(x1,x2,abs(x2-x1)+1));
        yy = round(y1+(xx-x1)*(y2-y1)/(x2-x1));
    else
        yy = round(linspace(y1,y2,abs(y2-y1)+1));
        xx = round(x1+(yy-y1)*(x2-x1)/(y2-y1));
    end
    ind = find(xx>=1 & xx<=padd3 & yy>=1 & yy<=padd3);
    Lidx = sub2ind(size(I),xx(ind),yy(ind));
    I(Lidx) = 1;
end

se = strel('disk',Talv);
I = imdilate(I,se);

Itrim = I(marg:marg+padd1-1,marg:marg+padd1-1);
ind = find(Itrim>0);