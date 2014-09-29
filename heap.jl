# heaps are either a max-heap or min-heap
# a max heap satisisfies the condition that A[parent] >= A[i]
# a min heap satisisfies the condition that A[parent] <= A[i]
# the following functors are used throughout to test this relation

Fmaxheap = (parent, child) -> parent >= child
Fminheap = (parent, child) -> parent <= child

function isheap(A::AbstractArray, property = Fmaxheap)
    previous_min = A[1]

    n = length(A)

    for i=2:n
        parent = i>>1
        if !property( A[parent], A[i] )
            return false
        end
    end

    return true
end

function test_isheap()
    success = true

    A = [1, 3, 4, 5, 8]
    success |= isheap(A, Fminheap)
    A = [1, 1, 1]
    success |= isheap(A, Fminheap)
    A = [1, 2]
    success |= isheap(A, Fminheap)
    A = [1, 2, 2, 3, 8, 8, 12]
    success |= isheap(A, Fminheap)
    A = [23, 17, 14, 7, 13, 10, 1, 5, 7, 12];
    success |= isheap(A)
    # TODO: test this more

    return success
end

function print_heap{T}(A::AbstractArray{T})
    n = length(A)
    nlevels = convert(typeof(n), ceil(log2(n)))

    first = 1
    for level = 1:nlevels
        last = min(2*first, n+1)
        for i = first:last-1
            print(A[i], " ")
        end
        print("\n")
        first = last
    end

    return None
end

function heapify!(A::AbstractArray, i, operator = Fmaxheap)
    n = length(A)
    l = 2*i
    r = l+1
    max_pos = i
    if l<=n && !operator(A[max_pos], A[l])
        max_pos = l
    end
    if r<=n && !operator(A[max_pos], A[r])
        max_pos = r
    end
    if max_pos != i
        tmp = A[max_pos]
        A[max_pos] = A[i]
        A[i] = tmp
        heapify!(A, max_pos, operator)
    end
    return None
end

function build_heap!(A::AbstractArray, operator = Fmaxheap)
    n = length(A)
    for i=(n>>1):-1:1
        heapify!(A, i, operator)
    end
    return None
end

function heapsort!(A::AbstractArray, operator = Fmaxheap)
    n = length(A)
    build_heap!(A, operator)
    for i=n:-1:2
        tmp = A[1]
        A[1] = A[i]
        A[i] = tmp
        heapify!(sub(A,1:i-1), 1, operator)
    end

    return None
end

function sorted(A::AbstractArray, operator = (x,y) -> x<=y)
    n = length(A)
    for i=1:n-1
        if !operator(A[i], A[i+1])
            return false
        end
    end
    return true
end

println("isheap                : ", test_isheap() ? "works": "fails")

A = mod(rand(Int64,100), 100);
build_heap(A)
println("build_heap            : ", isheap(A) ? "works": "fails")

A = mod(rand(Int64,100), 100);
heapsort!(A)
println("heapsort (descending) : ", sorted(A) ? "works": "fails")
A = mod(rand(Int64,100), 100);
heapsort!(A, Fminheap)
println("heapsort (ascending)  : ", sorted(A, (x,y) -> x>=y) ? "works": "fails")
