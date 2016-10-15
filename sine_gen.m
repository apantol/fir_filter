clc;
clear;

fid = fopen('sine_in.txt', 'w');

bn = 12;
amp = (2^bn/2)-1;
f  = 1e3;
fs = 20e3;

t = 0:(1/fs):2047*(1/fs);


y = amp*sin(2*pi*f*t);
y = round(y);

fprintf(fid, '%d\n', y);