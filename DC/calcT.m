% calculator T-I-F
function T_value = calcT(x, a1, a2, a3, a4)
    if x<a1
        T=0;
    else
        if x>=a1 && x<a2
            T=(x-a1)/(a2-a1);
        else
            if x>=a2 && x<a3
                T=(a3-x)/(a3-a2);
            else
                if x>=a3 && x<a4
                    T=(x-a3)/(a4-a3);
                else
                    T=0;
                end
            end
        end
    end
         T_value   = T;        
end
