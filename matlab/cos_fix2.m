% a : 0 + 0 + 10;
% cosa : 1 + 1 + 11 = 13;
% sina : 1 + 1 + 11 = 13;

function [cosa3,sina3] = cos_fix2(a)

if (a < 256)
    a2 = a;
elseif (a >= 256) && (a < 512)
    a2 = 512 - a;
elseif (a >= 512) && (a < 768)
    a2 = a - 512;
elseif (a >= 768) && (a < 1024)
    a2 = 1024 - a;
end 

itr = 14;

%exp_cosa = 2;
%cosa = round (0.60725293501 * (2^(itr-1+exp_cosa)));
cosa = 19898;

sina = 0;

%exp_ar = -7;
ar = a2 * 2^6;

tt = [8192,4836,2555,1297,651,326,163,81,41,20,10,5,3,1];

for cnt = 0 : itr - 1
   %tt = round (atan(2^(-cnt))/(2*pi/1024)*2^(itr-1+exp_ar));
   
   tmp1 = floor(sina / (2^cnt));
   tmp2 = floor(cosa / (2^cnt));
   
   if (ar >= 0)
      cosa = cosa - tmp1;
      sina = sina + tmp2;
      ar = ar - tt(cnt+1);
   else 
      cosa = cosa + tmp1;
      sina = sina - tmp2;
      ar = ar + tt(cnt+1);      
   end
end

cosa2 = round (cosa * 2^(-4));
sina2 = round (sina * 2^(-4));


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