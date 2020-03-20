import math
import numpy as np
import matplotlib.pyplot as plt

wl = [1.451, 1.471, 1.491, 1.511, 1.531, 1.551, 1.571, 1.591]  # Operating wavelengths
n_wl = []  # Empty array to hold corresponding refractive index values at 22 Degrees Celsius
n_T = []  # Empty array to hold the refractive index temperature dependence at one wavelength
delta_wl = []  # Empty array to hold dispersion angle of each wavelength

# Constants of dispersion for the Schott SF11 Glass
B1 = 1.73759695
B2 = 0.313747346
B3 = 1.89878101
C1 = 0.013188707
C2 = 0.0623068142
C3 = 155.23629

# Constants of temperature dependent dispersion for the Schott SF11 Glass
D0 = -3.56e-6
D1 = 9.20e-9
D2 = -2.10e-11
E0 = 9.65e-7
E1 = 1.44e-9
wltk = 0.294

# Sellmeier equation
for lambd in wl:
    n = math.sqrt(
        1 + (B1 * lambd ** 2) / (lambd ** 2 - C1) + (B2 * lambd ** 2) / (lambd ** 2 - C2) + (B3 * lambd ** 2) / (
                lambd ** 2 - C3))
    n_wl.append(n)
alpha = math.radians(60.0)  # Angle of dispersive prism apex
# Prism total internal reflection, from Snell's Law
alpha = math.radians(60.0)  # Angle of dispersive prism apex
theta = math.asin(math.sin(alpha - math.asin(1 / n_wl[0])) * (n_wl[0]))  # Max angle before TIR, in radians
print('Maximum angle before total internal reflection: ' + str(round(math.degrees(theta))) + ' degrees')

# Equation for deflection of beams from the prism
for n in n_wl:
    delta = theta - alpha + math.asin(
        math.sin(alpha * math.sqrt(n * n - (math.sin(theta)) ** 2)) - math.sin(theta) * math.cos(alpha))
    delta_wl.append(delta)

    # for d in range(len(delta_wl)):  # Find the angle between each dispersed wavelength
    #     if d < len(delta_wl) - 1:
    #         ddelta = -math.degrees((delta_wl[d] - delta_wl[d + 1]))
    #     else:
    #         ddelta = 0
    #     ddelta_wl.append(ddelta)
    # Just find two of these at some wavelength; we'll difference these later on

print(n_wl)
print(-(math.degrees(delta_wl[3]) - math.degrees(delta_wl[4])))  # Angle of dispersion between channel 4 and 5

# plt.plot(theta_array, delta_array)
# plt.show()
T_max = 31
T_min = 15
T_0 = 22
temperature = np.arange(T_min - T_0, T_max - T_0+1, 1)  # Create the array of temperature deviations
channel_index = 0
for T in temperature:
    dn = ((n_wl[channel_index] ** 2 - 1) / (2 * n_wl[channel_index])) * (
                D0 * T + D1 * T ** 2 + D2 * T ** 3 + ((E0 * T + E1 * T ** 2) / (wl[channel_index] ** 2 - wltk ** 2))) + \
         wl[channel_index]
    n_T.append(dn)

print(temperature)
plt.plot(temperature+22, n_T)
plt.title('Temperature Dependence of Refractive\nIndex of SF11 Glass, 15-31 Celsius')
plt.xlabel('Temperature, Deg. Celsius')
plt.ylabel('Refractive Index')
plt.xlim(15, 31)
plt.show()
