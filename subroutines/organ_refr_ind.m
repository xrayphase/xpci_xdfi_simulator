function m = organ_refr_ind(E,organ_id,M1,M2,matdir0)

%%
m = zeros(length(organ_id),1);

for ctr = 1:length(organ_id)
    mater = M1(organ_id(ctr));
    compo = M2(organ_id(ctr));
    for num = 1:length(mater)
        m(ctr) = m(ctr) + xcat_material_refr_ind(matdir0,E,mater(num))*compo(num);
    end
end