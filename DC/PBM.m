function PBM_value = PBM(data, center, clust)
E_1 = calcSumDistDataPoint2X(data, mean(data));

numClust = max(clust);
E_k = 0;

for i = 1 : numClust
    index = find(data(i,:) == i);
    clustData = data(index, :);
    E_k = E_k +  calcSumDistDataPoint2X(clustData, center(i, :));
end

D_k = 0;
for i = 1:numClust-1
    for j = i+1:numClust
        D_k = max(D_k, norm(center(i, :) - center(j, :)));
    end
end
    
PBM_value = (E_1 * D_k / (numClust * E_k)) ^ 2;
end
