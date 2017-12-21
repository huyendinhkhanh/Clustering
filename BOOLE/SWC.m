function SWC_value = SWC(data, center,clust)
    numClust = max(clust);
    SWC_value = 0;
    for i = 1 : numClust
        index = find(clust(:,1) == i);
        clustData = data(index, :);

        for j = index
            a_i_j = calcSumDistDataPoint2X(clustData, data(j, :)) / size(index, 2);
            b_i_j = 10^6;

            for k = 1 : numClust
                if k ~= i
                    index_k = find(clust(k,:) == i);

                    clustData_k = data(index_k, :);

                    d_k_j = calcSumDistDataPoint2X(clustData_k, data(j, :)) / size(index_k, 2);
                     if d_k_j~=0
                    b_i_j = min(b_i_j, d_k_j);
                     end
                end
            end
            SWC_value = SWC_value + (b_i_j - a_i_j) / max(a_i_j, b_i_j);
           
        end
    end
    SWC_value = SWC_value / size(data, 1);
end
