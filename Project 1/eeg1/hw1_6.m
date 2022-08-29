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

%% Select alpha wave from signal
alpha_wave = a(510:561,1);
time = t(510:561);

%% Show alpha wave and its frequency domain
figure();
subplot(2,1,1);
plot(time,alpha_wave);
y = fft(alpha_wave);
f = (0:length(y)-1)*sample_rate / length(y);
title('Time Domain');
xlabel('Time (S)')
ylabel('Magnitude')

subplot(2,1,2);
n = length(alpha_wave);                         
fshift = (-n/2:n/2-1)*(sample_rate/n);
yshift = fftshift(y);
plot(fshift,abs(yshift))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('Frequency Domain')

%% Cross Correlation
figure();
batch_size = 10;

for i = 1:m(2)
    subplot(m(2),1,i);
    [acor,lag] = xcorr(a(:,i),alpha_wave);
    lag = lag / sample_rate;
    acor = acor / (std(a(:,i)) * std(alpha_wave)); 
    thresh = zeros(length(acor),1);
    stand = std(acor);
    avg = mean(abs(acor));
    for j = batch_size/2+1:length(acor)-batch_size/2
        if (mean(abs(acor(j-batch_size/2:j+batch_size/2)))>stand)
            thresh(j) = stand;
            if (mean(abs(acor(j-batch_size/2:j+batch_size/2)))>2*stand)
                thresh(j) = 2*stand;
            end
        end
    end
    plot(lag((length(lag)+1)/2:end),(acor((length(lag)+1)/2:end)),'b');
    hold on
    plot(lag((length(lag)+1)/2:end),thresh((length(lag)+1)/2:end),'r')
end

suptitle('Cross-Correlation')

