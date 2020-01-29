import math

bw = 70e-9	# Bandwidth of dielectric mirror
wl = 1550e-9	# Central wavelength
N = 35		# Number of stacks
d1 = 6e-6	# Thickness of layer 1
d2 = 5.881e-6	# Thickness of layer 2
n0 = 1		# Refractive index of air
n1 = 3.5243	# Refractive index of first layer
n2 = 3.257	# Refractive index of second layer
n3 = 1.9743	# Refractive index of substrate
print( (n1*d1 + n2*d2) * 2)
#d2 = (wl*52/2 - n1*d1)/n2
#print(d2)
R = math.pow( (math.pow(n1,2*N) - (n0/n3)*math.pow(n2, 2*N)) / ((math.pow(n1,2*N) + (n0/n3)*math.pow(n2, 2*N))) ,2)
print(R)
# bw/wl = (4/math.pi)*math.arcsin( (n1-n2) / (n1+n2) )
# it follows that 
  # x = math.sin(math.pi*bw/(4*wl))
  # n2 = n1*(1-x)/(1+x)\
  
  # Note that at 1550nm both GaInAs and GaInAsP have a relatively flat characteristic
  # Say n1 = 3.5243, GaInAs
  #     n2 = 3.257, GaInAsP
  # See refractiveindex.info
