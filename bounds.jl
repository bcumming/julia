function increment!(A)
    n = length(A)
    for i=1:n
        A[i] += 1
    end
end

A = [0 0 0 0 0]
print(A)
increment!(A)
print(A)
increment!(sub(A,1:3))
print(A)


