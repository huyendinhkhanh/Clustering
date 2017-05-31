function IFV_value = IFV(data, center, clust)
    numClust = max(clust);
    sigmaD = 0;
    sum = 0;
    sizeData = size(data,1);
    
    for i = 1:numClust
        tg1 = 0;
        tg2 = 0;
        for j = 1:sizeData
            if clust(j,1) == i 
                clust(j,1) = 1 - eps;
            end
            
            tg1 = tg1 + log(clust(i, 1))/log(2);
            tg2 = tg2 + clust(i, 1)^2;
            sigmaD = sigmaD + norm(data(j, :) - center(i, :))^2;
        end
        
        tg = (log(numClust)/log(2) - tg1/sizeData)^2;
        tg2 = tg2/sizeData;
        
        sum = sum + tg * tg2;
    end
    
    sigmaD = sigmaD/(numClust * sizeData);
    
    calcSDmax = 0;
    for i = 1:numClust-1
        for j = i+1:numClust
            calcSDmax = max(calcSDmax, norm(center(i, :) - center(j, :))^2);
        end
    end
    
    IFV_value  = (sum * calcSDmax) / (sigmaD * numClust);
end
