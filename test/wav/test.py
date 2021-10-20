from scipy.io import wavfile
import scipy.signal as sps
import numpy as np
from http.server import BaseHTTPRequestHandler,HTTPServer, SimpleHTTPRequestHandler
import json

# Your new sampling rate
new_rate = 44100

# Read file
sampling_rate, data = wavfile.read('burst_2394_20211006_130618_lambda.wav')
print(sampling_rate)

# Resample data
number_of_samples = round(len(data) * float(new_rate) / sampling_rate)
data = sps.resample(data, number_of_samples).astype(np.int16)

f = open("burst_2394_20211006_130618_filtered_44100.txt", "a")
f.write(','.join(str(x) for x in data))
f.close()

wavfile.write('burst_2394_20211006_130618_lambda_44100.wav', new_rate, data)

sampling_rate, data = wavfile.read('burst_2394_20211006_130618_lambda_44100.wav')
print(sampling_rate)

wav_data = open('burst_2394_20211006_130618_lambda_44100.wav',  'rb').read()
#print(data)

class GetHandler(SimpleHTTPRequestHandler):
    @property
    def api_response(self):
        return json.dumps({"date": "2021-07-10T09:53:44Z", "wav_bytes": list(wav_data)}).encode()

    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()
        self.wfile.write(bytes(self.api_response))
        return

Handler=GetHandler

httpd=HTTPServer(("192.168.1.17", 8080), Handler)
httpd.serve_forever()