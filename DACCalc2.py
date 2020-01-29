import cmath
import math
import matplotlib.pyplot as plt
import numpy as np

pi = cmath.pi
V_FS = 0.285    # Full-scale DAC voltage
f = 1/8.0    # Baseband frequency (Discrete-Time)
freqmultiples = [f, 1+f, 1-f, 2+f, 2-f]

for f0 in freqmultiples:
    magF = 10*math.log( math.pow(
        abs( V_FS * cmath.exp(1j*pi*f0) * cmath.sin(pi*f0) / (pi*f0) )
        ,2) )
    print(magF)

Fs = 1 # samples/second
F = np.arange(-2.5,2.5,0.01).tolist()
plt.figure()
P0 = [10*math.log(V_FS*V_FS*math.pow(math.sin(pi*i/Fs),2)/(2*pow(pi*i/Fs,2))) for i in F]
plt.xlabel('Frequency (radians/second)')
plt.ylabel('Power (dBV)')
plt.ylim(-80,6)
plt.xlim(-2.5,2.5)
plt.plot(F,P0)
plt.show()

Fs = 25e6 # samples/second
F = np.arange(-2.5*Fs,2.5*Fs,1000.0).tolist()
plt.figure()
P1 = [10*math.log( (V_FS*V_FS*math.pow(math.sin(pi*i/Fs+1e-15),2)/(2*pow(pi*i/Fs,2)*50+1e-15)) / 1e-3) for i in F]

plt.xlabel('Frequency (radians/second)')
plt.ylabel('Power (dBm)')
plt.ylim(-80,6)
plt.xlim(-2.5*25e6,2.5*25e6)
plt.plot(F,P1)
plt.show()
