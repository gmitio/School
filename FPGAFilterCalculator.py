## Nifty little filter script good for analysis of small filters or second order sections for FPGA Implementation ##
## Saves some of the work involved in signal level planning and calculating Verilog filter coefficients           ##
## Written by Graison Mitio, February 29, 2020 (grm011@mail.usask.ca) ##
import math
import cmath
import numpy as np
import matplotlib.pyplot as plt


## CHANGE THIS STUFF ##
r = 0.9
phi = math.pi/4
scaling = 1

#a_coeff = [1]
b_coeff = [1, -1, 1]
#b_coeff = [1]
a_coeff = [1, 1.1314, -0.64]	# Use MATLAB freqz() style for these coefficients
coeff_file = r"C:\Users\graison\PycharmProjects\FPGAFilterCalculator\output.v"  # File to store the Verilog coefficients to
## SHOULDN'T NEED TO CHANGE ANYTHING ELSE ##


## Find the frequency response of the transfer function from the coefficients ##
omega = np.arange(0, math.pi, 0.01)    # Array holding frequency range to be plotted
amplitude = []  # Array to hold amplitude values at each frequency

for w in omega: # Construct the transfer function for each value of w
    numerator = 0
    denominator = 0
    for i in range(len(b_coeff)):
        numerator += (b_coeff[i]*cmath.exp(-i*1j*w))
    for i in range(len(a_coeff)):
        if i == 0:
            denominator = 1
        else:
            denominator += -(a_coeff[i]*cmath.exp(-i*1j*w))

    H = numerator/denominator   # Stick it all together and push it to the mag response array
    amplitude.append(abs(H))

#plt.plot(omega,amplitude)  # For debugging
#plt.show()
print('Maximum amplitude from input to output, unity scaling:\033[1;32;48m ' + str(round(abs(max(amplitude)),4)) + '\033[0;37;48m')
print('Number of additional bits required at output with a scaling factor of ' + str(scaling) +': \033[1;36;48m' + str(math.ceil(math.log2(abs(max(amplitude))*scaling))) + '\033[0;37;48m')


## Generate the FPGA coefficients and their signal formats for the zero section ##
for b in range(len(b_coeff)):
    if b_coeff[b] != 0:
        msbits = math.ceil(math.log2(abs(b_coeff[b]))) + 1
        lsbits = 18 - (math.ceil(math.log2(abs(b_coeff[b]))) + 1)
        if b_coeff[b] != 1:
            print('Signal format of b' + str(b) + ':\033[1;31;48m', str(msbits) + 's' + str(lsbits) + '\033[0;37;48m')
            if b_coeff[b] < 0:
                print('b' + str(b) +  ' = -18\'sd' + str(-round(b_coeff[b]*2**lsbits)))
                with open(coeff_file, 'a') as f:
                    f.write(f'  localparam B' + str(b) + ' = ' + '-18\'sd' + str(-round(b_coeff[b]*2**lsbits)) + '; // '+str(msbits)+'s'+str(lsbits)+' signal format\n')
            else:
                print('b' + str(b) + ' = 18\'sd' + str(round(b_coeff[b] * 2 ** lsbits)))
                with open(coeff_file, 'a') as f:
                    f.write(f'  localparam B' + str(b) + ' = ' + '18\'sd' + str(round(b_coeff[b]*2**lsbits)) + '; // '+str(msbits)+'s'+str(lsbits)+' signal format\n')

# Generate the FPGA coefficients for the pole section
for a in range(len(a_coeff)):
    if a_coeff[a] != 0:
        msbits = math.ceil(math.log2(abs(a_coeff[a]))) + 1
        lsbits = 18 - (math.ceil(math.log2(abs(a_coeff[a]))) + 1)
        if a_coeff[a] != 1:
            print('Signal format of a' + str(a) + ':\033[1;31;48m', str(msbits) + 's' + str(lsbits) + '\033[0;37;48m')
            if a_coeff[a] < 0:
                print('a' + str(a) + ' = -18\'sd' + str(-round(a_coeff[a]*2**lsbits)))
                with open(coeff_file, 'a') as f:
                    f.write(f'  localparam A' + str(a) + ' = ' + '-18\'sd' + str(-round(a_coeff[a]*2**lsbits)) + '; // '+str(msbits)+'s'+str(lsbits)+' signal format\n')
            else:
                print('a' + str(a) + ' = 18\'sd' + str(round(a_coeff[a] * 2 ** lsbits)))
                with open(coeff_file, 'a') as f:
                    f.write(f'  localparam A' + str(a) + ' = ' + '18\'sd' + str(round(a_coeff[a]*2**lsbits)) + '; // '+str(msbits)+'s'+str(lsbits)+' signal format\n')



