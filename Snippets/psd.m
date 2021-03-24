Fs=10000;

[Pu,f] = pwelch(z2,hanning(1024*8),1024*4,1024*32,Fs,'onesided');
plot(f,Pu);
xlim([6,20]);