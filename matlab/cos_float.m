function [cosa,sina] = cos_float(a)

if (a < (pi/2))
    a2 = a;
elseif (a >= (pi/2)) && (a < pi)
    a2 = pi - a;
elseif (a >= pi) && (a < (1.5*pi))
    a2 = a - pi;
elseif (a >= (1.5*pi)) && (a < (2*pi))
    a2 = 2*pi - a;
end

%cordic算法过程

itr = 12;

cosa = 0.60725293501;
sina = 0;
ar = a2;

for cnt = 0 : itr-1
    tt = atan(2^(-cnt));
    
    if ar >= 0
       cosa2 = cosa - sina*(2^(-cnt));
       sina2 = sina + cosa*(2^(-cnt));
       ar = ar - tt;
    else 
       cosa2 = cosa + sina*(2^(-cnt));
       sina2 = sina - cosa*(2^(-cnt));
       ar = ar + tt;
    end
    cosa = cosa2;
    sina = sina2;
end

%复原回原来的象限

if (a < (pi/2))
    cosa = cosa;
    sina = sina;
elseif (a >= (pi/2)) && (a < pi)
    cosa = -cosa;
    sina = sina;
elseif (a >= pi) && (a < 1.5*pi)
    cosa = -cosa;
    sina = -sina;
elseif (a >= (1.5*pi)) && (a < (2*pi))
    cosa = cosa;
    sina = -sina;
end







end