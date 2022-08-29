%%
clc
clear
close all

%% Load data
dat_files_name = dir('*.dat');
a = [];
for i = 1:length(dat_files_name)
    a = [a, load(dat_files_name(i).name)];
end
sample_rate = 100;
m = size(a);
t = 1:m(1);
t = t/sample_rate;


%% Plot

figure()
for i= 1:m(2)
    subplot(m(2),1,i);
    plot(t,a(:,i))
end
suptitle("Original data EEG1");

%% Select k complex from signal
k_complex = a(150:181,1);
time = t(150:181);

%% Show spike and its frequency domain
figure();
subplot(2,1,1);
plot(time,k_complex);
y = fft(k_complex);
f = (0:length(y)-1)*sample_rate / length(y);
title('Time Domain of K complex');
xlabel('Time (S)')
ylabel('Magnitude')

subplot(2,1,2);
n = length(k_complex);                         
fshift = (-n/2:n/2-1)*(sample_rate/n);
yshift = fftshift(y);
plot(fshift,abs(yshift))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('Frequency Domain')

%% Cross Correlation
figure();

for i = 1:m(2)
    subplot(m(2),1,i);
    [acor,lag] = xcorr(a(:,i),k_complex);
    lag = lag / sample_rate;
    acor = acor / (std(a(:,i)) * std(k_complex)); 
    plot(lag((length(lag)+1)/2:end),acor((length(lag)+1)/2:end),'b');

end

suptitle('Cross-Correlation with K complex')

%% Select spike from signal
spike = a(61:66,1);
time = t(61:66);

%% Show spike and its frequency domain
figure();
subplot(2,1,1);
plot(time,spike);
y = fft(spike);
f = (0:length(y)-1)*sample_rate / length(y);
title('Time Domain of spike');
xlabel('Time (S)')
ylabel('Magnitude')

subplot(2,1,2);
n = length(spike);                         
fshift = (-n/2:n/2-1)*(sample_rate/n);
yshift = fftshift(y);
plot(fshift,abs(yshift))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('Frequency Domain')

%% Cross Correlation
figure();

for i = 1:m(2)
    subplot(m(2),1,i);
    [acor,lag] = xcorr(a(:,i),spike);
    lag = lag / sample_rate;
    acor = acor / (std(a(:,i)) * std(spike)); 
    plot(lag((length(lag)+1)/2:end),acor((length(lag)+1)/2:end),'b');

end

suptitle('Cross-Correlation with spike')

