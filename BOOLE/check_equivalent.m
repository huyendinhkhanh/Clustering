function result=check_equivalent(d, beta_d)
result=1;
row_D=size(d,1); col_D=size(d,2);
row_C=size(beta_d,1); col_C=size(beta_d,2);
% %reflexive
% for i=1:row_C
%     for j=col_C
%        if beta_d(i,j)>d(i,j)
%           result=0; 
%        end
%     end
% end

%symmetric
if beta_d'~=beta_d
    result=0;
end

%transitive
matrix_mu2=beta_d.*beta_d;
for i=size(matrix_mu2,1)
    for j=size(matrix_mu2,2)
       if matrix_mu2(i,j)>beta_d(i,j)
           result=0;
       end;
    end
end

end