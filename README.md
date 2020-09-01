# Example: Calling a Fortran Subroutine for complex arrays in Julia

For this example, say that our Fortran Subroutine in `perturbhamiltonian.f90` is responsible for adding an anharmonic term to the Hamiltonian of a 1D-QHO (working in the |n>basis).

We have already written the unperturbed Hamiltonian `H` with Julia in `perturb.jl`, but would like to use out existing Fortran-code to add the anharmonic term to the same variable.

## Quickstart
After cloning this repository, you can run this example with
```bash
make
```
The end result will be a shared library of the subroutine (`.so` file) and two text outputs with (almost) identical Hamiltonian data (`fortrancall.txt` and `julia.txt`).

## Short overview

We need to compile this subroutine as a shared library, (with `gfortran` we'll have to use the `-shared` and `-fPIC` options).

```bash
gfortran -shared -fPIC perturbhamiltonian.f90 -o libperturb.so
```

`libperturb.so` exposes the `PERTURB` subroutine to Julia, where it can be called with

```julia
# In a Julia session/script
ccall((:perturb_,"./libperturb.so"), Cvoid, (Ref{Int64}, Ref{ComplexF64}, Ref{ComplexF64}), N, lambda, H)
```

Note that the return type in `ccall` is set to `Cvoid`, since we're calling a subroutine (that modifies the input).
Care must be taken to specify the correct element types (in the tuple of `Ref`s). For more information on the type correspondences between Julia and C/Fortran, go to the [Julia Manual](https://docs.julialang.org/en/v1/manual/calling-c-and-fortran-code/#mapping-c-types-to-julia).