%%
function nslice = get_nslice(Apatch_pad,E,padd0,N,marg,subdiv,Nalv,Talv, ...
    M1,M2,matdir0)

padd1 = (padd0/N+2*marg)*subdiv;

organ_id = unique(Apatch_pad);

nslice = zeros(size(Apatch_pad));
for ctr = 1:length(organ_id)
    nslice(Apatch_pad==organ_id(ctr)) = ...
        organ_refr_ind(E,organ_id(ctr),M1,M2,matdir0);
end

% Augment the lung region witih Voronoi grids
islung = sum(ismember([1224 1225],organ_id));
if islung
    tmp = imresize(Apatch_pad,[padd1 padd1],"nearest");
    tmp = find(tmp==1224|tmp==1225); % tmp is an index array from this point

    ind2 = voronoi_grid(padd1,Nalv,Talv);
    tmp = setdiff(tmp,ind2);

    nslice = imresize(nslice,[padd1 padd1],"nearest");
    nslice(tmp) = xcat_material_refr_ind(matdir0,E,22);
%             figure(22), imagesc(1-real(nslice)); pause(0.5);
else
    nslice = imresize(nslice,[padd1 padd1],"nearest");
end

end