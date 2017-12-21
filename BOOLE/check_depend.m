function result = check_depend(c_matrix, p_matrix)
result=1;
row_c=size(c_matrix,1);
col_c=size(c_matrix,2);
for i=1:row_c
    for j=1:col_c
        if c_matrix(i,j)>p_matrix(i,j)
            result=0;
        end
    end
end
end