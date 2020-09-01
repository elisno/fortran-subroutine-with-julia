
SUBROUTINE PERTURB(N, lambda, H)
    integer*8, intent(in) :: N
    complex*16, intent(in):: lambda
    complex*16, intent(out) :: H(N,N)
    complex*16, ALLOCATABLE, DIMENSION(:,:) :: X, X2, X4
    complex*16                              :: czero=0.0_16

    integer :: i, j


    ALLOCATE(X(N,N), X2(N,N), X4(N,N))
    X(:,:) = czero
    X2(:,:) = czero
    X4(:,:) = czero

    do j=1,size(X,2) !n
        do i=1,size(X,1) !n
            if (abs(i-j) == 1) then
                X(i,j)= complex(0.5* sqrt(real(i) + real(j) + 1.0), 0.0)
            end if
        end do
    end do

    X2 = matmul(X, X)
    X4 = matmul(X2, X2)

    H = H + lambda * X4

    DEALLOCATE(X, X2, X4)
END subroutine PERTURB