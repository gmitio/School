import math
import matplotlib.pyplot as plt
from scipy.stats import linregress

m = 3.0
c = 3.0e8	# m/s
k_b = 1.38e-23	# m^2kg/s
T = 300	# K
h = 6.626e-34 # m^2*kg/s
#d_lambda = (m*k_b*T)/(h*c)*lambd**2

lambd_measured = [650e-9, 810e-9, 820e-9, 890e-9, 950e-9, 1150e-9, 1270e-9, 1500e-9]
d_lambda_measured = [22e-9, 36e-9, 40e-9, 50e-9, 55e-9, 90e-9, 110e-9, 150e-9]

plt.plot(lambd_measured, d_lambda_measured)
plt.xlabel('Square peak emission wavelength (nm)')
plt.ylabel('Linewidth (nm)')
plt.show()

m_arr = []
d_lamd_calculated_array = []
for i in range(len(lambd_measured)):
  m = d_lambda_measured[i]*h*c/(lambd_measured[i]**2*k_b*T)
  m_arr.append(m)

for i in range(len(lambd_measured)):
  d_lamd_calculated = 62508*lambd_measured[i]**2;
  d_lamd_calculated_array.append(d_lamd_calculated);


print('m values of each spectral width: ', m_arr)
print('\n\nSpectral width values for each wavelength', d_lamd_calculated_array)
