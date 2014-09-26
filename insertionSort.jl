function insertionSort!{T}(v::Array{T}, operator=(x,y)->x<y)
    n = length(v)

    for i=2:n
        key = v[i]
        j = i
        while j>1 && operator(key, v[j-1])
            v[j] = v[j-1]
            j = j-1
        end

        v[j] = key
    end
end

