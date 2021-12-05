clc,clear all;

%%%%% 1 Transmitter %%%%%

[y,fs]=audioread('EAin.mp3');
y=y(1:5*fs,:);
Tt=length(y)/fs;
t=linspace(0,Tt,Tt*fs);t=t';
figure; subplot(3,2,1); plot(t,y(:,1));
title('the first original signal  with time');
subplot(3,2,2); plot(t,y(:,2),'m');
title('the second original signal  with time');
yf_mag=abs(fftshift(fft(y)));
yf_phase=angle(fftshift(fft(y))*(180/pi));
ft1=linspace(-fs/2,fs/2,length(yf_mag));ft1=ft1';
subplot(3,2,3); stem(ft1,yf_mag(:,1));
title('the first original signal magnitude with frequency');
subplot(3,2,4); stem(ft1,yf_mag(:,2),'m');
title('the second original signal magnitude with frequency');
subplot(3,2,5); stem(ft1,yf_phase(:,1));
title('the first original signal phase with frequency');
subplot(3,2,6); stem(ft1,yf_phase(:,2),'m');
title('the second original signal phase with frequency');
sound(y,fs);
pause(length(y)/fs);

%%%%% 2 Channel %%%%%

fprintf(' Choose 1 for Delta function \n Choose 2 for exp(-2pi*5000t) \n Choose 3 for exp(-2pi*1000t) \n Choose 4 for The channel has 2 delta functions \n');
op= input( '  Enter the number of the wanted channel: ');
switch op 
    case 1
        h= zeros(1,length(y));
        h(1)=1; h=h';
        Y1=conv(y(:,1),h);
        Y2=conv(y(:,2),h);
    case 2
        h=exp(-2*pi*5000*t);
        Y1=conv(y(:,1),h);
        Y2=conv(y(:,2),h);
    case 3
        h=exp(-2*pi*1000*t);
        Y1=conv(y(:,1),h);
        Y2=conv(y(:,2),h);
    case 4
         h=zeros(1,length(y));
         h(1)=2;h(fs)=.5;
         Y1=conv(y(:,1),h);
         Y2=conv(y(:,2),h);
    otherwise 
        fprintf('Wrong choice please try again.....');
end
      t1=linspace(0,length(Y1)/fs,length(Y1));
      figure;subplot(2,1,1); plot(t1,Y1);
      title('the first signal after passing the channel with time');
      subplot(2,1,2); plot(t1,Y2,'m');
      title('the second signal after passing the channel with time');
      Yt= [Y1  Y2] ;
      
%%%%% 3 Noise %%%%%

sigma=input('  Enter the value of sigma: ');
Yt=Yt(1:5*fs,:);
z=sigma*randn(1,length(Yt)); z=z';
Noised = Yt + z ;
Tt1=length(Noised)/fs;
t1=linspace(0,Tt1,Tt1*fs);t1=t1';
Noisedf_mag=abs(fftshift(fft(Noised)));
Noisedf_phase=angle(fftshift(fft(Noised)));
ft2=linspace(-fs/2,fs/2,length(yf_mag));ft2=ft2';
figure; subplot(3,2,1); plot(t1,Noised(:,1));
title('the first noised signal  with time');
subplot(3,2,2); plot(t1,Noised(:,2),'m');
title('the second noised signal  with time');
subplot(3,2,3); stem(ft2,Noisedf_mag(:,1));
title('the first noised signal magnitude with frequency');
subplot(3,2,4); stem(ft2,Noisedf_mag(:,2),'m');
title('the second noised signal magnitude with frequency');
subplot(3,2,5); stem(ft2,Noisedf_phase(:,1));
title('the first noised signal phase with frequency');
subplot(3,2,6); stem(ft2,Noisedf_phase(:,2),'m');
title('the second noised signal phase with frequency');
sound(Noised,fs);
pause (length(Noised)/fs);

%%%%% 4 Receiver %%%%%%

nSHZ= length(Noisedf_mag)/fs ;
signal_fltr=ones(1,length(Noisedf_mag));
signal_fltr(1: nSHZ*(-3400+(fs/2)))=0;
signal_fltr(nSHZ*(3400+(fs/2)):end)=0;
signal_fltr=signal_fltr';
outsignalf_mag= Noisedf_mag .* signal_fltr ;
% outsignalf_phase=Noisedf_phase .* signal_fltr;
outsignal=real(ifft(ifftshift(outsignalf_mag)));
Tt2=length(outsignal)/fs;
t2=linspace(0,Tt2,Tt2*fs);t2=t2';
ft3=linspace(-fs/2,fs/2,length(yf_mag));ft3=ft3';
figure; subplot(2,2,1); plot(t2,outsignal(:,1));
title('the first output signal  with time');
subplot(2,2,2); plot(t2,outsignal(:,2),'m');
title('the second output signal  with time');
subplot(2,2,3); stem(ft3,outsignalf_mag(:,1));
title('the first output signal magnitude with frequency');
subplot(2,2,4); stem(ft3,outsignalf_mag(:,2),'m');
title('the second output signal magnitude with frequency');
% subplot(3,2,5); plot(ft3,outsignalf_phase(:,1));
% title('the first output signal phase with frequency');
% subplot(3,2,6); plot(ft3,outsignalf_phase(:,2),'m');
% title('the second output signal phase with frequency');
sound(outsignal,fs);
pause (length(outsignal)/fs);