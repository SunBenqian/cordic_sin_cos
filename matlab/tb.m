clc;
clear ;
close all;

delt_a = 2*pi / (2^10);
a = transpose([0:delt_a:2*pi-delt_a]);
deg_axis = a * 180/pi;
len = length(a);
cosa = zeros(len,1);
sina = zeros(len,1);

a_fix = round(a/delt_a);

for cnt = 1 : len
%    [cosa(cnt),sina(cnt)] = cos_float(a(cnt)); 
      
    [cosa_fix(cnt),sina_fix(cnt)] = cos_fix2 (a_fix(cnt));
    cosa(cnt) = cosa_fix(cnt)/2^11;
    sina(cnt) = sina_fix(cnt)/2^11;
    
end


figure (1);
plot (deg_axis,cosa);grid on;hold on;
plot (deg_axis,sina,'r');hold off;

figure (2);
cosa_real = cos(a);
sina_real = sin(a);
err_cos = abs(cosa - cosa_real);
err_sin = abs(sina - sina_real);
plot (deg_axis,err_cos);grid on;hold on;
plot (deg_axis,err_sin,'r');hold off;
