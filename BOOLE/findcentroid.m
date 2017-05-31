function centroid_array = findcentroid(clust,data)
%     clust = convert(clust);
    numclust = max(clust);
    [n,m] = size(clust);
    for i=1:numclust
        member=0;
        sum1=0;sum2=0;sum3=0;
        for j=1:n
            if clust(j,1)==i
                sum1=sum1+data(j,1);
                sum2=sum2+data(j,2);
                sum3=sum3+data(j,3);
                member = member+1;
            end
        end
        centroid_array(i,1) = sum1/member;
        centroid_array(i,2) = sum2/member;
        centroid_array(i,3) = sum3/member;
    end
end
