%%
clc
clear
close all

%% Load data
mat_files_name = dir('*.mat');

for i = 1:length(mat_files_name)
    load(mat_files_name(i).name);
end
fs = 2000;%Hz
t1 = 0:1/fs:(length(data1)-1)/fs;
t2 = 0:1/fs:(length(data2)-1)/fs;
t3 = 0:1/fs:(length(data3)-1)/fs;
t4 = 0:1/fs:(length(data4)-1)/fs;

figure()
subplot(3,3,1);
plot(t1,data1,"b");
title("EMG1 Original");
xlabel("t");
ylabel("Magnitude");
ylim([-2e-3 , 2e-3]);
subplot(3,3,2);
plot(t2,data2,"b");
title("EMG2 Original");
xlabel("t");
ylabel("Magnitude");
ylim([-2e-3 , 2e-3]);
subplot(3,3,3);
plot(t3,data3,"b");
title("EMG3 Original");
xlabel("t");
ylabel("Magnitude");
ylim([-2e-3 , 2e-3]);


%% Notch filter
Notch = designfilt(...
    'bandstopiir','FilterOrder',2,...
    'HalfPowerFrequency1',49,'HalfPowerFrequency2',51,...
    'DesignMethod','butter','SampleRate',fs);
% freqz(Notch);
EMG1_filtered=filtfilt(Notch,data1);
EMG2_filtered=filtfilt(Notch,data2);
EMG3_filtered=filtfilt(Notch,data3);
% EMG4_filtered=filtfilt(Notch,data4);

%% second row

subplot(3,3,4)
plot(t1,EMG1_filtered,'r')
title('filtered EMG1')
xlabel('t')
ylabel("Magnitude");
ylim([-2e-3 , 2e-3]);
subplot(3,3,5)
xlabel("t");
ylabel("Magnitude");
plot(t2,EMG2_filtered,'r')
title('filtered EMG2')
xlabel("t");
ylabel("Magnitude");
ylim([-2e-3 , 2e-3]);
subplot(3,3,6)
plot(t3,EMG3_filtered,'r')
title('filtered EMG3')
xlabel("t");
ylabel("Magnitude");
ylim([-2e-3 , 2e-3]);


%% Envelope detection 
% rectify 
abs_EEG1=sqrt(EMG1_filtered.^2);
abs_EEG2=sqrt(EMG2_filtered.^2);
abs_EEG3=sqrt(EMG3_filtered.^2);

% moving average 
% window is 100ms * fs = 200
mean_EMG1=movmean(abs_EEG1,200);
mean_EMG2=movmean(abs_EEG2,200);
mean_EMG3=movmean(abs_EEG3,200);

%now we show RMS of EMG
subplot(3,3,7)
plot(t1,mean_EMG1,'k')
title('envelope EMG1')
xlabel('t')
ylabel("Magnitude");
ylim([0 , 5e-4]);
subplot(3,3,8)
xlabel('t')
ylabel("Magnitude");
plot(t2,mean_EMG2,'k')
title('envelope EMG2')
xlabel('t')
ylabel("Magnitude");
ylim([0 , 5e-4]);
subplot(3,3,9)
plot(t3,mean_EMG3,'k')
title('envelope EMG3')
xlabel('t')
ylabel("Magnitude");
ylim([0 , 5e-4]);



%% Windows
% time 
windows = zeros(7,0.5*fs+1);
figure();
[a,b] = size(windows);
t = 0:1/fs:(b-1)/fs;
meds = zeros(7,1);
zeroCrossing = zeros(7,1);
for i = 0:6
    windows(i+1, : ) = data4(5 * fs * i + 1 : 5 * fs * i + 0.5 * fs + 1);
    subplot(7,1,i+1);
    plot(t,windows(i+1,:));
    ylim([-2e-3 , 2e-3]);
    meds(i+1) = medfreq(windows(i+1, : ),fs);
    for j = 1:0.5*fs
        if (windows(i+1, j )*windows(i+1, j+1 ) < 0)
            zeroCrossing(i+1) = zeroCrossing(i+1) + 1;
        end
    end
end
suptitle("Windows 1-7");

figure()
fwindows = zeros(7,0.5*fs+1);
for i = 1:7
    fwindows(i,:) = fft(windows(i,:));
    fwindows(i,:) = fftshift(fwindows(i,:));
    f = (-b/2:b/2-1)*(fs/b);
    subplot(7,1,i);
    plot(f,real(fwindows(i,:)));
    
end
suptitle("frequency domain of windows");

figure();
plot(meds);
ylabel("frequency");
xlabel("window number");
title("medians");

figure();
plot(zeroCrossing);
ylabel("number");
xlabel("window number");
title("number of zero crossing");


