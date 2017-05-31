function Q_EAM_T = Calc_EAM(Q_EAM)
   n = size(Q_EAM,1);
   for i=1:n
       for j=i:n
           Q_EAM_T(i,j) = Find_MM(Q_EAM,i,j);
       end
   end
   for i=1:n
        for j=1:i
            Q_EAM_T(i,j) = Q_EAM_T(j,i);
        end
    end
end
