import Adafruit_ADS1x15

adc = Adafruit_ADS1x15.ADS1115()
GAIN = 1

values = [0]*4
for i in range(4):
    values[i] = adc.read_adc(i, gain=GAIN)

print('Photodiode = {}'.format(values[0]))
print('Photoresistor = {}'.format(values[1]))
print('Watermark = {}'.format(values[2]))
