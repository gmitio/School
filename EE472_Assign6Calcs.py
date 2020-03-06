import math
import matplotlib.pyplot as plt
import numpy as np

# Standard SMF Variables
smf_R = [5.0, 7.0, 10.0, 12.5, 16.0, 17.5]	# mm
smf_alpha = [15.0, 4.00, 0.611, 0.124, 0.0105, 0.0040]	# dB/turn
[rrc_smf, A_smf] = np.polyfit(smf_R, np.log(smf_alpha), 1)
#print('SMF Values:', math.exp(A_smf), rrc_smf)
print('SMF Equation: ', 'y = ' + str(math.exp(A_smf)) + '*e^' + str(rrc_smf))

# Trench Fiber 1 Variables
trench1_R = [7.50, 10.0, 15.0]	# mm
trench1_alpha = [0.354, 0.135, 0.020]	# dB/turn
[rrc_trench1, A_trench1] = np.polyfit(trench1_R, np.log(trench1_alpha), 1)
#print('Trench 1 Values:', math.exp(A_trench1), rrc_trench1)
print('Trench 1 Equation: ', 'y = ' + str(math.exp(A_trench1)) + '*e^' + str(rrc_trench1))

# Trench Fiber 2 Variables
trench2_R = [5.0, 7.5, 10.0, 15.0]	# mm
trench2_alpha = [0.178, 0.0619, 0.0162, 0.00092]	# dB/turn
[rrc_trench2, A_trench2] = np.polyfit(trench2_R, np.log(trench2_alpha), 1)
#print('Trench 2 Values:', math.exp(A_trench2), rrc_trench2)	# Print the A and -R/Rc value
print('Trench 2 Equation: ', 'y = ' + str(math.exp(A_trench2)) + '*e^' + str(rrc_trench2))

# Nanoengineered Fiber Variables
nanoeng_R = [5.0, 7.5, 10.0, 15]	# mm
nanoeng_alpha = [0.031, 0.0081, 0.0030, 0.00018]	# dB/turn

[rrc_nanoeng, A_nanoeng] = np.polyfit(nanoeng_R, np.log(nanoeng_alpha), 1)
print('Nanoengineered Equation: ', 'y = ' + str(math.exp(A_nanoeng)) + '*e^' + str(rrc_nanoeng))


smf_rc = math.log(0.1/math.exp(A_smf))/rrc_smf
print('Min allowed radii of curvature for SMF:', round(smf_rc, 1), 'mm')

trench1_rc = math.log(0.1/math.exp(A_trench1))/rrc_trench1
print('Min allowed radii of curvature for Trench Fiber 1:', round(trench1_rc, 1), 'mm')

trench2_rc = math.log(0.1/math.exp(A_trench2))/rrc_trench2
print('Min allowed radii of curvature for Trench Fiber 2:', round(trench2_rc, 1), 'mm')

nanoeng_rc = math.log(0.1/math.exp(A_nanoeng))/rrc_nanoeng
print('Min allowed radii of curvature for nanoengineered fiber:', round(nanoeng_rc, 1), 'mm')


plt.plot(smf_R, smf_alpha,'bo-', label='SMF')
plt.yscale('log')
plt.plot(trench1_R, trench1_alpha, 'gd-',  label='Trench1')
plt.yscale('log')
plt.plot(trench2_R, trench2_alpha, 'rv-',  label='Trench2')
plt.yscale('log')
plt.plot(nanoeng_R, nanoeng_alpha, 'cx-',  label='Nanoengineered')
plt.yscale('log')
plt.xlabel('Radius (mm)')
plt.ylabel('Loss (dB/turn)')
plt.show()
