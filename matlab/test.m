
itr = 15
for cnt = 0 : itr - 1
   tt(cnt+1) = floor(atan(2^(-cnt))/(2*pi/1024)*2^(itr-1-7));
end