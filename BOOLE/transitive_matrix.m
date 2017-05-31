function M_sao=transitive_matrix(M)
% M=[1 1 0 0 0;
%    1 1 0 0 1;
%    0 0 1 0 0;
%    0 0 0 1 0;
%    0 1 0 0 1];
n=size(M,1);
M_sao=M;
for rep=1:3
for i=1:n
    for j=1:n
        for k=1:n
           if M_sao(i,j) == 1 && M_sao(j, k) == 1
               M_sao(i,k)=1;
               M_sao(k,i)=1;
           end
        end
    end
end
end
end