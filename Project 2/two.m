clear
close all 
clc;
%% Load data
load('ex2data.mat');
fs = 250; % Hz


%% Preprocessing 
% sweeps = [10,50,100,200,300,400,length(indf)];
sweeps = 2:2:length(indf);
SNRs = zeros(length(sweeps),1);
counter = 1;
for sweep = sweeps
    [ target , novel , target_e, target_o, novel_e , novel_o ] = Grand_Averaging(eeg,indf,indd , fs,sweep);
    x_prime = target_o - target_e;
    x_bar = ( target_o + target_e ) / 2;
    SNRs(counter) = var(x_bar) / var(x_prime);
    counter = counter+1;
end

%% calculate ABR and show
t = -52*0.001:1/fs:500*0.001;
t2 = 16*0.001:1/fs:200*0.001;
figure();
plot(t,novel);
hold on;
plot(t,target);
ylabel("Magnitude");
xlabel("Time");
plot(t2,(novel_o+novel_e)/2);
plot(t2,(target_o+target_e)/2);
legend("erp novel", "erp target","Mean of novel sweeps" , "Mean of target sweeps")
title("Averaged ABR")
saveas(gcf,'Averaged ABR.png');

figure();
hold on;
plot(t2,target_e);
plot(t2,target_o);
plot(t2, target_o - target_e);
legend("even sweeps", "odd sweeps", "diffrences between sweeps");
ylabel("Magnitude");
xlabel("Time");
title("even and odd sweeps")
saveas(gcf,'even and odd sweeps.png');

figure()
plot(sweeps,SNRs);
title("SNR");
xlabel("Sweeps");
ylabel("SNR");
disp("Sum of All SNRs in different sweeps")
disp("Normal: "+sum(SNRs));
saveas(gcf,'SNRs.png');

%% Filter FIR LP,HP

low_freq = 1;
high_freq = 20;
t = 0:1/fs:(length(eeg)-1)/fs;

lpFilt = designfilt('lowpassfir','PassbandFrequency',2*high_freq/fs, ...
'StopbandFrequency',2.1*high_freq/fs,'PassbandRipple',0.5, ...
'StopbandAttenuation',65,'DesignMethod','kaiserwin');

freqz(lpFilt);
saveas(gcf,'lpf FIR.png');

eeg_filtered1 = filtfilt(lpFilt,eeg);

hpFilt = designfilt('highpassfir','PassbandFrequency',2*low_freq/fs, ...
'StopbandFrequency',1.9*low_freq/fs,'PassbandRipple',0.5, ...
'StopbandAttenuation',65,'DesignMethod','kaiserwin');
freqz(hpFilt);
saveas(gcf,'hpf FIR.png');

eeg_filtered1 = filtfilt(hpFilt,eeg_filtered1);

%% calculate SNR throw sweeps
SNRs = zeros(length(sweeps),1);
counter = 1;
for sweep = sweeps
    [ target , novel , target_e, target_o, novel_e , novel_o ] = Grand_Averaging(eeg_filtered1,indf,indd , fs,sweep);
    x_prime = target_o - target_e;
    x_bar = ( target_o + target_e ) / 2;
    SNRs(counter) = var(x_bar) / var(x_prime);
    counter = counter+1;
end

%% calculate ABR and show
t = -52*0.001:1/fs:500*0.001;
t2 = 16*0.001:1/fs:200*0.001;
figure();
plot(t,novel);
hold on;
plot(t,target);
ylabel("Magnitude");
xlabel("Time");
plot(t2,(novel_o+novel_e)/2);
plot(t2,(target_o+target_e)/2);
legend("erp novel", "erp target","Mean of novel sweeps" , "Mean of target sweeps")
title("Averaged ABR")
saveas(gcf,'Averaged ABR FIR.png');

figure();
hold on;
plot(t2,target_e);
plot(t2,target_o);
plot(t2, target_o - target_e);
legend("even sweeps", "odd sweeps", "diffrences between sweeps");
ylabel("Magnitude");
xlabel("Time");
title("even and odd sweeps")
saveas(gcf,'even and odd sweeps FIR.png');

figure()
plot(sweeps,SNRs);
title("SNR");
xlabel("Sweeps");
ylabel("SNR");
disp("FIR: "+sum(SNRs));
saveas(gcf,'SNRs FIR.png');

figure()
frequency_domain = fft(target);
frequency_domain_shifted = fftshift(frequency_domain);
n = length(target);
f = (-n/2:n/2-1)*(fs/n);
plot(f,real(frequency_domain_shifted));
title("frequency domain of target");
saveas(gcf,'frequency domain represenation FIR filter.png');

%% Filter IIR LP,HP

lpFilt = designfilt('lowpassiir','FilterOrder',8, ...
         'PassbandFrequency',high_freq/fs,'PassbandRipple',0.2, ...
         'SampleRate',1);
freqz(lpFilt);
saveas(gcf,'lpf IIR.png');

eeg_filtered2 = filtfilt(lpFilt,eeg);

hpFilt = designfilt('highpassiir','FilterOrder',8, ...
         'PassbandFrequency',low_freq,'PassbandRipple',0.2, ...
         'SampleRate',250);
freqz(hpFilt);
saveas(gcf,'hpf IIR.png');

eeg_filtered2 = filtfilt(hpFilt,eeg_filtered2);

%% calculate SNR throw sweeps
SNRs = zeros(length(sweeps),1);
counter = 1;
for sweep = sweeps
    [ target , novel , target_e, target_o, novel_e , novel_o ] = Grand_Averaging(eeg_filtered2,indf,indd , fs,sweep);
    x_prime = target_o - target_e;
    x_bar = ( target_o + target_e ) / 2;
    SNRs(counter) = var(x_bar) / var(x_prime);
    counter = counter+1;
end

%% calculate ABR and show
t = -52*0.001:1/fs:500*0.001;
t2 = 16*0.001:1/fs:200*0.001;
figure();
plot(t,novel);
hold on;
plot(t,target);
ylabel("Magnitude");
xlabel("Time");
plot(t2,(novel_o+novel_e)/2);
plot(t2,(target_o+target_e)/2);
legend("erp novel", "erp target","Mean of novel sweeps" , "Mean of target sweeps")
title("Averaged ABR")
saveas(gcf,'Averaged ABR IIR.png');

figure();
hold on;
plot(t2,target_e);
plot(t2,target_o);
plot(t2, target_o - target_e);
legend("even sweeps", "odd sweeps", "diffrences between sweeps");
ylabel("Magnitude");
xlabel("Time");
title("even and odd sweeps")
saveas(gcf,'even and odd sweeps IIR.png');

figure()
plot(sweeps,SNRs);
title("SNR");
xlabel("Sweeps");
ylabel("SNR");
disp("IIR: "+sum(SNRs) );
saveas(gcf,'SNRs IIR.png');

figure()
frequency_domain = fft(target);
frequency_domain_shifted = fftshift(frequency_domain);
n = length(target);
f = (-n/2:n/2-1)*(fs/n);
plot(f,real(frequency_domain_shifted));
title("frequency domainof target");
saveas(gcf,'frequency domain represenation IIR.png');

