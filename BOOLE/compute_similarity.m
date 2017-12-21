function similarity_matrix = compute_similarity(d_T_component,d_I_component,d_F_component,s_T_component,s_I_component,s_F_component)
d_num = size(d_T_component,1);
s_num = size(s_T_component,1);
similarity_matrix=zeros(s_num,d_num);
numerator=zeros(s_num,d_num);
denominator_s=zeros(s_num,d_num);
denominator_d=zeros(s_num,d_num);
denominator=zeros(s_num,d_num);
for i=1:s_num
    for j=1:d_num
        pi_d(i,j)=(1-(d_T_component(i,j)+d_I_component(i,j)+d_F_component(i,j)));
        pi_s(i,j)=(1-(s_T_component(i,j)+s_I_component(i,j)+s_F_component(i,j)));
        numerator(i,j)=numerator(i,j)+(s_T_component(i,j)*d_T_component(i,j)+s_I_component(i,j)*d_I_component(i,j)+s_F_component(i,j)*d_F_component(i,j) + pi_s(i,j)*pi_d(i,j));
        denominator_s(i,j)=denominator_s(i,j)+(s_T_component(i,j)^2+s_I_component(i,j)^2+s_F_component(i,j)^2+pi_s(i,j)^2);
        denominator_d(i,j)=denominator_d(i,j)+(d_T_component(i,j)^2+d_I_component(i,j)^2+d_F_component(i,j)^2+pi_d(i,j)^2);
    end
end

for i=1:s_num
    for j=1:d_num
        denominator(i,j)=sqrt(denominator_s(i,j)*denominator_d(i,j));
        if(denominator(i,j) ==0)
            similarity_matrix(i,j) = 1;
        else
            similarity_matrix(i,j) = abs(numerator(i,j)/denominator(i,j));
        end
        
    end
end

end