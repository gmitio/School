# TO DO: Make the frequency response work with N-length filters in a loop
import math
import cmath
import numpy as np
import matplotlib.pyplot as plt

# Transfer Function Coefficients
r = 0.9
phi = math.pi/4
scaling = 0.5

b_coeff = [1,0,0,0]
a_coeff = [1,2*r*math.cos(phi),-r*r,0]


omega = np.arange(0, math.pi, 0.01)    # Array holding frequency range to be plotted
amplitude = []  # Array to hold amplitude values at each frequency

for w in omega:     # Calculate the frequency response and build the amplitude array
    H = (b_coeff[0] + b_coeff[1]*cmath.exp(-1j*w) + b_coeff[2]*cmath.exp(-2j*w) + b_coeff[3]*cmath.exp(-3j*w)) / \
        (a_coeff[0] - a_coeff[1]*cmath.exp(-1j*w) - a_coeff[2]*cmath.exp(-2j*w) - a_coeff[3]*cmath.exp(-3j*w))  # Generate the frequency response
    amplitude.append(abs(H))

print('Maximum amplitude from input to output, unity scaling:', abs(max(amplitude)))
print('Number of additional bits required at output with a scaling factor of ' + str(scaling) +':', math.ceil(math.log2(abs(max(amplitude))*scaling)))

coeff_file = r"C:\Users\graison\PycharmProjects\FPGAFilterCalculator\output.v"

# Generate the FPGA coefficients and their signal formats for the zero section
for b in range(len(b_coeff)):
    if b_coeff[b] != 0:
        msbits = math.ceil(math.log2(abs(b_coeff[b]))) + 1
        lsbits = 18 - (math.ceil(math.log2(abs(b_coeff[b]))) + 1)
        if b_coeff[b] != 1:
            print('Signal format of b' + str(b) + ':', str(msbits) + 's' + str(lsbits))
            if b_coeff[b] < 0:
                print('-18\'sd' + str(-round(b_coeff[b]*2**lsbits)))
                with open(coeff_file, 'a') as f:
                    f.write(f'  localparam B' + str(b) + ' = ' + '-18\'sd' + str(-round(b_coeff[b]*2**lsbits)) + ';\n')
            else:
                print('18\'sd' + str(round(b_coeff[b] * 2 ** lsbits)))

                with open(coeff_file, 'a') as f:
                    f.write(f'  localparam B' + str(b) + ' = ' + '18\'sd' + str(round(b_coeff[b]*2**lsbits)) + ';\n')

# Generate the FPGA coefficients for the pole section
for a in range(len(a_coeff)):
    if a_coeff[a] != 0:
        msbits = math.ceil(math.log2(abs(a_coeff[a]))) + 1
        lsbits = 18 - (math.ceil(math.log2(abs(a_coeff[a]))) + 1)
        if a_coeff[a] != 1:
            print('Signal format of a' + str(a) + ':', str(msbits) + 's' + str(lsbits))
            if a_coeff[a] < 0:
                print('-18\'sd' + str(-round(a_coeff[a]*2**lsbits)))
                with open(coeff_file, 'a') as f:
                    f.write(f'  localparam A' + str(a) + ' = ' + '-18\'sd' + str(-round(a_coeff[a]*2**lsbits)) + ';\n')
            else:
                print('18\'sd' + str(round(a_coeff[a] * 2 ** lsbits)))
                with open(coeff_file, 'a') as f:
                    f.write(f'  localparam A' + str(a) + ' = ' + '18\'sd' + str(round(a_coeff[a]*2**lsbits)) + ';\n')



