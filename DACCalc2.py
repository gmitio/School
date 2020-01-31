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
#F = np.arange(-2.5*Fs,2.5*Fs,1000.0).tolist()
F0 = np.arange(-2.5*Fs,2.5*Fs,0.01).tolist()


#plt.figure()
P0 = [10*math.log(V_FS*V_FS*math.pow(math.sin(pi*i/Fs),2)/(2*pow(pi*i/Fs,2))) for i in F0]	# dBV Plot
"""
plt.xlabel('Frequency (radians/second)')
plt.ylabel('Power (dBV)')
plt.ylim(-80,6)
plt.xlim(-2.5,2.5)
plt.plot(F,P0)
plt.show()
"""

Fs = 25e6 # samples/second
F1 = np.arange(-2.5*Fs,2.5*Fs,1000.0).tolist()
#plt.figure()
P1 = [10*math.log( (V_FS*V_FS*math.pow(math.sin(pi*i/Fs+1e-15),2)/(2*pow(pi*i/Fs,2)*50+1e-15)) / 1e-3) for i in F1]	# dBm plot

"""
plt.xlabel('Frequency (radians/second)')
plt.ylabel('Power (dBm)')
plt.ylim(-80,6)
plt.xlim(-2.5*25e6,2.5*25e6)
plt.plot(F,P1)
plt.show()
"""

Fs = 25e6
F_ref = 0
F2 = np.arange(-2.5*Fs, 2.5*Fs, 1000.0).tolist()
#plt.figure()
P2 = [10*math.log(( (V_FS*V_FS*math.pow(math.sin(pi*i/Fs + 1e-15) ,2)) / (2*math.pow(pi*i/Fs + 1e-15, 2)))  / (V_FS*V_FS*math.pow(math.sin(pi*F_ref/Fs + 1e-15), 2) / (2*math.pow(pi*F_ref/Fs + 1e-15 ,2)) ) ) for i in F2]

"""
plt.xlabel('Frequency (radians/second)')
plt.ylabel('Power (dB Ref.)')
plt.ylim(-80,6)
#plt.xlim()
plt.plot(F, P2)
plt.show()
"""

# Let's try to use these fancy subplots so it's less AIDS to present
fig, axs = plt.subplots(2,2)
axs[0, 0].plot(F0, P0)
axs[0, 0].set_title('dBV Plot')
axs[0, 0].set_ylim([-80,6])
axs[0, 0].set_xlim([-2.5,2.5])

axs[0, 1].plot(F1, P1)
axs[0, 1].set_title('dBm Plot')
axs[0, 1].set_xlim([-2.5*25e6, 2.5*25e6])
axs[0, 1].set_ylim([-80,6])

axs[1, 0].plot(F2, P2)
axs[1, 0].set_title('dB Ref Plot')
axs[1, 0].set_xlim([-2.5*25e6, 2.5*25e6])
axs[1, 0].set_ylim([-80,6])

plt.show()

