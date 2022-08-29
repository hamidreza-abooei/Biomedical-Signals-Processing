import numpy as np
import matplotlib.pyplot as plt
import matplotlib

frequency_range = [0 , 11000]
dynamic_range = [0,0.11]

class Biomedical_Signal:
    def __init__(self, name, min_frequincy, max_frequency, min_dynamic_range, max_dynamic_range):
        self.name = name
        self.min_dynamic_range = min_dynamic_range
        self.max_dynamic_range = max_dynamic_range
        self.min_frequincy = min_frequincy 
        self.max_frequency = max_frequency
    def get_freq_range(self):
        return self.max_frequency - self.min_frequincy
    def get_dynamic_range_range(self):
        return self.max_dynamic_range - self.min_dynamic_range
    
BME_signals = []
BME_signals.append(Biomedical_Signal("EEG" ,0.5,100,2*10**-6,100*10**-6))
BME_signals.append(Biomedical_Signal("ECG" ,0.05,100,1*10**-3,10*10**-3))
BME_signals.append(Biomedical_Signal("AP" ,100,2000,10*10**-6,100*10**-3))
BME_signals.append(Biomedical_Signal("ENG" ,100,1000,5*10**-6,10*10**-3))
BME_signals.append(Biomedical_Signal("ERG" ,0.2,200,0.5*10**-6,1*10**-3))
BME_signals.append(Biomedical_Signal("EOG" ,0,100,10*10**-6,5*10**-3))
BME_signals.append(Biomedical_Signal("VEP" ,1,300,1*10**-6,20*10**-6))
BME_signals.append(Biomedical_Signal("SEP" ,2,3000 ,0.1*10**-6,5*10**-6))
BME_signals.append(Biomedical_Signal("AEP" ,100,3000 ,0.5*10**-6,10*10**-6))
BME_signals.append(Biomedical_Signal("SFEMG" ,500,10000 ,1*10**-6,10*10**-6))
BME_signals.append(Biomedical_Signal("MUAP" ,5,10000 ,100*10**-6,2*10**-3))
BME_signals.append(Biomedical_Signal("Skeletal SEMG" ,2,500 ,50*10**-6,5*10**-3))
BME_signals.append(Biomedical_Signal("Smooth SEMG" ,0.01,1 ,50*10**-6,5*10**-3))



fig = plt.figure()
ax = fig.add_subplot(111)
for BME_signal in BME_signals:
    colors = np.random.rand(3)
    rect = matplotlib.patches.Rectangle((BME_signal.min_frequincy, BME_signal.min_dynamic_range),
                                     BME_signal.get_freq_range(), BME_signal.get_dynamic_range_range(),
                                     color =colors,label = BME_signal.name, alpha = 0.4)
    ax.add_patch(rect)


ax.set_yscale('log') 
ax.set_xscale('log')

plt.legend()
plt.title("Signal dynamic range and frequency domain")
plt.xlabel("Frequency")
plt.ylabel("Dynamic range")
plt.xlim(frequency_range)
plt.ylim(dynamic_range)
mng = plt.get_current_fig_manager()
mng.resize(*mng.window.maxsize())
plt.savefig("Biomedical-signal-rang.png")
plt.show()
