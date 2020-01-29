import math

bw = 70e-9	# Bandwidth of dielectric mirror
wl = 1550e-9	# Central wavelength
N = 10		# Number of stacks
d1 = 0.2e-3	# Distance of layer 1
d2 = 0.3e-3	# Distance of layer 2
n1 = 2.33	# Refractive index of first layer
n2 = 1.21	# Refractive index of second layer
# n1*d1 + n2*d2 = wl/2
R = math.pow( (math.pow(n1,2*N) - (n0/n3)*math.pow(n2, 2*N)) / ((math.pow(n1,2*N) - (n0/n3)*math.pow(n2, 2*N))) ,2)

# bw/wl = (4/math.pi)*math.arcsin( (n1-n2) / (n1+n2) )
# it follows that 
  # x = math.sin(math.pi*bw/(4*wl))
  # n2 = n1*(1-x)/(1+x)
