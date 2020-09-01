using LinearAlgebra
using DelimitedFiles

N = 8;
lambda = 0.1;
H = Array(Diagonal(rand(ComplexF64,N)));

# For comparison with Fortran, add anharmonic term in Julia
begin
    X = zeros(ComplexF64,N,N)
    for j in 1:N
        for i in 1:N
            if abs(i-j) == 1
                X[i,j]= complex(0.5 * sqrt(i+j+1))
            end
        end
    end
    native = H + lambda * X^4
end

function perturb!(N,lambda,H)
    ccall((:perturb_,"./libperturb.so"), Cvoid, (Ref{Int64}, Ref{ComplexF64}, Ref{ComplexF64}), N, lambda, H)
    return H
end

perturb!(N,lambda,H)


# Write results to file
begin
    open("fortrancall.txt","w") do f
        writedlm(f,H)
    end 

    open("julia.txt","w") do f
        writedlm(f,native)
    end
end

# Norm of residuals
println("norm(H - native) = ", norm(H - native))