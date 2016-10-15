
generate = 0;

bn = 12;
amp = (2^bn/2)-1;
f  = 1e3;
fs = 20e3;

if(generate)
    clc;
    clear;

    fid = fopen('sine_in.txt', 'w');
    t = 0:(1/fs):2047*(1/fs);
    y = amp*sin(2*pi*f*t);
    y = round(y);
    fprintf(fid, '%d\n', y);
else
     fid = fopen('sine_out.txt', 'r');
     sine_out = fscanf(fid, '%d\n');
     
     sine_in_fft = abs(fft(y, 1024));
     sine_out_fft = abs(fft(sine_out,1024));
end