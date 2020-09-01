# Text files storing Hamiltonians for an anharmonic oscillator.
# Anharmonic term computed either natively, or in Fortran.
TEXTS=fortrancall.txt julia.txt

# Compiler options
FC=gfortran
FC-FLAGS=-shared -fPIC
JULIA=julia
JULIA-FLAGS=

# Source and object files
FSRC=perturbhamiltonian.f90
JSRC=perturb.jl
OBJS=libperturb.so

.PHONY: clean

$(TEXTS): $(OBJS) $(JSRC)
	$(JULIA) $(JULIA-FLAGS) $(JSRC)

$(OBJS): $(FSRC)
	$(FC) $(FC-FLAGS) $(FSRC) -o $@

clean:
	rm $(TEXTS)

clean-all:
	rm $(TEXTS) $(OBJS)

clean-keep-src:
	rm *.txt *.so
