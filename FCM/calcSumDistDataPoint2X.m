function t = calcSumDistDataPoint2X(data, X)
    temp = data - X(ones(size(data, 1), 1), :);
    temp = temp.^2;
    temp = sum(temp, 2);
    temp = sqrt(temp);
    t = sum(temp);
end
