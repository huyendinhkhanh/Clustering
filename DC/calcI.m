function I_value = calcI(x, b1, b2, b3, b4)
	if x<b1
        I=0;
    else
        if x>=b1 && x<b2
            I=(x-b1)/(b2-b1);
        else
            if x>=b2 && x<b3
                I=(b3-x)/(b3-b2);
            else
                if x>=b3 && x<b4
                    I=(x-b3)/(b4-b3);
                else
                    I=0;
                end
            end
        end
    end
	
   I_value = I;
end
