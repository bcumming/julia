function selectionSort!{T}(v::Array{T}, operator=(x,y) -> x<y)

    n = length(v)

    for i=1:n-1
        # index of minimum value in remaining array
        k = i
        for j=i+1:n
            k = operator(v[j], v[k]) ? j : k
        end
        tmp = v[i]
        v[i] = v[k]
        v[k] = tmp
    end
end # function

v = [1 4 2 8 1 9 7 3 5 2 8 4 7]
print(v)
selectionSort!(v)
print(v)
selectionSort!(v, (x,y) -> x>y)
print(v)
