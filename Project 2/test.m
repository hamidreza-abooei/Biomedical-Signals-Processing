clear ;
close all; 
clc;
%% 
wform = ecg(500);
x = wform' + 0.25*randn(500,1);

lpFilt = designfilt('lowpassfir','PassbandFrequency',0.20, ...
'StopbandFrequency',0.35,'PassbandRipple',0.5, ...
'StopbandAttenuation',65,'DesignMethod','kaiserwin');
freqz(lpFilt)

filted = filtfilt(lpFilt,x);
plot(filted);
hold on ;
plot(x);

a = fft(x);
figure()
plot(abs(a));
c = fft(filted);
hold on
plot(abs(c))

%%

% lpFilt = designfilt('lowpassiir','PassbandFrequency',0.25, ...
% 'StopbandFrequency',0.35,'PassbandRipple',0.5, ...
% 'StopbandAttenuation',65,'DesignMethod','kaiserwin');
hpFilt = designfilt('lowpassiir','FilterOrder',8, ...
         'PassbandFrequency',25,'PassbandRipple',0.2, ...
         'SampleRate',250);
freqz(hpFilt)

filted2 = filtfilt(hpFilt,x);
plot(filted2);
hold on ;
plot(x);

a = fft(x);
figure()
plot(abs(a));
d = fft(filted2);
hold on
plot(abs(d))

figure()
plot(filted)
hold on
plot(filted2)
plot(wform)
