% Created matrix TIF with data
function matrix_TIF = creatmatrixtif(data)
    [n,m] = size(data);
    if n>m
        n=m;
    else
        m=n;
    end
%     matrix_TIF = creat_data(n,m);
    for i=1:n
        for j=1:m
            matrix_TIF(i,j,1) = calcT(data(i,j), 0.02, 0.25, 0.47, 0.7);
            matrix_TIF(i,j,2) = calcI(data(i,j), 0.16, 0.28, 0.41, 0.53);
            matrix_TIF(i,j,3) = calcF(data(i,j), 0.15, 0.31, 0.48, 0.65);
        end
    end        
end
