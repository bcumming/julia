function merge_inplace{T}(v::Array{T}, q::Int, p::Int, r::Int)
    pold = p
    while q<pold && p<=r
        println(q, " ", p, " :: ",  v[q], ",", v[p] )
        if v[q] > v[p]
            println(" v[", q, "]<->v[", p, "] :: ", v[q], "<->", v[p])
            tmp = v[q]
            v[q] = v[p]
            v[p] = tmp
            p+=1
            print(v)
        else
            q+=1
        end
    end
    return v
end # function merge

function merge!(v, q::Int, p::Int, r::Int)
    L = v[q:p-1]
    R = v[p:r]
    nl = p-q
    nr = r-p+1
    il = 1
    ir = 1
    i = 1
    while il<=nl && ir<=nr
        if L[il] > R[ir]
            v[i] = R[ir]
            ir+=1
        else
            v[i] = L[il]
            il+=1
        end
        i += 1
    end
    while il<=nl
        v[i] = L[il]
        i += 1
        il += 1
    end
    while ir<=nr
        v[i] = R[ir]
        i += 1
        ir += 1
    end
end # function merge!

function insertion_sort!{T}(v::AbstractArray{T}, operator=(x,y)->x<y)
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

function merge_sort!(v)
    n = length(v)
    if n==1
        return
    end

    # find the midpoint of the array
    m = integer(floor(n/2))

    if m<32
        insertion_sort!(sub(v,1:m))
        insertion_sort!(sub(v,m+1:n))
    else
        merge_sort!(sub(v,1:m))
        merge_sort!(sub(v,m+1:n))
    end
    merge!(v, 1, m+1, n)
end

v = zeros(Int64, 20);
for i=1:length(v)
    v[i] = mod(rand(Int64), 100)
end
merge_sort!(v)

times=[];
powers = [1:20];
for p = powers
    n = 2^p
    v = zeros(Int64, n);
    for i=1:n
        v[i] = mod(rand(Int64), 100)
    end
    println("array of length ", n)
    tic()
    merge_sort!(v)
    times = [times, toc()];
end

lens = 2.^powers;

#Pkg.add("PyPlot")
#using PyPlot
#plot(powers, times)
