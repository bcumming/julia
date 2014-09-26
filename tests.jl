function rev!(A)
    n = length(A)
    for i=1:(n>>1)
        tmp = A[i]
        A[i] = A[end-i+1]
        A[end-i+1] = tmp
    end
end

function allperms(A, swap_index=1)
    local n = length(A)
    if n==swap_index
        print(A)
    else
        for i=swap_index:n
            tmp = A[i]
            A[i] = A[swap_index]
            A[swap_index] = tmp

            allperms(A, swap_index+1)

            tmp = A[i]
            A[i] = A[swap_index]
            A[swap_index] = tmp
        end
    end
    return None
end

A = [1];
rev!(A); print(A);
A = [1 2];
rev!(A); print(A);
A = [1 2 3];
rev!(A); print(A);
A = [1 2 3 4];
rev!(A); print(A);

A = ['A' 'B' 'C' 'D' 'E']
print("======= All perms of ", A)
allperms(A)

