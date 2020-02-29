# TO DO: Make this handle filter coefficients as arrays; generalize to fit N-length filters--use loops
import math
import cmath
import numpy as np
import matplotlib.pyplot as plt

# Transfer Function Coefficients
r = 0.9
phi = math.pi/4
scaling = 0.5
b0 = 1.21
b1 = 1.3
b2 = 1.22
b3 = -0.9

a0 = 1
a1 = 2*r*math.cos(phi)
a2 = -r*r
a3 = 0

omega = np.arange(0, math.pi, 0.01)    # Array holding frequency range to be plotted
amplitude = []  # Array to hold amplitude values at each frequency

for w in omega:     # Calculate the frequency response and build the amplitude array
    H = (b0 + b1*cmath.exp(-1j*w) + b2*cmath.exp(-2j*w) + b3*cmath.exp(-3j*w)) / \
        (a0 - a1*cmath.exp(-1j*w) - a2*cmath.exp(-2j*w) - a3*cmath.exp(-3j*w))  # Generate the frequency response
    amplitude.append(abs(H))

print('Maximum amplitude from input to output, unity scaling:', abs(max(amplitude)))
print('Number of additional bits required at output:', math.ceil(math.log2(abs(max(amplitude))*scaling)))

coeff_file = r"C:\Users\graison\PycharmProjects\FPGAFilterCalculator\output.v"

if b0 != 0:
    msbits = math.ceil(math.log2(abs(b0)))+1
    lsbits = 18 - (math.ceil(math.log2(abs(b0)))+1)
    print('Signal format of b0:', str(msbits) + 's' + str(lsbits))
    if b0 != 1:
        if b0 < 0:
            print('-18\'sd' + str(-round(b0*2**lsbits)))
            with open(coeff_file, 'a') as f:
                f.write(f'  localparam B0 = ' + '-18\'sd' + str(-round(b0*2**lsbits)) + ';\n')
        else:
            print('18\'sd' + str(round(b0 * 2 ** lsbits)))
            with open(coeff_file, 'a') as f:
                f.write(f'  localparam B0 = ' + '18\'sd' + str(round(b0*2**lsbits)) + ';\n')
if b1 != 0:
    msbits = math.ceil(math.log2(abs(b1)))+1
    lsbits = 18 - (math.ceil(math.log2(abs(b1)))+1)
    print('Signal format of b1:', str(msbits) + 's' + str(lsbits))
    #if b1 < 0:
     #   print('-18\'sd' + str(-round(b1*2**lsbits)))
    #else:
     #   print('18\'sd' + str(round(b1 * 2 ** lsbits)))
    if b1 != 1:
        if b1 < 0:
            print('-18\'sd' + str(-round(b1*2**lsbits)))
            with open(coeff_file, 'a') as f:
                f.write(f'  localparam B1 = ' + '-18\'sd' + str(-round(b1*2**lsbits)) + ';\n')
        else:
            print('18\'sd' + str(round(b1 * 2 ** lsbits)))
            with open(coeff_file, 'a') as f:
                f.write(f'  localparam B1 = ' + '18\'sd' + str(round(b1*2**lsbits)) + ';\n')
if b2 != 0:
    msbits = math.ceil(math.log2(abs(b2))) + 1
    lsbits = 18 - (math.ceil(math.log2(abs(b2))) + 1)
    print('Signal format of b2:', str(msbits) + 's' + str(lsbits))
    #if b0 < 0:
      #  print('-18\'sd' + str(-round(b2 * 2 ** lsbits)))
    #else:
     #   print('18\'sd' + str(round(b2 * 2 ** lsbits)))
    if b2 != 1:
        if b2 < 0:
            print('-18\'sd' + str(-round(b2*2**lsbits)))
            with open(coeff_file, 'a') as f:
                f.write(f'  localparam B2 = ' + '-18\'sd' + str(-round(b2*2**lsbits)) + ';\n')
        else:
            print('18\'sd' + str(round(b2 * 2 ** lsbits)))
            with open(coeff_file, 'a') as f:
                f.write(f'  localparam B2 = ' + '18\'sd' + str(round(b2*2**lsbits)) + ';\n')
if b3 != 0:
    msbits = math.ceil(math.log2(abs(b3)))+1
    lsbits = 18 - (math.ceil(math.log2(abs(b3)))+1)
    print('Signal format of b3:', str(msbits) + 's' + str(lsbits))
    #if b3 < 0:
     #   print('-18\'sd' + str(-round(b3*2**lsbits)))
    #else:
     #   print('18\'sd' + str(round(b3 * 2 ** lsbits)))
    if b3 != 1:
        if b3 < 0:
            print('-18\'sd' + str(-round(b3*2**lsbits)))
            with open(coeff_file, 'a') as f:
                f.write(f'  localparam B3 = ' + '-18\'sd' + str(-round(b3*2**lsbits)) + ';\n')
        else:
            print('18\'sd' + str(round(b3 * 2 ** lsbits)))
            with open(coeff_file, 'a') as f:
                f.write(f'  localparam B3 = ' + '18\'sd' + str(round(b3*2**lsbits)) + ';\n')

if a0 != 0:
    msbits = math.ceil(math.log2(abs(a0))) + 1
    lsbits = 18 - (math.ceil(math.log2(abs(a0))) + 1)
    print('Signal format of a0:', str(msbits) + 's' + str(lsbits))
    if a0 < 0:
        print('-18\'sd' + str(-round(a0*2**lsbits)))
    else:
        print('18\'sd' + str(round(a0 * 2 ** lsbits)))
if a1 != 0:
    msbits = math.ceil(math.log2(abs(a1))) + 1
    lsbits = 18 - (math.ceil(math.log2(abs(a1))) + 1)
    print('Signal format of a1:', str(msbits) + 's' + str(lsbits))
    if a1 < 0:
        print('-18\'sd' + str(-round(a1*2**lsbits)))
    else:
        print('18\'sd' + str(round(a1 * 2 ** lsbits)))
if a2 != 0:
    msbits = math.ceil(math.log2(abs(a2))) + 1
    lsbits = 18 - (math.ceil(math.log2(abs(a2))) + 1)
    print('Signal format of a2:', str(msbits) + 's' + str(lsbits))
    if a2 < 0:
        print('-18\'sd' + str(-round(a2*2**lsbits)))
    else:
        print('18\'sd' + str(round(a2 * 2 ** lsbits)))
if a3 != 0:
    msbits = math.ceil(math.log2(abs(a3))) + 1
    lsbits = 18 - (math.ceil(math.log2(abs(a3))) + 1)
    print('Signal format of a3:', str(msbits) + 's' + str(lsbits))
    if a3 < 0:
        print('-18\'sd' + str(-round(a3*2**lsbits)))
    else:
        print('18\'sd' + str(round(a3 * 2 ** lsbits)))