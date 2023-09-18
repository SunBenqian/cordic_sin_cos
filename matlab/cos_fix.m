function [cosa3,sina3] = cos_fix(a)

if (a < 256)
    a2 = a;
elseif (a >= 256) && (a < 512)
    a2 = 512 - a;
elseif (a >= 512) && (a < 768)
    a2 = a - 512;
elseif (a >= 768) && (a < 1024)
    a2 = 1024 - a;
end 

itr = 13;

exp_cosa = 4;
cosa = round (0.60725293501 * (2^(itr-1+exp_cosa)));

sina = 0;

exp_ar = -2;
ar = a2 * 2^(itr-1+exp_ar);

for cnt = 0 : itr - 1
   tt = round (atan(2^(-cnt))/(2*pi/1024)*2^(itr-1+exp_ar));
   
   tmp1 = floor(sina / (2^cnt));
   tmp2 = floor(cosa / (2^cnt));
   
   if (ar >= 0)
      cosa = cosa - tmp1;
      sina = sina + tmp2;
      ar = ar - tt;
   else 
      cosa = cosa + tmp1;
      sina = sina - tmp2;
      ar = ar + tt;      
   end
end

cosa2 = round (cosa * 2^(-(itr-1+exp_cosa)+11));
sina2 = round (sina * 2^(-(itr-1+exp_cosa)+11));


if (a < 256)
    cosa3 = cosa2;
    sina3 = sina2;
elseif (a >= 256) && (a < 512)
    cosa3 = -cosa2;
    sina3 = sina2;
elseif (a >= 512) && (a < 768)
    cosa3 = -cosa2;
    sina3 = -sina2;
elseif (a >= 768) && (a < 1024)
    cosa3 = cosa2;
    sina3 = -sina2;
end 



end