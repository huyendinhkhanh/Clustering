function F_value = calcF(x, c1, c2, c3, c4)
	if x<c1
        F=0;
    else
        if x>=c1 && x<c2
            F=(x-c1)/(c2-c1);
        else
            if x>=c2 && x<c3
                F=(c3-x)/(c3-c2);
            else
                if x>=c3 && x<c4
                    F=(x-c3)/(c4-c3);
                else
                    F=0;
                end
            end
        end
    end
   F_value = F;
end