
generate = 0;

bn = 14;
amp = (2^bn/2)-1;
f  = 1e3;
fs = 20e3;

if(generate == 1)

    fid = fopen('D:\priv\sine_in.txt', 'w');
    t = 0:(1/fs):2047*(1/fs);
    y = amp*sin(2*pi*f*t);
    y = round(y);
    fprintf(fid, '%d\n', y);
else
     fid = fopen('D:\priv\sine_out.txt', 'r');
     sine_out = fscanf(fid, '%d\n');
     x = y(1:length(sine_out));
     sine_in_fft = abs(fft(y, 1024));
     sine_out_fft = abs(fft(sine_out,1024));
     
    [pxx1,w1] = pwelch(x,'power');
    [pxx2,w2] = pwelch(sine_out,'power');

    dB1 = pow2db(pxx1);
    dB2 = pow2db(pxx2);
    
    plot(w1/pi,dB1)
    xlabel('\omega / \pi')
    ylabel('Power (dB)')
    hold on
    plot(w2/pi,dB2,'r')
    
end