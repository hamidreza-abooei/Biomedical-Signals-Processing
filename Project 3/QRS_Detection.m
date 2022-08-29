function QRS_Detection(ecg, titletext)
%Pan Tompkin algorithm for QRS-Detection
%   input ecg signal , title

[m,n] = size(ecg);

fs = 200; %Hz
high_freq = 15;
low_freq = 5;

t = 0:1/fs:(m-1)/fs;
figure();
plot(t,ecg);
title("Original Signal "+titletext);

lpFilt = designfilt('lowpassiir','FilterOrder',8, ...
         'PassbandFrequency',high_freq,'PassbandRipple',0.2, ...
         'SampleRate',fs);


hpFilt = designfilt('highpassiir','FilterOrder',8, ...
         'PassbandFrequency',low_freq,'PassbandRipple',0.2, ...
         'SampleRate',fs);

lpffiltered = filtfilt(lpFilt,ecg);
filtered = filtfilt(hpFilt,lpffiltered);

figure()
frequency_domain = fft(filtered);
frequency_domain_shifted = fftshift(frequency_domain);
f = (-m/2:m/2-1)*(fs/m);
plot(f,real(frequency_domain_shifted));
title("frequency domain of filtered " + titletext);

% figure();
% plot(t,filtered);
% title("filtered" +titletext);

%% Derivation
% Make impulse response
h = [-1 -2 0 2 1]/8;
% Apply filter
derivate = conv (filtered ,h);
derivate = derivate (2+ [1: m]);

%% Squering 
squered = derivate.^2;

%% Moving Window Integration
% Make impulse response
h2 = ones (1 ,31)/31;

% Apply filter
MWI = conv (squered ,h2);
MWI = MWI (15 + [1: m]);

%% QRS detection
refractory_period = 0.2 * fs;
thresh = mean (MWI );
MWI_thresh = MWI > thresh ;

% Drivation
MWIderivate = conv (MWI ,h);
MWIderivate = MWIderivate (2+ [1: m]);

MWIderivate_thresh = MWIderivate .* MWI_thresh;

pot_peak_index = zeros(1,length(MWIderivate_thresh));
for index = 2:length(MWIderivate_thresh)-1
    if (MWIderivate_thresh(index-1)<0 && MWIderivate_thresh(index+1)>0)
        pot_peak_index(index) = 1;
    end
end
selected = pot_peak_index' .* MWI;
peak_index = zeros(1,length(pot_peak_index));
padded = padarray(selected,refractory_period/2);
for i = refractory_period/2+1 : length(MWIderivate_thresh)+refractory_period/2
    [a,index] = max(padded(i - refractory_period / 2 : i + refractory_period / 2));
    if(index == refractory_period/2+1)
        peak_index(i - refractory_period / 2 ) = i - refractory_period / 2 ;
    end
end
peak_index(peak_index == 0) = [];
peaks = length(peak_index);
RR_time = zeros(1,peaks);
for i = 1:peaks-1
    RR_time(i) = (peak_index(i+1)-peak_index(i))/fs;
end


Q_index = zeros(1,peaks);
S_index = zeros(1,peaks);
counter = 1;
false_QS = [];
for i = peak_index
    if (i-refractory_period/2 > 0)
        [Q,Q_index(counter)] = min(filtered(i-refractory_period/2:i));
        Q_index(counter) = Q_index(counter) - refractory_period/2 + i-1;
    else
        false_QS = [false_QS, counter];
    end 
    if (i+refractory_period/2 < length(filtered))
        [S,S_index(counter)] = min(filtered(i+1:i+refractory_period/2));
        S_index(counter) = S_index(counter) + i;
    else
        false_QS = [false_QS, counter];
    end
    counter = counter+1;
end

Q_index(false_QS) = [];
S_index(false_QS) = [];
QS_sum = (sum(S_index)-sum(Q_index))/fs;
QS_mean = QS_sum / length(Q_index);


fprintf("\n\n%s\n", titletext);
fprintf("Number of identified peaks:");
disp(peaks);
total_time = length(ecg)/fs;
HR = peaks * 60 / total_time;
fprintf("\nHeart rate: %d", HR);
fprintf("\nRR time: %f ms", mean(RR_time)*1000);
fprintf("\nRR std: %f ms", std(RR_time)*1000);
fprintf("\nQRS width mean: %f ms\n", QS_mean*1000);


figure();
plot(t,filtered);
hold on ;
scatter (t(peak_index),filtered(peak_index),'b');
scatter (t(Q_index),filtered(Q_index),'r');
scatter (t(S_index),filtered(S_index),'g');
legend("filtered ECG","R","Q","S");
title("detected QRS " + titletext);


end

