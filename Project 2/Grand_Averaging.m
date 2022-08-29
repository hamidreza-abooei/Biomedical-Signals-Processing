function [ relevant_avg , irrelevant_avg , relevant_avg_even, relevant_avg_odd,irrelevant_avg_even , irrelevant_avg_odd ] = Grand_Averaging(eeg,indf,indd,fs , sweep)
%GRAND_AVERAGING computes grand averaging from -50ms to 500ms after stimuli
%   Input: eeg raw data, indf: index of relevant, indd: index of irrilevant
%   fs: sampling frequency
start_time = -50*0.001;
final_time = 500*0.001;
start_index = round(start_time * fs);
final_index = final_time * fs;
snr_s_index = 16*0.001 * fs;
snr_f_index = 200*0.001 * fs;
% indd = indd(randperm(length(indd)));
% indf = indf(randperm(length(indf)));

relevant_avg = zeros(final_index - start_index + 1,1);
relevant_avg_even = zeros(snr_f_index - snr_s_index + 1,1);
relevant_avg_odd = zeros(snr_f_index - snr_s_index + 1,1);
counter_odd = 0;
counter_even = 0;
counter = 0;
for index = indf'
    counter = counter + 1;
    epoch = eeg(index + start_index : index + final_index );
    average = mean (epoch);
    epoch = epoch - average;
    if (counter <= sweep )
        if (mod(counter , 2) == 0)
            relevant_avg_even = relevant_avg_even + eeg(index + snr_s_index : index + snr_f_index ) - average;
            counter_even = counter_even+1;
        else
            relevant_avg_odd = relevant_avg_odd + eeg(index + snr_s_index : index + snr_f_index ) - average;
            counter_odd = counter_odd + 1;
        end
    end
    relevant_avg = relevant_avg + epoch;
end 

relevant_avg_odd = relevant_avg_odd / counter_odd;
relevant_avg_even = relevant_avg_even / counter_even;
relevant_avg = relevant_avg / length(indf);

irrelevant_avg_even = zeros(snr_f_index - snr_s_index + 1,1);
irrelevant_avg_odd = zeros(snr_f_index - snr_s_index + 1,1);
ircounter_odd = 0;
ircounter_even = 0;
ircounter = 0;
irrelevant_avg = zeros(final_index - start_index+1,1);
for index = indd'
    ircounter = ircounter + 1;
    epoch = eeg(index + start_index : index + final_index );
    average = mean (epoch);
    epoch = epoch - average;
    if (ircounter <= sweep )
        if (mod(ircounter , 2) == 0)
            irrelevant_avg_even = irrelevant_avg_even + eeg(index + snr_s_index : index + snr_f_index ) - average;
            ircounter_even = ircounter_even+1;
        else
            irrelevant_avg_odd = irrelevant_avg_odd + eeg(index + snr_s_index : index + snr_f_index ) - average;
            ircounter_odd = ircounter_odd + 1;
        end
    end
    irrelevant_avg = irrelevant_avg + epoch;
end 

irrelevant_avg_odd = irrelevant_avg_odd / ircounter_odd;
irrelevant_avg_even = irrelevant_avg_even / ircounter_even;
irrelevant_avg = irrelevant_avg / length(indd);

end

