function M_Matrix = MMT(matrix_data,anpha)
    [n,m]=size(matrix_data);
    for i=1:n
        for j=i:n
            Func_3(matrix_data,anpha,i,j);
            Func_4(matrix_data,anpha,i,j);
            M_Matrix(i,j) = Func_3(matrix_data,anpha,i,j)/Func_4(matrix_data,anpha,i,j);
        end
    end
    for i=1:n
        for j=1:i
            M_Matrix(i,j) = M_Matrix(j,i);
        end
    end
end
