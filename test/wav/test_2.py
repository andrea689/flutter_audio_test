from scipy.io import wavfile
import scipy.signal as sps
import numpy as np

# Your new sampling rate
new_rate = 44100

# Read file
sampling_rate, data = wavfile.read('burst_2394_20211006_130618_lambda.wav')
print(sampling_rate)

# Resample data
number_of_samples = round(len(data) * float(new_rate) / sampling_rate)
data = sps.resample(data, number_of_samples).astype(np.int16)

wavfile.write('burst_2394_20211006_130618_lambda_44100.wav', new_rate, data)

sampling_rate, data = wavfile.read('burst_2394_20211006_130618_lambda_44100.wav')
print(sampling_rate)